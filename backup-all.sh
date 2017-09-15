#!/bin/bash

source config.sh

if [ ! -d $BASEDIR ];then
  mkdir -p $BASEDIR
fi 

if [ ! -d $INCRE_DIR ];then
  mkdir -p $INCRE_DIR
fi


echo "`date +"%Y-%m-%d %H:%M:%S"`==================rm old backup data...====================="
rm -rf $BASEDIR/* $INCRE_DIR/*

echo "`date +"%Y-%m-%d %H:%M:%S"`==================mysql start backup dir is: $BASEDIR========"
innobackupex --defaults-file=$MY_CNF  --user=$USER --password=$PASSWORD $BASEDIR
echo "`date +"%Y-%m-%d %H:%M:%S"`==================backup end and flush cache============"
dir=`ls -l -t $BASEDIR |sed -n '2p'|awk '{print $9}'`
echo "`date +"%Y-%m-%d %H:%M:%S"`==================new backup dir is: $dir==============="
innobackupex --defaults-file=$MY_CNF  --apply-log $BASEDIR/$dir

if [ -n "$HDFS_BACKUP_ALL"  ];then
echo "`date +"%Y-%m-%d %H:%M:%S"`==================put data to hdfs======================"
  source $HDFS_BACKUP_ALL
fi

echo "`date +"%Y-%m-%d %H:%M:%S"`==================END==================================="


