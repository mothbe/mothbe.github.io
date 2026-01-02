---
title: "Konfiguracja SMART we FreeBSD"
date: 2025-04-13T23:08:31+02:00
draft: false
tags:
  - freebsd
categories:
  - sysops
---

1. Instalacja pakietu `smartmontools`:
```
# pkg install -y smartmontools
```

2. Sprawdzenie listy lokalnych dysków:
```
# smartctl --scan
/dev/ada0 -d atacam # /dev/ada0, ATA device
```

3. Utworzenie pliku konfiguracyjnego dla SMART:

- `/usr/local/etc/smartd.conf`
```
/dev/ada0 -a -d atacam -m root@localhost -s S/../.././15
```

> **UWAGA:**
>
> `S/../.././15` oznacza: uruchamianie krótkiego testu (ang. Short) każdego dnia o 15:00.
>
> `smartd` nie jest uruchamiany za pomocą Cron a zamiast tego sam sprawdza co 30 minut.

4. Uruchomienie `smartd` podczas startu systemu:
```
sysrc smartd_enable=YES
service smartd start
```

