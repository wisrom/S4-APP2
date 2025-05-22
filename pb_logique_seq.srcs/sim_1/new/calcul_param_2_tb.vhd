library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
 
entity tb_calcul_param_2 is
end tb_calcul_param_2;
 
architecture behavior of tb_calcul_param_2 is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;
 
    -- Signals
    signal i_bclk    : std_logic := '0';
    signal i_reset   : std_logic := '0';
    signal i_en      : std_logic := '0';
    signal i_ech     : std_logic_vector (23 downto 0) := (others => '0');
    signal o_param   : std_logic_vector (7 downto 0);
    begin
            -- Connect UUT ports to signals
    uut: entity work.calcul_param_2 
        port map (
        i_bclk    => i_bclk,
        i_reset   => i_reset,
        i_en      => i_en,
        i_ech     => i_ech,
        o_param   => o_param
    );
    -- Clock process definitions
    clk_process :process
    begin
        wait for 5 ns;
        i_bclk <= not i_bclk;
    end process;
 
    -- Stimulus process
    stim_proc : process
    begin
        -- Initialize
        i_reset <= '1';
        wait for 10 ns;
        i_reset <= '0';
 
        wait for 10 ns;
        i_en <= '1';
        i_ech <= "101010101001110111000000";
 
 
        -- Test case 1: Reset, Enable, and Sample Input
        i_reset <= '1';
        wait for 10 ns;
        i_reset <= '0';
        wait for 10 ns;
        i_en <= '1';
        i_ech <= "000111000111100100010001";
        wait for 10 ns;
        i_en <= '0';
        wait for 10 ns;
 
        -- Test case 2: Another Reset, Enable, and a different Sample Input
        i_reset <= '1';
        wait for 10 ns;
        i_reset <= '0';
        wait for 10 ns;
        i_en <= '1';
        i_ech <= "111110001110110011110001";
        wait for 10 ns;
        i_en <= '0';
        wait for 10 ns;
 
        -- Add more test cases as needed
        i_reset <= '1';
        wait for 10 ns;
        i_reset <= '0';
        wait for 10 ns;
        i_en <= '1';
        i_ech <= "101010101001110111000000";
        wait for 10 ns;
        i_en <= '1';
        wait for 10 ns;
        i_en <= '0';
        wait for 10 ns;
        i_en <= '1';
        i_ech <= "111110001110110011110001";
             wait;
    end process;
 
    -- Instantiate the Unit Under Test (UUT)
    -- Add assertions or check statements if needed
 
end;