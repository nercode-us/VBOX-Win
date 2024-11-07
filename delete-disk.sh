#!/bin/bash
# To run this script on Windows you need Msys2 https://www.msys2.org/
#
cd /c/Program\ Files/Oracle/VirtualBox
./vboxmanage list hdds | tr -s '\\' '\n' | grep -e 'UUID' -e 'Capacity' -e '\.vdi' | grep -v 'Parent UUID' \
| tr -s '\n' ' ' | sed 's/UUID/\nUUID/g' | awk '{print $1,$2,$3,$5,$6}' | grep '\.vdi' | awk '{print $1,$2,$3,$4,$5}' | sed 's/UUID:/ */g' \
| grep -n '' | awk '{print $2,$1,$3,$4,$5,$6}' 
echo -e "Select drive to delete or close [CTRL+C]:"
read num
disk=`./vboxmanage list hdds | tr -s '\\\' '\n' | grep -e 'UUID' -e 'Capacity' -e '\.vdi' | grep -v 'Parent UUID' | tr -s '\n' ' ' \
| sed 's/UUID/\nUUID/g' | awk '{print $1,$2,$3,$5,$6}' | grep '\.vdi' | awk '{print $1,$2,$3,$4,$5}' | sed 's/UUID:/ */g' | grep -n '' \
| awk '{print $2,$1,$3,$4,$5,$6}' | grep "\* $num\:" | awk '{print $4}'`
echo "Disk: "$disk
id=`./vboxmanage list hdds | tr -s '\\\' '\n' | grep -e 'UUID' -e 'Capacity' -e '\.vdi' | grep -v 'Parent UUID' | tr -s '\n' ' ' \
| sed 's/UUID/\nUUID/g' | awk '{print $1,$2,$3,$5,$6}' | grep '\.vdi' | awk '{print $1,$2,$3,$4,$5}' | sed 's/UUID:/ */g' | grep -n '' \
| awk '{print $2,$1,$3,$4,$5,$6}' | grep "\* $num\:" | awk '{print $3}'`
echo "Disk ID: "$id
echo -n "Press [ENTER] to delete: "
read
./VBoxManage.exe closemedium disk $id --delete > /dev/null 2>&1
./VBoxManage.exe mediumproperty delete $id $disk > /dev/null 2>&1

echo "Disk was deleted."
