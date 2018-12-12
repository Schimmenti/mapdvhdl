library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

USE ieee.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;

USE std.textio.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

--USE IEEE.STD_LOGIC_ARITH.ALL;



entity tb_fir is
generic(N      : integer := 16);
end tb_fir;

architecture Behavioral of tb_fir is

component fir
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0));
end component;

signal clk : std_logic :='0';
signal rst : std_logic :='0';
signal xin : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(1,N));
signal yout : std_logic_vector(N-1 downto 0);
signal cnt : unsigned(N-1 downto 0) := (others => '0');

begin
fir0 : fir port map (clk => clk, rst => rst, x_in => xin, y_out => yout);
sim_fir : process(clk) is
    begin
    if cnt = 1 then
    rst <= '1';
    rst <= '0' after 10 ns;
    end if;
    clk <= not clk after 50 ns;
    cnt <= cnt + 1;
end process;


end Behavioral;