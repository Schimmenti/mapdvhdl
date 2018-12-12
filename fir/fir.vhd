library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir is
generic(N      : integer := 16;
Q : integer := 8);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0));
end fir;

architecture rtl of fir is

signal c0,c1,c2,c3,c4 :  unsigned(N-1 downto 0);
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

c0 <= to_unsigned(1,N);
c1 <= to_unsigned(2,N);
c2 <= to_unsigned(3,N);
c3 <= to_unsigned(4,N);
c4 <= to_unsigned(5,N);

p_fir : process(clk)
    begin
    if rising_edge(clk) then
    x_sum_part <= std_logic_vector(c0*unsigned(x_in)+c1*unsigned(y01)+c2*unsigned(y12)+c3*unsigned(y23)+c4*unsigned(y34));
    x_sum <= x_sum_part(N-1 downto 0);
    end if;
end process;


end rtl;
