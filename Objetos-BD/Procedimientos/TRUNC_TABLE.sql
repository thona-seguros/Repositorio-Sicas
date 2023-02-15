PROCEDURE TRUNC_TABLE(tbl_name in varchar2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  execute immediate 'truncate table ' ||  tbl_name;

END trunc_table;

 
