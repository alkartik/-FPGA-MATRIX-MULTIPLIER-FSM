library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
--use ieee.numeric_bit.all;
use IEEE.std_logic_unsigned;

entity controlFSM is
port(
clk: in std_logic;
fgh : out unsigned(15 downto 0)
);  
end controlFSM;

architecture behavioral of controlFSM is

component addressgen
  Port (
  ad1 : in integer;
  ad2 : integer;
  ad3 : in integer;
  addr1 : out std_logic_vector(13 downto 0);
  addr2 : out std_logic_vector(13 downto 0);
  addr3 : out std_logic_vector(13 downto 0) 
   );
end component;

component rom1
port(
clk : in std_logic;
a : in std_logic_vector(13 downto 0);
spo : out std_logic_vector(7 downto 0)
);
end component;

component rom2
port(
clk : in std_logic;
a : in std_logic_vector(13 downto 0);
spo : out std_logic_vector(7 downto 0)
);
end component;

component ram
port(
clk : in std_logic;
a : in std_logic_vector(13 downto 0);
d : in std_logic_vector(15 downto 0);
we : in std_logic;
spo : out std_logic_vector(7 downto 0)
);
end component;

component reg_a
port ( 
signal rega_input :in unsigned(7 downto 0);
signal we: in std_logic;
signal clk: in std_logic;
signal rega_output: out unsigned(7 downto 0)
); 
end component;

component reg_b
port (
signal rega_input :in unsigned(15 downto 0);
signal we: in std_logic;
signal clk: in std_logic;
signal rega_output: out unsigned(15 downto 0)
); 
end component;

component MAC is
port ( 
a: in unsigned(7 downto 0);
b: in unsigned(7 downto 0);
c: out unsigned(15 downto 0);
Clk: in std_logic;
cntr : in integer
);
end component;

signal i1: unsigned(7 downto 0);
--signal i1: std_logic_vector(7 downto 0);
signal we1: std_logic;
signal o1: unsigned(7 downto 0);
--signal o1: std_logic_vector(7 downto 0);
signal i2: unsigned(7 downto 0);
--signal i2: std_logic_vector(7 downto 0);
signal we2: std_logic;

signal o2: unsigned(7 downto 0);
--signal o2: std_logic_vector(7 downto 0);
signal i3: unsigned(15 downto 0);
--signal i3: std_logic_vector(15 downto 0);
signal we3: std_logic;
signal o3: unsigned(15 downto 0);
--signal o3: std_logic_vector(15 downto 0);
signal a1 : integer := 0;
signal a2 : integer := 0;
signal i : integer := 0;
signal addr1 : std_logic_vector(13 downto 0):="00000000000000";
signal addr2 : std_logic_vector(13 downto 0):="00000000000000";
signal addr3 : std_logic_vector(13 downto 0):="00000000000000";
signal ad1 : integer;
signal ad2 : integer;
signal ad3 : integer;
signal fe: integer :=0 ;
signal re: integer :=0 ;
signal we : std_logic:='1';
signal x : std_logic_vector(7 downto 0);
signal y : std_logic_vector(7 downto 0);
signal zx : std_logic_vector(15 downto 0);
signal yz : std_logic_vector(15 downto 0);


begin
ad1<=128*a1+i;
ad2<=128*i+a2;
ad3<=128*a1+a2;

process(clk)
begin
 if falling_edge(clk) then
  if fe=3 then
    fe<=1;
  else 
    fe<=fe+1;
  end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(clk) then
  if re=3 then
    re<=1;
  else
    re<=re+1;
  end if;
 end if;
end process;

process(fe)
begin
  if fe=1 then
    we2<='0';
    we1<='0';
    we3<='0';
  elsif fe=2 then
    we3<='1';
    we2<='0';
    we1<='0';
  elsif fe=3 then
    we3<='0';
    we2<='1';
    we1<='1';
    if i = 128 then
      i<=0;
      if a2=127 then
         if a1=127 then
           a1<=127;
           a2<=127;
         else 
          a1<=a1+1;
          a2<=0;
         end if;
      else 
         a2<=a2+1;
      end if;
    else
     i<=i+1;
    end if;  
  end if;
end process;

mac1 : MAC port map(
a=>o1,
b=>o2,
c=>i3,
Clk=>clk,
cntr=>i
);

reg1 : reg_a port map(
rega_input=>i1,
we=>we1,
clk=>clk,
rega_output=>o1
);

reg2 : reg_a port map(
rega_input=>i2,
we=>we2,
clk=>clk,
rega_output=>o2
);

reg3 : reg_b port map(
rega_input=>i3,
we=>we3,
clk=>clk,
rega_output=>o3
);

addgen : addressgen port map(
ad1=>ad1,
ad2=>ad2,
ad3=>ad3,
addr1=>addr1,
addr2=>addr2,
addr3=>addr3
);

fgh<=o3;

rom12 : rom1 port map(
clk=>clk,
a => addr1,
spo =>x
);
x<=std_logic_vector(i1);

rom22: rom2 port map(
clk=>clk,
a => addr2,
spo=> y
);
y<=std_logic_vector(i2);

ram1 : ram port map(
clk=>clk,
we=>we,
d=>yz,
a=>addr3,
spo=>zx 
);

zx<=std_logic_vector(o3);
yz<=std_logic_vector(i3);

end architecture;