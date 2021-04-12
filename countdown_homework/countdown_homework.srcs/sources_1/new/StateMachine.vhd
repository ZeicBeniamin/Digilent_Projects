----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Zeic Beniamin
-- 
-- Create Date: 23.03.2021 11:56:12
-- Design Name: 
-- Module Name: StateMachine - Behavioral
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

entity StateMachine is
    Port ( sck100Mhz : in STD_LOGIC; -- clock source
           sbtnC : in STD_LOGIC; -- button used for start/stop/reset
           salarm : in STD_LOGIC; -- alarm signal, from counterBCD
           senCnt : out STD_LOGIC; -- enable counter signal
           sresCnt : out STD_LOGIC); -- reset counter signal
end StateMachine;

architecture Behavioral of StateMachine is

-- Enumerate the values the state can take
type state_type is (res0, res1, run0, run1, stop0, stop1, pause);

signal st, nxt_st: state_type := res0;

begin

-- Update the state of the machine on rising edges
sync_process:process(sck100Mhz)
begin
  -- at every risign edge, update the current state with  
  -- the next state  
  if rising_edge(sck100Mhz) then
    st <= nxt_st;
  end if;
end process;

-- The next state is recomputed only on button press and on
-- changes to the previous states
nxt_state_dcd:process(st, sbtnC, salarm)
begin
  -- By default, the process stays in the same state
  nxt_st <= st;
  -- Depending on button presses, the signal that holds the
  -- next state also changes
  
  -- MODIFIED - set the next state to 'pause' if the alarm is triggered
  if (salarm = '1') then
    nxt_st <= pause;
  end if;
  
  case(st) is
  -- If the button is presssed after a reset, move into the
  -- "run" state 
    when res1 => 
      if sbtnC = '1' then
        nxt_st <= run0;
      end if;
    when run0 =>
      if sbtnC = '0' then
        nxt_st <= run1;
      end if;
    when run1 =>
      if sbtnC = '1' then
        nxt_st <= stop0;
      end if;
    when stop0 =>
      if sbtnC = '0' then
        nxt_st <= stop1;
      end if;
    when stop1 =>
      if sbtnC = '1' then
        nxt_st <= res0;
      end if;
    when res0 =>
      if sbtnC = '0' then
        nxt_st <= res1;
      end if;
    -- MODIFIED
    -- on button press, pass from state 'pause' to 'reset'
    when pause =>
      if sbtnC = '1' then
        nxt_st <= res0;
      end if;
    when others =>
      nxt_st <= res0; 
  end case;
  
end process;

-- Output decode, based on the current state
-- Another process, one that changes the enCnt ouptut signal;
senCnt <= '1' when st=run0 OR st=run1 else '0';
-- The fourth process, that manages the resCnt siganl
sresCnt <= '1' when st=res0 else '0';


end Behavioral;
