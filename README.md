# Nagios Plugins for Linux

## About

This package contains several `nagios plugins` for monitoring Linux boxes.
Nagios is an open source computer system monitoring, network monitoring and infrastructure monitoring software application (see: http://www.nagios.org/).

Here is the list of the available plugins:

* **check_clock** - returns the number of seconds elapsed between local time and Nagios server time 
* **check_cpu** - checks the CPU (user mode) utilization 
* **check_cswch** - checks the total number of context switches across all CPUs
* **check_ifmountfs** - checks whether the given filesystems are mounted
* **check_intr** - monitors the total number of system interrupts
* **check_iowait** - monitors the I/O wait bottlenecks 
* **check_load** - checks the current system load average 
* **check_memory** - checks the memory usage 
* **check_multipath** - checks the multipath topology status 
* **check_nbprocs** - displays the number of running processes per user 
* **check_network** - displays some network interfaces statistics 
* **check_paging** - checks the memory and swap paging 
* **check_readonlyfs** - checks for readonly filesystems 
* **check_swap** - checks the swap usage 
* **check_tcpcount** - checks the tcp network usage 
* **check_temperature** - monitors the hardware's temperature 
* **check_uptime** - checks how long the system has been running 
* **check_users** - displays the number of users that are currently logged on 


## Full documentation

The full documentation of the `nagios-plugins-linux` is available online
[here](https://sites.google.com/site/davidemadrisan/nagios-monitoring/linux-os).


## Source code

The source code of the latest stable version can be found in
[this page](https://sites.google.com/site/davidemadrisan/nagios-monitoring/linux-os).


## The plugins in detail 

**The check_clock plugin**

This Nagios plugin returns the number of seconds elapsed between the host local
time and Nagios time.

*Usage*

	check_clock [-w COUNTER] [-c COUNTER] --refclock TIME
	check_clock --help

*Where*

* -r, --refclock TIME: the clock reference (in seconds since the Epoch)
* -w, --warning COUNTER: warning threshold
* -c, --critical COUNTER: critical threshold
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	# $ARG1$ is the number of seconds since the Epoch --
	# "$(date '+%s')" -- provided by the Nagios poller
	check_clock -w 60 -c 120 --refclock $ARG1$


**The check_cpu plugin**

This Nagios plugin checks the CPU (user mode) utilization.

*Usage*

	check_cpu [-f] [-v] [-w PERC] [-c PERC] [delay [count]]
	check_cpu --cpuinfo
	check_cpu --help

*Where*

* -w, --warning PERCENT: warning threshold
* -c, --critical PERCENT: critical threshold
* -f, --cpufreq: show the CPU frequency characteristics
* -i, --cpuinfo: show the CPU characteristics (for debugging)
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)
* delay is the delay between updates in seconds (default: 1sec)
* count is the number of updates (default: 2)
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_cpu -w 85% -c 95%
	cpu OK - cpu user 23% | cpu_user=23%, cpu_system=10%, cpu_idle=66%, cpu_iowait=0%, cpu_steal=0%
	
	# count = 1 means the percentages of total CPU time from boottime
	check_cpu -w 85% -c 95% 1 1
	cpu OK - cpu user 34% | cpu_user=34%, cpu_system=11%, cpu_idle=49%, cpu_iowait=7%, cpu_steal=0%


**The check_cswch plugin**

This Nagios plugin checks the total number of context switches across all CPUs.

*Usage*

	check_cswch [-v] [-w COUNTER] -c [COUNTER] [delay [count]]
	check_cswch --help

*Where*

* -w, --warning COUNTER: warning threshold
* -c, --critical COUNTER: critical threshold
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)

*Examples*

	check_cswch 1 2


**The check_ifmountfs plugin**

This Nagios plugin checks whether the given filesystems are mounted.

*Usage*

	check_ifmountfs [FILESYSTEM]...
	check_ifmountfs --help

*Examples*

	check_ifmountfs /mnt/nfs-data /mnt/cdrom


**The check_intr plugin**

This Nagios plugin monitors the total number of system interrupts.

*Usage*

	check_intr [-v] [-w COUNTER] -c [COUNTER] [delay [count]]
	check_intr --help

*Where*

* -w, --warning COUNTER: warning threshold
* -c, --critical COUNTER: critical threshold
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)

*Examples*

	check_intr 1 2


**The check_iowait plugin**

This Nagios plugin checks for I/O wait bottlenecks.

*Usage*

	check_iowait [-v] [-w PERC] [-c PERC] [delay [count]]
	check_iowait --help

*Where*

