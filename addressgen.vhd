library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity addressgen is
  Port (
  ad1 : in integer;
  ad2 : integer;
  ad3 : in integer;
  addr1 : out std_logic_vector(13 downto 0);
  addr2 : out std_logic_vector(13 downto 0);
  addr3 : out std_logic_vector(13 downto 0) 
   );
end addressgen;

architecture Behavioral of addressgen is

begin


addr1 <= std_logic_vector(to_unsigned(ad1,14));
addr2 <= std_logic_vector(to_unsigned(ad2,14));
addr3 <= std_logic_vector(to_unsigned(ad3,14));

end Behavioral;
