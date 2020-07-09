--
-- OC_JOB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_SCHEDULER (Package)
--   DBMS_SCHEDULER (Synonym)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_JOB IS

PROCEDURE CREAR( cJob_name VARCHAR2,cStart_Date DATE,cRepeat_Interval VARCHAR2,cJob_action VARCHAR2);
PROCEDURE DESAHABILITAR(cJob_name VARCHAR2);
PROCEDURE HABILITAR(cJob_name VARCHAR2);
PROCEDURE FRECUENCIA (cJob_name VARCHAR2,cFrecuencia VARCHAR2);
PROCEDURE INICIO (cJob_name VARCHAR2, cFecha_Inicio VARCHAR2);
PROCEDURE EJECUTAR (cJob_name VARCHAR2);
PROCEDURE ELIMINAR (cJob_name VARCHAR2);

END;
/

--
-- OC_JOB  (Package Body) 
--
--  Dependencies: 
--   OC_JOB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_JOB IS
PROCEDURE CREAR( cJob_name VARCHAR2,cStart_Date DATE,cRepeat_Interval VARCHAR2,cJob_action VARCHAR2) IS
BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => cJob_name
     -- ,start_date      => TO_TIMESTAMP_TZ(TO_CHAR(cStart_Date,'yyyy/mm/dd')|| ' ' ||'06:00:00.000000 -06:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
     ,start_date      => TO_TIMESTAMP_TZ(TO_CHAR(cStart_Date,'yyyy/mm/dd HH24:MI:SS')||'.000000 -06:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
     ,repeat_interval => cRepeat_Interval
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'STORED_PROCEDURE'
      ,job_action      => cJob_action
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => cJob_name
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => cJob_name
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_RUNS);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => cJob_name
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => cJob_name
     ,attribute => 'MAX_RUNS');
  BEGIN
    SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
      ( name      => cJob_name
       ,attribute => 'STOP_ON_WINDOW_CLOSE'
       ,value     => FALSE);
  EXCEPTION

    WHEN OTHERS THEN
      NULL;
  END;
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => cJob_name
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => cJob_name
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      =>cJob_name
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
 SYS.DBMS_SCHEDULER.ENABLE
    (name                  => cJob_name);

END CREAR;

PROCEDURE DESAHABILITAR(cJob_name VARCHAR2) IS
BEGIN
   BEGIN
      DBMS_SCHEDULER.DISABLE(
      NAME => cJob_name,
      FORCE=> TRUE);
   END;

END DESAHABILITAR;

PROCEDURE HABILITAR(cJob_name VARCHAR2) IS
BEGIN
   BEGIN
      DBMS_SCHEDULER.ENABLE(cJob_name);
   END;
END HABILITAR;

PROCEDURE FRECUENCIA (cJob_name VARCHAR2,cFrecuencia VARCHAR2) IS
BEGIN
   BEGIN
      DBMS_SCHEDULER.SET_ATTRIBUTE(
      NAME => cJob_name,
      ATTRIBUTE => 'REPEAT_INTERVAL',
      VALUE=> cFrecuencia);
   END;
END FRECUENCIA;

PROCEDURE INICIO (cJob_name VARCHAR2, cFecha_Inicio VARCHAR2) IS
BEGIN
  BEGIN
    DBMS_SCHEDULER.SET_ATTRIBUTE(
    NAME => cJob_name,
    ATTRIBUTE => 'START_DATE',
   -- VALUE=> cFecha_Inicio||' 06:00:00?');
    VALUE => cFecha_Inicio||' -06:00');

  END ;
END INICIO;

PROCEDURE EJECUTAR (cJob_name VARCHAR2) IS
BEGIN
   BEGIN
      DBMS_SCHEDULER.RUN_JOB(cJob_name, TRUE);
   END;
END EJECUTAR;

PROCEDURE ELIMINAR (cJob_name VARCHAR2) IS
BEGIN

   DBMS_SCHEDULER.DROP_JOB(cJob_name, TRUE);

END ELIMINAR;

END OC_JOB;
/

--
-- OC_JOB  (Synonym) 
--
--  Dependencies: 
--   OC_JOB (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_JOB FOR SICAS_OC.OC_JOB
/


GRANT EXECUTE ON SICAS_OC.OC_JOB TO PUBLIC
/
