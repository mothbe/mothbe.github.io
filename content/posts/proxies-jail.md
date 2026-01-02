---
title: "Utworzenie FreeBSD Jail z nullfs - proxies"
date: 2026-01-03T00:29:12+01:00
draft: false
---

1. Utworzenie ze z migawski (ang. snapshot) podstawowej struktury katalogów która może być zmieniania:
```
# zfs clone tank/jails/templates/15.0-RELEASE-skeleton@base tank/jails/containers/proxies
```

2. Przygotowanie katalogu roboczego do którego będą montowane systemy plików:
```
# mkdir /usr/local/jails/proxies-nullfs-base/
```

3. Przygotowanie konfiguracji `fstab` wykorzystywanego w konfiguracji Jail:
```
# echo > /usr/local/jails/proxies-nullfs-base.fstab << EOF
/usr/local/jails/templates/15.0-RELEASE-base  /usr/local/jails/proxies-nullfs-base/ nullfs ro 0 0
/usr/local/jails/containers/proxies /usr/local/jails/proxies-nullfs-base/skeleton nullfs rw 0 0
EOF
```

4. Przygotowanie głównego pliku konfiguracyjnego dla `proxies`:
```
# cat /etc/jail.conf.d/proxies.conf
proxies {
  # STARTUP/LOGGING
  exec.start = "/bin/sh /etc/rc";
  exec.stop = "/bin/sh /etc/rc.shutdown";
  exec.consolelog = "/var/log/jail_console_${name}.log";

  # PERMISSIONS
  exec.clean;
  mount.devfs;

  # HOSTNAME/PATH
  host.hostname = "${name}";
  path = "/usr/local/jails/${name}-nullfs-base";

  # NETWORK
  ip4 = inherit;
  interface = re0bridge;

  # MOUNT
  mount.fstab = "/usr/local/jails/${name}-nullfs-base.fstab";
}
```

5. Uruchomienie Jail i weryfikacja działania:
```
# service jail start proxies
# jail -c proxies
jail: "proxies" already exist
```


6. Instalacja pakietu `xcaddy` do z budowania pakietu `caddy`:
```
# pkg -j proxies install -y xcaddy
```

7. Instalacja `caddy` ze wsparciem dla `CloudFlare`:
```
# jexec proxies
```

Następnie w `proxies` budowa `caddy`:
```
export DNS_PLUGIN=cloudflare
xcaddy build --output /usr/local/bin/caddy --with github.com/caddy-dns/${DNS_PLUGIN}

# Utworzenie niezbędnych katalogów dla skruty startowego i konfiguracji
mkdir -p /usr/local/etc/rc.d
mkdir -p /usr/local/www

# Usunięcie niepotrzebnych plików po zbudowania caddy
rm -fr /root/go

```

