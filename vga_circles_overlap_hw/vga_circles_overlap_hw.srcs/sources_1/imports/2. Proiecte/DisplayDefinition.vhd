--
--	Package File Template
--
--	Purpose: VGA resolution dependent constants.
--  Let the desired resolution constants active, comment the other resolutions constants. 
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package DisplayDefinition is

-- Display definitions for resolution 640 X 480
-- ckVideo = 25MHz
--  constant cstHorAc: integer := 640;  -- pixels/active line
--  constant cstHorFp: integer := 16;  -- pixels/front porch
--  constant cstHorPw: integer := 96;  -- pixels/pulse with
--  constant cstHorBp: integer := 48;  -- pixels/back porch
----  constant cstHorSize: integer := 800;-- cstHorAl + cstHorFp + cstHorPw + cstHorBp; -- pixel/total line
--   constant cstHorSize: integer := cstHorAc + cstHorFp + cstHorPw + cstHorBp; -- pixel/total line
 
--  constant cstVerAc: integer := 480;  -- lines/active frame
--  constant cstVerFp: integer := 10;  -- lines/front porch
--  constant cstVerPw: integer := 2;  -- lines/pulse with
--  constant cstVerBp: integer := 29;  -- lines/back porch
----  constant cstVerSize: integer := 521; --cstVerAf + cstVerFp + cstVerPw + cstVerBp; -- lines/total frame    
--  constant cstVerSize: integer := cstVerAc + cstVerFp + cstVerPw + cstVerBp; -- lines/total frame    
---- constants for DCM (50MHz to 25MHz)
--  constant cstCLKFX_DIVIDE: integer := 2;   --  Can be any interger from 1 to 32
--  constant cstCLKFX_MULTIPLY: integer := 2; --  Can be any integer from 1 to 32
--  constant cstCLKIN_DIVIDE_BY_2: boolean := true; --  TRUE/FALSE to enable CLKIN divide by two feature

---- constants for DCM (100MHz to 25MHz)
--  constant cstCLKFBOUT_MULT:  integer := 10;  -- Multiply value for all CLKOUT, (2-64) fVCO=1GHz
--  constant cstCLKIN1_PERIOD:  real := 10.000; -- Input clock period in ns to ps resolution 10ns.
--  -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
--  constant cstCLKOUT0_DIVIDE: integer := 40;  -- ckVideo = 25MHz
--  constant cstCLKOUT1_DIVIDE: integer := 2*cstCLKFBOUT_MULT;  -- FclkOut1 = FclkIn/2 = 50MHz
--  constant cstDIVCLK_DIVIDE:  integer :=  1;  -- Master division value, (1-56)


------ Display definitions for resolution 800 X 600
------ ckVideo = 40MHz
--  constant cstHorAc: integer := 800;  -- pixels/active line
--  constant cstHorFp: integer := 40;  -- pixels/front porch
--  constant cstHorPw: integer := 128;  -- pixels/pulse with
--  constant cstHorBp: integer := 88;  -- pixels/back porch
--  constant cstHorSize: integer := cstHorAc + cstHorFp + cstHorPw + cstHorBp; -- pixel/total line
 
--  constant cstVerAc: integer := 600;  -- lines/active frame
--  constant cstVerFp: integer := 1;  -- lines/front porch
--  constant cstVerPw: integer := 4;  -- lines/pulse with
--  constant cstVerBp: integer := 23;  -- lines/back porch
--  constant cstVerSize: integer := cstVerAc + cstVerFp + cstVerPw + cstVerBp; -- lines/total frame    

---- constants for DCM (100MHz to 40MHz)
--  constant cstCLKFBOUT_MULT:  integer := 10;  -- Multiply value for all CLKOUT, (2-64) fVCO=1GHz
--  constant cstCLKIN1_PERIOD:  real := 10.000; -- Input clock period in ns to ps resolution 10ns.
--  -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
--  constant cstCLKOUT0_DIVIDE: integer := 25;  -- ckVideo = 40MHz
--  constant cstDIVCLK_DIVIDE:  integer :=  1;  -- Master division value, (1-56)


---- Display definitions for resolution 1920 X 1080 60Hz
---- ckVideo = 148.5MHz (real = 148.571)
  constant cstHorAc: integer := 1920;  -- pixels/active line
  constant cstHorFp: integer := 88;  -- pixels/front porch
  constant cstHorPw: integer := 44;  -- pixels/pulse with
  constant cstHorBp: integer := 148;  -- pixels/back porch
  constant cstHorSize: integer := cstHorAc + cstHorFp + cstHorPw + cstHorBp; -- pixel/total line
 
  constant cstVerAc: integer := 1080;  -- lines/active frame
  constant cstVerFp: integer := 4;  -- lines/front porch
  constant cstVerPw: integer := 5;  -- lines/pulse with
  constant cstVerBp: integer := 36;  -- lines/back porch
  constant cstVerSize: integer := cstVerAc + cstVerFp + cstVerPw + cstVerBp; -- lines/total frame    

-- constants for DCM (100MHz to 148.571MHz)
  constant cstCLKFBOUT_MULT:  integer := 52;  -- Multiply value for all CLKOUT, (2-64) fVCO=1GHz
  constant cstCLKIN1_PERIOD:  real := 10.000; -- Input clock period in ns to ps resolution 10ns.
  -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
  constant cstCLKOUT0_DIVIDE: integer := 7;  -- ckVideo = 148.571MHz
  constant cstCLKOUT1_DIVIDE: integer := 21;  -- FclkOut1 = FclkIn/2 = 50MHz (49.524)
  constant cstDIVCLK_DIVIDE:  integer :=  5;  -- Master division value, (1-56)




end DisplayDefinition;

package body DisplayDefinition is

end DisplayDefinition;
