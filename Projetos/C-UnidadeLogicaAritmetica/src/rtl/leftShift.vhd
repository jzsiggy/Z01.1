library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity leftShift is
   port(
	    a    : in STD_LOGIC_VECTOR(15 downto 0);
        q    : out STD_LOGIC_VECTOR(15 downto 0)
        
   );
end leftShift;

architecture rtl of leftShift is
  -- Aqui declaramos sinais (fios auxiliares)
  -- e componentes (outros módulos) que serao
  -- utilizados nesse modulo.

begin

    q(0) <= '0';
    q(1) <= a(0);
    q(2) <= a(1);
    q(3) <= a(2);
    q(4) <= a(3);
    q(5) <= a(4);
    q(6) <= a(5);
    q(7) <= a(6);
    q(8) <= a(7);
    q(9) <= a(8);
    q(10) <= a(9);
    q(11) <= a(10);
    q(12) <= a(11);
    q(13) <= a(12);
    q(14) <= a(13);
    q(15) <= a(14);
    
end architecture;