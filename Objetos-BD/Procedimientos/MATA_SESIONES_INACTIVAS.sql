PROCEDURE MATA_SESIONES_INACTIVAS IS
CURSOR SES_Q IS
   SELECT Sid, Serial#, Wait_Class, Last_Call_Et, SchemaName, USER, Program
     FROM SYS.V_$SESSION
    WHERE Status               = 'INACTIVE'
      AND SchemaName          <> 'SYS'
      AND UPPER(Wait_Class)    = 'IDLE'
      AND (Last_Call_Et / 60) >= 30
      AND Program              = 'frmweb.exe';
BEGIN
   FOR W IN SES_Q LOOP
--       NULL;
      EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ' || CHR(39) || W.SID || ',' || W.SERIAL# || CHR(39);
   END LOOP;
end;
