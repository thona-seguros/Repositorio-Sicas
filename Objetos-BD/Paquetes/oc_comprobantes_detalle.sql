--
-- OC_COMPROBANTES_DETALLE  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   COMPROBANTES_CONTABLES (Table)
--   COMPROBANTES_DETALLE (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COMPROBANTES_DETALLE IS

  FUNCTION NUM_DETALLE(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER;

  PROCEDURE INSERTA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER, cNivelCta1 VARCHAR2,
                            cNivelCta2 VARCHAR2, cNivelCta3 VARCHAR2, cNivelCta4 VARCHAR2,
                            cNivelCta5 VARCHAR2, cNivelCta6 VARCHAR2, cNivelCta7 VARCHAR2,
                            cNivelAux VARCHAR2, cMovDebCred VARCHAR2, nMtoMovCuenta NUMBER, 
                            cDescMovCuenta VARCHAR2, cCodCentroCosto VARCHAR2,
                            cCodUnidadNegocio VARCHAR2, cDescCptoGeneral VARCHAR2,
                            nMtoMovCuentaLocal NUMBER);

  PROCEDURE REVERSA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER, nNumCompRev NUMBER);

  FUNCTION TOTAL_DEBITOS(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER;

  FUNCTION TOTAL_CREDITOS(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER;

  FUNCTION TOTAL_DEBITOS_LOCAL(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER;

  FUNCTION TOTAL_CREDITOS_LOCAL(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER;

  PROCEDURE ELIMINA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER);

  PROCEDURE ACTUALIZA_FECHA(nCodCia NUMBER, nNumComprob NUMBER, dFecComprob DATE);
  
  FUNCTION SUMA_CUENTAS_CONTABLES(nNumComprob NUMBER,           cNivelCta1 VARCHAR2 := null, cNivelCta2 VARCHAR2 := null,
                                  cNivelCta3  VARCHAR2 := null, cNivelCta4 VARCHAR2 := null, cNivelCta5 VARCHAR2 := null,
                                  cNivelAux   VARCHAR2 := NULL) RETURN NUMBER;

                                    
END OC_COMPROBANTES_DETALLE;
/

--
-- OC_COMPROBANTES_DETALLE  (Package Body) 
--
--  Dependencies: 
--   OC_COMPROBANTES_DETALLE (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_comprobantes_detalle IS
    FUNCTION NUM_DETALLE(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER IS
      nIdDetCuenta    COMPROBANTES_DETALLE.IdDetCuenta%TYPE;
    BEGIN
       SELECT NVL(MAX(IdDetCuenta),0)+1
         INTO nIdDetCuenta
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob;
       RETURN(nIdDetCuenta);
    END NUM_DETALLE;
    PROCEDURE INSERTA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER, cNivelCta1 VARCHAR2,
                              cNivelCta2 VARCHAR2, cNivelCta3 VARCHAR2, cNivelCta4 VARCHAR2,
                              cNivelCta5 VARCHAR2, cNivelCta6 VARCHAR2, cNivelCta7 VARCHAR2, 
                              cNivelAux VARCHAR2, cMovDebCred VARCHAR2, nMtoMovCuenta NUMBER, 
                              cDescMovCuenta VARCHAR2, cCodCentroCosto VARCHAR2,
                              cCodUnidadNegocio VARCHAR2, cDescCptoGeneral VARCHAR2,
                              nMtoMovCuentaLocal NUMBER) IS
    nIdDetCuenta    COMPROBANTES_DETALLE.IdDetCuenta%TYPE;
    BEGIN
       BEGIN
          SELECT IdDetCuenta
            INTO nIdDetCuenta
            FROM COMPROBANTES_DETALLE
           WHERE CodCia           = nCodCia
             AND NumComprob       = nNumComprob
             AND NivelCta1        = cNivelCta1
             AND NivelCta2        = cNivelCta2
             AND NivelCta3        = cNivelCta3
             AND NivelCta4        = cNivelCta4
             AND NivelCta5        = cNivelCta5
             AND NivelCta6        = cNivelCta6
             AND NivelCta7        = cNivelCta7
             AND NivelAux         = cNivelAux
             AND CodCentroCosto   = cCodCentroCosto
             AND CodUnidadNegocio = cCodUnidadNegocio
             AND MovDebCred       = cMovDebCred;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nIdDetCuenta := 0;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20000,'Existe Varios Detalles de la Misma Cuenta en Comprobante '||nNumComprob || ' de Compa?ia ' || nCodCia);
       END;
    
       IF NVL(nIdDetCuenta,0) = 0 THEN
          nIdDetCuenta := OC_COMPROBANTES_DETALLE.NUM_DETALLE(nCodCia, nNumComprob);
    
          BEGIN
             INSERT INTO COMPROBANTES_DETALLE
                    (CodCia, NumComprob, IdDetCuenta, FecDetalle, NivelCta1, NivelCta2, NivelCta3,
                     NivelCta4, NivelCta5, NivelCta6 , NivelCta7, NivelAux, MovDebCred,
                     MtoMovCuenta, DescMovCuenta, CodCentroCosto, CodUnidadNegocio, DescCptoGeneral,
                     MtoMovCuentaLocal)
             VALUES (nCodCia, nNumComprob, nIdDetCuenta, TRUNC(SYSDATE), cNivelCta1, cNivelCta2, cNivelCta3,
                     cNivelCta4, cNivelCta5, cNivelCta6, cNivelCta7, cNivelAux, cMovDebCred,
                     nMtoMovCuenta, cDescMovCuenta, cCodCentroCosto, cCodUnidadNegocio, cDescCptoGeneral,
                     nMtoMovCuentaLocal);
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20000,'Detalle Duplicado de Comprobante '||nNumComprob || ' de Compa?ia ' || nCodCia);
          END;
       ELSE
          BEGIN
             UPDATE COMPROBANTES_DETALLE
                SET MtoMovCuenta      = MtoMovCuenta + nMtoMovCuenta,
                    MtoMovCuentaLocal = MtoMovCuentaLocal + nMtoMovCuentaLocal
              WHERE CodCia            = nCodCia
                AND NumComprob        = nNumComprob
                AND NivelCta1         = cNivelCta1
                AND NivelCta2         = cNivelCta2
                AND NivelCta3         = cNivelCta3
                AND NivelCta4         = cNivelCta4
                AND NivelCta5         = cNivelCta5
                AND NivelCta6         = cNivelCta6
                AND NivelCta7         = cNivelCta7
                AND NivelAux          = cNivelAux
                AND CodCentroCosto    = cCodCentroCosto
                AND CodUnidadNegocio  = cCodUnidadNegocio
                AND MovDebCred        = cMovDebCred;
          END;
       END IF;
    END INSERTA_DETALLE;

    PROCEDURE REVERSA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER, nNumCompRev NUMBER) IS
    cMovDebCred     COMPROBANTES_DETALLE.MovDebCred%TYPE;
    CURSOR DET_Q IS
       SELECT IdDetCuenta, NivelCta1, NivelCta2, NivelCta3, NivelCta4, 
              NivelCta5, NivelCta6, NivelCta7, NivelAux, CodCentroCosto,
              CodUnidadNegocio, MovDebCred, MtoMovCuenta, DescMovCuenta,
              DescCptoGeneral, MtoMovCuentaLocal
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob;
    BEGIN
       FOR X IN DET_Q LOOP
          SELECT DECODE(X.MovDebCred,'D','C','D')
            INTO cMovDebCred
            FROM DUAL;
          OC_COMPROBANTES_DETALLE.INSERTA_DETALLE(nCodCia, nNumCompRev, X.NivelCta1, X.NivelCta2,
                                                  X.NivelCta3, X.NivelCta4, X.NivelCta5,
                                                  X.NivelCta6, X.NivelCta7, X.NivelAux, cMovDebCred, 
                                                  X.MtoMovCuenta, 'REVERSO: ' ||X.DescMovCuenta,
                                                  X.CodCentroCosto, X.CodUnidadNegocio, X.DescCptoGeneral,
                                                  X.MtoMovCuentaLocal);
       END LOOP;
    END REVERSA_DETALLE;

    FUNCTION TOTAL_DEBITOS(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER IS
      nTotDebitos     COMPROBANTES_CONTABLES.TotalDebitos%TYPE;
    BEGIN
       SELECT NVL(SUM(MtoMovCuenta),0)
         INTO nTotDebitos
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob
          AND MovDebCred = 'D';
    
       RETURN(nTotDebitos);
    END TOTAL_DEBITOS;
    
    FUNCTION TOTAL_CREDITOS(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER IS
      nTotCreditos     COMPROBANTES_CONTABLES.TotalCreditos%TYPE;
    BEGIN
       SELECT NVL(SUM(MtoMovCuenta),0)
         INTO nTotCreditos
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob
          AND MovDebCred = 'C';
    
       RETURN(nTotCreditos);
    END TOTAL_CREDITOS;
    
    FUNCTION TOTAL_DEBITOS_LOCAL(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER IS
      nTotDebitos     COMPROBANTES_CONTABLES.TotalDebitos%TYPE;
    BEGIN
       SELECT NVL(SUM(MtoMovCuentaLocal),0)
         INTO nTotDebitos
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob
          AND MovDebCred = 'D';
    
       RETURN(nTotDebitos);
    END TOTAL_DEBITOS_LOCAL;

    FUNCTION TOTAL_CREDITOS_LOCAL(nCodCia NUMBER, nNumComprob NUMBER) RETURN NUMBER IS
      nTotCreditos     COMPROBANTES_CONTABLES.TotalCreditos%TYPE;
    BEGIN
       SELECT NVL(SUM(MtoMovCuentaLocal),0)
         INTO nTotCreditos
         FROM COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob
          AND MovDebCred = 'C';
    
       RETURN(nTotCreditos);
    END TOTAL_CREDITOS_LOCAL;

    PROCEDURE ELIMINA_DETALLE(nCodCia NUMBER, nNumComprob NUMBER) IS
    BEGIN
    
       DELETE COMPROBANTES_DETALLE
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob;
    
    END ELIMINA_DETALLE;

    PROCEDURE ACTUALIZA_FECHA(nCodCia NUMBER, nNumComprob NUMBER, dFecComprob DATE) IS
    BEGIN
       UPDATE COMPROBANTES_DETALLE
          SET FecDetalle = TRUNC(dFecComprob)
        WHERE CodCia     = nCodCia
          AND NumComprob = nNumComprob;
    END ACTUALIZA_FECHA;

    FUNCTION SUMA_CUENTAS_CONTABLES(nNumComprob NUMBER,           cNivelCta1 VARCHAR2 := null, cNivelCta2 VARCHAR2 := null,
                                    cNivelCta3  VARCHAR2 := null, cNivelCta4 VARCHAR2 := null, cNivelCta5 VARCHAR2 := null,
                                    cNivelAux   VARCHAR2 := NULL) RETURN NUMBER IS
        nTotCuenta        COMPROBANTES_DETALLE.MtoMovCuenta%TYPE;
    BEGIN
        SELECT nvl(abs(SUM(DECODE(D.MovDebCred, 'D', nvl(D.MtoMovCuenta,0), (nvl(D.MtoMovCuenta,0) * -1)))),0)
          INTO nTotCuenta
          FROM COMPROBANTES_DETALLE D
         WHERE D.NumComprob    = nNumComprob
           AND NVL(NivelCta1,0)     = NVL(cNivelCta1, NVL(NivelCta1,0))          
           AND NVL(NivelCta2,0)     = NVL(cNivelCta2, NVL(NivelCta2,0))
           AND NVL(NivelCta3,0)     = NVL(cNivelCta3, NVL(NivelCta3,0))
           AND NVL(NivelCta4,0)     = NVL(cNivelCta4, NVL(NivelCta4,0))
           AND NVL(NivelCta5,0)     = NVL(cNivelCta5, NVL(NivelCta5,0))
           AND NVL(NivelAux,0)      = NVL(cNivelAux,  NVL(NivelAux,0));
        RETURN(nTotCuenta);
    END;    
END OC_COMPROBANTES_DETALLE;
/

--
-- OC_COMPROBANTES_DETALLE  (Synonym) 
--
--  Dependencies: 
--   OC_COMPROBANTES_DETALLE (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_COMPROBANTES_DETALLE FOR SICAS_OC.OC_COMPROBANTES_DETALLE
/


GRANT EXECUTE ON SICAS_OC.OC_COMPROBANTES_DETALLE TO PUBLIC
/
