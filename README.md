# incremental-backup-btrfs-subvolume

This scrips incrementially backup a BTRFS subvolume. It consists of at least 2 scrips. One for setting the constants and a second generic backup script. BTRFS send and receive are used.

For each subvolume create a script, use backup@home.sh as template. Set the constans according your needs.

At the target directory an additional snapshot with time stamp is created. Hence a history is build up. One may to clean up this snapshots after some time.

## Install
Install whereever you want. I prever my home directory.
```shell
git clone https://github.com/stesind/incremental-backup-btrfs-subvolume.git
cd incremental-backup-btrfs-subvolume
sudo install -d $HOME/bin
sudo install -m 644 -o $USER -g $USER backup@home.sh $HOME/bin
sudo install -m 644 -o $USER -g $USER incremental-backup-btrfs-subvolume.sh $HOME/bin
```
