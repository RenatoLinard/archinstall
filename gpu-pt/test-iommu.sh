#!/bin/bash
#  _____         _     _                                  
# |_   _|__  ___| |_  (_) ___  _ __ ___  _ __ ___  _   _  
#   | |/ _ \/ __| __| | |/ _ \| '_ ` _ \| '_ ` _ \| | | | 
#   | |  __/\__ \ |_  | | (_) | | | | | | | | | | | |_| | 
#   |_|\___||___/\__| |_|\___/|_| |_| |_|_| |_| |_|\__,_| 
#                                                         
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

#!/bin/bash
shopt -s nullglob
for g in /sys/kernel/iommu_groups/*; do
    if [ -d "$g/devices" ]; then
        echo "IOMMU Group ${g##*/}:"
        for d in $g/devices/*; do
            echo -e "\t$(lspci -nns ${d##*/})"
        done;
    fi
done;
