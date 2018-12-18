library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fflop is
  generic(N : integer := 16);
  Port (clk  :   in  std_logic;
        rst  :   in  std_logic;                    
        a_in :   in std_logic_vector(N-1 downto 0);
        ff_out : out std_logic_vector(N-1 downto 0)); 
end fflop;

architecture rtl of fflop is

begin

p_ff: process(clk, rst) is
   begin
   if rst = '1' then
      ff_out <= (others => '0');
   elsif rising_edge(clk) then
      ff_out <= a_in;
   end if;
end process;


end rtl;
