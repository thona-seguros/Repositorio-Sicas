PROCEDURE GRABA_TIEMPO
   (P_PROCESO       NUMBER,
    P_IDPROCMASIVO  NUMBER,
    P_PROGRAMA      VARCHAR2,
    P_PASO          NUMBER,
    P_EXTRA         VARCHAR2)
    IS
BEGIN
  INSERT INTO MONITOR
   (PROCESO,
    IDPROCMASIVO,
    PROGRAMA,
    PASO,
    TIEMPO,
    FECHA,
    EXTRA)
  VALUES
   (P_PROCESO,
    P_IDPROCMASIVO,
    P_PROGRAMA,
    P_PASO,
    CURRENT_TIMESTAMP,
    SYSDATE,
    P_EXTRA
   );
  --
END;