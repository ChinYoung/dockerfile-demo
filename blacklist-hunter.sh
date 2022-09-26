#! /bin/bash
cat /var/log/auth.log |awk '/Invalid user/{print $(NF-2)}'|sort|uniq -c|awk '{print $2"="$1;}' > /usr/local/bin/black.list
for i in `cat  /usr/local/bin/black.list`
do
  IP=`echo $i |awk -F= '{print $1}'`
  NUM=`echo $i|awk -F= '{print $2}'`
  if [ $NUM -gt 8 ]; then
    echo "$IP"
    grep $IP /etc/hosts.deny > /dev/null
    if [ $? -gt 0 ];then
      echo "ALL:$IP" >> /etc/hosts.deny
    fi
  fi
done
