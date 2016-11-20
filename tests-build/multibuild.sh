#!/bin/bash
# Multi-platform build system
# Copyright (C) 2016 Davide Madrisan <davide.madrisan@gmail.com>

PROGNAME="${0##*/}"
PROGPATH="${0%/*}"
REVISION=2

die () { echo -e "$PROGNAME: error: $1" 1>&2; exit 1; }
msg () { echo "*** info: $1"; }

docker_helpers="$PROGPATH/docker-shell-helpers/docker-shell-helpers.sh"

[ -r "$docker_helpers" ] || die "no such file: $docker_helpers"
. "$docker_helpers"

usage () {
   cat <<__EOF
Usage: $PROGNAME -o <os> -s <shared> [-d <distro>] [--spec <file>] \
[-t <folder>] -v <version>
       $PROGNAME --help
       $PROGNAME --version

Where:
   -d|--distro : distribution name (default: no distribution set)
   -o|--os     : distribution (example: centos:centos6)
   -s|--shared : shared folder that will be mounted on the docker instance
      --spec   : the specfile to be used for building the rpm packages
   -t|--target : the directory where to copy the rpm packages
   -v|--pckver : the package version
   -g|--gid    : group ID of the user 'developer' used for building the software
   -u|--uid    : user ID of the user 'developer' used for building the software

Supported distributions:
   CentOS 5/6/7
   Debian jessie
   Fedora 24/rawhide

Example:
       $0 -s $PROGPATH/../../nagios-plugins-linux:/shared:rw \\
          --spec specs/nagios-plugins-linux.spec \\
          -t pcks -d mamba -g 100 -u 1000 -o centos:latest
       $0 -s $PROGPATH/../../nagios-plugins-linux:/shared:rw \\
          -t pcks -d mamba v 19 -o debian:jessie

__EOF
}

help () {
   cat <<__EOF
$PROGNAME v$REVISION - containerized software build checker
Copyright (C) 2016 Davide Madrisan <davide.madrisan@gmail.com>

__EOF

   usage
}

while test -n "$1"; do
   case "$1" in
      --help|-h) help; exit 0 ;;
      --version|-V)
         echo "$PROGNAME v$REVISION"
         exit 0 ;;
      --distro|-d)
         usr_distro="$2"; shift ;;
      --gid|-g)
         usr_gid="$2"; shift ;;
      --os|-o)
         usr_os="$2"; shift ;;
      --shared|-s)
         usr_disk="$2"; shift ;;
      --spec)
         usr_specfile="$2"; shift ;;
      --target|-t)
         usr_targetdir="$2"; shift ;;
      --pckver|-v)
         usr_pckver="$2"; shift ;;
      --uid|-u)
         usr_uid="$2"; shift ;;
      --*|-*) die "unknown argument: $1" ;;
      *) die "unknown option: $1" ;;
    esac
    shift
done

[ "$usr_disk" ] || { usage; exit 1; }
[ "$usr_os" ] || { usage; exit 1; }
[ "$usr_specfile" ] &&
 { [ -r "$usr_specfile" ] || die "no such file: $usr_specfile"; }
[ "$usr_pckver" ] || { usage; exit 1; }

# parse the shared disk string
IFS_save="$IFS"
IFS=":"; set -- $usr_disk
shared_disk_host="$(readlink -f $1)"
shared_disk_container="$2"
IFS="$IFS_save"

([ "$shared_disk_host" ] && [ "$shared_disk_container" ]) ||
   die "bad syntax for --shared"

if [ "$usr_specfile" ]; then
   specfile="$(readlink -f $usr_specfile)"
   case "$specfile" in
      ${shared_disk_host}*)
          specfile="./${specfile#$shared_disk_host}" ;;
      *) die "the specfile must be in $shared_disk_host" ;;
   esac
fi
if [ "$usr_targetdir" ]; then
   targetdir="$(readlink -f $usr_targetdir)"
   case "$targetdir" in
      ${shared_disk_host}*)
         targetdir="$shared_disk_container/${targetdir#$shared_disk_host}" ;;
      *) die "the target dir must be in $shared_disk_host" ;;
   esac
fi

msg "instantiating a new container based on $usr_os ..."
container="$(container_create --random-name --os "$usr_os" \
                --disk "$shared_disk_host:$shared_disk_container")" ||
   die "failed to create a new container with os $usr_os"

container_start "$container"

ipaddr="$(container_property --ipaddr "$container")"
os="$(container_property --os "$container")"

case "$os" in
   centos-*)
      pck_format="rpm"
      pck_install="yum install -y"
      pck_dist=".el${os:7:1}"
      pcks_dev="bzip2 make gcc xz rpm-build" ;;
   debian-*)
      pck_format="deb"
      pck_install="\
export DEBIAN_FRONTEND=noninteractive;
apt-get update && apt-get -y install"
      pcks_dev="bzip2 make gcc xz-utils devscripts"
      ;;
   fedora-*)
      pck_format="rpm"
      pck_install="dnf install -y"
      pck_dist=".fc${os:7:2}"
      pcks_dev="bzip2 make gcc xz rpm-build" ;;
   *) die "FIXME: unsupported os: $os" ;;
esac
pck_dist="${pck_dist}${usr_distro:+.$usr_distro}"

pckname="nagios-plugins-linux"

echo "\
Container \"$container\"  status:running  ipaddr:$ipaddr  os:$os
"

msg "testing the build process inside $container ..."
container_exec_command "$container" "\
# install the build prereqs
$pck_install $pcks_dev

# create a non-root user for building the software (developer) ...
useradd -m '${usr_gid:+-g $usr_gid}' '${usr_uid:+-u $usr_uid}' \
   -c Developer developer -s /bin/bash

# ... and switch to this user
su - developer -c '
msg () { echo \"*** info: \$1\"; }

if [ \"'$pck_format'\" = rpm ] && [ \"'$specfile'\" ]; then
   mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
   cp -p $shared_disk_container/$specfile ~/rpmbuild/SPECS/
   cp -p $shared_disk_container/${pckname}*.tar.* ~/rpmbuild/SOURCES/

   msg \"creating the rpm packages ...\"
   pushd ~/rpmbuild/SPECS/ &>/dev/null
   rpmbuild \
      --define=\"dist $pck_dist\" \
      --define=\"_topdir \$HOME/rpmbuild\" \
      -ba ${pckname}.spec

   msg \"testing the rpm installation ...\"
   rpm --test -hiv ../RPMS/*/*.rpm

   if [ \"'$targetdir'\" ]; then
      msg \"copying the rpm packages to the target folder ...\"
      mkdir -p '$targetdir' &&
      cp -p ../SRPMS/*.src.rpm ../RPMS/*/*.rpm '$targetdir'
   fi
   popd &>/dev/null
elif [ \"'$pck_format'\" = deb ]; then
   mkdir -p ~/debian-build
   cp $shared_disk_container/${pckname}-${usr_pckver}.tar.xz \
      ~/debian-build/${pckname}_${usr_pckver}.orig.tar.xz

   msg \"creating the deb package and build files ...\"
   cd ~/debian-build
   tar xf ${pckname}_${usr_pckver}.orig.tar.xz
   cd ~/debian-build/${pckname}-${usr_pckver}
   debuild -us -uc &&
   cp -p ../*.{changes,deb,dsc,orig.tar.*} '$targetdir'
fi
'"

msg "removing the temporary container ..."
container_remove "$container"