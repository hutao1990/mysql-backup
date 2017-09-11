#!/bin/bash

source config.sh

if [ ! -d $BASEDIR ];then
  echo "$BASEDIR is not exist! please exec all backup...  (run backup-all.sh)"
  exit 1
fi

dir=`ls -l -t $BASEDIR |sed -n '2p'|awk '{print $9}'`
echo "===============$dir==============="

idir=`ls -l -t $INCRE_DIR |sed -n '2p'|awk '{print $9}'`

if [ -z "$idir" ];then
    echo "==================innobackupex --defaults-file=$MY_CNF --user=$USER --password=$PASSWORD  --incremental --incremental-basedir=$BASEDIR/$dir $INCRE_DIR"
    innobackupex --defaults-file=$MY_CNF --user=$USER --password=$PASSWORD  --incremental --incremental-basedir=$BASEDIR/$dir $INCRE_DIR
else
    echo "==================innobackupex --defaults-file=$MY_CNF --user=$USER --password=$PASSWORD  --incremental --incremental-basedir=$INCRE_DIR/$idir $INCRE_DIR"
    innobackupex --defaults-file=$MY_CNF --user=$USER --password=$PASSWORD  --incremental --incremental-basedir=$INCRE_DIR/$idir $INCRE_DIR
fi

if [ -n $HDFS_BACKUP_INCRE ];then
   echo "==================put data to hdfs======================"
   source $HDFS_BACKUP_INCRE
fi

echo "===============================END==================================="

