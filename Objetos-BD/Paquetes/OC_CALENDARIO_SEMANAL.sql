CREATE OR REPLACE PACKAGE OC_CALENDARIO_SEMANAL IS

  FUNCTION SEMANA(dFecSemana DATE) RETURN NUMBER;

  PROCEDURE GENERAR_CALENDARIO(dFecIniSemana DATE, nAnioSemana NUMBER);
  
END OC_CALENDARIO_SEMANAL;
/

CREATE OR REPLACE PACKAGE BODY OC_CALENDARIO_SEMANAL IS

FUNCTION SEMANA(dFecSemana DATE) RETURN NUMBER IS
nIdSemana   CALENDARIO_SEMANAL.IdSemana%TYPE;
BEGIN
   BEGIN
      SELECT IdSemana
        INTO nIdSemana
        FROM CALENDARIO_SEMANAL
       WHERE FecIniSemana <= dFecSemana
         AND FecFinSemana >= dFecSemana;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No Existe Configuracion de Calendario Semanal para Fecha '||TO_CHAR(dFecSemana,'DD/MM/YYYY'));
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Existe Configuradas Varias Semanas para la Fecha '||TO_CHAR(dFecSemana,'DD/MM/YYYY'));
   END;
   RETURN(nIdSemana);
END SEMANA;

PROCEDURE GENERAR_CALENDARIO(dFecIniSemana DATE, nAnioSemana NUMBER) IS
nAnioSemIni   NUMBER(4);
nAnioSemFin   NUMBER(4);
dFecIniSem    DATE;
dFecIniCal    DATE;
dFecFinCal    DATE;
nContador     NUMBER(10);
nIdSemana     CALENDARIO_SEMANAL.IdSemana%TYPE;
nVerifica     NUMBER(10);

BEGIN
   nContador  := 0;
   dFecIniSem := dFecIniSemana;
   IF TRIM(TO_CHAR(dFecIniSemana,'DAY')) IN ('LUNES','MONDAY') AND
      (TO_NUMBER(TO_CHAR(dFecIniSemana+6,'YYYYMMDD')) >= TO_NUMBER(nAnioSemana||'0101') AND
       TO_NUMBER(TO_CHAR(dFecIniSemana,'YYYYMMDD')) <= TO_NUMBER(nAnioSemana||'0107')) THEN
      LOOP
         nContador   := nContador+1;
         dFecIniCal  := dFecIniSem;
         dFecFinCal  := dFecIniCal+6;
         nAnioSemIni := TO_NUMBER(TO_CHAR(dFecIniCal,'YYYY'));
         nAnioSemFin := TO_NUMBER(TO_CHAR(dFecFinCal,'YYYY'));
         --
         nIdSemana   := nAnioSemana||LPAD(nContador,2,'0');
         --
         BEGIN
            SELECT COUNT(*)
              INTO nVerifica
              FROM CALENDARIO_SEMANAL
             WHERE IdSemana = nIdSemana;
         END;
         --
         IF nVerifica = 0 THEN
            INSERT INTO CALENDARIO_SEMANAL
                   (IdSemana, FecIniSemana, FecFinSemana, AnioSemana, NumSemana)
            VALUES (nIdSemana, dFecIniCal, dFecFinCal, nAnioSemIni, nContador);
         ELSE
            RAISE_APPLICATION_ERROR(-20100,'Semana '||TO_CHAR(nIdSemana) || ' Ya Existe en el Calendario Semanal ');
         END IF;
         --
         dFecIniSem := dFecFinCal+1;
         --
         EXIT WHEN nAnioSemFin > nAnioSemana;
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR(-20100,'La Fecha Inicial NO es Dia LUNES o la Fecha No Coincide con la Primer Semana del A?o '||TRIM(TO_CHAR(nAnioSemana)));
   END IF;
END GENERAR_CALENDARIO;

END OC_CALENDARIO_SEMANAL;
