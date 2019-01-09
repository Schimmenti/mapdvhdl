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

type bm_state is (s_idle,s_wait, s_pulse, s_measure); 
signal bms : bm_state;
begin

bm_fsm : process(clk, rst, pulses_in) is
variable cnt : unsigned(5 downto 0);
begin
    if rst = '1' then
        bms <= s_idle;
        cnt := (others => '0');
        done_out <= '0';
    elsif rising_edge(clk) then
          case bms is
            when s_idle =>
            if pulses_in = '1' then --first pulse about to start
                bms <= s_pulse;
            else
                bms <= s_idle; 
            end if;
            cnt := "0";
            when s_pulse =>
               if pulses_in = '1' then --still in the pulse
                  bms <= s_pulse;
                  cnt := "0";
				  done_out <= '0';
               else
                  bms <= s_measure;
                  cnt := "1";
               end if;
             when s_measure =>
                if pulses_in = '1' then --measure finished
                    bms <= s_wait;
					cnt := 0;
                else
                    cnt := cnt + 1;
                    bms <= s_measure;
                end if;
             when s_wait =>
				if cnt < DONE_TIME then
					cnt:= cnt + 1;
				else
					done_out <= '0';
					cnt := '0'
					bms <= s_idle;
				end if;
             when others =>
                bms <= s_idle;
                cnt := (others => '0');
                done_out <= '0';
             end case;
    end if;
    count_out <= cnt;
end process;



end Behavioral;
