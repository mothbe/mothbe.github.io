---
title: "Notyfikacja o nieodczytanych wiadomość lokalnych na FreeBSD"
date: 2025-04-13T23:03:04+02:00
draft: false
tags:
  - freebsd
categories:
  - sysops
---

Aby otrzymywać powiadomienia po zalogowaniu przez terminal o nieprzeczytanych wiadomościach e-mail w systemie lokalnym, utwórz plik w `/usr/local/etc/profile` z następującą zawartością:

```
unread_count=$(echo q | mailx -N | head -n2 | tail -n1 | cut -f4 -d" ")
if [ -n "$unread_count" ] && [ "$unread_count" -gt 0 ]; then
    echo -e "\n\tYou have $unread_count unread mail message(s).\n"
fi
```

