#### Set Persistent Name for the Adapter  

Sometime, the adapter name (location) may change if you unplug the adapter and plug it again. It is better to set a persistent name for the adapter. Here is how you do it.

First, plug in the 3d Printer and list all USB devices: `lsusb`

    pi@zigbee2mqtt:/etc/udev/rules.d $ lsusb
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 001 Device 004: ID 04d9:0007 Holtek Semiconductor, Inc. Raspberry Pi Internal Keyboard
    Bus 001 Device 003: ID 10c4:ea60 Silicon Labs CP210x UART Bridge
    Bus 001 Device 009: ID 1a86:7523 QinHeng Electronics CH340 serial converter
    Bus 001 Device 002: ID 2109:3431 VIA Labs, Inc. Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    
Bus 001 Device 009: ID 1a86:7523 QinHeng Electronics CH340 serial converter  ->  **Ender3Pro**  
In this case, the ID for adapter is 1a86:7523. Please take note of this ID.

Next, create this file: `sudo nano /etc/udev/rules.d/99-usb-serial.rules` and then enter this line into it…

    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="ender3pro"

Note the idVendor and idProduct are the value gotten from above step. ender3pro is the persistent name that you want it to be.

Reboot the Pi: `sudo reboot`

To test, unplug the adapter and plug it back. Then execute this: `ls -l /dev/ender3pro`. It should show this result…

    lrwxrwxrwx 1 root root 7 Oct 19 00:04 /dev/ender3pro -> ttyUSB1
