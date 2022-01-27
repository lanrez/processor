----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2022 04:41:10 PM
-- Design Name: 
-- Module Name: processor - Behavioral
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

entity processor is
--  Port ( );
end processor;

architecture Behavioral of processor is
    
--wires
signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal PCWriteCond : STD_LOGIC;
signal PCWrite : STD_LOGIC;
signal IorD : STD_LOGIC;
signal MemRead : STD_LOGIC;
signal MemWrite : STD_LOGIC;
signal IRWrite : STD_LOGIC;
signal op : STD_LOGIC_VECTOR (5 downto 0);
signal RegDst : STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal ALUSrcB : STD_LOGIC_VECTOR (1 downto 0);
signal ALUSrcA : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0);
signal PCSrc : STD_LOGIC_VECTOR (1 downto 0);

-- Components
component datapath is
Port ( clk : in STD_LOGIC;
       PCWriteCond : in STD_LOGIC;
       PCWrite : in STD_LOGIC;
       IorD : in STD_LOGIC;
       MemRead : in STD_LOGIC;
       MemWrite : in STD_LOGIC;
       IRWrite : in STD_LOGIC;
       op : out STD_LOGIC_VECTOR (5 downto 0);
       RegDst : in STD_LOGIC;
       MemtoReg : in STD_LOGIC;
       RegWrite : in STD_LOGIC;
       ALUSrcB : in STD_LOGIC_VECTOR (1 downto 0);
       ALUSrcA : in STD_LOGIC;
       ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
       --funccode: out STD_LOGIC_VECTOR(5 downto 0);
       PCSrc : in STD_LOGIC_VECTOR (1 downto 0));
end component;

component control_unit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PCWriteCond : out STD_LOGIC;
           PCWrite : out STD_LOGIC;
           IorD : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           op : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrcA : out STD_LOGIC;
           ALUOp    : out STD_LOGIC_VECTOR(1 downto 0);
           --funccode : in STD_LOGIC_VECTOR (5 downto 0);
           PCSrc : out STD_LOGIC_VECTOR (1 downto 0)
           );
end component;

begin
    
    --Instantiate Components
    --Control unit
    CU : control_unit
    port map(clk => clk,
            rst => rst,
            PCWriteCond => PCWriteCond,
            PCWrite => PCWrite,
            IorD => IorD,
            MemRead => MemRead,
            MemWrite => MemWrite,
            IRWrite => IRWrite,
            op => op,
            RegDst => RegDst,
            MemtoReg => MemtoReg,
            RegWrite => RegWrite,
            ALUSrcB => ALUSrcB,
            ALUSrcA => ALUSrcA,
            ALUOp => ALUOp,
            PCSrc => PCSrc
            );
    
    --Data path
    DP : datapath
    port map(clk => clk,
            PCWriteCond => PCWriteCond,
            PCWrite => PCWrite,
            IorD => IorD,
            MemRead => MemRead,
            MemWrite => MemWrite,
            IRWrite => IRWrite,
            op => op,
            RegDst => RegDst,
            MemtoReg => MemtoReg,
            RegWrite => RegWrite,
            ALUSrcB => ALUSrcB,
            ALUSrcA => ALUSrcA,
            ALUOp => ALUOp,
            PCSrc => PCSrc
            );

end Behavioral;
