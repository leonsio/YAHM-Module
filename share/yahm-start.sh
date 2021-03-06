#!/bin/sh

EQ3LOOP_MAJOR=`cat /sys/module/plat_eq3ccu2/parameters/eq3charloop_major`
UART_MAJOR=`cat /sys/module/plat_eq3ccu2/parameters/uart_major`

version () { echo "$@" | awk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'; }

# generate/update dev nodes

rm -f /dev/eq3loop
rm -f /dev/ttyS0
rm -f /dev/mmd_bidcos
rm -f /dev/mxs_auart_raw.0

mknod -m 666 /dev/mxs_auart_raw.0 c $UART_MAJOR 0

# get radio mac and serial
/bin/eq3configcmd update-coprocessor -p /dev/mxs_auart_raw.0 -t HM-MOD-UART -c -se 2>&1 | grep "SerialNumber:" | cut -d' ' -f5 > /sys/module/plat_eq3ccu2/parameters/board_serial
/bin/eq3configcmd read-default-rf-address -f /dev/mxs_auart_raw.0 -h | grep "^0x" > /sys/module/plat_eq3ccu2/parameters/radio_mac

firmware_version=`/bin/eq3configcmd update-coprocessor -p /dev/mxs_auart_raw.0 -t HM-MOD-UART -c -v 2>&1 | grep "Version:" | cut -d' ' -f5`
echo $firmware_version > /sys/module/plat_eq3ccu2/parameters/board_extended_info

if [ "$(version "$firmware_version")" -lt "$(version "2.0.0")" ]; then
	ln -sf /dev/mxs_auart_raw.0 /dev/mmd_bidcos
else
	mknod -m 666 /dev/eq3loop c $EQ3LOOP_MAJOR 0                               
	mknod -m 666 /dev/ttyS0 c $EQ3LOOP_MAJOR 1  
	mknod -m 666 /dev/mmd_bidcos c $EQ3LOOP_MAJOR 2
fi
