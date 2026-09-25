# Linux Health Check Script

A bash script that checks the health of a Linux system — disk usage, memory,
top processes, and key service status — and logs the results.

## What it does

- Checks disk usage across mounted filesystems and flags anything over 80% full
- Reports current memory and swap usage
- Lists the top 5 processes by CPU usage and top 5 by memory usage
- Checks whether key services (sshd, crond, firewalld) are running
- Logs every run with a timestamp to `~/health_check.log`

## How to run it

```bash
chmod +x health_check.sh
./health_check.sh
```

## Example output

Disk usage flagged an external/mounted volume at 100% capacity during a real run:

```
WARNING: /run/media/shivam/VBox_GAs_7.2.8 is at 100% - above threshold of 80%
```


## Automating it with cron

To run this automatically every hour:

```bash
crontab -e
```

Add this line:

```
0 * * * * /full/path/to/health_check.sh
```


## Why I built this

I wanted a small, real project to practice core Linux administration —
file systems, permissions, process monitoring, and service management —
the same skills I use daily in enterprise monitoring at work, applied
here in my own lab environment.
