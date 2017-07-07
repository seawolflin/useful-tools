#!/bin/bash
# 挂着三个USB设备到指定目录下，目录结构为：
# nas-data
#   - Alice
#   - Seawolf

getUUID(){
    for item in $1
    do
        split=(${item//=/ })
        if   test ${split[0]} = UUID
        then
            uuid=${split[1]}
            results=(${uuid//\"/ })
            echo ${results[0]}
            break
        fi
    done
}

mount_dir_base=/home/pi/ # 要挂载USB设备的路径
mount_dirs=(nas-data nas-data/Alice nas-data/Seawolf)
# 三个磁盘对应的uuid，可以通过blkid获取到
disk_uuids=(a1a14afa-b278-4b7d-9676-f046caa9d889 F004E86304E82DF2 3254268554264C43)
# mount_txt=/etc/mount.txt

# fdisk -l | grep /dev/ > $mount_txt
mount_result=`fdisk -l | grep /dev/ | awk '{print $1}'|awk '/dev\/sd*/'`

# 确认nas-data目录存在
mount_dir=${mount_dir_base}${mount_dirs[0]}
umount -fl $mount_dir > /dev/null 2>&1  # 如果第一次拔掉的时候没有umount，这里可以实现首先umount之后再进行挂载
`test -d ${mount_dir}`
status=$?
if [ $status -eq 1 ]
then
	echo "mkdir ${mount_dir}"
	mkdir $mount_dir
fi

# 先安装nas-data
echo "先安装nas-data"
i=0
for disk in $mount_result
do
	mount_dir=${mount_dir_base}${mount_dirs[0]}
	disk_uuid="$(getUUID "`blkid ${disk}`")" #获取磁盘的UUID
	if test $disk_uuid = ${disk_uuids[0]}
	then
		mount $disk $mount_dir
		echo "mount ${disk} ${mount_dir}"
		ls -l ${mount_dir}
		break
	fi
	i=`expr $i + 1`
done

# 确认其他目录都存在
mount_dir=${mount_dir_base}${mount_dirs[1]}
umount -fl $mount_dir > /dev/null 2>&1  # 如果第一次拔掉的时候没有umount，这里可以实现首先umount之后再进行挂载
`test -d ${mount_dir}`
status=$?
if [ $status -eq 1 ]
then
	echo "mkdir ${mount_dir}"
	mkdir $mount_dir
fi
mount_dir=${mount_dir_base}${mount_dirs[2]}
umount -fl $mount_dir > /dev/null 2>&1  # 如果第一次拔掉的时候没有umount，这里可以实现首先umount之后再进行挂载
`test -d ${mount_dir}`
status=$?
if [ $status -eq 1 ]
then
	echo "mkdir ${mount_dir}"
	mkdir $mount_dir
fi

# 再把剩下的安装到nas-data下
echo "再把剩下的安装到nas-data下"
for disk in $mount_result
do
	disk_uuid="$(getUUID "`blkid ${disk}`")" #获取磁盘的UUID
	case $disk_uuid in
		${disk_uuids[0]})
			continue
		;;
		${disk_uuids[1]})
			mount_dir=${mount_dir_base}${mount_dirs[1]}
		;;
		${disk_uuids[2]})
			mount_dir=${mount_dir_base}${mount_dirs[2]}
		;;
	esac
	mount $disk $mount_dir
	echo "mount ${disk} ${mount_dir}"
    ls -l ${mount_dir}
done

echo "-----------------------"
echo "         End           "
echo "-----------------------"
