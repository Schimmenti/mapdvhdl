library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_master is
   generic (
      WTIME    : integer   := 6;
      TXBITS   : integer   := 32;
      RXBITS   : integer   := 8
      );
   port ( 
      clock    : in  std_logic;
      reset    : in  std_logic;
      txd      : in  std_logic_vector(TXBITS-1 downto 0);
      rxd      : out std_logic_vector(RXBITS-1 downto 0);
      start    : in  std_logic;
      ready    : out std_logic;
      miso     : in  std_logic;
      mosi     : out std_logic;
      sclk     : out std_logic;
      cs       : out std_logic
      );
end spi_master;

architecture Behavioral of spi_master is

signal sclk_s : std_logic := '0';
signal mosi_s : std_logic := '1';
signal cs_s : std_logic :='1';
signal ready_s : std_logic :='0';
signal bufout : std_logic_vector(TXBITS-1 downto 0) := txd;
signal bufin :  std_logic_vector(RXBITS-1 downto 0) := (others => '0');

type state is (s_idle, s_send, s_read);
signal ms_state : state := s_idle;
begin

fsm_process : process (clock, reset, start) is
variable tcnt : integer := 0;
variable wcnt : integer := TXBITS - 1;
variable rcnt : integer := RXBITS - 1;
begin
case ms_state is
    when s_idle =>
        ready_s <= '0';
        if rising_edge(start) then
            ms_state <= s_send;
            cs_s <= '0';
        end if;  
    when s_send =>
        tcnt := tcnt + 1;
        if tcnt = 1 then
            sclk_s <= '0';
            mosi_s <= bufout(wcnt);
        elsif tcnt = WTIME / 2 then
            sclk_s <= '1';
        elsif tcnt = WTIME then
            tcnt := 0;
            sclk_s <= '0';
            if wcnt = 0 then --finished sending instruction
                wcnt := TXBITS - 1;
                mosi_s <= '1';
                tcnt := 0; --wrong?
                ms_state <= s_read;
            else
                wcnt := wcnt - 1;
            end if;
         end if;
      when s_read =>
        tcnt := tcnt + 1;
        if tcnt = 1 then
            sclk_s <= '0';         
        elsif tcnt = WTIME / 2 then
            sclk_s <= '1';
            bufin(rcnt) <= miso;
        elsif tcnt = WTIME then
            tcnt := 0;
            sclk_s <= '0';
            if rcnt = 0 then --finished sending instruction
                rcnt := RXBITS - 1;
                tcnt := 0; --wrong?
                ms_state <= s_idle;
                ready_s <= '1';
                rxd <= bufin; --here?
                cs_s <= '1';
            else
                rcnt := rcnt - 1;
            end if;
        end if;
        
end case;

end process;
sclk <= sclk_s;
mosi <= mosi_s;
cs <= cs_s;
ready <= ready_s;
end Behavioral;

