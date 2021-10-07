# find_disk

Simple commandline tool for matching WWN to serial number.


# Raison d'être

I administer some zfs applicances. These appliances use worldwide names (WWNs) to uniquely identify physical drives (rather than `/dev/sdX` device names, which are not immutable). However, it is often necessary/useful to be able to identify drives by serial number as well. Having spent far too long looking this up manually in the past, I figured I could write a script in the time it took me to do a couple of manual lookups. Seems I was right, so thought I'd make it available in case anyone else finds it useful too.


# Usage

It is really simple. Run the script with no arguments, and it'll display a help message. Run it passing a wwn, and it'll look up the serial number. Run it with more than one argument and I honestly can't be bothered to handle it properly - it'll look up the first one only. If someone makes a PR with some better behaviour, I'll gladly accept it.



# How does it work?

In `/dev/disk/by-id` there exists a full list of all disks in the system (and partitions thereof). Each disk appears twice, once identified by WWN and once by serial number. Each time a disk appears, what we're actually seeing is a symlink that targets the corresponding device file `/dev/sdX`. These symlinks are generated and maintained by the kernel, so if `/dev/sdX` identifiers change, the symlinks are still correct. When passed a WWN, the script just resolves the target device file, then iterates over all the non-WWN devices in `/dev/disk/by-id` until it finds one whose symlink target matches that of the WWN symlink. Simples.


# Todo

* Would be nice to be able to run it backwards and retrieve WWNs from serial numbers. Just for completeness.
* Decent handling of passing several inputs rather than just one.
* Probably something like the ability to pass a `/dev/sdX` identifier and be given the WWN and serial.
