----------------------------------------------------------------------
-- tb_blinking_led.vhd
-- Testbench for blinking_led. Three test cases per the lab procedure.
-- ECE 520/L Lab 1 - Andres Riano
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_blinking_led is
end tb_blinking_led;

architecture sim of tb_blinking_led is

    -- The lab asks for a toggle every 10 clock cycles in simulation.
    constant TB_CYCLES  : integer := 10;
    constant CLK_PERIOD : time    := 8 ns;   -- 125 MHz, matching the Zybo Z7

    signal sys_clk : std_logic := '0';
    signal rst     : std_logic := '1';
    signal led_en  : std_logic := '0';
    signal led_out : std_logic;

begin

    uut : entity work.blinking_led
        generic map (
            CLK_CYCLES_PER_TOGGLE => TB_CYCLES
        )
        port map (
            sys_clk => sys_clk,
            rst     => rst,
            led_en  => led_en,
            led_out => led_out
        );

    -- Free-running 125 MHz clock
    clk_process : process
    begin
        sys_clk <= '0';
        wait for CLK_PERIOD / 2;
        sys_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_process : process
    begin
        ----------------------------------------------------------------
        -- TEST CASE 1 - Reset Behavior
        -- rst = 1 and led_en = 0 for the first 5 clock cycles.
        -- led_out must be 0 and the counter must be held at 0.
        ----------------------------------------------------------------
        rst    <= '1';
        led_en <= '0';
        wait for CLK_PERIOD * 5;
        assert led_out = '0'
            report "TEST 1 FAILED: led_out not 0 during reset" severity error;

        ----------------------------------------------------------------
        -- TEST CASE 2 - Disabled Output
        -- Deassert reset but keep led_en = 0.
        -- led_out stays 0 and the counter stays 0 while disabled.
        ----------------------------------------------------------------
        rst <= '0';
        wait for CLK_PERIOD * 10;
        assert led_out = '0'
            report "TEST 2 FAILED: led_out not 0 while disabled" severity error;

        ----------------------------------------------------------------
        -- TEST CASE 3 - LED Toggling
        -- Assert led_en. led_out toggles once every 10 rising edges.
        -- Stopping at 55 clocks leaves led_out HIGH, so dropping led_en
        -- shows the required 1 -> 0 transition.
        ----------------------------------------------------------------
        led_en <= '1';
        wait for CLK_PERIOD * 55;

        led_en <= '0';
        wait for CLK_PERIOD * 10;
        assert led_out = '0'
            report "TEST 3 FAILED: led_out did not clear when led_en went low" severity error;

        report "All tests completed." severity note;
        wait;
    end process;

end sim;
