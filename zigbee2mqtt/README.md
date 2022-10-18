## Mosquitto
* First load /docker/mosquitto/config/mosquitto.conf file with auth disable 
```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/logs/mosquitto.log
listener 1883
allow_anonymous true
```   

* Within the container run create_password.sh  
* Enable auth in config file 
```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/logs/mosquitto.log
password_file /mosquitto/config/mosquitto.passwd
listener 1883
allow_anonymous false
```
* Intregate in HomeAssistant


## Zigbee2MQTT  

#### Set Persistent Name for the Adapter  

Sometime, the adapter name (location) may change if you unplug the adapter and plug it again. It is better to set a persistent name for the adapter. Here is how you do it.

First, plug in the SONOFF Zigbee 3.0 USB Dongle Plus adapter and list all USB devices: `lsusb`

    pi@zigbee2mqtt:/etc/udev/rules.d $ lsusb
    Bus 001 Device 005: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP2102/CP2109 UART Bridge Controller [CP210x family]
    Bus 001 Device 004: ID 0658:0200 Sigma Designs, Inc. Aeotec Z-Stick Gen5 (ZW090) - UZB
    Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp. SMSC9512/9514 Fast Ethernet Adapter
    Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp. SMC9514 Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    

In this case, the ID for adapter is “10c4:ea60”. Please take note of this ID.

Next, create this file: `sudo nano /etc/udev/rules.d/99-usb-serial.rules` and then enter this line into it…

    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="zigbee"

Note the idVendor and idProduct are the value gotten from above step. “zigbee” is the persistent name that you want it to be.

Reboot the Pi: `sudo reboot`

To test, unplug the adapter and plug it back. Then execute this: `ls -l /dev/zigbee`. It should show this result…

    lrwxrwxrwx 1 root root 7 Mar 30 11:28 /dev/zigbee -> ttyUSB0


* Load configuration.yaml to /docker/zigbee2mqtt/data
* Configure server, user and pass for mosquitto 