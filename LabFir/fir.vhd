library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir is
generic(N      : integer := 16;
Q : integer := 11);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     -- we assume that all inputs x_in are integers
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0);
     c0,c1,c2,c3,c4 : in signed(N-1 downto 0)); 
end fir;

--examples for coefficents
--we use fixed point binary point with 11 bits for fractional part and 4 for integer part and 1 for the sign
--max positive number 15.99951171875
--0.19335315 approx 0.001100010111 -> 0|0000|00110001011 -> after a Q=11 leftshift 0x18B
--0.20330353 approx 0.001101000000 -> 0|0000|00110100000 -> after a Q=11 leftshift 0x1A0
--0.20668665 approx 0.001101001110 -> 0|0000|00110100111 -> after a Q=11 leftshift 0x1A7

-- -2.7896 approx -0010.11001010001 -> abs(-2.7896 ) approx 0|0010|11001010001) -> 1|1101|00110101110 + 1 -> 1|1101|00110101111  
architecture rtl of fir is

signal y01,y12,y23,y34 : std_logic_vector(N-1 downto 0)  := (others => '0');
signal x_sum_part : std_logic_vector(2*N-1 downto 0);
signal x_sum : std_logic_vector(N-1 downto 0);
signal m0,m1,m2,m3,m4 : signed(2*N-1 downto 0):= (others => '0');
signal sgn : std_logic := '0';

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



x_sum_part <= std_logic_vector(shift_right(c0*signed(x_in)+c1*signed(y01)+c2*signed(y12)+c3*signed(y23)+c4*signed(y34), Q));
sgn <= x_sum_part(2*N-1);
x_sum <= sgn & x_sum_part(N-2 downto 0);
--p_fir : process(clk,rst)
--variable sgn : std_logic;
--    begin
 --   if rst = '1' then
   -- x_sum <= (others => '0');
    --elsif rising_edge(clk) then
    --x_sum_part <= std_logic_vector(shift_right(c0*signed(x_in)+c1*signed(y01)+c2*signed(y12)+c3*signed(y23)+c4*signed(y34),Q));
     --x_sum_part <= std_logic_vector(c0*signed(x_in)+c1*signed(y01)+c2*signed(y12)+c3*signed(y23)+c4*signed(y34));
   -- sgn := x_sum_part(2*N-1);
    --x_sum <= '0' & x_sum_part(N-2 downto 0);
    --end if;
--end process;


end rtl;
