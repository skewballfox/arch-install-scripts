########################### Partition management #################
##################################################################

skip_flag=0
EFI_Flag="empty"
while {skip_flag!=1} {
    read -p "Have the partitions already been set up?\n Type y(es) or n(o): " APart_Flag
    if {$APart_Flag == "y" || $APart_Flag == "yes"} {
        #skip automated partition management
        if { -d /sys/firmware/efi/efivars} {
                    read -p "will this system be EFI-based?/n Type y(es) or n(o): " EFI_Flag
        } else {
            EFI_Flag="no"
        }
        skip_flag=1

    } elseif {$APart_Flag== "n" or $APart_Flag == "no"} {
        #begin automated partition management
        #####################################
        while {$cont_flag!=1} {
            read -p "Do you want to zero the drive?\n Type y(es) or n(o): " Zero_Flag
            if {$Zero_Flag == "y" || $Zero_Flag == "yes"} then {
                #zero out the drives
                ###################
                dd if=/dev/zero of=/dev/sda status=progress
                dd if=/dev/zero of=/dev/sdb status=progress
                
                cont_flag=1

            } elseif {$Zero_Flag == "n" or $Zero_Flag== "no"} then {
                cont_flag=1
            }else {
                echo "Response not understood, Please try again"
            }
        }
        cont_flag=0
        while { $cont_flag!=1 } {
            # begin partiton creation
            #########################
            while { $EFI_Flag == "empty" } {
                if {-d /sys/firmware/efi/efivars} {
                    read -p "EFI is supported, Do you want to Set it up?/n Type yes or no: " EFI_Flag
                        if { $EFI_Flag != "yes" && $EFI_Flag != "no"} {
                            EFI_Flag="empty"
                        }
                    } else {
                        EFI_Flag="no"
                    }

                
                if { $EFI_Flag== "no"} {
                    #Generate MBR partition setup
                    #############################
                    sfdisk /dev/sda < /arch-install-scripts/build_scripts/partition_setups/mbr_sda.sfdisk
                    sfdisk /dev/sdb < /arch-install-scripts/build_scripts/partition_setups/mbr_sdb.sfdisk
                    mkswap /dev/sdb2 
                    swapon /dev/sdb2
                    mount /dev/sda1 /mnt
                    mkdir /mnt/home
                    mount /dev/sdb1 /mnt/home
                }
                elif { $EFI_Flag == "yes" }
                {
                    #Generate GPT partition setup
                    #############################
                    echo "coming back to this, not fully developed"
                    reboot
                }
            }
            # end partition creation
            ########################
        }
        skip_flag=1
        #end automated partition management
        ###################################
    } else {
        echo "Response not understood, Please try again"
    }

}
cont_flag=0


########################### Begin Install ########################
##################################################################

timedatectl set-ntp true

genfstab -U /mnt >> /mnt/etc/fstab

#creating the base system
pacstrap /mnt base-devel

#copy necessary files to new root and continue install process
cd arch-install-scripts
cp -r build_scripts pacman_hooks polkit_rules systemd_units /mnt
cd ..

#begin install
arch-chroot /mnt mnt/build_scripts/arch-post-chroot.sh
wait $1


######################### Clean up and reboot ####################
##################################################################

rm /mnt/build/build_scripts
#unmount all and reboot