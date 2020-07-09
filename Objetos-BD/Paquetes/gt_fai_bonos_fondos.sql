--
-- GT_FAI_BONOS_FONDOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CARGOS_FONDOS (Table)
--   GT_FAI_BONOS_FONDOS_DET (Package)
--   GT_FAI_BONOS_FONDOS_RANGOS (Package)
--   FAI_BONOS_FONDOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_BONOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2);

FUNCTION DESCRIPCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2,
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2, cDescBonoDest VARCHAR2);

FUNCTION SE_PIERDE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2;

FUNCTION MOV_PERDIDA_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2;

END GT_FAI_BONOS_FONDOS;
/

--
-- GT_FAI_BONOS_FONDOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_BONOS_FONDOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_BONOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) IS
BEGIN
   UPDATE FAI_BONOS_FONDOS
      SET StsBono    = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodBono    = cCodBono;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) IS
BEGIN
   UPDATE FAI_BONOS_FONDOS
      SET StsBono    = 'CONFIG',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodBono    = cCodBono;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) IS
BEGIN
   UPDATE FAI_BONOS_FONDOS
      SET StsBono    = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodBono    = cCodBono;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) IS
BEGIN
   UPDATE FAI_BONOS_FONDOS
      SET StsBono    = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodBono    = cCodBono;
END SUSPENDER;

FUNCTION DESCRIPCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2 IS
cDescBono    FAI_BONOS_FONDOS.DescBono%TYPE;
BEGIN
   BEGIN
      SELECT DescBono
        INTO cDescBono
        FROM FAI_BONOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodBono    = cCodBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescBono := 'NO EXISTE';
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración del Fondo: '||cTipoFondo||' y Bono: '||cCodBono);
   END;
   RETURN(cDescBono);
END DESCRIPCION_BONO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2, cDescBonoDest VARCHAR2) IS
CURSOR BONO_Q IS
   SELECT CodBono, DescBono, TipoBono, CptoMovFondo,
          PeriodoBono, StsBono, FecStatus,
          TipoAplic,  IndPierdeBono, MovPerdidaBono
     FROM FAI_BONOS_FONDOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
	   AND CodBono    = cCodBonoOrig;
BEGIN
   FOR X IN BONO_Q LOOP
      BEGIN
         INSERT INTO FAI_BONOS_FONDOS
                (CodCia, CodEmpresa, TipoFondo, CodBono, DescBono, 
                 TipoBono, CptoMovFondo, PeriodoBono, StsBono, 
                 FecStatus, TipoAplic, IndPierdeBono, MovPerdidaBono)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodBonoDest, cDescBonoDest,
                 X.TipoBono, X.CptoMovFondo, X.PeriodoBono, 'CONFIG',
                 TRUNC(SYSDATE),  X.TipoAplic, X.IndPierdeBono, X.MovPerdidaBono);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Bono para Fondo: '||cTipoFondoDest||' y Bono: '||cCodBonoDest);
      END;
   END LOOP;
   
   GT_FAI_BONOS_FONDOS_DET.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, cCodBonoOrig, cCodBonoDest);

   GT_FAI_BONOS_FONDOS_RANGOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, cCodBonoOrig, cCodBonoDest);

END COPIAR;

FUNCTION SE_PIERDE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2 IS
cIndPierdeBono    FAI_BONOS_FONDOS.IndPierdeBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndPierdeBono,'N')
        INTO cIndPierdeBono
        FROM FAI_BONOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodBono    = cCodBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No Existe Código de Bono ' || cCodBono || ' en el Fondo ' || cTipoFondo);
   END;
   RETURN(cIndPierdeBono);
END SE_PIERDE_BONO;

FUNCTION MOV_PERDIDA_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2 IS
cMovPerdidaBono    FAI_BONOS_FONDOS.MovPerdidaBono%TYPE;
BEGIN
   BEGIN
      SELECT MovPerdidaBono
        INTO cMovPerdidaBono
        FROM FAI_BONOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodBono    = cCodBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No existe Código de Bono ' || cCodBono || ' en el Fondo ' || cTipoFondo);
   END;
   IF cMovPerdidaBono IS NULL THEN
      RAISE_APPLICATION_ERROR(-20100,'No existe Movimiento de Pérdida de Bono ' || ' en el Fondo ' || 
                              cTipoFondo || ' y Código de Bono ' || cCodBono);
   END IF;
   RETURN(cMovPerdidaBono);
END MOV_PERDIDA_BONO;

FUNCTION CONCEPTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2) RETURN VARCHAR2 IS
cCptoMovFondo    FAI_CARGOS_FONDOS.CptoMovFondo%TYPE;
BEGIN
   BEGIN
      SELECT CptoMovFondo
        INTO cCptoMovFondo
        FROM FAI_BONOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodBono    = cCodBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCptoMovFondo := NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración Existen Varios Bonos ' || cCodBono || ' en Fondo: '||cTipoFondo);
   END;

   RETURN(cCptoMovFondo);
END CONCEPTO_BONO;

END GT_FAI_BONOS_FONDOS;
/

--
-- GT_FAI_BONOS_FONDOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_BONOS_FONDOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_BONOS_FONDOS FOR SICAS_OC.GT_FAI_BONOS_FONDOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_BONOS_FONDOS TO PUBLIC
/
