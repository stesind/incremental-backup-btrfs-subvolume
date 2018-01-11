#!/bin/bash

# Constants
# Use for UUID: ls -l /dev/disk/by-uuid/
# Source device #SDEV=/dev/sdd2
SDEV=/dev/disk/by-uuid/170bcf0e-21cd-4bda-aa96-afe745116a30
# Target device #TDEV=/dev/sdf1
TDEV=/dev/disk/by-uuid/0f53d9d2-2f42-43c4-bb1c-d9754e4e11f2
# Source mount point
SMOUNT=/mnt
# Target mount point 
TMOUNT=/media/backup
# Source directory
SDIR=@home
# Target directory
TDIR=home
# Backup snapshot name
BACKUP=BACKUP

source incremental-backup-btrfs-subvolume.sh

