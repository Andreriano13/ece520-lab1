----------------------------------------------------------------------
-- rgb_led_top.vhd
-- Top level: blinks one colour of the Zybo RGB LED, chosen by switches.
-- ECE 520/L Lab 1 - Andres Riano
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rgb_led_top is
    generic (
        CLK_CYCLES_PER_TOGGLE : integer := 62500000
    );
    port (
        sys_clk : in  std_logic;                     -- 125 MHz
        rst     : in  std_logic;                     -- active-high, synchronous
        sw      : in  std_logic_vector(2 downto 0);  -- SW2..SW0 pick the colour
        rgb_out : out std_logic_vector(2 downto 0)   -- 0=Red 1=Green 2=Blue
    );
end rgb_led_top;

architecture Behavioral of rgb_led_top is

    component blinking_led is
        generic (CLK_CYCLES_PER_TOGGLE : integer := 62500000);
        port (
            sys_clk : in  std_logic;
            rst     : in  std_logic;
            led_en  : in  std_logic;
            led_out : out std_logic
        );
    end component;

    signal blink : std_logic;

begin

    ------------------------------------------------------------------
    -- One blinker. led_en is tied high: the colour mux below already
    -- handles every "LED off" case, so the blinker runs continuously
    -- and the mux decides where (or whether) it goes.
    ------------------------------------------------------------------
    blinker : blinking_led
        generic map (
            CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE
        )
        port map (
            sys_clk => sys_clk,
            rst     => rst,
            led_en  => '1',
            led_out => blink
        );

    ------------------------------------------------------------------
    -- Colour select. Exactly one switch = that colour blinks.
    -- Zero switches, or more than one = LED off.
    ------------------------------------------------------------------
    process (sw, blink)
    begin
        rgb_out <= "000";                    -- default: everything off
        case sw is
            when "001"  => rgb_out(0) <= blink;   -- SW0 -> Red
            when "010"  => rgb_out(1) <= blink;   -- SW1 -> Green
            when "100"  => rgb_out(2) <= blink;   -- SW2 -> Blue
            when others => null;                  -- 000, 011, 101, 110, 111 -> off
        end case;
    end process;

end Behavioral;
