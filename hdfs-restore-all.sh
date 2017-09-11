#!/bin/bash
s_dir=$(cd `dirname $0` && pwd)
source $s_dir/config.sh
exist=`ls $BASEDIR`
echo "$BASEDIR"
echo "$exist"
chown -R hdfs:hdfs $BASEDIR $INCRE_DIR
if [ -z "$exist"  ];then
  mkdir -p $BASEDIR $INCRE_DIR
  su - hdfs  <<EOF
   source /etc/profile;
   hadoop fs -get $HDFS_DIR/$ALL/*  $BASEDIR/
   hadoop fs -get $HDFS_DIR/$INCRE/*  $INCRE_DIR/
   
EOF
fi