- Utworzenie skryptu startowego `caddy`:
```
cat > /usr/local/etc/rc.d/caddy << EOF
#!/bin/sh

# PROVIDE: caddy
# REQUIRE: LOGIN DAEMON NETWORKING
# KEYWORD: shutdown

# To enable caddy, add 'caddy_enable="YES"' to /etc/rc.conf or
# /etc/rc.conf.local

# Optional settings:
# caddy_config (string):      Full path to caddy config file
#                             (/usr/local/etc/caddy/Caddyfile)
# caddy_adapter (string):     Config adapter type (caddyfile)
# caddy_directory (string):   Root for caddy storage (ACME certs, etc.)
#                             (/var/db/caddy)
# caddy_extra_flags (string): Extra flags passed to caddy start
# caddy_logdir (string):      Where caddy logs are stored
#                             (/var/log/caddy)
# caddy_logfile (string):     Location of process log (${caddy_logdir}/caddy.log)
#                             This is for startup/shutdown/error messages.
#                             To create an access log, see:
#                             https://caddyserver.com/docs/caddyfile/directives/log
# caddy_user (user):          User to run caddy (root)
# caddy_group (group):        Group to run caddy (wheel)
#
# This script will honor XDG_CONFIG_HOME/XDG_DATA_HOME. Caddy will create a
# .../caddy subdir in each of those. By default, they are subdirs of /var/db/caddy.
# See https://caddyserver.com/docs/conventions#data-directory

. /etc/rc.subr

name=caddy
rcvar=caddy_enable
desc="Powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"

load_rc_config $name

# Defaults
: ${caddy_enable:=NO}
: ${caddy_adapter:=caddyfile}
: ${caddy_config:=/usr/local/etc/caddy/Caddyfile}
: ${caddy_directory:=/var/db/caddy}
: ${caddy_extra_flags:=""}
: ${caddy_logdir:="/var/log/${name}"}
: ${caddy_logfile:="${caddy_logdir}/${name}.log"}
: ${caddy_user:="root"}
: ${caddy_group:="wheel"}

# Config and base directories
: ${XDG_CONFIG_HOME:="${caddy_directory}/config"}
: ${XDG_DATA_HOME:="${caddy_directory}/data"}
export XDG_CONFIG_HOME XDG_DATA_HOME

command="/usr/local/bin/${name}"
caddy_flags="--config ${caddy_config} --adapter ${caddy_adapter}"
pidfile="/var/run/${name}/${name}.pid"

required_files="${caddy_config} ${command}"

start_precmd="caddy_precmd"
start_cmd="caddy_start"
stop_cmd="caddy_stop"

# Extra Commands
extra_commands="configtest reload"
configtest_cmd="caddy_command validate ${caddy_flags}"
reload_cmd="caddy_command reload ${caddy_flags}"

caddy_command()
{
        /usr/bin/su -m "${caddy_user}" -c "${command} $*"
}

caddy_precmd()
{
        # Create required directories and set permissions
        /usr/bin/install -d -m 755 -o "${caddy_user}" -g "${caddy_group}" ${caddy_directory}
        /usr/bin/install -d -m 700 -o "${caddy_user}" -g "${caddy_group}" ${caddy_directory}/config
        /usr/bin/install -d -m 700 -o "${caddy_user}" -g "${caddy_group}" ${caddy_directory}/data
        /usr/bin/install -d -m 755 -o "${caddy_user}" -g "${caddy_group}" ${caddy_logdir}
        /usr/bin/install -d -m 700 -o "${caddy_user}" -g "${caddy_group}" /var/run/caddy
}

caddy_start()
{
        echo -n "Starting caddy... "
        /usr/bin/su -m ${caddy_user} -c "${command} start ${caddy_flags} \
                ${caddy_extra_flags} --pidfile ${pidfile}" >> ${caddy_logfile} 2>&1
        if [ $? -eq 0 ] && ps -ax -o pid | grep -q "$(cat ${pidfile})"; then
                echo "done"
                echo "Log: ${caddy_logfile}"
        else
                echo "Error: Caddy failed to start"
                echo "Check the caddy log: ${caddy_logfile}"
        fi
}

caddy_stop()
{
        echo -n "Stopping caddy... "
        if caddy_command stop; then
                echo "done"
        else
                echo "Error: Unable to stop caddy"
                echo "Check the caddy log: ${caddy_logfile}"
        fi
}

run_rc_command "$1"

EOF
```

- Nadanie uprawnienia wykonywania dla pliku startowego:
```
chmod +x /usr/local/etc/rc.d/caddy
```

- Utworzenie pliku konfiguracyjnego `caddy`
```
cat > /usr/local/www/Caddyfile << EOF
# Define a snippet with ALL common, non-backend-specific directives.
(common_conf) {
	log {
		output file /var/log/caddy/access.log
		format console
	}

	tls {
		dns cloudflare {env.CLOUDFLARE_API_TOKEN}
	}
	# Encoding
	encode zstd gzip
}

(common_headers) {
	# Security Headers (HSTS, etc.)
	header {
		Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
		X-Content-Type-Options "nosniff"
		X-Frame-Options "DENY"
		Referrer-Policy "strict-origin-when-cross-origin"
	}
}

jelly.ts.ocloud.site {
	# Import common configuration
	import common_conf

	header {
		Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
		X-Content-Type-Options "nosniff"
		Referrer-Policy "strict-origin-when-cross-origin"
	}

	# Define the reverse proxy with its specific backend address and required headers
	reverse_proxy 172.16.16.50:8096 {
		header_up Host {host}
	}
}

adguard.ts.ocloud.site {
	import common_conf
	import common_headers
	reverse_proxy 172.16.16.2:80 {
		header_up Host {host}
	}
}

prometheus.ts.ocloud.site {
	import common_conf
	import common_headers
	reverse_proxy 127.0.0.1:9090 {
		header_up Host {host}
	}
}

grafana.ts.ocloud.site {
	import common_conf
	import common_headers
	reverse_proxy 127.0.0.1:3000 {
		header_up Host {host}
	}
}

EOF
```

- Utworzenie konfiguracji startowej dla `proxies`
```
cat > /etc/rc.conf << EOF
syslogd_flags="-ss"
sendmail_enable="NO"
sendmail_submit_enable="NO"
sendmail_outbound_enable="NO"
sendmail_msp_queue_enable="NO"
cron_flags="-J 60"
caddy_config="/usr/local/www/Caddyfile"
caddy_enable="YES"
caddy_env="CLOUDFLARE_API_TOKEN=<change_me>"

EOF
```

Na zakończenie konfiguracji należy wyjść z `proxies` wpisując `exit`.

8. Usunięcie niepotrzebnych pakietów:
```
# pkg -j proxies remove -y go124 xcaddy
```

9. Zatrzymanie `proxies`:
```
# service jail stop proxies
```

10. Ponowne uruchomienie `proxies`:
```
# service jail start proxies
```

