skip_flag=0
cont_flag=0
EFI_Flag="empty"
skip_flag="placeholder"

while [[ ${skip_flag} != "n" ]] && [[ ${skip_flag} != "no" ]]; do
    echo -e "Have the partitions already been set up?\n Type y(es) or n(o): "
    read APart_Flag
    if [[ ${skip_flag} == "y" ]] || [[ ${skip_flag} == "yes" ]]; then
        #skip all this shit if already managed
        exit
    elif [[ ${skip_flag} != "n" ]] && [[ ${skip_flag} != "no" ]]; then
        echo "Response not understood, Please try again"
    fi
done
skip_flag="placeholder"
while [[ ${skip_flag} != "n" ]] && [[ ${skip_flag} != "no" ]]; do
    echo -e "Do you want to zero the drive?\n Type y(es) or n(o): "
    read Zero_Flag
    if [[ ${skip_flag} == "y" ]] || [[ ${skip_flag} == "yes" ]]; then
        #zero out the drives in parallel using calculated optimal block sizes
        #####################################################################

        dd if=/dev/zero of=/dev/sda status=progress bs=128K &
        dd if=/dev/zero of=/dev/sdb status=progress bs=256K &
        wait

        skip_flag="no"

    elif [[ ${skip_flag} != "n" ]] && [[ ${skip_flag} != "no" ]]; then
        echo "Response not understood, Please try again"
    fi
done

if [[ ${skip_flag} == "n" ]] || [[ ${skip_flag} == "no" ]]; then
    #begin automated partition management
    #####################################
    cont_flag=0
    echo 'beginning partition creation'
    while [[ $cont_flag!=1 ]]; do
        # begin partiton creation
        #########################
        while [[ $EFI_Flag == "empty" ]]; do
            if [ -d /sys/firmware/efi/efivars ]; then
                echo -e "EFI is supported, Do you want to Set it up?/n Type yes or no: "
                read EFI_Flag
                if [[ "$EFI_Flag" != "yes" && "$EFI_Flag" != "no" ]]; then
                    EFI_Flag="empty"
                fi
            else
                echo 'EFI is not supported on this system'
                EFI_Flag="no"
            fi
        done

        if [[ "$EFI_Flag" == "no" ]]; then
            # Generate MBR partition setup
            ##############################
            sfdisk /dev/sda </arch-install-scripts/build_scripts/partition_setups/mbr_sda.sfdisk
            sfdisk /dev/sdb </arch-install-scripts/build_scripts/partition_setups/mbr_sdb.sfdisk
            mkswap /dev/sdb2
            swapon /dev/sdb2
            mount /dev/sda1 /mnt
            mkdir /mnt/home
            mount /dev/sdb1 /mnt/home

            rm -r /arch-install-scripts/build_scripts/partition_setups

        elif [[ "$EFI_Flag" == "yes" ]]; then
            # Generate GPT partition setup
            ##############################
            #parted -s -a optimal -- /dev/sda mkpart primary 1MiB -2048s
            echo "coming back to this, not fully developed"
            reboot
        fi

    done
    # end partition creation
    ########################
    exit
#end automated partition management
###################################
else
    "skip_flag wasn't a no. that wasn't supposed to happen, exiting just in case"
    exit
fi
