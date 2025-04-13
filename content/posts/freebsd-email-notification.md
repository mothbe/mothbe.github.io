---
title: "Freebsd Email Notification"
date: 2025-04-13T23:03:04+02:00
draft: false
tags:
  - freebsd
categories:
  - sysops
---

To get notification about not read email on local system, create file in `/usr/local/etc/profile` with following content:

```
unread_count=$(echo q | mailx -N | head -n2 | tail -n1 | cut -f4 -d" ")
if [ -n "$unread_count" ] && [ "$unread_count" -gt 0 ]; then
    echo -e "\n\tYou have $unread_count unread mail message(s).\n"
fi
```
