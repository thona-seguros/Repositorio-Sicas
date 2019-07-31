--
-- GT_FAI_BONOS_FONDOS_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_BONOS_FONDOS_DET (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_BONOS_FONDOS_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2);

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                      cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN VARCHAR2;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN VARCHAR2;

FUNCTION PORCENTAJE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                         cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN NUMBER;

FUNCTION MONTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                    cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN NUMBER;

END GT_FAI_BONOS_FONDOS_DET;
/

--
-- GT_FAI_BONOS_FONDOS_DET  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_BONOS_FONDOS_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_BONOS_FONDOS_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2) IS 

CURSOR DET_BONO_Q IS
   SELECT CodBono, FecIniBono, FecFinBono, AnioBono,
          PorcBono, TipoInteres, CodRutinaCalc
     FROM FAI_BONOS_FONDOS_DET
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodBono    = cCodBonoOrig;
BEGIN
   -- Inserta Detalles del Bono 
   FOR Y IN DET_BONO_Q LOOP
      BEGIN
         INSERT INTO FAI_BONOS_FONDOS_DET
                (CodCia, CodEmpresa, TipoFondo, CodBono, FecIniBono, FecFinBono,
                 AnioBono, PorcBono, TipoInteres, CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodBonoDest, Y.FecIniBono, Y.FecFinBono,
                 Y.AnioBono, Y.PorcBono, Y.TipoInteres, Y.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Detalle de Bono para Fondo: '||cTipoFondoDest||' y Bono: '||cCodBonoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                      cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN VARCHAR2 IS
cTipoInteres   FAI_BONOS_FONDOS_DET.TipoInteres%TYPE;
BEGIN
   BEGIN
      SELECT TipoInteres
        INTO cTipoInteres
        FROM FAI_BONOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodBono       = cCodBono
         AND AnioBono      = nAnioBono
         AND FecIniBono   >= dFecBono
         AND FecFinBono   <= dFecBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoInteres := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Tipo de Interes del Bono para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(cTipoInteres);
END TIPO_INTERES;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN VARCHAR2 IS
cCodRutinaCalc   FAI_BONOS_FONDOS_DET.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_BONOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodBono       = cCodBono
         AND AnioBono      = nAnioBono
         AND FecIniBono   >= dFecBono
         AND FecFinBono   <= dFecBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodRutinaCalc := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Rutina de Cálculo del Bono para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION PORCENTAJE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                         cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN NUMBER IS
nPorcBono     FAI_BONOS_FONDOS_DET.PorcBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcBono,0)
        INTO nPorcBono
        FROM FAI_BONOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodBono       = cCodBono
         AND AnioBono      = nAnioBono
         AND FecIniBono   >= dFecBono
         AND FecFinBono   <= dFecBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcBono := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Bono para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(nPorcBono);
END PORCENTAJE_BONO;

FUNCTION MONTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                    cCodBono VARCHAR2, nAnioBono NUMBER, dFecBono DATE) RETURN NUMBER IS
nMontoBono     FAI_BONOS_FONDOS_DET.MontoBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoBono,0)
        INTO nMontoBono
        FROM FAI_BONOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodBono       = cCodBono
         AND AnioBono      = nAnioBono
         AND FecIniBono   >= dFecBono
         AND FecFinBono   <= dFecBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoBono := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Monto del Bono para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(nMontoBono);
END MONTO_BONO;

END GT_FAI_BONOS_FONDOS_DET;
/
