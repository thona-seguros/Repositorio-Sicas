--
-- OC_COMPROBANTES_DETALLE_RES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   COMPROBANTES_CONTABLES (Table)
--   COMPROBANTES_DETALLE (Table)
--   OC_COMPROBANTES_DETALLE (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COMPROBANTES_DETALLE_RES IS

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

END OC_COMPROBANTES_DETALLE_RES;
/

--
-- OC_COMPROBANTES_DETALLE_RES  (Package Body) 
--
--  Dependencies: 
--   OC_COMPROBANTES_DETALLE_RES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_comprobantes_detalle_RES IS

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
DBMS_OUTPUT.PUT_LINE('OC_COMPROBANTES_DETALLE');  
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
DBMS_OUTPUT.PUT_LINE('PASO OCCD 1');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdDetCuenta := 0;
DBMS_OUTPUT.PUT_LINE('PASO OCCD 2');
      WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('PASO OCCD 18');
         RAISE_APPLICATION_ERROR(-20000,'Existe Varios Detalles de la Misma Cuenta en Comprobante '||nNumComprob || ' de Compa?ia ' || nCodCia);
   END;
DBMS_OUTPUT.PUT_LINE('PASO OCCD 3');

   IF NVL(nIdDetCuenta,0) = 0 THEN
DBMS_OUTPUT.PUT_LINE('PASO OCCD 4');
      nIdDetCuenta := OC_COMPROBANTES_DETALLE.NUM_DETALLE(nCodCia, nNumComprob);
DBMS_OUTPUT.PUT_LINE('PASO OCCD 5');

      BEGIN
DBMS_OUTPUT.PUT_LINE('PASO OCCD 6');
DBMS_OUTPUT.PUT_LINE('  nCodCia            -> '||nCodCia);
DBMS_OUTPUT.PUT_LINE('  nNumComprob        -> '||nNumComprob);
DBMS_OUTPUT.PUT_LINE('  nIdDetCuenta       -> '||nIdDetCuenta);
DBMS_OUTPUT.PUT_LINE('  cNivelCta1         -> '||cNivelCta1);
DBMS_OUTPUT.PUT_LINE('  cNivelCta2         -> '||cNivelCta2);
DBMS_OUTPUT.PUT_LINE('  cNivelCta3         -> '||cNivelCta3);
DBMS_OUTPUT.PUT_LINE('  cNivelCta4         -> '||cNivelCta4);
DBMS_OUTPUT.PUT_LINE('  cNivelCta5         -> '||cNivelCta5);
DBMS_OUTPUT.PUT_LINE('  cNivelCta6         -> '||cNivelCta6);
DBMS_OUTPUT.PUT_LINE('  cNivelCta7         -> '||cNivelCta7);
DBMS_OUTPUT.PUT_LINE('  cNivelAux          -> '||cNivelAux);
DBMS_OUTPUT.PUT_LINE('  cMovDebCred        -> '||cMovDebCred);
DBMS_OUTPUT.PUT_LINE('  nMtoMovCuenta      -> '||nMtoMovCuenta);
DBMS_OUTPUT.PUT_LINE('  cDescMovCuenta     -> '||cDescMovCuenta);
DBMS_OUTPUT.PUT_LINE('  cCodCentroCosto    -> '||cCodCentroCosto);
DBMS_OUTPUT.PUT_LINE('  cCodUnidadNegocio  -> '||cCodUnidadNegocio);
DBMS_OUTPUT.PUT_LINE('  cDescCptoGeneral   -> '||cDescCptoGeneral);
DBMS_OUTPUT.PUT_LINE('  nMtoMovCuentaLocal -> '||nMtoMovCuentaLocal);
 
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
DBMS_OUTPUT.PUT_LINE('PASO OCCD 7');
   ELSE
DBMS_OUTPUT.PUT_LINE('PASO OCCD 8');
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
DBMS_OUTPUT.PUT_LINE('PASO OCCD 9');
      END;
DBMS_OUTPUT.PUT_LINE('PASO OCCD 10');
   END IF;
DBMS_OUTPUT.PUT_LINE('PASO OCCD 11');
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

END OC_COMPROBANTES_DETALLE_RES;
/
