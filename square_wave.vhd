library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity square_wave is
  generic( PERIOD      : integer := 20; -- in number of clock cycles
           DUTY_CYC    : integer := 50; -- in number of clock cycles
           SAMPLE_N    : integer := 1024
  );
  Port (clk        : in  std_logic;  
        rst        : in  std_logic; 
        en_gen_in  : in  std_logic;                       -- start signal
        we_out     : out std_logic;                       -- write enable for the dpram
        address_out: out std_logic_vector(9 downto 0);    -- address for the dpram 
        y_out      : out std_logic_vector(31 downto 0));  -- data to write in the dpram
end square_wave;

architecture Behavioral of square_wave is

type state_sg is (s_idle, s_high,s_low);
   signal state   : state_sg;

signal y : std_logic_vector(31 downto 0);
signal addr_s : std_logic_vector(9 downto 0);  
signal we_s : std_logic;

constant HIGH_D : integer := (PERIOD*DUTY_CYC)/100;
constant LOW_D : integer := PERIOD-HIGH_D;

-- HIGH LOGIC LEVEL
-- y <= std_logic_vector(to_signed(1024 , y'length)); 

-- LOW LOGIC LEVEL
-- y <= std_logic_vector(to_signed(-1024, y'length));


begin

sqgen : process(clk, rst, en_gen_in)
variable d_cnt  : integer; --high counter
variable s_cnt : integer; --sample counter

begin
	if rising_edge(clk) then
	   if rst = '1' then
	       state <= s_idle;
	       d_cnt := 0;
	       s_cnt := 0;
	       we_s <= '0';
	   else
	       case state is
	       
	       when s_idle =>
	           if en_gen_in = '1' then
	               state <= s_high;
	               --d_cnt := 1;
                   --s_cnt := 1;
                   --y <= std_logic_vector(to_signed(1024 , y'length));
                   d_cnt := 0;
                   s_cnt := 0;
                   we_s <= '0';
	           end if;
	       when s_high =>
	           if s_cnt = SAMPLE_N then --maybe i finished
	               state <= s_idle;
	               d_cnt := 0;
	               s_cnt := 0;
	               we_s <= '0';
	           else
	               we_s <= '1';
	           	   addr_s <= std_logic_vector(to_unsigned(s_cnt, addr_s'length));
	               d_cnt := d_cnt + 1;
	               s_cnt := s_cnt + 1;
	               y <= std_logic_vector(to_signed(1024 , y'length));
	               if d_cnt = HIGH_D then --jump to low state
	                   state <= s_low;
	                   d_cnt := 0;
	               end if;
	           end if;
	        when s_low =>
	           if s_cnt = SAMPLE_N then --maybe i finished
                   state <= s_idle;
                   d_cnt := 0;
                   s_cnt := 0;
                   we_s <= '0';
               else
                   we_s <= '1';
               	   addr_s <= std_logic_vector(to_unsigned(s_cnt, addr_s'length));
                   d_cnt := d_cnt + 1;
                   s_cnt := s_cnt + 1;
                   y <= std_logic_vector(to_signed(-1024 , y'length));
                   if d_cnt = LOW_D then --jump to high state
                        state <= s_high;
                        d_cnt := 0;
                   end if;
               end if;
	        end case;
	   end if;
    end if;
end process;

y_out <= y;
address_out <= addr_s;
we_out <= we_s;
end Behavioral;