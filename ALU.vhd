----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2020 07:05:30 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           res : out STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0));
           --funccode : in STD_LOGIC_VECTOR (11 downto 0));
end ALU;

architecture Behavioral of ALU is
--Signals
signal iop1             : signed (31 downto 0);
signal iop2             : signed (31 downto 0);
signal ires             : std_logic_vector (31 downto 0);
--signal op               : std_logic_vector (2 downto 0);

begin

res <= ires;
iop1 <= signed (op1);
iop2 <= signed (op2);

ires <= std_logic_vector(iop1 or iop2) when ALUOp = "000" else
       std_logic_vector(iop1 and iop2) when ALUOp = "001" else 
       std_logic_vector(iop1 + iop2) when ALUOp = "010" else
       std_logic_vector(iop1 - iop2) when ALUOp = "110" else
       X"00000001"  when ALUOp = "111" and (iop1 < iop2) else
       X"00000000"  when ALUOp = "111" and (iop1 >= iop2) else
       ires;

zero <= '1' when ires = X"00000000" else
        '0';
        
end Behavioral;
