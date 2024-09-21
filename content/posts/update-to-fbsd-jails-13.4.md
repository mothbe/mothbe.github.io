---
title: "Update FreeBSD Jails to 13.4"
date: 2024-09-21T10:13:10+02:00
draft: false
tags:
  - freebsd
  - jails
categories:
  - sysops
---

## Description
Following steps describe upgrading Thin Jails managed by Bastille (Bastille).

## Upgrade steps for Thin Jails
> **Important Note:**
> These instructions are for upgrading Thin Jails managed by Bastille. Upgrading Thick Jails would require a different approach.
It's highly recommended to back up your jail configuration files before proceeding.

1. List of Jails and FreeBSD version:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille cmd $jail freebsd-version -ur ; done
```
Output:
```
[adguardhome]:
13.4-RELEASE-p1
13.3-RELEASE-p6
[adguardhome]: 0

[jellyfin]:
13.4-RELEASE-p1
13.3-RELEASE-p6
[jellyfin]: 0

[tran]:
13.4-RELEASE-p1
13.3-RELEASE-p6
[tran]: 0

[prom]:
13.4-RELEASE-p1
13.3-RELEASE-p6
[prom]: 0
```

2. Download Bastille boostrap for 13.4-RELEASE
```
bastille bootstrap 13.4-RELEASE
```

3. Stopping Jails:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille stop $jail ; done
```
Output:
```
pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf
[adguardhome]:
adguardhome: removed
pfctl: /dev/pf: No such file or directory

pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf
[jellyfin]:
jellyfin: removed

pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf
[prom]:
prom: removed

pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf
[tran]:
tran: removed
```

4. Update Jails `fstab` file to use 13.4-RELEASE:
```
for file in `bastille list -a | grep -v IP | awk '{ print $7 }' | sed 's#root#fstab#' ` ; do sed -i'.backup-13.3' 's/13.3-RELEASE/13.4-RELEASE/g' $file ; done
```

5. Verify `fstab` files:
```
for file in `bastille list -a | grep -v IP | awk '{ print $7 }' | sed 's#root#fstab#' ` ; do echo -e "\nfile: $file" ; cat $file ; done
```

Output:
```
file: /usr/local/bastille/jails/adguardhome/fstab
/usr/local/bastille/releases/13.4-RELEASE /usr/local/bastille/jails/adguardhome/root/.bastille nullfs ro 0 0

file: /usr/local/bastille/jails/jellyfin/fstab
/usr/local/bastille/releases/13.4-RELEASE /usr/local/bastille/jails/jellyfin/root/.bastille nullfs ro 0 0
/tank/movies /usr/local/bastille/jails/jellyfin/root/movies nullfs rw 0 0
/tank/music /usr/local/bastille/jails/jellyfin/root/music nullfs rw 0 0

file: /usr/local/bastille/jails/prom/fstab
/usr/local/bastille/releases/13.4-RELEASE /usr/local/bastille/jails/prom/root/.bastille nullfs ro 0 0

file: /usr/local/bastille/jails/tran/fstab
/usr/local/bastille/releases/13.4-RELEASE /usr/local/bastille/jails/tran/root/.bastille nullfs ro 0 0
/tank/movies /usr/local/bastille/jails/tran/root/movies nullfs rw 0 0
```

6. Checking old `fstab` - backup files:
```
for file in `bastille list -a | grep -v IP | awk '{ print $7 }' | sed 's#root#fstab#' ` ; do echo -e "\nfile: $file" ; cat $file.backup-13.3 ; done
```
Output:
```
file: /usr/local/bastille/jails/adguardhome/fstab
/usr/local/bastille/releases/13.3-RELEASE /usr/local/bastille/jails/adguardhome/root/.bastille nullfs ro 0 0

file: /usr/local/bastille/jails/jellyfin/fstab
/usr/local/bastille/releases/13.3-RELEASE /usr/local/bastille/jails/jellyfin/root/.bastille nullfs ro 0 0
/tank/movies /usr/local/bastille/jails/jellyfin/root/movies nullfs rw 0 0
/tank/music /usr/local/bastille/jails/jellyfin/root/music nullfs rw 0 0

file: /usr/local/bastille/jails/prom/fstab
/usr/local/bastille/releases/13.3-RELEASE /usr/local/bastille/jails/prom/root/.bastille nullfs ro 0 0

file: /usr/local/bastille/jails/tran/fstab
/usr/local/bastille/releases/13.3-RELEASE /usr/local/bastille/jails/tran/root/.bastille nullfs ro 0 0
/tank/movies /usr/local/bastille/jails/tran/root/movies nullfs rw 0 0
```

7. Start jails:
```
for jail in  `bastille list -a | awk '{print $5}' |grep -v IP ` ; do bastille start $jail ; done
```
Output:
```
[Published]: Not found.
pfctl: /dev/pf: No such file or directory
[adguardhome]:
e0a_bastille0
e0b_bastille0
adguardhome: created
pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf
pfctl: /dev/pf: No such file or directory
rdr-anchor not found in pf.conf

pfctl: /dev/pf: No such file or directory
[jellyfin]:
e0a_bastille1
e0b_bastille1
jellyfin: created

pfctl: /dev/pf: No such file or directory
[prom]:
e0a_bastille5
e0b_bastille5
prom: created

pfctl: /dev/pf: No such file or directory
[tran]:
e0a_bastille2
e0b_bastille2
tran: created
```

