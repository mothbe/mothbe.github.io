---
title: "Bastille Jails Update"
date: 2024-09-06T16:42:41+02:00
draft: false
---

Before update Jail execute switch to `root`:
```
sudo sudo -i
```

1. Update Bastille FreeBSD release:
```
bastille bootstrap 13.3-RELEASE update
```
Output:
```
Bootstrapping FreeBSD distfiles...
Bootstrap appears complete.

Bootstrap successful.
See 'bastille --help' for available commands.

src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 13.3-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Inspecting system... done.
Preparing to download files... done.
The following files will be updated as part of updating to
13.3-RELEASE-p6:
/bin/freebsd-version
/lib/libnv.so.0
/usr/bin/calendar
/usr/lib/libnv.a
/usr/lib/libnv_p.a
/usr/sbin/bhyve
src component not installed, skipped
Installing updates...Scanning /usr/local/bastille/releases/13.3-RELEASE/usr/share/certs/blacklisted for certificates...
Scanning /usr/local/bastille/releases/13.3-RELEASE/usr/share/certs/trusted for certificates...
 done.
```

2. Update packages in Jail managed by Bastille:
- dry mode:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do pkg -j $jail upgrade -n ; done                                              
```

Output:
```
Updating FreeBSD repository catalogue...
[adguardhome] Fetching data.pkg: 100%    7 MiB   2.5MB/s    00:03    
Processing entries: 100%
FreeBSD repository update completed. 34415 packages processed.
All repositories are up to date.
Checking for upgrades (2 candidates): 100%
Processing candidates (2 candidates): 100%
The following 2 package(s) will be affected (of 0 checked):

Installed packages to be UPGRADED:
        curl: 8.9.1 -> 8.9.1_1
        perl5: 5.36.3_1 -> 5.36.3_2

Number of packages to be upgraded: 2

16 MiB to be downloaded.
Updating FreeBSD repository catalogue...
[jellyfin] Fetching data.pkg: 100%    7 MiB   3.8MB/s    00:02    
...
```

- upgrade packages
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do pkg -j $jail upgrade  -y ; done
```

3. Restart Jails:
```
for jail in  `bastille list | awk '{print $2}' |grep -v IP ` ; do bastille restart $jail ; done
```