----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/21/2020 02:50:42 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

TYPE FSM is (F,ID,EX,MEM,WB);

signal state      : fSM;

signal opcode   : STD_LOGIC_VECTOR(5 downto 0);
begin

process(clk)

begin
if clk'event and clk = '1' then
    if rst = '1' then
        state <= F;
        PCWriteCond <= '0';
        PCWrite <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        RegDst <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        ALUSrcB <= "00";
        ALUSrcA <= '0';
        ALUOp <= "00";
        PCSrc <= "00";
        opcode <= "000000";
    else
        PCWriteCond <= '0';
        PCWrite <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        RegDst <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        ALUSrcB <= "00";
        ALUSrcA <= '0';
        ALUOp <= "00";
        PCSrc <= "00";
        case state is
            when F =>
                MemRead <= '1';
                IRWrite <= '1';
                ALUSrcB <= "01";
                ALUOp <= "00";
                PCWrite <= '1';
                opcode <= op;
                state <= ID;
            when ID =>
                ALUSrcB <= "11";
                ALUOp <= "00";
                state <= EX;
            when EX =>
                case opcode is
                    when "101011" | "100011"=>   --Load Store
                        ALUSrcA <= '1';
                        ALUSrcB <= "10";
                        ALUOp <= "00";
                        state <= MEM;
                    when "000000" =>            -- R type
                        ALUSrcA <= '1';
                        ALUSrcB <= "00";
                        ALUOp <= "10";
                        state <= WB;       
                    when "000100" =>            --Branch
                        ALUSrcA <= '1';
                        ALUSrcB <= "00";
                        ALUOp <= "01";
                        PCWriteCond <= '1';
                        PCSrc <= "01";
                        state <= F;
                    when "000010" =>            --Jump
                        PCWrite <= '1';
                        PCSrc <= "10";
                        state <= F;
                    
                    --when "001100" =>
                    
                    --when "001101" =>
                    
                    --when "001000" =>
                    
                    when others =>
                        state <= F;
                    
                end case;
                
                when MEM =>
                    case opcode is
                        when "101011" =>     --Store
                            MemWrite <= '1';
                            IorD <= '1';
                            state <= F;
                        when "100011" =>       --Load
                            MemRead <= '1';
                            IorD <= '1';
                            state <= WB;
                        when others =>
                            state <= F;
                        end case;
                when WB =>
                    case opcode is
                        when "000000" =>    --R type
                            RegDst <= '1';
                            RegWrite <= '1';
                            MemtoReg <= '0';
                            state <= F;
                        when "100011" =>    --Load
                            RegDst <= '0';
                            RegWrite <= '1';
                            MemtoReg <= '1';
                            state <= F;
                        when others =>
                            state <= F;
                    end case;
                    
        end case;
    end if;
end if;

end process;

end Behavioral;
