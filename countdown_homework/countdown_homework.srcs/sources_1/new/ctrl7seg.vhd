----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Zeic Beniamin
-- 
-- Create Date: 09.03.2021 18:45:57
-- Design Name: 
-- Module Name: ctrl7seg - Behavioral
-- Project Name: 
-- Target Devices: Basys 3
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

entity ctrl7seg is
    Port ( ck100Mhz : in STD_LOGIC;
           data : in unsigned (15 downto 0);
           alarm : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           led : out unsigned (15 downto 0)
           );
end ctrl7seg;

architecture Behavioral of ctrl7seg is

-- cntPresc gives the sweeping frequency of the BCD figures 
signal cntPresc: unsigned(19 downto 0); -- 10ns * (2^20) = 10.485760 ms
-- first 2 digits of cntPresc are used as select for the 4 figures of the BCD 
alias cntAn is cntPresc(19 downto 18); -- the first two digits used as select for BCD
signal hex: unsigned(3 downto 0); -- a single hexadecimal digit

begin
  
  led <= cntPresc(15 downto 0);
  
  prescaller: process(ck100Mhz)
  begin
    if rising_edge(ck100Mhz) then
      cntPresc <= cntPresc + 1; -- rollover counter
    end if;
  end process;

  an <= "1110" when cntAn = "00" else
        "1101" when cntAn = "01" else
        "1011" when cntAn = "10" else
        "0111"; -- when cntAn="11"
        
  -- upload the values from the data array corresponding to each
  -- figure, depending on the selection signal "cntAn"
  hex <=  data(3 downto 0) when cntAn = "00" else
          data(7 downto 4) when cntAn = "01" else
          data(11 downto 8) when cntAn = "10" else
          data(15 downto 12);--whhen cntAn ="11"
  
  -- only activate the second decimal point
  decimal_point:process(alarm, cntAn)
  begin
    -- light up all the decimal points on alarm
    if (alarm = '1') then
      dp <= '0'; -- negative logic
    -- if not, only light up the second decimal point
    else
      if (cntAn = "10") then
        dp <= '0';
      else 
        dp <= '1';
      end if;
    end if;
  end process;
  
  --HEX-to-seven-segment decoder
  --   HEX:   in    STD_LOGIC_VECTOR (3 downto 0);
  --   LED:   out   STD_LOGIC_VECTOR (6 downto 0);
  --
  -- segment encoding
  --       0
  --      ----
  --  5 |     | 1
  --      ----   <- 6
  --  4 |     | 2
  --      ----
  --       3
  
  with hex SELect
  -- negative logic: cathodes
  seg<= "1111001" when "0001",   --1  
        "0100100" when "0010",   --2
        "0110000" when "0011",   --3
        "0011001" when "0100",   --4
        "0010010" when "0101",   --5
        "0000010" when "0110",   --6
        "1111000" when "0111",    --7
        "0000000" when "1000",   --8
        "0010000" when "1001",   --9
        "0001000" when "1010",   --A
        "0000011" when "1011",   --b
        "1000110" when "1100",   --C
        "0100001" when "1101",   --d
        "0000110" when "1110",   --E
        "0001110" when "1111",    --F
        "1000000" when others;   --0
        
        

      
end Behavioral;
