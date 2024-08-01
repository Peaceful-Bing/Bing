#!/bin/bash

##############################
#        执行sql文件
##############################


#连接到PSQL以后
psql -d database -U username
\i /path/xxx.sql

#未连接到PSQL直接执行
psql -d database -U userName -f /path/xxx.sql


#当前总共正在使用的连接数
postgres=# select count(1) from pg_stat_activity;
 
#显示系统允许的最大连接数
postgres=# show max_connections;
 
#显示系统保留的用户数
postgres=# show superuser_reserved_connections ;

#按照用户分组查看
postgres=# select usename, count(*) from pg_stat_activity group by usename order by count(*) desc;


###################################
#        PostgreSQL连接数
###################################

#合适的最大连接数 
#used_connections/max_connections在85%左右

#修改最大连接数
  #postgresql最大连接数默认为100
    #1)打开postgresql配置文件
       vim /var/lib/pgsql/9.4/data/postgresql.conf 
    #2)修改最大连接数
       max_connections = 100
    #3)重启postgresql服务

#在CentOS 6.x系统中
service postgresql-9.4 restart 
#在CentOS 7系统中
systemctl restart postgresql-9.4