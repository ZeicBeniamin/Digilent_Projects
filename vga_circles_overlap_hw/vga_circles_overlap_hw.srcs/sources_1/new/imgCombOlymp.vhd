----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2021 17:24:32
-- Design Name: 
-- Module Name: imgCombOlymp - Behavioral
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

entity imgCombOlymp is
    Port ( ckVideo: in std_logic;
           flgActiveArea : in STD_LOGIC;
           flgOlymp : in STD_LOGIC_VECTOR (5 downto 0);
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end imgCombOlymp;

architecture Behavioral of imgCombOlymp is
 
  signal red, grn, blu: std_logic_vector(3 downto 0); -- internal colors
  
begin

-- Implement the code below with flip-flops
--  red <= (others => flgOlymp(1) or flgOlymp(2) or flgOlymp(3)); -- white, red, yellow
--  grn <= (others => flgOlymp(1) or flgOlymp(3) or flgOlymp(4)); -- white, yellow, green
--  blu <= (others => flgOlymp(0) or flgOlymp(1)); -- blue, white
   
  -- subtract colors rather than adding them
          -- red out of blue, black and green
  red <= (others => (not(flgOlymp(0) or flgOlymp(1) or flgOlymp(4))
                     -- add red back over the lower yellow-blue joint
                     or (flgOlymp(0) and flgOlymp(3) and flgOlymp(5))
                     -- add red back over the upper black-yellow joint
                     or (flgOlymp(1) and flgOlymp(3) and not(flgOlymp(5)))
                     -- add red back over the lower red-green joint
                     or (flgOlymp(2) and flgOlymp(4) and flgOlymp(5))));  
  
          -- take green out of blue, black and red
  grn <= (others => (not(flgOlymp(0) or flgOlymp(1) or flgOlymp(2)))
                    -- add green back over the lower yellow-blue joint (TODO: red)
                     or (flgOlymp(0) and flgOlymp(3) and flgOlymp(5))
                    -- add green back over the upper black-yellow joint (TODO: red)
                     or (flgOlymp(3) and flgOlymp(1) and not(flgOlymp(5)))
                    -- add green back to the lower green-black joint
                    or (flgOlymp(1) and flgOlymp(4) and flgOlymp(5))
                    -- add green back to the upper red-green joint 
                    or (flgOlymp(2) and flgOlymp(4) and not(flgOlymp(5))));
                     
          -- take blue out of all the circles (except the blue one)
  blu <= (others => (not(flgOlymp(1) or flgOlymp(2) or flgOlymp(3) or flgOlymp(4)) or
                     --not(flgOlymp(0) and flgOlymp(3) and flgOlymp(5))) or
                     -- add blue at the upper yellow-blue joint
                     (flgOlymp(0) and flgOlymp(3) and not (flgOlymp(5)))));
                    
  -- test signals
--  red <= (others => flgOlymp(5));                     
  
--  -- black reference - combinatorial; simplified processes
--  vgaRed   <= red when flgActiveArea = '1' else "0000";
--  vgaGreen <= grn when flgActiveArea = '1' else "0000"; 
--  vgaBlue  <= blu when flgActiveArea = '1' else "0000";
  
-- black reference; output register 
OutReg: process(ckVideo, flgOlymp)
begin
  if rising_edge(ckVideo) then
    if flgActiveArea = '1' then
      vgaRed   <= red;
      vgaGreen <= grn;
      vgaBlue  <= blu;
    else
      vgaRed   <= "0000";
      vgaGreen <= "0000";
      vgaBlue  <= "0000";
    end if;
  end if;    
end process;  
  
end Behavioral;