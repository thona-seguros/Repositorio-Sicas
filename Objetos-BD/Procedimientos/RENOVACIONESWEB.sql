PROCEDURE          RENOVACIONESWEB IS
   nCodCia        NUMBER := 1;
   nCodEmpresa    NUMBER := 1;
   dFecEjecucion  DATE   := TRUNC(SYSDATE);
BEGIN
   IF TO_NUMBER(TO_CHAR(dFecEjecucion, 'DD')) IN (1, 15) THEN
      OC_RENOVACION.SELECCIONAR_POLIZAS(nCodCia, nCodEmpresa, dFecEjecucion );
      OC_RENOVACION.APLICAR_CRITERIOS_RENOVACION(nCodCia, nCodEmpresa, dFecEjecucion );
      --COMMIT;
      --DBMS_OUTPUT.PUT_LINE(dFecEjecucion);
   END IF;
END RENOVACIONESWEB;
