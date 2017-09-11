#!/bin/bash

source config.sh

if [ ! -d $BASEDIR ];then
  mkdir -p $BASEDIR
fi 

if [ ! -d $INCRE_DIR ];then
  mkdir -p $INCRE_DIR
fi


echo "==================rm old backup data...====================="
rm -rf $BASEDIR/* $INCRE_DIR/*

echo "==================mysql start backup dir is: $BASEDIR========"
innobackupex --defaults-file=$MY_CNF  --user=$USER --password=$PASSWORD $BASEDIR
echo "==================backup end and flush cache============"
dir=`ls -l -t $BASEDIR |sed -n '2p'|awk '{print $9}'`
echo "==================new backup dir is: $dir==============="
innobackupex --defaults-file=$MY_CNF  --apply-log $BASEDIR/$dir

if [ -n "$HDFS_BACKUP_ALL"  ];then
echo "==================put data to hdfs======================"
  source $HDFS_BACKUP_ALL
fi

echo "==================END==================================="


