----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2021 19:11:14
-- Design Name: 
-- Module Name: TopChrono - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopChrono is
    Port ( ck100Mhz : in STD_LOGIC;
           btnC : in STD_LOGIC; -- reset
           sw : in STD_LOGIC_VECTOR (0 downto 0);
           led : out unsigned (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0); --digit select
           dp : out STD_LOGIC
           ); --decimal point
end TopChrono;

architecture Structural of TopChrono is

  signal data : unsigned(15 downto 0);
  signal enCnt, resCnt : std_logic;
  signal btnCDeb : std_logic;
  signal alarm : STD_LOGIC;
  

  -- The BCD 7 segment controller component
  component ctrl7seg is
      Port ( ck100Mhz : in STD_LOGIC;
             data : in unsigned (15 downto 0);
             alarm : in STD_LOGIC;
             seg : out STD_LOGIC_VECTOR (6 downto 0);
             an : out STD_LOGIC_VECTOR (3 downto 0);
             dp : out STD_LOGIC;
             led : out unsigned (15 downto 0)
             );
  end component;
  
  -- The counter component
  component counterBCD is
      Port ( ck100Mhz : in STD_LOGIC;
             resCnt : in STD_LOGIC;
             enCnt : in STD_LOGIC;
             data : out unsigned (15 downto 0);
             alarm_out : out STD_LOGIC);
  end component;

  -- Declaration of the state machine
  component StateMachine is
      Port (sck100Mhz : in STD_LOGIC; -- clock source
            sbtnC : in STD_LOGIC; -- button used for start/stop/reset
            salarm : in STD_LOGIC; -- alarm signal, from counterBCD
            senCnt : out STD_LOGIC; -- enable counter signal
            sresCnt : out STD_LOGIC); -- reset counter signal
  end component;
  
begin

  instctrl7seg: ctrl7seg
  Port map(
      ck100MHz => ck100MHz,
        data => data,
        alarm => alarm,
        seg => seg,
        an => an,
        dp => dp,
        led => led);
  
  instBcd: counterBcd 
      Port map (
        ck100MHz => ck100MHz,
        resCnt => resCnt,  -- reset
        enCnt => enCnt,  -- enable
        data => data,
        -- MODIFIED - added "alarm_out"
        alarm_out => alarm);
        
  
  -- Instantiation of the state machine
  instStateMachine : StateMachine
      Port map( sck100Mhz => ck100Mhz,  -- connect the clock pin (sck100Mhz) to the clock signal 
         sbtnC => btnC,
         senCnt => enCnt,
         sresCnt => resCnt,
         -- MODIFIED - added "salarm"
         salarm => alarm
        );


end Structural;