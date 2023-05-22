#!/bin/bash



Last_IO_Error=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep -i Last_IO_Error|awk -F ":" '{print $2}'|sed 's/ //g'`
Last_SQL_Error=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep -i Last_SQL_Error|awk -F ":" '{print $2}'|sed 's/ //g'`
Last_Error=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep -i Last_Error|awk -F ":" '{print $2}'|sed 's/ //g'`
Seconds_Behind_Master=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep -i Seconds_Behind_Master|awk -F ":" '{print $2}'|sed 's/ //g'`
Slave_IO_Running=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep -i Slave_IO_Running|awk -F ":" '{print $2}'|sed 's/ //g'`
Slave_SQL_Running=`mysql -h mysql_slave -u root -p111 -e"show slave status\G"|grep "Slave_SQL_Running: Yes"|awk -F ":" '{print $2}'|sed 's/ //g'`



if [ -z "$Last_IO_Error" ] && [ -z "$Last_SQL_Error" ] && [ -z "$Last_Error" ] &&  [ "$Slave_SQL_Running" = "Yes" ] && [ "$Slave_IO_Running" = "Yes" ]; then
    true
    echo "Slave is Running"
else
        echo "Attention: The MySQL slave has stopped its work. As a result, the replication process has been interrupted, and any changes made to the master database will not be reflected in the slave. The possible causes of this issue could be a network connectivity problem, a configuration error, or a problem with the master database. Please investigate the logs and the replication configuration to identify the root cause of the problem. Once the issue is resolved, it is recommended to manually resume the replication process using the START SLAVE command to ensure data consistency between the master and the slave." >> /var/log/check_replication.log
        curl -s --user 'api:9c5860b8473cb726ae70840830e00dd2-81bd92f8-f0ac3521' \
        https://api.mailgun.net/v3/sandbox4de29a8a0699461cac15c69fb8f515d4.mailgun.org/messages \
        -F from='MYsql server <mailgun@sandbox4de29a8a0699461cac15c69fb8f515d4.mailgun.org>' \
        -F to=education.oleksandr@gmail.com \
        -F subject='mysql replica is not running' \
        -F text='Attention: The MySQL slave has stopped its work. As a result, the replication process has been interrupted, and any changes made to the master database will not be reflected in the slave. The possible causes of this issue could be a network connectivity problem, a configuration error, or a problem with the master database. Please investigate the logs and the replication configuration to identify the root cause of the problem. Once the issue is resolved, it is recommended to manually resume the replication process using the START SLAVE command to ensure data consistency between the master and the slave.'
fi
