#!/bin/bash


source config.sh

echo "=========================START==================================="

if [ -n $HDFS_BACKUP_RECIVER ];then
    echo "==================get data from hdfs======================"
   source $HDFS_BACKUP_RECIVER
fi

if [ ! -d $BASEDIR ];then
  echo "$BASEDIR is not exist! please exec all backup...  (run backup-all.sh)"
  exit 1
fi

echo "stop mysql service..."

service mysqld stop

dir=`ls -l -t $BASEDIR |sed -n '2p'|awk '{print $9}'`
echo "========================recover mysql start...========================="
echo "========================apply base backup dir========================="

innobackupex --defaults-file=$MY_CNF --user=$USER --apply-log   $BASEDIR/$dir
echo "========================start incremental dir add to base dir========="
delta_dirs=`ls -l -t -r $INCRE_DIR |awk '{print "'$INCRE_DIR/'"$9}'|sed -n '1!p'|awk BEGIN{RS=EOF}'{gsub(/\n/," ");print}'`

dir_arr=($delta_dirs)

arr_len=${#dir_arr[@]}

i=0
while [[ i -lt arr_len  ]]
do
  if [[ i -eq $[arr_len - 1]  ]];then
    echo ${dir_arr[${i}]}
    innobackupex --defaults-file=$MY_CNF --user=$USER --apply-log $BASEDIR/$dir  --incremental-dir=${dir_arr[${i}]}
    break
  fi
  echo ${dir_arr[${i}]} 
  innobackupex --defaults-file=$MY_CNF --user=$USER --apply-log --redo-only $BASEDIR/$dir  --incremental-dir=${dir_arr[${i}]} 
  ((i++))
done

echo "==========================start recover mysql========================"

innobackupex --defaults-file=$MY_CNF --user=$USER --copy-back   $BASEDIR/$dir

datadir=`cat $MY_CNF |grep datadir|cut -d"=" -f2`

chown -R mysql:mysql $datadir

echo "===================start mysql server...========================"
service mysqld start
sleep 1
service mysqld status
echo "===================END==============================="
