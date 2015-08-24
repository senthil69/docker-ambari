create user ambari with password 'bigdata';
create database ambari ;
grant all privileges on database ambari to ambari ;
\connect ambari;
create schema ambarischema authorization ambari;
alter schema  ambarischema owner to ambari;
alter role ambari set search_path to 'ambarischema' , 'public';
