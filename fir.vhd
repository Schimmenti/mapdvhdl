library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir is
generic(N      : integer := 16;
Q : integer := 0);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     -- we assume that all inputs x_in are integers
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0);
     c0,c1,c2,c3,c4 : in unsigned(N-1 downto 0));
end fir;

--examples for coefficents
--we use fixed point binary point with 12 bits for fractional part and 4 for integer part
--0.19335315 approx 001100010111 -> 0000001100010111 = 0x317 =  791
--0.20330353 approx 001101000000 -> 0000001101000000 = 0x340 = 832
--0.20668665 approx 0.00110100 -> 0000001101001110 = 0x34E = 846
architecture rtl of fir is

signal y01,y12,y23,y34 : std_logic_vector(N-1 downto 0)  := (others => '0');
signal x_sum_part : std_logic_vector(2*N-1 downto 0);
signal x_sum : std_logic_vector(N-1 downto 0);

component fflop
 Port (clk  :   in  std_logic;
        rst  :   in  std_logic;                    
        a_in :   in std_logic_vector(N-1 downto 0);
        ff_out : out std_logic_vector(N-1 downto 0)); 
end component;

begin
f1 : fflop port map (clk => clk, rst => rst, a_in => x_in, ff_out  => y01);
f2 : fflop port map (clk => clk, rst => rst, a_in => y01, ff_out  => y12);
f3 : fflop port map (clk => clk, rst => rst, a_in => y12, ff_out  => y23);
f4 : fflop port map (clk => clk, rst => rst, a_in => y23, ff_out  => y34);
f5 : fflop port map (clk => clk, rst => rst, a_in => x_sum, ff_out  => y_out);



p_fir : process(clk)
    begin
    if rising_edge(clk) then
    x_sum_part <= std_logic_vector(shift_right(c0*unsigned(x_in)+c1*unsigned(y01)+c2*unsigned(y12)+c3*unsigned(y23)+c4*unsigned(y34),Q));
    
    x_sum <= x_sum_part(N-1 downto 0);
    end if;
end process;


end rtl;
