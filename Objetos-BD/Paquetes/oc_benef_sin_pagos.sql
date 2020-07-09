--
-- OC_BENEF_SIN_PAGOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   BENEF_SIN_PAGOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_BENEF_SIN_PAGOS IS

  PROCEDURE INSERTA(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                    nNum_Aprobacion NUMBER, nIdDetSin NUMBER);

  PROCEDURE PAGADO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                   nNum_Aprobacion NUMBER, nIdDetSin NUMBER);

  PROCEDURE ANULAR(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                   nNum_Aprobacion NUMBER, nIdDetSin NUMBER);

  PROCEDURE REVERTIR(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                     nNum_Aprobacion NUMBER, nIdDetSin NUMBER);
				   
END OC_BENEF_SIN_PAGOS;
/

--
-- OC_BENEF_SIN_PAGOS  (Package Body) 
--
--  Dependencies: 
--   OC_BENEF_SIN_PAGOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_BENEF_SIN_PAGOS IS

  PROCEDURE INSERTA(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                    nNum_Aprobacion NUMBER, nIdDetSin NUMBER) IS
  BEGIN
    BEGIN
      INSERT INTO BENEF_SIN_PAGOS
            (IdSiniestro, IdPoliza, Benef, Num_Aprobacion,
             IdDetSin, StsPago, FecSts)
      VALUES (nIdSiniestro, nIdPoliza, nBenef, nNum_Aprobacion,
              nIdDetSin, 'PENPAG', SYSDATE);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'INSERCION BEFEF_SIN_PAGOS - Ocurrió el siguiente error: '||SQLERRM);
    END;
  END INSERTA;

  PROCEDURE PAGADO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                   nNum_Aprobacion NUMBER, nIdDetSin NUMBER) IS
  BEGIN
    UPDATE BENEF_SIN_PAGOS
       SET StsPago = 'PAGADO',
           FecSts  = SYSDATE
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND Benef          = nBenef
       AND Num_Aprobacion = nNum_Aprobacion
       AND IdDetSin       = nIdDetSin;
  END PAGADO;

  PROCEDURE ANULAR(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                   nNum_Aprobacion NUMBER, nIdDetSin NUMBER) IS
  BEGIN
    UPDATE BENEF_SIN_PAGOS
       SET StsPago = 'ANULAR',
           FecSts  = SYSDATE
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND Benef          = nBenef
       AND Num_Aprobacion = nNum_Aprobacion
       AND IdDetSin       = nIdDetSin;
  END ANULAR;

  PROCEDURE REVERTIR(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nBenef NUMBER,
                     nNum_Aprobacion NUMBER, nIdDetSin NUMBER) IS
  BEGIN
    DELETE FROM BENEF_SIN_PAGOS
	 WHERE IdSiniestro    = nIdSiniestro
	   AND IdPoliza       = nIdPoliza
	   AND Benef          = nBenef
	   AND Num_Aprobacion = nNum_Aprobacion
	   AND IdDetSin       = nIdDetSin;
  END REVERTIR;

END OC_BENEF_SIN_PAGOS;
/

--
-- OC_BENEF_SIN_PAGOS  (Synonym) 
--
--  Dependencies: 
--   OC_BENEF_SIN_PAGOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_BENEF_SIN_PAGOS FOR SICAS_OC.OC_BENEF_SIN_PAGOS
/


GRANT EXECUTE ON SICAS_OC.OC_BENEF_SIN_PAGOS TO PUBLIC
/
