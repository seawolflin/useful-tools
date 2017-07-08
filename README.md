# useful-tools

## automount.sh
这个脚本是在树莓派上把/dev/sd*的三个磁盘装载到/home/pi/nas-data, /home/pi/nas-data/Alice和/home/pi/nas-data/Seawolf目录下。为了想把指定磁盘装载到指定的目录下，由于磁盘插入usb是映射到/dev下的文件是不固定的，但是每个磁盘的UUID是固定的，所以可以把UUID作为判断挂载到哪个目录的依据。

## rpi-backup.sh
来自https://github.com/conanwhf/RaspberryPi-script/blob/master/rpi-backup.sh，
根据自己的实际情况改的。