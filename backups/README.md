[

![](https://www.it-react.com/wp-content/uploads/2020/02/ingo-schulz-mwWZTLr9Tcg-unsplash-e1580675497622.jpg)

Photo by Ingo Schulz on Unsplash



](https://www.it-react.com/index.php/2020/02/02/backup-your-raspberry-pi-remotely/ "Backup your Raspberry Pi remotely")

*   [February 2, 2020](https://www.it-react.com/index.php/2020/02/02/)
*   [
    
    Ioan Penu](https://www.it-react.com/index.php/author/crymy22/)
*   [IoT](https://www.it-react.com/index.php/category/iot/), [Linux](https://www.it-react.com/index.php/category/linux/)

I think Raspbbery Pi is a great device and I love how easy and fun is to create IoT projects using it. I am using Raspberry Pi at my vacation house and also at my parents summer house. It is monitoring remotely the temperature, the voltage of batteries connected to the wind-turbine and solar-panels and controlling the alarm system and some relays that are starting and stopping different appliances.

These projects started for fun and curiosity, but as time goes by, they seem to become a very important component of the house itself, whithout which, it is difficult to imagine now the existence of the house.

Therefore we have to keep this component as safe as possible and to have a backup in case something goes wrong. Because, in my case, it’s almost impossible to do a backup of the SD card locally, I would need a remotely backup solution.  
  
So let’s see how can we create it. I’ll use a Linux VM as local computer from where I start the connection.

### **Step one – Check SD Card**

Connect to RPi from Linux VM local computer:
```
 root@kali:~# ssh pi@192.168.1.223  
```
Once in, use this command to list block devices :
```
pi@raspberrypi:~ $ lsblk -p
 NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
 /dev/mmcblk0     179:0    0 29.8G  0 disk
 ├─/dev/mmcblk0p1 179:1    0 42.9M  0 part /boot
 └─/dev/mmcblk0p2 179:2    0 29.8G  0 part /
```
Note block device marked above, then disconnect from RPi.

**Step two – Backup your Raspberry**
------------------------------------

Start the backup from Linux local computer using this command :
```
 root@kali:~# ssh pi@192.168.1.223 "sudo dd if=/dev/mmcblk0 bs=1M | gzip -" | dd of=~/Desktop/pibackup.gz
 ..............................
 pi@192.168.1.223's password: 
```
add the password of the RPi and the backup will start.

**Command explained:**

*   ssh = secure shell. Starts connection to RPi
*   pi = the name of the user you are logging in as on RPi
*   @192.168.1.223 = the IP address of RPi
*   sudo = elevate the privilages to the super user
*   dd = tool used to copy and convert files
*   if=/dev/mmcblk0 = input file, will read the SD card of the RPi in this case
*   bs=1M = instruct dd to use a block size of 1MB
*   | = pipe command will transfer the reading of the SD card to gzip program
*   gzip = program that compresses files
*   \- = instruct gzip to compress the output of the SD card
*   | = pipe command will transfer the compressed file to next command
*   of=~/Desktop/pibackup.gz = output file, will write the compressed file named pibackup.gz on the of the local user’s Desktop.

### **Step three – Check status of the backup**

Open a new Terminal window in Linux local computer and check the status of the backup:
```
root@kali:~/Desktop# watch -n 10 ls -alh

Every 10.0s: ls -lh                         kali: Sun Feb  2 14:18:39 2020
 total 494M
 -rw-r--r--  1 root root 494M Feb  2 14:18 pibackup.gz
```
You can use “watch” command to update the “ls -alh” command every n seconds, here is 10s.

When the backup is complete, you will get a similar information in the Terminal from which you started the command.
```
 30528+0 records in                                                                                                                                                                                                
 30528+0 records out                                                                                                                                                                                               
 32010928128 bytes (32 GB, 30 GiB) copied, 50627.9 s, 632 kB/s                                                                                                                                                     
 25290460+1 records in                                                                                                                                                                                             
 25290460+1 records out                                                                                                                                                                                            
 12948715910 bytes (13 GB, 12 GiB) copied, 50644.9 s, 256 kB/s   
```
### **Step four – Restore Raspberry**

There is no way to restore the RPi remotely, you have to remove the micro SD card from RPi and the insert it to your local machine via an USB micro SD card reader.  
As I’m using a Linux VM that is running in VMWorkstation, it will take me a few more steps until the SD card will be seen by the VM. More information about this subject you can find [here](https://www.it-react.com/index.php/2020/02/03/add-sd-card-in-vmworkstation/).  
Once all the above are done, you can start your Linux VM and run the following command to check the SD card drive:
```
ioan@kali:~$ lsblk -p
 NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
 /dev/sda       8:0    0 59.6G  0 disk 
 └─/dev/sda1   8:1    0 59.6G  0 part 
 /dev/sdb      8:16   0   50G  0 disk 
 ├─/dev/sdb1   8:17   0 49.3G  0 part /
 ├─/dev/sdb2   8:18   0    1K  0 part 
 └─/dev/sdb5   8:21   0  765M  0 part \[SWAP\]
 /dev/sr0     11:0    1    2G  0 rom  
```
So now that we found out the drive of the SD card, we can start the restore. In my case SD card has /dev/sda, so the command is looking like this:
```
 root@kali:~# gunzip -dc pibackup.gz | sudo dd of=/dev/sda bs=1M
```
And after some time, you’ll get this once finished:
```
 1+936147 records in
 1+936147 records out
 32010928128 bytes (32 GB, 30 GiB) copied, 517.036 s, 61.9 MB/s 
```
Now you have your RPi’s system back on the SD card. Just remove it from the local machine, insert it in the RPi and you are good to go.

 
