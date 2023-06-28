library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity MAC_tb is
end MAC_tb;

architecture rtl of MAC_tb is

constant ClockFrequency : integer := 100e6;
constant ClockPeriod    : time    := 1000 ms / ClockFrequency;


component MAC
port ( 
a: in unsigned(7 downto 0);
b: in unsigned(7 downto 0);
c: out unsigned(15 downto 0);
reset: in std_logic;
Clk: in std_logic;
cntr: in integer
);
end component;

signal a: unsigned(7 downto 0):="00000000";
signal b: unsigned(7 downto 0):="00000000";
signal c: unsigned(7 downto 0);
signal reset : std_logic := '0';
signal Clk : std_logic:='1';
signal cntr : integer :=0;
begin

pm: MAC port map(
a=>a,
b=>b,
c=>c,
reset=>reset,
Clk=>Clk,
cntr=>cntr
);

Clk <= not Clk after ClockPeriod / 2;

P1 : process
begin
a<="00000111";
b<="00001011";
cntr<=0;
wait for 40ns;
a<="00000111";
b<="00001011";
cntr<=1;
wait for 40ns;
a<="00000111";
b<="00001011";
cntr<=2;
wait for 40ns;
a<="00000001";
b<="00001011";
cntr<=3;
wait;
end process;
end rtl;