8. Checking FreeBSD version
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille cmd $jail freebsd-version -ur ; done
```
Output:
```
[adguardhome]:
13.4-RELEASE-p1
13.4-RELEASE-p1
[adguardhome]: 0

[jellyfin]:
13.4-RELEASE-p1
13.4-RELEASE-p1
[jellyfin]: 0

[tran]:
13.4-RELEASE-p1
13.4-RELEASE-p1
[tran]: 0

[prom]:
13.4-RELEASE-p1
13.4-RELEASE-p1
[prom]: 0
```

9. Upgrade packages:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille pkg $jail upgrade -y ; done
```
Output:
```
[adguardhome]:
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
[adguardhome] [1/1] Fetching curl-8.10.0.pkg: 100%    2 MiB   1.6MB/s    00:01
Checking integrity... done (0 conflicting)
[adguardhome] [1/1] Upgrading curl from 8.9.1_1 to 8.10.0...
[adguardhome] [1/1] Extracting curl-8.10.0: 100%

[jellyfin]:
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (19 candidates): 100%
Processing candidates (19 candidates): 100%
The following 19 package(s) will be affected (of 0 checked):

Installed packages to be UPGRADED:
	Imath: 3.1.11 -> 3.1.12
	aom: 3.10.0 -> 3.10.0_1
	argp-standalone: 1.5.0 -> 1.5.0_1
	ffmpeg: 6.1.2,1 -> 6.1.2_1,1
	libdrm: 2.4.122,1 -> 2.4.123,1
	libjxl: 0.10.3 -> 0.11.0
	libnghttp2: 1.62.1 -> 1.63.0
	libv4l: 1.23.0_4 -> 1.23.0_5
	openssl: 3.0.14,1 -> 3.0.15,1
	py311-attrs: 24.1.0 -> 24.2.0
	py311-certifi: 2024.7.4 -> 2024.8.30
	py311-cffi: 1.17.0 -> 1.17.1
	py311-cryptography: 42.0.8_2,1 -> 42.0.8_3,1
	py311-httpx: 0.27.0_1 -> 0.27.2
	py311-idna: 3.7 -> 3.8
	python311: 3.11.9_1 -> 3.11.10
	python39: 3.9.19 -> 3.9.20
	readline: 8.2.10 -> 8.2.13
	shaderc: 2024.1 -> 2024.2

Number of packages to be upgraded: 19

The process will require 2 MiB more space.
70 MiB to be downloaded.
[jellyfin] [1/19] Fetching py311-idna-3.8.pkg: 100%   78 KiB  79.4kB/s    00:01
[jellyfin] [2/19] Fetching libnghttp2-1.63.0.pkg: 100%  132 KiB 135.2kB/s    00:01
[jellyfin] [3/19] Fetching aom-3.10.0_1.pkg: 100%    3 MiB   3.3MB/s    00:01
[jellyfin] [4/19] Fetching py311-cffi-1.17.1.pkg: 100%  263 KiB 269.6kB/s    00:01
[jellyfin] [5/19] Fetching python39-3.9.20.pkg: 100%   18 MiB   9.2MB/s    00:02
[jellyfin] [6/19] Fetching shaderc-2024.2.pkg: 100%    3 MiB   2.9MB/s    00:01
[jellyfin] [7/19] Fetching py311-attrs-24.2.0.pkg: 100%   98 KiB 100.7kB/s    00:01
[jellyfin] [8/19] Fetching py311-certifi-2024.8.30.pkg: 100%  158 KiB 161.4kB/s    00:01
[jellyfin] [9/19] Fetching ffmpeg-6.1.2_1,1.pkg: 100%   10 MiB   3.6MB/s    00:03
[jellyfin] [10/19] Fetching Imath-3.1.12.pkg: 100%  103 KiB 105.8kB/s    00:01
[jellyfin] [11/19] Fetching py311-cryptography-42.0.8_3,1.pkg: 100%    1 MiB   1.1MB/s    00:01
[jellyfin] [12/19] Fetching openssl-3.0.15,1.pkg: 100%    6 MiB   3.2MB/s    00:02
[jellyfin] [13/19] Fetching libdrm-2.4.123,1.pkg: 100%  256 KiB 261.8kB/s    00:01
[jellyfin] [14/19] Fetching py311-httpx-0.27.2.pkg: 100%  153 KiB 156.9kB/s    00:01
[jellyfin] [15/19] Fetching libjxl-0.11.0.pkg: 100%    2 MiB   1.8MB/s    00:01
[jellyfin] [16/19] Fetching libv4l-1.23.0_5.pkg: 100%  364 KiB 373.0kB/s    00:01
[jellyfin] [17/19] Fetching python311-3.11.10.pkg: 100%   25 MiB   5.3MB/s    00:05
[jellyfin] [18/19] Fetching argp-standalone-1.5.0_1.pkg: 100%   29 KiB  30.0kB/s    00:01
[jellyfin] [19/19] Fetching readline-8.2.13.pkg: 100%  371 KiB 379.8kB/s    00:01
Checking integrity... done (0 conflicting)
[jellyfin] [1/19] Upgrading readline from 8.2.10 to 8.2.13...
[jellyfin] [1/19] Extracting readline-8.2.13: 100%
[jellyfin] [2/19] Upgrading python311 from 3.11.9_1 to 3.11.10...
[jellyfin] [2/19] Extracting python311-3.11.10: 100%
[jellyfin] [3/19] Upgrading py311-idna from 3.7 to 3.8...
[jellyfin] [3/19] Extracting py311-idna-3.8: 100%
[jellyfin] [4/19] Upgrading Imath from 3.1.11 to 3.1.12...
[jellyfin] [4/19] Extracting Imath-3.1.12: 100%
[jellyfin] [5/19] Upgrading shaderc from 2024.1 to 2024.2...
[jellyfin] [5/19] Extracting shaderc-2024.2: 100%
[jellyfin] [6/19] Upgrading py311-certifi from 2024.7.4 to 2024.8.30...
[jellyfin] [6/19] Extracting py311-certifi-2024.8.30: 100%
[jellyfin] [7/19] Upgrading libdrm from 2.4.122,1 to 2.4.123,1...
[jellyfin] [7/19] Extracting libdrm-2.4.123,1: 100%
[jellyfin] [8/19] Upgrading aom from 3.10.0 to 3.10.0_1...
[jellyfin] [8/19] Extracting aom-3.10.0_1: 100%
[jellyfin] [9/19] Upgrading py311-cffi from 1.17.0 to 1.17.1...
[jellyfin] [9/19] Extracting py311-cffi-1.17.1: 100%
[jellyfin] [10/19] Upgrading libjxl from 0.10.3 to 0.11.0...
[jellyfin] [10/19] Extracting libjxl-0.11.0: 100%
[jellyfin] [11/19] Upgrading libv4l from 1.23.0_4 to 1.23.0_5...
[jellyfin] [11/19] Extracting libv4l-1.23.0_5: 100%
[jellyfin] [12/19] Upgrading libnghttp2 from 1.62.1 to 1.63.0...
[jellyfin] [12/19] Extracting libnghttp2-1.63.0: 100%
[jellyfin] [13/19] Upgrading python39 from 3.9.19 to 3.9.20...
[jellyfin] [13/19] Extracting python39-3.9.20: 100%
[jellyfin] [14/19] Upgrading py311-attrs from 24.1.0 to 24.2.0...
[jellyfin] [14/19] Extracting py311-attrs-24.2.0: 100%
[jellyfin] [15/19] Upgrading ffmpeg from 6.1.2,1 to 6.1.2_1,1...
[jellyfin] [15/19] Extracting ffmpeg-6.1.2_1,1: 100%
[jellyfin] [16/19] Upgrading py311-cryptography from 42.0.8_2,1 to 42.0.8_3,1...
[jellyfin] [16/19] Extracting py311-cryptography-42.0.8_3,1: 100%
[jellyfin] [17/19] Upgrading openssl from 3.0.14,1 to 3.0.15,1...
[jellyfin] [17/19] Extracting openssl-3.0.15,1: 100%
[jellyfin] [18/19] Upgrading py311-httpx from 0.27.0_1 to 0.27.2...
[jellyfin] [18/19] Extracting py311-httpx-0.27.2: 100%
[jellyfin] [19/19] Upgrading argp-standalone from 1.5.0 to 1.5.0_1...
[jellyfin] [19/19] Extracting argp-standalone-1.5.0_1: 100%
==> Running trigger: gdk-pixbuf-query-loaders.ucl
Generating gdk-pixbuf modules cache
==> Running trigger: shared-mime-info.ucl
Building the Shared MIME-Info database cache

[tran]:
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
[tran] [1/1] Fetching curl-8.10.0.pkg: 100%    2 MiB   1.6MB/s    00:01
Checking integrity... done (0 conflicting)
[tran] [1/1] Upgrading curl from 8.9.1_1 to 8.10.0...
[tran] [1/1] Extracting curl-8.10.0: 100%

[prom]:
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (2 candidates): 100%
Processing candidates (2 candidates): 100%
The following 1 package(s) will be affected (of 0 checked):

Installed packages to be UPGRADED:
	curl: 8.9.1_1 -> 8.10.0

Number of packages to be upgraded: 1

2 MiB to be downloaded.
[prom] [1/1] Fetching curl-8.10.0.pkg: 100%    2 MiB   1.6MB/s    00:01
Checking integrity... done (0 conflicting)
[prom] [1/1] Upgrading curl from 8.9.1_1 to 8.10.0...
[prom] [1/1] Extracting curl-8.10.0: 100%
```

10. Restart Jails:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille restart $jail; done
```

11. Bastille FreeBSD Jails upgrade completed!
