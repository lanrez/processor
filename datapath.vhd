----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2020 06:30:24 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
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
end datapath;

architecture Behavioral of datapath is
--Reister file
--signal REG_FILE     : array(31 downto 0) of std_logic_vector(31 downto 0);

--Registers

signal PC           : std_logic_vector(31 downto 0);
signal IR           : std_logic_vector(31 downto 0);
signal MDR          : std_logic_vector(31 downto 0);
signal A           : std_logic_vector(31 downto 0);
signal B           : std_logic_vector(31 downto 0);
signal T           : std_logic_vector(31 downto 0);

--wires
signal iaddr            : std_logic_vector(31 downto 0);
signal iwtreg           : std_logic_vector(4 downto 0);
signal iwtdata          : std_logic_vector(31 downto 0);
signal iop1             : std_logic_vector(31 downto 0);
signal iop2             : std_logic_vector(31 downto 0);
signal iPC              : std_logic_vector(31 downto 0);
signal izero            : std_logic;
signal ibool            : std_logic;
signal iextend          : std_logic_vector(31 downto 0);
signal iresul          : std_logic_vector(31 downto 0);
signal iresult          : std_logic_vector(31 downto 0);
signal iMemData          : std_logic_vector(31 downto 0);
signal irddata1          : std_logic_vector(31 downto 0);
signal irddata2          : std_logic_vector(31 downto 0);
signal iALUOp            : std_logic_vector(2 downto 0);
signal iiALUOp           : std_logic_vector(2 downto 0);
--signal ifunccode        : std_logic_vector(11 downto 0);

--Components
component memo is
port(
clk : STD_LOGIC;
addr        : in std_logic_vector(31 downto 0);
writedata    : in std_logic_vector(31 downto 0);
memdata     : out std_logic_vector(31 downto 0);
MemRead     : in std_logic;
MemWrite    : in std_logic);
end component;

component RegFile is
port(
clk : STD_LOGIC;
rdreg1      : in std_logic_vector(4 downto 0);
rdreg2      : in std_logic_vector(4 downto 0);
wtreg       : in std_logic_vector(4 downto 0);
wtdata      : in std_logic_vector(31 downto 0);
rddata1      : out std_logic_vector(31 downto 0);
rddata2      : out std_logic_vector(31 downto 0);
RegWrite    : in std_logic);
end component;

component ALU is
port(
op1      : in std_logic_vector(31 downto 0);
op2      : in std_logic_vector(31 downto 0);
res      : out std_logic_vector(31 downto 0);
zero     : out std_logic;
--ALUOp    : in std_logic_vector (1 downto 0);
ALUOp : in std_logic_vector(2 downto 0)
);
end component;

begin

--Instantiate Componenents
mem : memo 
port map (clk => clk,
          addr =>iaddr,
          writedata => B,
          MemData => iMemData,
          MemRead => MemRead,
          MemWrite => MemWrite
          );
          
Reg : RegFile
port map(clk => clk,
         rdreg1 => IR(25 downto 21),
         rdreg2 => IR(20 downto 16),
         wtreg => iwtreg,
         wtdata => iwtdata,
         rddata1 => irddata1,
         rddata2 => irddata2,
         RegWrite => RegWrite
        );

ALU1 : ALU
port map(op1 => iop1,
         op2 => iop2,
         res => iresult,
         zero => izero,
         --ALUOp => ALUOp,
         ALUOp => iALUOp
);

--Operation
op <= IR(31 downto 26);
---------------------------------
-- Bool logic
----------------------------------
ibool <= PCWrite or (PCWriteCond and izero);

---------------------------------
-- ALU control logic
---------------------------------
with IR(5 downto 0) select
    iiALUOp <= "010" when "100000" | "100001",
               "001" when "100100",
               "000" when "100101",
               "110" when "100010" | "100011",
               "111" when "101010" | "101001",    
                unaffected when others;

with ALUOp select
    iALUOp <= "010" when "00",
           "110" when "01",
           iiALUOp when "10",
           unaffected when others;

---------------------------------
-- Multiplexer logic
---------------------------------

    -----------------------------
    -- -- Register Write register logic
    -----------------------------
    iwtreg <= IR (20 downto 16) when RegDst = '0' else
          IR (15 downto 11);
          
    -----------------------------
    -- -- Register Write data logic
    -----------------------------
    iwtdata <= T when MemtoReg = '0' else
           MDR;
    
    -----------------------------
    -- -- Memory address logic
    -----------------------------
    iaddr <= PC when IorD = '0' else
         T;
         
    -----------------------------
    -- -- ALU op1 logic
    -----------------------------
    iop1 <= PC when ALUSrcA = '0' else
        A;
        
    -----------------------------
    -- -- ALU op2 logic
    -----------------------------
    --iextend <= std_logic_vector(resize(signed(IR(15 downto 0)), 32));
    iextend(31 downto 16) <= (others => IR(15));
    iextend(15 downto 0) <= IR(15 downto 0);
     
    with ALUSrcB select
    iop2 <= B when "00",
            X"00000004" when "01",
            iextend when "10",
            iextend(29 downto 0) & "00" when "11",
            unaffected when others;
            
    -----------------------------
    -- -- PC select logic
    -----------------------------
    with PCSrc select
    iPC <= iresult when "00",
           T when "01",
           PC(31 downto 28) & IR(25 downto 0) & "00" when "10",
           unaffected when others;
            
--obsolete
--ifunccode <= IR(31 downto 26) & IR(5 downto 0);
      
--IR <= MDR when IRWrite = '1' else
--      unaffected;

---------------------------
-- PC Update
---------------------------- 
process (clk)
begin
    if (clk'event and clk = '1') then
        if (ibool = '1') then
            PC <= iPC;
        end if;
    end if;
end process;

---------------------------------
-- Reg T
---------------------------------
process (clk)
begin
    if (clk'event and clk = '1') then
        T <= iresult;
     end if;
end process;

---------------------------------
-- Reg A
---------------------------------
process (clk)
begin
    if (clk'event and clk = '1') then
        A <= irddata1;
     end if;
end process;

---------------------------------
-- Reg B
---------------------------------
process (clk)
begin
    if (clk'event and clk = '1') then
        B <= irddata2;
     end if;
end process;


---------------------------------
-- Reg IR
---------------------------------
process (clk)
begin
    if (clk'event and clk = '1') then
        if (IRWrite = '1') then
            IR <= iMemData;
        end if;
     end if;
end process;

---------------------------------
-- Reg MDR
---------------------------------
process (clk)
begin
    if (clk'event and clk = '1') then
        MDR <= iMemData;
     end if;
end process;

end Behavioral;
