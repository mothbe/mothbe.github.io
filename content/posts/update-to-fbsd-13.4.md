---
title: "Update to FreeBSD host to 13.4"
date: 2024-09-21T09:53:47+02:00
draft: false
tags:
  - freebsd
  - jails
categories:
  - sysops
---

## Description

This guide details how to upgrade a FreeBSD system hosted on a machine named "Wyse" from version 13.3-RELEASE to 13.4-RELEASE. The system manages Thin Jails using Bastille (https://bastillebsd.org/getting-started/).

## Upgrade steps on host

1. Switch to the `root` user.
2. Check the current FreeBSD version:
```
freebsd-version -kur
```
Expected output:
```
13.3-RELEASE-p6
13.3-RELEASE-p6
13.3-RELEASE-p6
```

3. Ensure the system is fully updated for the 13.3 Release:
```
freebsd-update fetch install
```
Expected output (this step require to close popup with list of files to update):
```
src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 13.3-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
...
The following files will be updated as part of updating to
13.3-RELEASE-p7:
/bin/freebsd-version
/boot/kernel/kernel
/boot/kernel/pf.ko
/lib/libnv.so.0
/usr/include/net/pfvar.h
/usr/lib/libnv.a
/usr/lib/libnv_p.a
/usr/sbin/bhyve
...
src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 13.3-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Inspecting system... done.
Preparing to download files... done.
Creating snapshot of existing boot environment... done.
Installing updates...
Restarting sshd after upgrade
Performing sanity check on sshd configuration.
Stopping sshd.
Waiting for PIDS: 77258.
Performing sanity check on sshd configuration.
Starting sshd.
Scanning //usr/share/certs/blacklisted for certificates...
Scanning //usr/share/certs/trusted for certificates...
Scanning //usr/local/share/certs for certificates...
 done.
```

4. Upgrade the host to `13.4-RELASE`
```
freebsd-update upgrade -r 13.4-RELEASE
```
Expected output (this step prompts for confirmation before proceeding):
```
src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 13.3-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic world/base

The following components of FreeBSD do not seem to be installed:
kernel/generic-dbg world/base-dbg world/lib32 world/lib32-dbg

Does this look reasonable (y/n)? y

Fetching metadata signature for 13.4-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic world/base

The following components of FreeBSD do not seem to be installed:
kernel/generic-dbg world/base-dbg world/lib32 world/lib32-dbg

Does this look reasonable (y/n)? y

Fetching metadata signature for 13.4-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Fetching 1 metadata files... done.

Fetching 1 metadata files... done.
Inspecting system... done.
Fetching files from 13.3-RELEASE for merging... done.
Preparing to download files... done.
Fetching 3257 patches.....10....20....30....40....50....60....70....80....90....100....110....120....130....140....150....160....170....180....190....200....210....220....230....240....250....260....270....280....290....300....310....320....330....340....350....360....370....380....390....400....410....420....430....440....450....460....470....480....490....500....510....520....530....540....550....560....570....580....590....600....610....620....630....640....650....660....670....680....690....700....710....720....730....740....750....760....770....780....790....800....810....820....830....840....850....860....870....880....890....900....910....920....930....940....950....960....970....980....990....1000....1010....1020....1030....1040....1050....1060....1070....1080....1090....1100....1110....1120....1130....1140....1150....1160....1170....1180....1190....1200....1210....1220....1230....1240....1250....1260....1270....1280....1290....1300....1310....1320....1330....1340....1350....1360....1370....1380....1390....1400....1410....1420....1430....1440....1450....1460....1470....1480....1490....1500....1510....1520....1530....1540....1550....1560....1570....1580....1590....1600....1610....1620....1630....1640....1650....1660....1670....1680....1690....1700....1710....1720....1730....1740....1750....1760....1770....1780....1790....1800....1810....1820....1830....1840....1850....1860....1870....1880....1890....1900....1910....1920....1930....1940....1950....1960....1970....1980....1990....2000....2010....2020....2030....2040....2050....2060....2070....2080....2090....2100....2110....2120....2130....2140....2150....2160....2170....2180....2190....2200....2210....2220....2230....2240....2250....2260....2270....2280....2290....2300....2310....2320....2330....2340....2350....2360....2370....2380....2390....2400....2410....2420....2430....2440....2450....2460....2470....2480....2490....2500....2510....2520....2530....2540....2550....2560....2570....2580....2590....2600....2610....2620....2630....2640....2650....2660....2670....2680....2690....2700....2710....2720....2730....2740....2750....2760....2770....2780....2790....2800....2810....2820....2830....2840....2850....2860....2870....2880....2890....2900....2910....2920....2930....2940....2950....2960....2970....2980....2990....3000....3010....3020....3030....3040....3050....3060....3070....3080....3090....3100....3110....3120....3130....3140....3150....3160....3170....3180....3190....3200....3210....3220....3230....3240....3250... done.
Applying patches...

Fetching 197 files... ....10....20....30....40....50....60....70....80....90....100....110....120....130....140....150....160....170....180....190... done.
Attempting to automatically merge changes in files... done.

The following changes, which occurred between FreeBSD 13.3-RELEASE and
FreeBSD 13.4-RELEASE have been merged into /etc/ssh/sshd_config:
--- current version
+++ new version
@@ -103,11 +103,11 @@
 #PidFile /var/run/sshd.pid
 #MaxStartups 10:30:100
 #PermitTunnel no
 #ChrootDirectory none
 #UseBlacklist no
-#VersionAddendum FreeBSD-20240104
+#VersionAddendum FreeBSD-20240806

 # no default banner path
 #Banner none

 # override default of no subsystems
 Does this look reasonable (y/n)? y
To install the downloaded upgrades, run "/usr/sbin/freebsd-update install".
```

5. Install 13.4-RELEASE
```
freebsd-update install
```
Expected output:
```
src component not installed, skipped
Creating snapshot of existing boot environment... done.
Installing updates...
Restarting sshd after upgrade
Performing sanity check on sshd configuration.
Stopping sshd.
Waiting for PIDS: 19285, 19285.
Performing sanity check on sshd configuration.
Starting sshd.
Scanning //usr/share/certs/blacklisted for certificates...
Scanning //usr/share/certs/trusted for certificates...
Scanning //usr/local/share/certs for certificates...
 done.
```

6. Reboot the system:
```
shutdown -r now
```

7. After rebooting, `freebsd-update` needs to be run again to install the new userland components:
```
freebsd-update install
```

8. Upgrade packages:
```
pkg upgrade -y
```
Expected output:
```
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
root@wyse:~ # pkg upgrade
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (1 candidates): 100%
Processing candidates (1 candidates): 100%
The following 1 package(s) will be affected (of 0 checked):

Installed packages to be UPGRADED:
	curl: 8.9.1_1 -> 8.10.0

Number of packages to be upgraded: 1

2 MiB to be downloaded.

[1/1] Fetching curl-8.10.0.pkg: 100%    2 MiB   1.6MB/s    00:01
Checking integrity... done (0 conflicting)
[1/1] Upgrading curl from 8.9.1_1 to 8.10.0...
[1/1] Extracting curl-8.10.0: 100%
```

9. Finally, reboot into 13.4-RELEASE:
```
shutdown -r now
```

10. FreeBSD upgrade completed!
