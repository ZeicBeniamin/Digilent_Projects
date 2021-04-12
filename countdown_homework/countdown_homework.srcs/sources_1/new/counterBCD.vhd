----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Zeic Beniamin
-- 
-- Create Date: 09.03.2021 16:58:53
-- Design Name: counterBCD
-- Module Name: counterBCD - Behavioral
-- Project Name: 03_counter_bcd
-- Target Devices: Basys 3
-- Tool Versions: Vivado 2020.2
-- Description: 
-- 4-bit BCD counter with async Reset (resCnt) and sync Enable (enCnt)
-- clock prescaller/divider by 1000000
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


entity counterBCD is
    Port ( ck100Mhz : in STD_LOGIC; -- clock 
           resCnt : in STD_LOGIC; --reset counter
           enCnt : in STD_LOGIC; -- enable counter
           data : out unsigned (15 downto 0);
           alarm_out : out STD_LOGIC); -- counter storage
end counterBCD;

architecture Behavioral of counterBCD is
  
  constant cstPresc: integer := 1000000; -- prescaler signal
  signal cntPresc: integer range 0 to cstPresc - 1; 
  signal ck100Hz: std_logic;
  signal cntBcd: unsigned(15 downto 0);
  signal alarm: std_logic;
  -- internal signal; can be used as counter

begin

prescaller: process(ck100MHz, resCnt)
begin
  -- on reset, the counter basically stops
  if resCnt = '1' then  -- asynchronous reset
    cntPresc <= 0;   
  -- on enCnt=1, the counter is enabled and the prescaler is 
  -- incremented until it reaches the preset value 
  elsif rising_edge(ck100MHz) then
    if enCnt = '1' then -- synchronous enable
      if cntPresc = cstPresc - 1 then
        cntPresc <= 0;
        ck100Hz <= '1';  -- see alternatives
      else
        cntPresc <= cntPresc + 1;
        ck100Hz <= '0'; -- see alternatives
      end if;
    end if;    
  end if;
end process;
  
  
-- MODIFIED: Decreases counter, but does not start from 10:00
BcdCounter: process(ck100Hz, resCnt)
begin
  if resCnt = '1' then
    -- cntBcd <= (others => '0');
    -- MODIFIED - On reset, reinitialize the counter to 10
    cntBcd(15 downto 0) <= "0001000000000000";
    alarm_out <= '0';
  elsif rising_edge(ck100Hz) then
  -- if the counter has reached 0, trigger the alarm 
    if cntBcd = "0000000000000000"  then
      alarm_out <= '1';
    -- otherwise, continue counting
    elsif enCnt = '1' then
      if cntBcd(3 downto 0) = x"0" then  -- if digit is 0
        cntBcd(3 downto 0) <= x"9";  -- set digit to 9
        if cntBcd(7 downto 4) = x"0" then  -- analyze next digit 
          cntBcd(7 downto 4) <= x"9";  
          if cntBcd(11 downto 8) = x"0" then  
            cntBcd(11 downto 8) <= x"9";
            if cntBcd(15 downto 12) = x"0" then  
              cntBcd(15 downto 12) <= x"9";
            else
              cntBcd(15 downto 12) <= cntBcd(15 downto 12) - 1; -- decrement digit
            end if; 
          else
            cntBcd(11 downto 8) <= cntBcd(11 downto 8) - 1;  
          end if;      
        else
          cntBcd(7 downto 4) <= cntBcd(7 downto 4) - 1;   
        end if;      
      else
        cntBcd(3 downto 0) <= cntBcd(3 downto 0) - 1; 
      end if;      
    end if;
  end if;
end process;    

data <= cntBcd; -- internal signal to output port
  
end Behavioral;
