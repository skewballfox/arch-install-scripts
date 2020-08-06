# Note don't run this unless your laptop occasionally wakes up on accident and overheats
# the following lines detect if it is a laptop, then writes a file disabling
# waking up if lid is opened.
# NOTE: may need to find better, more consistent, option
# NOTE: may use this to determine rest of the build process

read -r chassis_type </sys/class/dmi/id/chassis_type

if [[ ${chassis_type} == 9 ]] || [[ ${chassis_type} == 10 ]]; then
    echo 'w /proc/acpi/wakeup - - - - LID' >>/mnt/etc/tmpfiles.d/disable-lid-wakeup.conf
fi
