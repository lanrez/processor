----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2020 07:05:30 PM
-- Design Name: 
-- Module Name: memo - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memo is
    Port ( clk : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           writedata : in STD_LOGIC_VECTOR (31 downto 0);
           memdata : out STD_LOGIC_VECTOR (31 downto 0);
           MemRead : in STD_LOGIC;
           MemWrite : in STD_LOGIC);
end memo;

architecture Behavioral of memo is
TYPE REG_file 	    is array (31 DOWNTO 0) of STD_LOGIC_VECTOR(31 downto 0);
TYPE REG_stack      is array (31 DOWNTO 0) of REG_FILE;	
	signal REG     : REG_stack;


begin

process (clk)
begin
    if (clk'event and clk = '1') then
        if (MemRead = '1') then
            memdata <= REG(to_integer(unsigned(addr(9 downto 5))))(to_integer(unsigned(addr(4 downto 0))));
        end if;
    end if;
end process;                                   

process (clk)
begin
    if (clk'event and clk = '1') then
        if (MemWrite = '1') then
            REG(to_integer(unsigned(addr(9 downto 5))))(to_integer(unsigned(addr(4 downto 0)))) <= writedata;
        end if;
    end if;
end process;

end Behavioral;
