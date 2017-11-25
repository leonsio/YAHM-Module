#!/bin/sh
#LXC_CONFIG_FILE=/var/lib/lxc/yahm/config
#LXC_ROOTFS_PATH=/var/lib/lxc/yahm/root
#LXC_NAME=yahm

if [ -f /var/lib/lxc/${LXC_NAME}/.modules/pivccu-driver ] 
then
	YAHM_KERNEL="pivccu"
	YAHM_DEVICE="raw-uart"
elif [ -f /var/lib/lxc/${LXC_NAME}/.modules/homematic-ip ] 
then
	YAHM_KERNEL="homematic-ip"
	YAHM_DEVICE="bcm2835-raw-uart"
else
	YAHM_KERNEL="none"
	exit 0
fi

if [ -d /sys/devices/virtual/eq3loop ] 
then
	EQ3LOOP_MAJOR=`cat /sys/devices/virtual/eq3loop/eq3loop/dev | cut -d: -f1`
	echo -n $EQ3LOOP_MAJOR > /sys/module/plat_eq3ccu2/parameters/eq3charloop_major
fi
if [ "${YAHM_KERNEL}" != "none" ] 
then
	UART_MAJOR=`cat /sys/devices/virtual/${YAHM_DEVICE}/${YAHM_DEVICE}/dev | cut -d: -f1`
	echo -n $UART_MAJOR > /sys/module/plat_eq3ccu2/parameters/uart_major
fi
#todo ggf checks einbauen ob alles richtig installiert wurde?
