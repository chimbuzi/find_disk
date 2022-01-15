# find_disk

Simple commandline tool for matching WWN to serial number.


# Raison d'être

I administer some zfs applicances. These appliances use worldwide names (WWNs) to uniquely identify physical drives (rather than `/dev/sdX` device names, which are not immutable). However, it is often necessary/useful to be able to identify drives by serial number as well. Having spent far too long looking this up manually in the past, I figured I could write a script in the time it took me to do a couple of manual lookups. Seems I was right, so thought I'd make it available in case anyone else finds it useful too.


# Usage

It is really simple. Run the script with no arguments, and it'll display a help message. Run it passing a wwn, and it'll look up the serial number and device name. Run it with a serial number, and it'll look up a device name and WWN, and run it with a device name it'll look up the WWN and serial. It'll intuit the sype of things you've given it automatically*.

*see known issues


# How does it work?

In `/dev/disk/by-id` there exists a full list of all disks in the system (and partitions thereof). Each disk appears twice, once identified by WWN and once by serial number. Each time a disk appears, what we're actually seeing is a symlink that targets the corresponding device file `/dev/sdX`. These symlinks are generated and maintained by the kernel, so if `/dev/sdX` identifiers change, the symlinks are still correct. When passed a WWN, the script just resolves the target device file, then iterates over all the non-WWN devices in `/dev/disk/by-id` until it finds one whose symlink target matches that of the WWN symlink. Simples. Something similar for the other options.


# Known Issues

* Only supports device names in the form /dev/sdX. For e.g. SAS-attached drives, those on hardware RAID controllers, and even just NVMe controllers, lookup by device name doesn't work.


# Todo

* Decent handling of passing several inputs rather than just one.
* Support arbitrary device names.
