----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2018 10:18:50 AM
-- Design Name: 
-- Module Name: tb_fir - Behavioral
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

USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

USE std.textio.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

USE IEEE.STD_LOGIC_ARITH.ALL;

entity tb_fir_file is
  generic(N      : integer := 16);
--  Port ( );
end tb_fir_file;

architecture Behavioral of tb_fir_file is

component fir is
  generic(N      : integer := 16);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0);
     c0,c1,c2,c3,c4 : in ieee.numeric_std.signed(N-1 downto 0)); 
end component;

signal clk,rst : std_logic;
signal x,y : std_logic_vector(N-1 downto 0);
signal c0,c1,c2,c3,c4 : ieee.numeric_std.signed(N-1 downto 0);

constant clk_T : time := 10 ns; 
constant t_rst : time := 30 ns;

begin
c0 <= to_signed(16#18B#,N);
c1 <= to_signed(16#1A0#,N);
c2 <= to_signed(16#1A7#,N);
c3 <= to_signed(16#1A0#,N);
c4 <= to_signed(16#18B#,N);
uut : fir port map (clk => clk, rst => rst, x_in => x,y_out => y, c0=>c0,c1=>c1,c2=>c2,c3=>c3,c4=>c4);

p_clk : process
begin
  clk <= '0'; wait for clk_T/2; clk <= '1'; wait for clk_T/2;
end process;

p_rst: process
begin
  rst <= '1'; wait for t_rst; rst <= '0'; wait;
end process;

p_x: process

file input  :text;
file output : text;
variable line_in: line;
variable line_out: line;
variable num_in: integer;
variable num_out: integer;

begin

file_open(input,"input_file.txt",read_mode);
file_open(output,"output_file.txt",write_mode);

wait for t_rst; 
 
while not (endfile(input)) loop 
  
  readline(input,line_in); 
  read(line_in,num_in);
  
  x <= conv_std_logic_vector(num_in,N);
  wait for clk_T;
  num_out := conv_integer(y);
  
  
  if (num_out > 2**15) then  -- if num_out is negative
     num_out := num_out - 2**16 ;
  end if;

  write(line_out, num_out);
  writeline(output,line_out);

end loop;

file_close(input);
file_close(output);
wait;

end process;

end Behavioral;
