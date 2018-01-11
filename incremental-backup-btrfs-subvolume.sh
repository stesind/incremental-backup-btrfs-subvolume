
# Generic backup script
# Backing up any btrfs subvolume to any btrfs disk

# Check if constants are set
if [ -z ${SDEV+x} ]; then echo "SDEV is unset"; exit 1; else echo "SDEV is set to '$SDEV'"; fi
if [ -z ${TDEV+x} ]; then echo "TDEV is unset"; exit 1; else echo "TDEV is set to '$TDEV'"; fi
if [ -z ${SMOUNT+x} ]; then echo "SMOUNT is unset"; exit 1; else echo "SMOUNT is set to '$SMOUNT'"; fi
if [ -z ${TMOUNT+x} ]; then echo "TMOUNT is unset"; exit 1; else echo "TMOUNT is set to '$TMOUNT'"; fi
if [ -z ${SDIR+x} ]; then echo "SDIR is unset"; exit 1; else echo "SDIR is set to '$SDIR'"; fi
if [ -z ${TDIR+x} ]; then echo "TDIR is unset"; exit 1; else echo "TDIR is set to '$TDIR'"; fi
if [ -z ${BACKUP+x} ]; then echo "BACKUP is unset"; exit 1; else echo "BACKUP is set to '$BACKUP'"; fi


# check root or sudo
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo "Doing an incremential backup of $SDEV/$SDIR to $TDEV/$TDIR/$BACKUP"

mount $TDEV $TMOUNT
if [[ $? -ne 0 ]]; then
	echo 'Cannot mount backup media! Exiting!'
	exit 1
fi

mount $SDEV $SMOUNT
if [[ $? -ne 0 ]]; then
	echo 'Cannot mount source media! Exiting!'
	exit 1
fi

if [ `stat --format=%i $SMOUNT/$SDIR` -ne 256 ]; then
		echo 'Source directory is not a btrfs subvolume! Exiting!'
		exit 1
fi

if [ ! -d "$TMOUNT/$TDIR" ]; then
	echo 'Target backup directory does not exist! Creating!'
	mkdir $TMOUNT/$TDIR
	if [[ $? -ne 0 ]]; then
        	echo 'Cannot create target backup directory! Exiting!'
        	exit 1
	fi
fi


if [ ! -d "$TMOUNT/$TDIR/$BACKUP" ]; then
	echo "No previous backup found, doing an initial backup!"
	btrfs subvolume snapshot -r $SMOUNT/$SDIR $SMOUNT/$SDIR/$BACKUP
	btrfs send  $SMOUNT/$SDIR/$BACKUP | btrfs receive $TMOUNT/$TDIR 
else
	if [ `stat --format=%i $TMOUNT/$TDIR/$BACKUP` -eq 256 ]; then
		echo "Doing an incremential backup!"
		btrfs subvolume snapshot -r $SMOUNT/$SDIR $SMOUNT/$SDIR/$BACKUP-new
		btrfs send  -p $SMOUNT/$SDIR/$BACKUP $SMOUNT/$SDIR/$BACKUP-new | sudo btrfs receive $TMOUNT/$TDIR
		btrfs subvolume delete $SMOUNT/$SDIR/$BACKUP
		mv $SMOUNT/$SDIR/$BACKUP-new $SMOUNT/$SDIR/$BACKUP
		btrfs subvolume delete $TMOUNT/$TDIR/$BACKUP
		mv $TMOUNT/$TDIR/$BACKUP-new $TMOUNT/$TDIR/$BACKUP
		btrfs subvolume snapshot -r $TMOUNT/$TDIR/$BACKUP $TMOUNT/$TDIR.$(date +%Y-%m-%d-%T)
	fi
fi

if [[ $? -ne 0 ]]; then
        echo 'Backup successful! Unmounting!'
fi

# umount all 

umount $TMOUNT
umount $SMOUNT

