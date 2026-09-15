##----------------------------------------------------------------------
## zybo_z7.xdc  -  Zybo Z7-10  -  ECE 520/L Lab 1, Procedure
## Andres Riano
##
## Procedure step 22: SW0 UP makes LED0 blink once per second.
## Pins taken from Digilent Zybo-Z7-Master.xdc (digilent-xdc repository).
##----------------------------------------------------------------------

## Clock - 125 MHz system clock
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33 } [get_ports { sys_clk }];
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clk }];

## Reset - BTN0
set_property -dict { PACKAGE_PIN K18  IOSTANDARD LVCMOS33 } [get_ports { rst }];

## LED enable - SW0
set_property -dict { PACKAGE_PIN G15  IOSTANDARD LVCMOS33 } [get_ports { led_en }];

## LED output - LED0
set_property -dict { PACKAGE_PIN M14  IOSTANDARD LVCMOS33 } [get_ports { led_out }];
