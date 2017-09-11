#/bin/bash
s_dir=$(cd `dirname $0` && pwd)
source $s_dir/config.sh
HDFS_ALL_PATH=$HDFS_DIR/$ALL

chown -R hdfs:hdfs  $BASEDIR
su - hdfs <<EOF
  source /etc/profile;
  exist=\$(hadoop fs -ls $HDFS_ALL_PATH)
  if [ -z "\$exist"  ];then
    hadoop fs -mkdir -p $HDFS_ALL_PATH/
    hadoop fs -put $BASEDIR/* $HDFS_ALL_PATH/
  else
    hadoop fs -rm -r $HDFS_ALL_PATH/
    hadoop fs -rm -r $HDFS_DIR/$INCRE
    hadoop fs -mkdir -p $HDFS_ALL_PATH/
    hadoop fs -put $BASEDIR/* $HDFS_ALL_PATH/
  fi
exit;
EOF


