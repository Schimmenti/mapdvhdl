----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/05/2019 05:05:10 PM
-- Design Name: 
-- Module Name: test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is

end test;




architecture Behavioral of test is

signal clk_s, rst_s : std_logic;
signal y_s    : std_logic_vector(31 downto 0); 
signal start_gen_s : std_logic;
signal we_out_s : std_logic;
signal addr_out_s : std_logic_vector(9 downto 0);
constant clk_period : time := 10 ns;

component square_wave is
    generic( PERIOD      : integer := 20;
           DUTY_CYC    : integer := 50;
           SAMPLE_N    : integer := 1024
  );
  port (clk        : in  std_logic;  
        rst        : in  std_logic; 
        en_gen_in  : in  std_logic;                       
        we_out     : out std_logic;                       
        address_out: out std_logic_vector(9 downto 0);    
        y_out      : out std_logic_vector(31 downto 0)); 

end component;


begin

start_gen_s <= '1';



sqgen : square_wave
port map
(
clk => clk_s,
rst => rst_s,
en_gen_in => start_gen_s,
we_out => we_out_s,
address_out => addr_out_s,
y_out => y_s
);


main : process
    begin
    clk_s <= '0';
    wait for clk_period/2;
    clk_s <= '1';
    wait for clk_period/2;
end process;





end Behavioral;