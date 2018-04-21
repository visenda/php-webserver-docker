#!/bin/bash

echo "Generating supervisor config ..."
printf "\
[unix_http_server]
file = /dev/shm/supervisor.sock   ; (the path to the socket file)

[supervisord]
logfile = /tmp/supervisord.log ; (main log file;default \$CWD/supervisord.log)
logfile_maxbytes = 50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups = 10           ; (num of main logfile rotation backups;default 10)
loglevel = info                ; (log level;default info; others: debug,warn,trace)
pidfile = /tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon = false               ; (start in foreground if true;default false)
minfds = 1024                  ; (min. avail startup file descriptors;default 1024)
minprocs = 200                 ; (min. avail process descriptors;default 200)
user = root

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl = unix:///dev/shm/supervisor.sock ; use a unix:// URL  for a unix socket

[program:php-fpm]
command = /usr/local/sbin/php-fpm --nodaemonize
autostart = true
autorestart = true
priority = 5
stdout_logfile = /proc/self/fd/1
stdout_logfile_maxbytes = 0
stderr_logfile = /proc/self/fd/2
stderr_logfile_maxbytes = 0

[program:nginx]
command = /usr/sbin/nginx -g \"daemon off;\"
autostart = true
autorestart = true
priority = 10
stdout_events_enabled = true
stderr_events_enabled = true
stdout_logfile = /proc/self/fd/1
stdout_logfile_maxbytes = 0
stderr_logfile = /proc/self/fd/2
stderr_logfile_maxbytes = 0

;TODO: needed?
[include]
files = /etc/supervisor/conf.d/*.conf
" > /etc/supervisord.conf