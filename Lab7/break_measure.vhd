library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity break_measure is
  generic(DONE_TIME : integer := 100);
  Port (clk   : in  std_logic;
        rst   : in  std_logic;            
        pulses_in  : in  std_logic; -- Counter input
        count_out  : out unsigned(5 downto 0); -- break time measurement in clock cycles
        done_out   : out std_logic);-- Calculation done
end break_measure;

architecture Behavioral of break_measure is

type bm_state is (s_idle, s_finished, s_1_pulse, s_distance,s_2_pulse); 
signal bms : bm_state;
begin

bm_fsm : process(clk, rst, pulses_in) is
begin
    if rst = '1' then
        count_out <= (others => '0');
        done_out <= '0';
    elsif rising_edge(clk) then
        case bms is
            when s_idle =>
            if pulses_in = '1' then
                bms <= s_1_pulse;
            else
                bms <= s_idle;
            end if;
            when 
    end if;
end process;


end Behavioral;
