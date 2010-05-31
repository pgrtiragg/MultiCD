#!/bin/sh
set -e
#Ubuntu #2 plugin for multicd.sh
#version 5.4
#Copyright (c) 2010 maybeway36
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
if [ $1 = scan ];then
	if [ -f ubuntu2.iso ];then
		echo "Ubuntu #2 (for using multiple versions on one disc - 9.10 or newer)"
		echo > tags/ubuntu2
	fi
elif [ $1 = copy ];then
	if [ -f ubuntu2.iso ];then
		echo "Copying Ubuntu #2..."
		if [ ! -d ubuntu2 ];then
			mkdir ubuntu2
		fi
		if grep -q "`pwd`/ubuntu2" /etc/mtab ; then
			umount ubuntu2
		fi
		mount -o loop ubuntu2.iso ubuntu2/
		cp -R ubuntu2/casper multicd-working/boot/ubuntu2 #Live system
		cp -R ubuntu2/preseed multicd-working/boot/ubuntu2
		# Fix the isolinux.cfg
		cp ubuntu2/isolinux/text.cfg multicd-working/boot/ubuntu2/ubuntu2.cfg
		sed -i 's@default live@default menu.c32@g' multicd-working/boot/ubuntu2/ubuntu2.cfg
		sed -i 's@file=/cdrom/preseed/@file=/cdrom/boot/ubuntu2/preseed/@g' multicd-working/boot/ubuntu2/ubuntu2.cfg
		sed -i 's^initrd=/casper/^live-media-path=/boot/ubuntu2 ignore_uuid initrd=/boot/ubuntu2/^g' multicd-working/boot/ubuntu2/ubuntu2.cfg
		sed -i 's^kernel /casper/^kernel /boot/ubuntu2/^g' multicd-working/boot/ubuntu2/ubuntu2.cfg
		sed -i 's^splash.jpg^linuxmint.jpg^g' multicd-working/boot/ubuntu2/ubuntu2.cfg
		umount ubuntu2;rmdir ubuntu2
	fi
elif [ $1 = writecfg ];then
if [ -f ubuntu2.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << EOF
label ubuntu2
menu label --> Ubuntu #2 Menu
com32 menu.c32
append /boot/ubuntu2/ubuntu2.cfg

EOF
cat >> multicd-working/boot/ubuntu2/ubuntu2.cfg << EOF

label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
EOF
if [ -f tags/ubuntu2.name ];then
	perl -pi -e "s/Ubuntu\ \#2/$(cat tags/ubuntu2.name)/g" multicd-working/boot/isolinux/isolinux.cfg
fi
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi