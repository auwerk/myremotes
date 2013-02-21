myremotes
=========

A little utility for fast SSHFS mounting

The script mounts/unmounts SSHFS locations
to the subdirectories in ~/_Remotes

* Usage: ./myremotes mount|umount <path_to_hostlist_file>

* Host list file format:
user@host[:port][#remotedir]

* Host list file example:

user@host.de
specificsshport@92.56.87.162:1222
tram@pampam.eu#/home/users/trampam
bam@bambam.tv:1222#/home/users/bam