* -w, --warning PERCENT: warning threshold
* -c, --critical PERCENT: critical threshold
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)
* delay is the delay between updates in seconds (default: 1sec)
* count is the number of updates (default: 2)
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_iowait -w 10% -c 20%
	iowait OK - cpu iowait 0% | cpu_user=31%, cpu_system=13%, cpu_idle=56%, cpu_iowait=0%, cpu_steal=0%
	
	# count = 1 means the percentages of total CPU time from boottime
	check_iowait -w 10% -c 20% 1 1
	iowait OK - cpu iowait 7% | cpu_user=34%, cpu_system=11%, cpu_idle=49%, cpu_iowait=7%, cpu_steal=0%


**The check_load plugin**

This Nagios plugin tests the current system load average.

*Usage*

	check_load [-r] [--load1=w,c] [--load5=w,c] [--load15=w,c]
	check_load --help

*Where*

* -r, --percpu: divide the load averages by the number of CPUs
* 1, --load1=WLOAD1,CLOAD1: warning and critial thresholds for load1
* 5, --load5=WLOAD5,CLOAD5. warning and critical thresholds for load5
* L, --load15=WLOAD15,CLOAD15: warning and critical thresholds for load15
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_load -r --load1=2,3 --load15=1.5,2.5


**The check_memory and check_swap plugins**

These two nagios plugins respectivery check for memory and swap usage.

*Usage*

	check_memory [-a] [-C] [-s] [-b,-k,-m,-g] [-w PERC] [-c PERC]
	check_swap [-b,-k,-m,-g] [-w PERC] [-c PERC]
	
	check_memory --help
	check_swap --help

*Where*

* -a, --available: prefer the kernel counter MemAvailable (kernel 3.14+)
* -C, --caches: count buffers and cached memory as free memory
* -s, --vmstats: display the virtual memory perfdata
* -b,-k,-m,-g: show output in bytes, KB (the default), MB, or GB
* -w, --warning PERCENT: warning threshold
* -c, --critical PERCENT: critical threshold
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_memory -C --vmstats -w 80% -c 90%
        memory WARNING: 86.44% (884864 kB) used | mem_total=1023632kB, mem_used=884864kB, mem_free=138768kB, mem_shared=48052kB, mem_buffers=3892kB, mem_cached=118396kB, mem_active=471324kB, mem_anonpages=653996kB, mem_committed=4939408kB, mem_dirty=8848kB, mem_inactive=471808kB, vmem_pageins/s=368, vmem_pageouts/s=1684, vmem_pgmajfault/s=1
	  # mem_total    : Total usable physical RAM
	  # mem_used     : Total amount of physical RAM used by the system
	  # mem_free     : Amount of RAM that is currently unused
	  # mem_shared   : Now always zero; not calculated
	  # mem_buffers  : Amount of physical RAM used for file buffers
	  # mem_cached   : In-memory cache for files read from the disk (the page cache)
	  # mem_active   : Memory that has been used more recently
	  # mem_anonpages: Non-file backed pages mapped into user-space page tables
	  # mem_committed: The amount of memory presently allocated on the system
	  # mem_dirty    : Memory which is waiting to get written back to the disk
	  # mem_inactive : Memory which has been less recently used
	  # vmem_pageins
	  # vmem_pageouts: The number of memory pages the system has written in and out to disk
	  # vmem_pgmajfault: The number of memory major pagefaults

	check_memory -a -C -m -w 20%: -c 10%:
	memory WARNING: 18.70% (186 MB) available | mem_total=999MB, mem_used=813MB, mem_free=185MB, mem_shared=38MB, mem_buffers=4MB, mem_cached=146MB, mem_available=186MB, mem_active=431MB, mem_anonpages=676MB, mem_committed=6276MB, mem_dirty=0MB, mem_inactive=444MB
	# mem_available  : Memory available for starting new applications, without swapping

	check_swap -w 40% -c 60% -m
	swap WARNING: 42.70% (895104 kB) used | swap_total=2096444kB, swap_used=895104kB, swap_free=1201340kB, swap_cached=117024kB, swap_pageins/s=97, swap_pageouts/s=73
	  # swap_total   : Total amount of swap space available
	  # swap_used    : Total amount of swap used by the system
	  # swap_free    : Amount of swap space that is currently unused
	  # swap_cached  : The amount of swap used as cache memory
	  # swap_pageins 
	  # swap_pageouts: The number of swap pages the system has brought in and out


**The check_multipath plugin**

This Nagios plugin checks the multipath topology status.

*Usage*

	check_multipath [-v]
	check_multipath --help

*Where*

* -v, --verbose: show details for command-line debugging (Nagios may truncate output)
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_multipath


**The check_nbprocs plugin**

This Nagios plugin displays the number of running processes per user.

