DIR=$( cd `dirname $0` && pwd)

cd $DIR

case $1 in
  all)  ./backup-all.sh;;
  incre) ./backup-incremental.sh;;
  restore) ./restore-all.sh ;;
  *)  echo "Usage: all|incre|restore ..."
esac
