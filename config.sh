#!/bin/bash
export s_dir=$(cd `dirname $0` && pwd)

export USER="root"
export PASSWORD="root"

export ALL="mysql/base"
export INCRE="mysql/delta"

export BASEDIR="$s_dir/$ALL"

export INCRE_DIR="$s_dir/$INCRE"

export MY_CNF="/etc/my.cnf"

export LOCAL_IP=$( /sbin/ifconfig | grep inet | grep -v inet6 | grep -v 127|awk '{print $2}'|cut -d":" -f2)
export HDFS_DIR="mysql_back/$LOCAL_IP"
export HDFS_BACKUP_ALL="hdfs-backup-all.sh"
export HDFS_BACKUP_INCRE="hdfs-backup-incre.sh"
export HDFS_BACKUP_RECIVER="hdfs-restore-all.sh"
