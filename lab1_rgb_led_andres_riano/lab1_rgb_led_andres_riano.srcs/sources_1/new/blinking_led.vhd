----------------------------------------------------------------------
-- blinking_led.vhd
-- Parameterized LED blinker. ECE 520/L Lab 1 - Andres Riano
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity blinking_led is
    generic (
        -- 125 MHz / 2 = 62,500,000 cycles per toggle.
        -- Two toggles = one full blink, so the LED blinks once per second.
        CLK_CYCLES_PER_TOGGLE : integer := 62500000
    );
    port (
        sys_clk : in  std_logic;   -- 125 MHz system clock
        rst     : in  std_logic;   -- active-high, synchronous
        led_en  : in  std_logic;   -- LED enable
        led_out : out std_logic    -- LED output
    );
end blinking_led;

architecture Behavioral of blinking_led is

    signal counter   : unsigned(31 downto 0) := (others => '0');
    signal led_state : std_logic := '0';

begin

    process (sys_clk)
    begin
        if rising_edge(sys_clk) then
            -- Reset OR disabled: clear both the counter and the output.
            if rst = '1' or led_en = '0' then
                counter   <= (others => '0');
                led_state <= '0';

            -- Reached the top: toggle and wrap.
            elsif counter = CLK_CYCLES_PER_TOGGLE - 1 then
                counter   <= (others => '0');
                led_state <= not led_state;

            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    led_out <= led_state;

end Behavioral;