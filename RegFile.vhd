----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2020 07:05:30 PM
-- Design Name: 
-- Module Name: RegFile - Behavioral
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

entity RegFile is
    Port ( clk : in STD_LOGIC;
           rdreg1 : in STD_LOGIC_VECTOR (4 downto 0);
           rdreg2 : in STD_LOGIC_VECTOR (4 downto 0);
           wtreg : in STD_LOGIC_VECTOR (4 downto 0);
           wtdata : in STD_LOGIC_VECTOR (31 downto 0);
           rddata1 : out STD_LOGIC_VECTOR (31 downto 0);
           rddata2 : out STD_LOGIC_VECTOR (31 downto 0);
           RegWrite : in STD_LOGIC);
end RegFile;

architecture Behavioral of RegFile is
	TYPE REG_file 	    is array (31 DOWNTO 0) of STD_LOGIC_VECTOR(31 downto 0);
	
	signal REG     : REG_File;
	
begin

process (clk)
begin
    if (clk'event and clk = '1') then
        rddata1 <= REG(to_integer(unsigned(rdreg1)));
    end if;
end process;

process (clk)
begin
    if (clk'event and clk = '1') then
        rddata2 <= REG(to_integer(unsigned(rdreg2)));
    end if;
 end process;

process (clk)
begin
    if (clk'event and clk = '1') then
        if (RegWrite = '1') then
            REG(to_integer(unsigned(wtreg))) <= wtdata;
        end if;
     end if;
end process;

end Behavioral;
