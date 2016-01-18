create user ambari with password 'bigdata';
create database ambari ;
grant all privileges on database ambari to ambari ;

create user hive  with password 'hive';
create database hive ;
grant all privileges on database hive to hive ;

create user oozie  with password 'oozie';
create database oozie ;
grant all privileges on database oozie to oozie ;

\connect ambari;
create schema ambarischema authorization ambari;
alter schema  ambarischema owner to ambari;
alter role ambari set search_path to 'ambarischema' , 'public';

