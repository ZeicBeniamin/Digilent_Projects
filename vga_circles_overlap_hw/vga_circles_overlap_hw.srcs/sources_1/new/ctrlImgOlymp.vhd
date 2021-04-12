----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2021 17:00:19
-- Design Name: 
-- Module Name: ctrlImgOlymp - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

use work.DisplayDefinition.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrlImgOlymp is

  Port ( 
    ckVideo: in std_logic; -- only needed for pipeline
--    adrHScreen : in STD_LOGIC_VECTOR (31 downto 0);
--    adrVScreen : in STD_LOGIC_VECTOR (31 downto 0);
    adrHScreen : in signed (31 downto 0);
    adrVScreen : in signed (31 downto 0);
    flgOlymp : out STD_LOGIC_VECTOR (5 downto 0)); 
    -- 4=green, 3=yellow, 2=red, 1=white, 0=blue

end ctrlImgOlymp;

architecture Behavioral of ctrlImgOlymp is

constant cstHOlympSize : integer := cstHorAc * 4/10; -- the horizontal size of the circles area
constant cstHOlympOrig : integer := cstHorAc/2 - cstHOlympSize/2; -- horizontal origin
constant cstVOlympOrig : integer := cstVerAc/10; -- vertical origin

 --constant cstVOlympOrig: integer := 1/10*cstVerAc; -- 1/10=0 in integer
 
  type OlimpCenterType is array (0 to 4) of integer;
  constant cstHOlimpCenter: OlimpCenterType := 
      (cstHOlympSize*157/1000 + cstHOlympOrig, -- blue 
       cstHOlympSize*497/1000 + cstHOlympOrig, -- white
       cstHOlympSize*837/1000 + cstHOlympOrig, -- red
       cstHOlympSize*331/1000 + cstHOlympOrig, -- yellow
       cstHOlympSize*671/1000 + cstHOlympOrig);-- green   
  constant cstVOlimpCenter: OlimpCenterType := 
       (cstHOlympSize*157/1000 + cstVOlympOrig, -- blue  
        cstHOlympSize*157/1000 + cstVOlympOrig, -- white
        cstHOlympSize*157/1000 + cstVOlympOrig, -- red
        cstHOlympSize*331/1000 + cstVOlympOrig, -- yellow
        cstHOlympSize*331/1000 + cstVOlympOrig);-- green
        
  constant cstMedianLine : integer := cstHOlympSize*244/1000 + cstVOlympOrig;     
     
  constant cstOlimpRadExt: integer := cstHOlympSize*157/1000;
  constant cstOlimpRadInt: integer := cstHOlympSize*131/1000;
 
  type distToCenterCenter2Type is array (0 to 4) of integer range 0 to cstHorAc**2 + cstVerAc**2;
  -- distances from the current pixel to centers of the circles (at power 2) 
  signal distToCenter2: distToCenterCenter2Type;  

  signal distToCenterH : distToCenterCenter2Type;
  signal distToCenterV : distToCenterCenter2Type;
  
  signal distToCenterH2 : distToCenterCenter2Type;
  signal distToCenterV2 : distToCenterCenter2Type;

begin

distances: process(adrHScreen, adrVScreen)
  begin
    if rising_edge(ckVideo) then
      for i in 0 to 4 loop
      -- split the calculations in two parallel pipelines
         distToCenter2(i) <= distToCenterH2(i) + distToCenterV2(i);
         distToCenterH2(i) <= distToCenterH(i)**2;  
         distToCenterV2(i) <= distToCenterV(i)**2;
         distToCenterH(i) <= (to_integer(adrHScreen) - cstHOlimpCenter(i));
         distToCenterV(i) <= (to_integer(adrVScreen) - cstVOlimpCenter(i));
       
      end loop;
    end if;
  end process; 
  
circles: process(adrHScreen, adrVScreen)
begin
-- TODO> IF OUT
   --if rising_edge(ckVideo) then

    flgOlymp <= (others => '0');
    for i in 0 to 4 loop
      if distToCenter2(i) >= cstOlimpRadInt **2 and
         distToCenter2(i) <= cstOlimpRadExt **2 then
        flgOlymp(i) <= '1';
      end if;
    end loop;
    
    if adrVScreen > cstMedianLine then
      flgOlymp(5) <= '1';
    else
      flgOlymp(5) <= '0';
    end if; 
  --end if;     
end process;
 
end Behavioral;
