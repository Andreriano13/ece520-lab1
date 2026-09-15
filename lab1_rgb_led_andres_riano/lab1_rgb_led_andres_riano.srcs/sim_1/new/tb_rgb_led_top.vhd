----------------------------------------------------------------------
-- tb_rgb_led_top.vhd
-- Testbench for the top level. Seven test cases covering colour select,
-- the multi-switch OFF rule, and reset behaviour.
-- ECE 520/L Lab 1 - Andres Riano
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_rgb_led_top is
end tb_rgb_led_top;

architecture sim of tb_rgb_led_top is

    -- Small value so a toggle takes 5 clocks instead of 62.5 million.
    constant TB_CYCLES  : integer := 5;
    constant CLK_PERIOD : time    := 8 ns;   -- 125 MHz

    signal sys_clk : std_logic := '0';
    signal rst     : std_logic := '0';
    signal sw      : std_logic_vector(2 downto 0) := "000";
    signal rgb_out : std_logic_vector(2 downto 0);

begin

    uut : entity work.rgb_led_top
        generic map (
            CLK_CYCLES_PER_TOGGLE => TB_CYCLES
        )
        port map (
            sys_clk => sys_clk,
            rst     => rst,
            sw      => sw,
            rgb_out => rgb_out
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
        -- TEST 1 - reset holds the LED off even with a switch on
        ----------------------------------------------------------------
        rst <= '1';
        sw  <= "001";
        wait for CLK_PERIOD * 10;
        assert rgb_out = "000"
            report "TEST 1 FAILED: output not off while in reset" severity error;

        rst <= '0';
        wait for CLK_PERIOD * 2;

        ----------------------------------------------------------------
        -- TEST 2 - SW0 selects RED, and it blinks
        ----------------------------------------------------------------
        sw <= "001";
        wait for CLK_PERIOD * 30;

        ----------------------------------------------------------------
        -- TEST 3 - SW1 selects GREEN
        ----------------------------------------------------------------
        sw <= "010";
        wait for CLK_PERIOD * 30;

        ----------------------------------------------------------------
        -- TEST 4 - SW2 selects BLUE
        ----------------------------------------------------------------
        sw <= "100";
        wait for CLK_PERIOD * 30;

        ----------------------------------------------------------------
        -- TEST 5 - TWO switches at once turns the LED OFF
        ----------------------------------------------------------------
        sw <= "011";
        wait for CLK_PERIOD * 20;
        assert rgb_out = "000"
            report "TEST 5 FAILED: two switches should give OFF" severity error;

        ----------------------------------------------------------------
        -- TEST 6 - NO switches gives OFF
        ----------------------------------------------------------------
        sw <= "000";
        wait for CLK_PERIOD * 20;
        assert rgb_out = "000"
            report "TEST 6 FAILED: no switches should give OFF" severity error;

        ----------------------------------------------------------------
        -- TEST 7 - reset asserted MID-BLINK clears the output
        ----------------------------------------------------------------
        sw  <= "001";
        wait for CLK_PERIOD * 15;
        rst <= '1';
        wait for CLK_PERIOD * 10;
        assert rgb_out = "000"
            report "TEST 7 FAILED: reset did not clear the output" severity error;

        rst <= '0';
        wait for CLK_PERIOD * 20;

        report "All tests completed." severity note;
        wait;
    end process;

end sim;
