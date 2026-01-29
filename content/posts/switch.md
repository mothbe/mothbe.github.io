---
title: "Switch"
date: 2026-01-30T00:08:46+01:00
draft: false
---
Manual dostępny dla switch: [Netgear GS105Ev2](https://www.downloads.netgear.com/files/GDC/GS105EV2/WebManagedSwitches_UM_EN.pdf)

W celu konfigucji switch-a należy:
1. Ustawić lokalny adres na PC: 192.168.0.210/24
2. Podłaczyć się do portu 5 na switch-u.
3. W przeglądarce wpisać: http://192.168.0.239/
4. Przejdź do 'VLAN->Advanced->Vlan Membership':
VLAN ID 1:
- porty Untagged (access port): 1, 5

![vlan1](/images/switch/switch-vlan1.png)

VLAN ID 110:
- porty Untagged (access port): 2,3,4
- porty Tagged (trunk): 1

![vlan110](/images/switch/switch-vlan110.png)


