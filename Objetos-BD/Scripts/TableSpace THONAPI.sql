--DROP TABLESPACE ts_something INCLUDING CONTENTS AND DATAFILES;

create tablespace TS_THONAPI
  logging
  datafile 'D:\SICASDB\TABLESPACES\TS_THONAPI_01' 
  size 32m 
  autoextend on 
  next 32m maxsize unlimited
  extent management local;