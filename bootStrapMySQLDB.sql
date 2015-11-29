create user 'ambari'@'%' identified by 'bigdata';
create user 'ambari'@'localhost' identified by 'bigdata';
create user 'hive'@'%' identified by 'hive';
create user 'hive'@'localhost' identified by 'hive';
create user oozie@'%' identified by 'oozie';
 

drop database  if exists ambari;
create database ambari ;
grant all on  ambari.* to 'ambari'@'%' ;


drop database if exists hive;
create database hive ;
grant all on hive.* to 'hive'@'%' ;
grant all on hive.* to 'hive'@'localhost' ;

drop database if exists oozie;
create database oozie ;
grant all on oozie.* to 'oozie'@'%' ;

