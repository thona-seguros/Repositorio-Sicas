--
-- OC_REGISTRO_TIPSEG_AUTORIDAD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   POLIZAS (Table)
--   REGISTRO_TIPSEG_AUTORIDAD (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_REGISTRO_TIPSEG_AUTORIDAD AS

FUNCTION NUMERO_AUTORIZACION(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN VARCHAR2;

FUNCTION  FECHA_AUTORIZACION(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN DATE;

END OC_REGISTRO_TIPSEG_AUTORIDAD;
/

--
-- OC_REGISTRO_TIPSEG_AUTORIDAD  (Package Body) 
--
--  Dependencies: 
--   OC_REGISTRO_TIPSEG_AUTORIDAD (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REGISTRO_TIPSEG_AUTORIDAD AS
FUNCTION NUMERO_AUTORIZACION(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN VARCHAR2 IS
--
cNumAutorTipSeg   REGISTRO_TIPSEG_AUTORIDAD.NumAutorTipSeg%TYPE;
--
WFECMINIMO   POLIZAS.FECEMISION%TYPE;
WFECSUSPEN   POLIZAS.FECEMISION%TYPE;
--
BEGIN
  --
  IF dFecIniVig <= dFecEmiVig THEN
     WFECMINIMO := dFecIniVig;
  ELSE
     WFECMINIMO := dFecEmiVig;
  END IF;
  --
  -- FECHA DE SUSPECION
  --
  BEGIN
    SELECT A.FEC_SUSPENCION
      INTO WFECSUSPEN
      FROM REGISTRO_TIPSEG_AUTORIDAD A
     WHERE IdTipoSeg   = cIdTipoSeg
       AND CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND fecregistro IN (SELECT MAX(A.fecregistro)
                             FROM REGISTRO_TIPSEG_AUTORIDAD A
                            WHERE A.IdTipoSeg   = cIdTipoSeg
                              AND A.CodCia      = nCodCia
                              AND A.CodEmpresa  = nCodEmpresa
                              AND A.fecregistro <= TRUNC(WFECMINIMO)
                              AND A.STREGISTRO  = 'SUS')
       AND STREGISTRO  = 'SUS';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         cNumAutorTipSeg := 'NO EXISTE REGISTRO NDS';
    WHEN OTHERS THEN
         cNumAutorTipSeg := 'NO EXISTE REGISTRO OS';
  END;  
  --
  IF WFECMINIMO < WFECSUSPEN THEN 
     IF dFecEmiVig > WFECSUSPEN THEN 
        BEGIN
          SELECT NumAutorTipSeg
            INTO cNumAutorTipSeg
            FROM REGISTRO_TIPSEG_AUTORIDAD
           WHERE IdTipoSeg   = cIdTipoSeg
             AND CodCia      = nCodCia
             AND CodEmpresa  = nCodEmpresa
             AND fecregistro IN (SELECT MIN(A.fecregistro)
                                   FROM REGISTRO_TIPSEG_AUTORIDAD A
                                  WHERE A.IdTipoSeg   = cIdTipoSeg
                                    AND A.CodCia      = nCodCia
                                    AND A.CodEmpresa  = nCodEmpresa
                                    AND A.fecregistro <= TRUNC(WFECMINIMO)
                                    AND A.STREGISTRO  = 'APRO')
          AND STREGISTRO  = 'APRO';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               cNumAutorTipSeg := 'NO EXISTE REGISTRO ND1';
          WHEN OTHERS THEN
               cNumAutorTipSeg := 'NO EXISTE REGISTRO O1';
        END;
     ELSE
        BEGIN
           SELECT NumAutorTipSeg
             INTO cNumAutorTipSeg
             FROM REGISTRO_TIPSEG_AUTORIDAD
            WHERE IdTipoSeg   = cIdTipoSeg
              AND CodCia      = nCodCia
              AND CodEmpresa  = nCodEmpresa
              AND fecregistro IN (SELECT MAX(A.fecregistro)
                                    FROM REGISTRO_TIPSEG_AUTORIDAD A
                                   WHERE A.IdTipoSeg   = cIdTipoSeg
                                     AND A.CodCia      = nCodCia
                                     AND A.CodEmpresa  = nCodEmpresa
                                     AND A.fecregistro <= TRUNC(WFECMINIMO));
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               cNumAutorTipSeg := 'NO EXISTE REGISTRO ND2';
          WHEN TOO_MANY_ROWS THEN
               BEGIN
                 SELECT NumAutorTipSeg
                   INTO cNumAutorTipSeg
                   FROM REGISTRO_TIPSEG_AUTORIDAD
                  WHERE IdTipoSeg   = cIdTipoSeg
                    AND CodCia      = nCodCia
                    AND CodEmpresa  = nCodEmpresa
                    AND (fecregistro,NUMREGISTRO) IN (SELECT MAX(A.fecregistro),
                                               MAX(A.NUMREGISTRO)
                                          FROM REGISTRO_TIPSEG_AUTORIDAD A
                                         WHERE A.IdTipoSeg   = cIdTipoSeg
                                           AND A.CodCia      = nCodCia
                                           AND A.CodEmpresa  = nCodEmpresa
                                           AND A.fecregistro <= TRUNC(WFECMINIMO));
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      cNumAutorTipSeg := 'NO EXISTE REGISTRO ND21';
                 WHEN OTHERS THEN
                      cNumAutorTipSeg := 'NO EXISTE REGISTRO O21';
                 END;
          WHEN OTHERS THEN
               cNumAutorTipSeg := 'NO EXISTE REGISTRO O2';
        END;
     END IF;
  ELSE
     BEGIN
       SELECT NumAutorTipSeg
         INTO cNumAutorTipSeg
         FROM REGISTRO_TIPSEG_AUTORIDAD
        WHERE IdTipoSeg   = cIdTipoSeg
          AND CodCia      = nCodCia
          AND CodEmpresa  = nCodEmpresa
          AND fecregistro IN (SELECT MAX(A.fecregistro)
                                FROM REGISTRO_TIPSEG_AUTORIDAD A
                               WHERE A.IdTipoSeg   = cIdTipoSeg
                                 AND A.CodCia      = nCodCia
                                 AND A.CodEmpresa  = nCodEmpresa
                                 AND A.fecregistro <= TRUNC(WFECMINIMO)
                                 AND A.STREGISTRO  = 'APRO')
          AND STREGISTRO  = 'APRO';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            cNumAutorTipSeg := 'NO EXISTE REGISTRO ND3';
       WHEN OTHERS THEN
            cNumAutorTipSeg := 'NO EXISTE REGISTRO O3';
     END;
  END IF;
  --
  RETURN(cNumAutorTipSeg);
END NUMERO_AUTORIZACION;

FUNCTION FECHA_AUTORIZACION(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN DATE IS
--
dFecRegistro   REGISTRO_TIPSEG_AUTORIDAD.FecRegistro%TYPE;
--
WFECMINIMO   POLIZAS.FECEMISION%TYPE;
WFECSUSPEN   POLIZAS.FECEMISION%TYPE;
--
BEGIN
  --
  IF dFecIniVig <= dFecEmiVig THEN
     WFECMINIMO := dFecIniVig;
  ELSE
     WFECMINIMO := dFecEmiVig;
  END IF;
  --
  -- FECHA DE SUSPECION
  --
  BEGIN
    SELECT A.FEC_SUSPENCION
      INTO WFECSUSPEN
      FROM REGISTRO_TIPSEG_AUTORIDAD A
     WHERE IdTipoSeg   = cIdTipoSeg
       AND CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND fecregistro IN (SELECT MAX(A.fecregistro)
                             FROM REGISTRO_TIPSEG_AUTORIDAD A
                            WHERE A.IdTipoSeg   = cIdTipoSeg
                              AND A.CodCia      = nCodCia
                              AND A.CodEmpresa  = nCodEmpresa
                              AND A.fecregistro <= TRUNC(WFECMINIMO)
                              AND A.STREGISTRO  = 'SUS')
       AND STREGISTRO  = 'SUS';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         --cNumAutorTipSeg := 'NO EXISTE FECHA NDS';
         dFecRegistro := NULL;
    WHEN OTHERS THEN
         --cNumAutorTipSeg := 'NO EXISTE FECHA OS';
         dFecRegistro := NULL;
  END;  
  --
  IF WFECMINIMO < WFECSUSPEN THEN 
     IF dFecEmiVig > WFECSUSPEN THEN 
        BEGIN
          SELECT fecregistro
            INTO dFecRegistro
            FROM REGISTRO_TIPSEG_AUTORIDAD
           WHERE IdTipoSeg   = cIdTipoSeg
             AND CodCia      = nCodCia
             AND CodEmpresa  = nCodEmpresa
             AND fecregistro IN (SELECT MIN(A.fecregistro)
                                   FROM REGISTRO_TIPSEG_AUTORIDAD A
                                  WHERE A.IdTipoSeg   = cIdTipoSeg
                                    AND A.CodCia      = nCodCia
                                    AND A.CodEmpresa  = nCodEmpresa
                                    AND A.fecregistro <= TRUNC(WFECMINIMO)
                                    AND A.STREGISTRO  = 'APRO')
          AND STREGISTRO  = 'APRO';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               --cNumAutorTipSeg := 'NO EXISTE FECHA ND1';
               dFecRegistro := NULL;
          WHEN OTHERS THEN
               --cNumAutorTipSeg := 'NO EXISTE FECHA O1';
               dFecRegistro := NULL;
        END;
     ELSE
        BEGIN
           SELECT fecregistro
             INTO dFecRegistro
             FROM REGISTRO_TIPSEG_AUTORIDAD
            WHERE IdTipoSeg   = cIdTipoSeg
              AND CodCia      = nCodCia
              AND CodEmpresa  = nCodEmpresa
              AND fecregistro IN (SELECT MAX(A.fecregistro)
                                    FROM REGISTRO_TIPSEG_AUTORIDAD A
                                   WHERE A.IdTipoSeg   = cIdTipoSeg
                                     AND A.CodCia      = nCodCia
                                     AND A.CodEmpresa  = nCodEmpresa
                                     AND A.fecregistro <= TRUNC(WFECMINIMO));
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               --cNumAutorTipSeg := 'NO EXISTE FECHA ND2';
               dFecRegistro := NULL;
          WHEN TOO_MANY_ROWS THEN
               BEGIN
                 SELECT fecregistro
                   INTO dFecRegistro
                   FROM REGISTRO_TIPSEG_AUTORIDAD
                  WHERE IdTipoSeg   = cIdTipoSeg
                    AND CodCia      = nCodCia
                    AND CodEmpresa  = nCodEmpresa
                    AND (fecregistro,NUMREGISTRO) IN (SELECT MAX(A.fecregistro),
                                               MAX(A.NUMREGISTRO)
                                          FROM REGISTRO_TIPSEG_AUTORIDAD A
                                         WHERE A.IdTipoSeg   = cIdTipoSeg
                                           AND A.CodCia      = nCodCia
                                           AND A.CodEmpresa  = nCodEmpresa
                                           AND A.fecregistro <= TRUNC(WFECMINIMO));
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      --cNumAutorTipSeg := 'NO EXISTE FECHA ND21';
                      dFecRegistro := NULL;
                 WHEN OTHERS THEN
                      --cNumAutorTipSeg := 'NO EXISTE FECHA O21';
                      dFecRegistro := NULL;
                 END;
          WHEN OTHERS THEN
               --cNumAutorTipSeg := 'NO EXISTE REGISTRO O2';
               dFecRegistro := NULL;
        END;
     END IF;
  ELSE
     BEGIN
       SELECT fecregistro
         INTO dFecRegistro
         FROM REGISTRO_TIPSEG_AUTORIDAD
        WHERE IdTipoSeg   = cIdTipoSeg
          AND CodCia      = nCodCia
          AND CodEmpresa  = nCodEmpresa
          AND fecregistro IN (SELECT MAX(A.fecregistro)
                                FROM REGISTRO_TIPSEG_AUTORIDAD A
                               WHERE A.IdTipoSeg   = cIdTipoSeg
                                 AND A.CodCia      = nCodCia
                                 AND A.CodEmpresa  = nCodEmpresa
                                 AND A.fecregistro <= TRUNC(WFECMINIMO)
                                 AND A.STREGISTRO  = 'APRO')
          AND STREGISTRO  = 'APRO';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            --cNumAutorTipSeg := 'NO EXISTE FECHA ND3';
            dFecRegistro := NULL;
       WHEN OTHERS THEN
            --cNumAutorTipSeg := 'NO EXISTE V O3';
            dFecRegistro := NULL;
     END;
  END IF;
  --
  RETURN(dFecRegistro);
END FECHA_AUTORIZACION;

END OC_REGISTRO_TIPSEG_AUTORIDAD;
/
