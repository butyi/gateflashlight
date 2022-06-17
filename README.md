# gateflashlight

Motorized gate moving warning flash light

## Introduction

This project was developed as a solution for my motorized gate moving warning flash light,
which got wet and damaged. It was easier and cheaper to put an
[sci2can](https://github.com/butyi/sci2can).
board into the light instead of buy another.

## Software

Software is pure assembly code.

To understand my description below you may need to look at the related part in
[processor reference manual](https://www.nxp.com/docs/en/data-sheet/MC9S08DZ60.pdf).

#### Central Processor Unit (S08CPUV3)
 
Regarding assembly commands read
[HCS08RMV1.pdf](https://www.nxp.com/docs/en/reference-manual/HCS08RMV1.pdf).
Now (when I am writing this) it is not available on this link. I have saved it
[here](https://github.com/butyi/sci2can/raw/master/hw/HCS08RMV1.pdf).

#### Parallel Input/Output Control

To prevent extra current consumption caused by flying not connected input ports,
all ports shall be configured as output. I have configured ports to low level
output by default.

#### Multi-purpose Clock Generator (S08MCGV1)

MCG is configured to PEE mode. But this mode can be reached through other modes.
See details in
[AN3499](https://www.nxp.com/docs/en/application-note/AN3499.pdf).
Bus frequency is only 4MHz now.

### Main loop

#### Initialization

Stack, ports, needed modules are initialized one by one.

#### Main activity

The main activity is to get value from a fast free-running counter
as random value for random time for turn on-off the light.
Cause of random flash time is just for fun, to make some strange. :smile:
Too short and and too long values are filtered out to not apply.
Power of LED is limited by a simple software PWM, that On state
is only 25% duty PWM. This value is experimental value, cause
enough light but not too much heat on power LED.

### Compile

- Download assembler from [aspisys.com](http://www.aspisys.com/asm8.htm).
  It works on both Linux and Windows.
- Check out the repo
- Run my bash file `./c`.
  Or run `asm8 prg.asm` on Linux, `asm8.exe prg.asm` on Windows.
- prg.s19 is now ready to download.

### Download

Since I haven't written downloader/bootloader for DZ family yet, I use USBDM.

![USBDM](https://github.com/butyi/sci2can/raw/master/pics/myusbdm.png)

USBDM Hardware interface is cheap. I have bought it for 10€ on Ebay.
(Update 2022: it is already 13€) Search "USBDM S08".

USBDM has free software tool support for S08 microcontrollers.
You can download it from [here](https://sourceforge.net/projects/usbdm/).
When you install the package, you will have Flash Downloader tools for several
target controllers. Once is for S08 family.

It is much more comfortable and faster to call the download from command line.
Just run my bash file `./p`.

## Hardware

The hardware is [sci2can board](https://github.com/butyi/sci2can)
Once digital output controls the power LED.
Supply of light is 230V AC. I used a small 230V-5V supply board to have 5V for
the microcontroller board.
Search "AC 230V to DC5V Converter Mini Switching Power Supply Module Board" on ebay.

![USBDM](https://github.com/butyi/gateflashlight/raw/master/pics/mini_power_supply_board.png)

## License

This is free. You can do anything you want with it.
While I am using Linux, I got so many support from free projects,
I am happy if I can give something back to the community.

## Keywords

Motorola, Freescale, NXP, MC68HC9S08DZ60, 68HC9S08DZ60, HC9S08DZ60, MC9S08DZ60,
9S08DZ60, HC9S08DZ48, HC9S08DZ32, HC9S08DZ, 9S08DZ, UART, RS232.

###### 2022 Janos BENCSIK