*Usage*

	check_nbprocs [--verbose] [--threads] [-w COUNT] [-c COUNT]
	check_nbprocs --help

*Where*

* -t, --threads: display the number of threads
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_nbprocs
	check_nbprocs --threads -w 1500 -c 2000


**The check_network plugin**

This Nagios plugin checks displays some network interfaces.statistics.

*Usage*

	check_network
	check_network --help

*Where*

* -h, --help: display this help and exit
* -V, --version: output version information and exit


**The check_paging plugin**

This Nagios plugin checks for memory and swap paging.

*Usage*

	check_paging [--paging] [--swapping]
	check_paging --help

*Where*

* -p, --paging: display the page reads and writes
* -s, --swapping: display the swap reads amd writes
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_paging --paging --swapping -w 10 -c 25


**The check_readonlyfs plugin**

This Nagios plugin checks for readonly filesystems.

*Usage*

	check_readonlyfs [OPTION]... [FILE]...
	check_readonlyfs --help

*Options*

* -l, --local: limit listing to local file systems
* -L, --list: display the list of checked file systems
* -T, --type=TYPE: limit listing to file systems of type TYPE
* -X, --exclude-type=TYPE: limit listing to file systems not of type TYPE
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_readonlyfs
	check_readonlyfs -l -T ext3 -T ext4
	check_readonlyfs -l -X vfat


**The check_tcpcount plugin**

This plugin displays TCP network and socket informations.

*Usage*

	check_tcpcount [--tcp] [--tcp6] --warning COUNTER --critical COUNTER
	check_tcpcount --help

*Where*

* -t, --tcp: display the statistics for the TCP protocol (the default)
* -6, --tcp6: display the statistics for the TCPv6 protocol
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_tcpcount -w 1000 -c 1500
	check_tcpcount --tcp6 -w 1000 -c 1500
	check_tcpcount --tcp --tcp6 -w 1500 -c 2000


**The check_temperature  plugin**

This Nagios plugin monitors the hardware's temperature.

*Usage*

	check_temperature [-f|-k] [-t <thermal_zone>] [-w COUNTER] [-c COUNTER]
	check_temperature -l
	check_temperature -.help

*Where*

* -f, --fahrenheit: use fahrenheit as the temperature unit
* -k, --kelvin: use kelvin as the temperature unit
* -l, --list: list the thermal zones available and exit
* -t, --thermal_zone: only consider a specific thermal zone
* -w, --warning COUNTER: warning threshold
* -c, --critical COUNTER: critical threshold
* -v, --verbose: show details for command-line debugging (Nagios may truncate output)
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_temperature -w 80 -c 90
	check_temperature --list
	check_temperature -t thermal_zone0 -w 80 -c 90


**The check_uptime plugin**

This Nagios plugin checks how long the system has been running.

*Usage*

	check_uptime [--warning [@]start:end] [--critical [@]start:end]
	check_uptime --help

*Where*

* -w, --warning COUNTER: warning threshold
* -c, --critical COUNTER: critical threshold
* -h, --help: display this help and exit
* -V, --version: output version information and exit

and

* start <= end
* start and ":" is not required if start=0
* if range is of format "start:" and end is not specified, assume end is infinity
* to specify negative infinity, use "~"
* alert is raised if metric is outside start and end range (inclusive of endpoints)
* if range starts with "@", then alert if inside this range (inclusive of endpoints)

*Examples*

	check_uptime
	check_uptime --warning 30: --critical 15:


**The check_users plugin**

This Nagios plugin displays the number of users that are currently logged on.

*Usage*

	check_users [-w PERC] [-c PERC]

Where

* -w, --warning PERCENT: warning threshold
* -c, --critical PERCENT: critical threshold
* -h, --help: display this help and exit
* -V, --version: output version information and exit

*Examples*

	check_users -w 1


## Installation

This package uses `GNU autotools` for configuration and installation.

If you have cloned the git repository then you will need to run
`autoreconf --install` to generate the required files.

Run `./configure --help` to see a list of available install options.
The plugin will be installed by default into `LIBEXECDIR`.

It is highly likely that you will want to customise this location to
suit your needs, i.e.:

        ./configure --libexecdir=/usr/lib/nagios/plugins

After `./configure` has completed successfully run `make install` and
you're done!


## Supported Platforms

This package is written in plain C, making as few assumptions as possible, and
sticking closely to ANSI C/POSIX. 
A C99-compliant compiler is required anyway.

This package is known to compile with
* gcc 4.4 (RHEL6),
* gcc 4.8.2 and clang 3.1 (openmamba GNU/Linux 2.90).


## Bugs

If you find a bug please create an issue in the project bug tracker at
[github](https://github.com/madrisan/nagios-plugins-linux/issues)
