##----------------------------------------------------------------------
## zybo_rgb.xdc  —  Zybo Z7-10  —  ECE 520/L Lab 1
## Andres Riano
##----------------------------------------------------------------------

## Clock — 125 MHz system clock
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33 } [get_ports { sys_clk }];
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clk }];

## Reset — BTN0, as the lab requires
set_property -dict { PACKAGE_PIN K18  IOSTANDARD LVCMOS33 } [get_ports { rst }];

## Switches — SW0, SW1, SW2 select the colour
set_property -dict { PACKAGE_PIN G15  IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];

## RGB LED 6  (LED5 is Zybo Z7-20 only — do not use it)
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports { rgb_out[0] }];  ## led6_r  Red
set_property -dict { PACKAGE_PIN F17  IOSTANDARD LVCMOS33 } [get_ports { rgb_out[1] }];  ## led6_g  Green
set_property -dict { PACKAGE_PIN M17  IOSTANDARD LVCMOS33 } [get_ports { rgb_out[2] }];  ## led6_b  Blue