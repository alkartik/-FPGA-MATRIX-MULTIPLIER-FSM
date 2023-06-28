library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_bit.all;
use ieee.std_logic_arith.all;



entity MAC is
port ( 
a: in unsigned(7 downto 0);
b: in unsigned(7 downto 0);
c: out unsigned(15 downto 0);
--reset: in std_logic;
Clk: in std_logic;
cntr : in integer
);
end MAC;

architecture behavioral of MAC is
    signal prod,reg : unsigned(15 downto 0);
begin
    process(Clk)
        variable sum : unsigned(15 downto 0);
    begin
        prod <= a*b;
--        if (reset='1') then
--            reg <= (others => '0');    
        if cntr=0 then
            if (Clk'EVENT AND clk='1') then
                sum := prod;
                reg <= sum;
            end if;
        elsif cntr=1 then
            if (Clk'EVENT AND clk='1') then
                        sum := prod+reg;
                        reg <= sum;
            end if;
        end if;
    c<=reg; 
    end process;
end architecture;