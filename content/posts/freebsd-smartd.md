---
title: "Freebsd SMART configuration"
date: 2025-04-13T23:08:31+02:00
draft: false
tags:
  - freebsd
categories:
  - sysops
---

1. Install `smartmontools` package.
```
sudo pkg install -y smartmontools
```

2. Check list of local disks.
```
sudo smartctl --scan
/dev/ada0 -d atacam # /dev/ada0, ATA device
```

3. Create config file:

- `/usr/local/etc/smartd.conf`
```
/dev/ada0 -a -d atacam -m root@localhost -s S/../.././15
```

> **NOTE:**
>
> `S/../.././15` says: run a Short test every day during the 15th hour.
>
> `smartd` does not schedule via cron. Instead, it polls every 30 minutes

4. Enable at boot and start `smartd`
```
sysrc smartd_enable=YES
service smartd start
```
