#/bin/bash
s_dir=$(cd `dirname $0` && pwd)
source $s_dir/config.sh
HDFS_INCRE_PATH=$HDFS_DIR/$INCRE

chown -R hdfs:hdfs $INCRE_DIR

su - hdfs <<EOF
  source /etc/profile;
  exist=\$(hadoop fs -ls $HDFS_INCRE_PATH)
  if [ -z "\$exist"  ];then
   echo "hadoop fs -mkdir -p $HDFS_INCRE_PATH/"
    hadoop fs -mkdir -p $HDFS_INCRE_PATH/
   echo "hadoop fs -put $INCRE_DIR/* $HDFS_INCRE_PATH/"
    hadoop fs -put $INCRE_DIR/* $HDFS_INCRE_PATH/
  else
    hadoop fs -rm -r $HDFS_INCRE_PATH/
    hadoop fs -mkdir -p $HDFS_INCRE_PATH/
    hadoop fs -put $INCRE_DIR/* $HDFS_INCRE_PATH/
  fi
EOF




