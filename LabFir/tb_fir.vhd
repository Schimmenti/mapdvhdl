library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

USE ieee.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;

USE std.textio.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;


--USE IEEE.STD_LOGIC_ARITH.ALL;



entity tb_fir is
generic(N      : integer := 16; Q : integer := 11);
end tb_fir;

architecture Behavioral of tb_fir is

component fir
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0);
     c0,c1,c2,c3,c4 : in signed(N-1 downto 0));
end component;

signal clk : std_logic :='0';
signal rst : std_logic :='1';
signal xin : std_logic_vector(N-1 downto 0) := std_logic_vector(to_signed(1,N));
signal yout : std_logic_vector(N-1 downto 0);
signal cnt : unsigned(N-1 downto 0) := (others => '0');
signal c0,c1,c2,c3,c4 : signed(N-1 downto 0);

begin
c0 <= to_signed(1*2**Q,N);
c1 <= to_signed(2*2**Q,N);
c2 <= to_signed(3*2**Q,N);
c3 <= to_signed(4*2**Q,N);
c4 <= to_signed(5*2**Q,N);
fir0 : fir port map (clk => clk, rst => rst, x_in => xin,y_out => yout, c0=>c0,c1=>c1,c2=>c2,c3=>c3,c4=>c4);

fir_clk : process(clk,rst) is
    begin
    if rst = '1' then
        rst <= '0';
    else
        clk <= not clk after 50 ns;
        cnt <= cnt + 1;
    end if;
end process;


--sim_fir : process(clk,rst) is
 --   begin
  --  if cnt = 0 then
   -- rst <= '1';
   -- rst <= '0' after 50 ns;
    --cnt <= cnt +1;
    --else
    --clk <= not clk after 50 ns;
    --cnt <= cnt + 1;
    --xin <= std_logic_vector(cnt);
    --end if;
--end process;


end Behavioral;