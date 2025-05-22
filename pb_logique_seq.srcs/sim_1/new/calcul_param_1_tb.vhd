library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_calcul_param_1 IS
END tb_calcul_param_1;

ARCHITECTURE behavior OF tb_calcul_param_1 IS 
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL en : STD_LOGIC := '0';
    SIGNAL ech : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    SIGNAL param : STD_LOGIC_VECTOR(7 downto 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.calcul_param_1
        PORT MAP (
            i_bclk => clk,
            i_reset => reset,
            i_en => en,
            i_ech => ech,
            o_param => param
        );

    -- Clock process definitions
    clk_process :process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initialize
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000001";
        wait for 10 ns;
        en <= '0';

        -- Test 2
        reset <= '1';  -- Assert reset before starting the next test
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000001";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000010";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000100";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "100000000000000000001000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000010000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000100000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000001000000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000010000000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000100000000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000001000000000";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000010000000001";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "100000000000100000000001";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000001000000000001";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000010000000000001";
        wait for 10 ns;
        en <= '0';
        
        wait for 10 ns;
        en <= '1';
        ech <= "000000000000000000000000";
        wait for 10 ns;
        en <= '0';
        
        
        wait for 100 ns;
        en <= '0';

        -- Add more tests as needed

        wait;
    end process;

END;
