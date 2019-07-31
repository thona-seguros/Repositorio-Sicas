--
-- OC_CONDICIONES_GENERALES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   POLIZAS (Table)
--   REGISTRO_TIPSEG_AUTORIDAD (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONDICIONES_GENERALES IS

FUNCTION NOMBRE_ARCHIVO(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN VARCHAR2;

END OC_CONDICIONES_GENERALES;
/

--
-- OC_CONDICIONES_GENERALES  (Package Body) 
--
--  Dependencies: 
--   OC_CONDICIONES_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONDICIONES_GENERALES IS

FUNCTION NOMBRE_ARCHIVO(cIdTipoSeg VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniVig DATE, dFecEmiVig DATE) RETURN VARCHAR2 IS
--
WDS_ARCH_CONGEN   REGISTRO_TIPSEG_AUTORIDAD.DS_ARCH_CONGEN%TYPE;
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
         WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO NDS';
    WHEN OTHERS THEN
         WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO OS';
  END;  
  --
  IF WFECMINIMO < WFECSUSPEN THEN 
     IF dFecEmiVig > WFECSUSPEN THEN 
        BEGIN
          SELECT DS_ARCH_CONGEN
            INTO WDS_ARCH_CONGEN
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
               WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO ND1';
          WHEN OTHERS THEN
               WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO O1';
        END;
     ELSE
        BEGIN
           SELECT DS_ARCH_CONGEN
             INTO WDS_ARCH_CONGEN
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
               WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO ND2';
          WHEN TOO_MANY_ROWS THEN
               BEGIN
                 SELECT DS_ARCH_CONGEN
                   INTO WDS_ARCH_CONGEN
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
                      WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO ND21';
                 WHEN OTHERS THEN
                      WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO O21';
                 END;
          WHEN OTHERS THEN
               WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO O2';
        END;
     END IF;
  ELSE
     BEGIN
       SELECT DS_ARCH_CONGEN
         INTO WDS_ARCH_CONGEN
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
            WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO ND3';
       WHEN OTHERS THEN
            WDS_ARCH_CONGEN := 'NO EXISTE REGISTRO O3';
     END;
  END IF;
  --
  RETURN(WDS_ARCH_CONGEN);
END NOMBRE_ARCHIVO;

END OC_CONDICIONES_GENERALES;
/
