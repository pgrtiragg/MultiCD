#!/bin/sh
set -e
#Linux Mint Debian Edition plugin for multicd.sh
#version 5.8
#Copyright (c) 2010 maybeway36, Zirafarafa
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
	if [ -f mintdebian.iso ];then
		echo "Linux Mint Debian Edition"
	fi
elif [ $1 = copy ];then
	if [ -f mintdebian.iso ];then
		echo "Linux Mint Debian Edition"
		plugins/ubuntu-common.sh mintdebian
	fi
elif [ $1 = writecfg ];then
if [ -f mintdebian.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << EOF
label mintdebian
menu label --> Linux Mint ^Debian Edition Menu
com32 vesamenu.c32
append /boot/mintdebian/mintdebian.cfg

EOF
cat >> multicd-working/boot/mintdebian/mintdebian.cfg << EOF

label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
EOF
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi