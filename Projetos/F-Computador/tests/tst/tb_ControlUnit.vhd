-- Elementos de Sistemas
-- developed by Luciano Soares
-- 1 tb_ControlUnit.vhd
-- date: 4/4/2017

Library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_ControlUnit is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_ControlUnit is

  component ControlUnit is
      port(
        instruction                 : in STD_LOGIC_VECTOR(17 downto 0);  -- instrução para executar
        zr,ng                       : in STD_LOGIC;                      -- valores zr(se zero) e ng(se negativo) da ALU
        muxALUI_A                   : out STD_LOGIC;
        muxAM                       : out STD_LOGIC;
        muxAMD                      : out STD_LOGIC;
        muxSD                       : out STD_LOGIC;
        zx, nx, zy, ny, f, no       : out STD_LOGIC;                     -- sinais de controle da ALU
        loadA, loadD, loadS, loadM, loadPC : out STD_LOGIC                      -- sinais de load do reg. A, reg. D, Mem. RAM e Program Counter
        );
  end component;

	signal clk : std_logic := '0';
  signal instruction                  : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
  signal zr,ng                        : STD_LOGIC := '0';
  signal muxAM                        : STD_LOGIC := '0';
  signal muxALUI_A                    : STD_LOGIC := '0';
  signal muxSD                        : STD_LOGIC := '0';
  signal muxAMD                       : STD_LOGIC := '0';
  signal zx, nx, zy, ny, f, no        : STD_LOGIC := '0';
  signal loadA, loadD, loadS, loadM, loadPC : STD_LOGIC := '0';

begin

	uCU: ControlUnit port map(instruction, zr, ng, muxALUI_A, muxAM, muxAMD, muxSD, zx, nx, zy, ny, f, no, loadA, loadD, loadS, loadM, loadPC);

	clk <= not clk after 100 ps;

  main : process
    begin
      test_runner_setup(runner, runner_cfg);

    -----------------------------------------------
    -- LAB
    -----------------------------------------------

    -- Teste: loadD
    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
    assert(loadD = '0')
      report "TESTE 1: LOAD D FALSO" severity error;

    instruction <= "10" & "0000000000010000";
    wait until clk = '1';
    assert(loadD = '1' and loadA = '0' and loadS = '0' and loadM = '0');
      report "TESTE 2: LOAD D" severity error;

    -- Teste: loadM
    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
    assert(loadM = '0')
      report "TESTE 3: LOAD m FALSO" severity error;

    instruction <= "10" & "0000000000100000";
    wait until clk = '1';
    assert(loadM = '1' and loadD = '0' and loadA = '0' and loadS = '0');
      report "TESTE 4: LOAD m" severity error;

    -- Teste: loadA
    instruction <= "10" & "0000000000100000";
    wait until clk = '1';
    assert(loadA = '0')
      report "TESTE 5: loadA falso" severity error;

    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
    assert(loadA = '1' and loadM = '0' and loadD = '0' and loadS = '0');
      report "TESTE 6: loadA" severity error;

    -- Teste: loadS
    instruction <= "10" & "0000000000100000";
    wait until clk = '1';
    assert(loadS = '0')
      report "TESTE 5: loadA falso" severity error;

    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
    assert(loadS = '1' and loadM = '0' and loadD = '0' and loadA = '0');
      report "TESTE 6: loadA" severity error;  

    -- Teste: muxALUI_A
    instruction <= "10" & "0000000000100000";
    wait until clk = '1';
    assert(muxALUI_A = '0')
      report "TESTE 7: muxALUIA" severity error;

    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
    assert(muxALUI_A = '1')
      report "TESTE 8: muxALUIA falso" severity error;

    -- Teste: zx
    instruction <= "10" & "0001000000000000";
    wait until clk = '1';
    assert(zx = '1')
      report "TESTE 9: zx" severity error;

    instruction <= "00" & "0001000000000000";
    wait until clk = '1';
    assert(zx = '0')
      report "TESTE 10: zx" severity error;


   -----------------------------------------------
   -- leaw
   -----------------------------------------------

		-- Teste: A instruction
    instruction <= "00" & "0111111111111111";
    wait until clk = '1';
		assert(loadA = '1' and loadD = '0' and loadM = '0' and loadPC = '0' and muxALUI_A = '1')
      report "Falha em leaw 0xFFFF, %A" severity error;

		-- leaw %5, %A
    instruction <= "00" & "0000000000000101";
    wait until clk = '1';
		assert(loadA = '1' and loadD = '0' and loadM = '0' and loadPC = '0' and muxALUI_A = '1')
      report "Falha em leaw 5, %A" severity error;

    -----------------------------------------------
    -- Zero na saida da ALU gravando
    ----------------------------------------------
    -- mov 0 -> D
    instruction <= "10" & "000" & "101010" & "0010" & "000";
    wait until clk = '1';
    assert(loadA  = '0' and loadD  = '1' and  loadM  = '0' and  loadPC = '0' and
           zx = '1' and nx = '0' and zy = '1' and ny = '0' and f = '1' and no = '0')
      report " **Falha** mov %0, %D " severity error;

       -- mov (%A) -> D
    instruction <= "10" & "010" & "110000" & "0010" & "000";
    wait until clk = '1';
    assert(loadA  = '0' and loadD  = '1' and  loadM  = '0' and  loadPC = '0' and
           zx = '1' and nx = '1' and zy = '0' and ny = '0' and f = '0' and no = '0')
      report " **Falha** mov (%A), %D " severity error;