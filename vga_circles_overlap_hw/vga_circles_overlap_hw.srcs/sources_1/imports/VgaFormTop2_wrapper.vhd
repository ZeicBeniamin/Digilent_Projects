--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
--Date        : Mon Apr  5 11:02:28 2021
--Host        : phantomcoder running 64-bit Ubuntu 18.04.5 LTS
--Command     : generate_target VgaFormTop2_wrapper.bd
--Design      : VgaFormTop2_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity VgaFormTop2_wrapper is
  port (
    ck100Mhz : in STD_LOGIC;
    vgaBlue : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vgaGreen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vgaHsync : out STD_LOGIC;
    vgaRed : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vgaVsync : out STD_LOGIC
  );
end VgaFormTop2_wrapper;

architecture STRUCTURE of VgaFormTop2_wrapper is
  component VgaFormTop2 is
  port (
    ck100Mhz : in STD_LOGIC;
    vgaHsync : out STD_LOGIC;
    vgaVsync : out STD_LOGIC;
    vgaRed : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vgaGreen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    vgaBlue : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component VgaFormTop2;
begin
VgaFormTop2_i: component VgaFormTop2
     port map (
      ck100Mhz => ck100Mhz,
      vgaBlue(3 downto 0) => vgaBlue(3 downto 0),
      vgaGreen(3 downto 0) => vgaGreen(3 downto 0),
      vgaHsync => vgaHsync,
      vgaRed(3 downto 0) => vgaRed(3 downto 0),
      vgaVsync => vgaVsync
    );
end STRUCTURE;
