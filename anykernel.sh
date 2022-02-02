# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Flashing Kernel
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=X00T
device.name2=X00TD
device.name3=x00t
device.name4=x00td
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/soc/c0c4000.sdhci/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

# Mount partitions as rw
mount /system;
mount /vendor;
mount -o remount,rw /system;
mount -o remount,rw /vendor;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 755 755 $ramdisk/init* $ramdisk/sbin;

## AnyKernel boot install
dump_boot;

# begin ramdisk changes
# Remove old kernel stuffs from ramdisk
ui_print "cleaning up ramdisk....";
sleep 5
rm -rf $ramdisk/*.sh
rm -rf $ramdisk/*.rc

ui_print "Tweaked....."
sleep 5
[ -f minerv.prop ] && . minerv.prop
cp hosts /etc/hosts

# init.rc
# backup_file init.rc;
# replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# init.tuna.rc
# backup_file init.tuna.rc;
# insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
# append_file init.tuna.rc "bootscript" init.tuna;

# fstab.tuna
# backup_file fstab.tuna;
# patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
# patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
# patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
# append_file fstab.tuna "usbdisk" fstab;

# end ramdisk changes

write_boot;
## end boot install

# shell variables
#block=vendor_boot;
#is_slot_device=1;

# reset for vendor_boot patching
#reset_ak;

## AnyKernel vendor_boot install
#split_boot; # skip unpack/repack ramdisk since we don't need vendor_ramdisk access

#flash_boot;
## end vendor_boot install
