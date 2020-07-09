--
-- GT_FAI_MOVIMIENTOS_FONDOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_EMAIL_MOVIMIENTO_FONDO (Table)
--   FAI_MOVIMIENTOS_FONDOS (Table)
--   GT_FAI_EMAIL_MOVIMIENTO_FONDO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_MOVIMIENTOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, 
                 cTipoFondoDest VARCHAR2, cCodCptoMovOrig VARCHAR2, cCodCptoMovDest VARCHAR2);

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2, cTipoIndic VARCHAR2) RETURN VARCHAR2;

FUNCTION TIPO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CONCEPTO_IMPUESTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2;

FUNCTION CANTIDAD_POR_ANIO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN NUMBER;

END GT_FAI_MOVIMIENTOS_FONDOS;
/

--
-- GT_FAI_MOVIMIENTOS_FONDOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_MOVIMIENTOS_FONDOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_MOVIMIENTOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'CONFIG';
BEGIN
   UPDATE FAI_MOVIMIENTOS_FONDOS
      SET StsMovFondo = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'ACTIVO';
BEGIN
   UPDATE FAI_MOVIMIENTOS_FONDOS
      SET StsMovFondo = 'CONFIG',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'SUSPEN';
BEGIN
   UPDATE FAI_MOVIMIENTOS_FONDOS
      SET StsMovFondo = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'ACTIVO';
BEGIN
   UPDATE FAI_MOVIMIENTOS_FONDOS
      SET StsMovFondo = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END SUSPENDER;


PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, 
                 cTipoFondoDest VARCHAR2, cCodCptoMovOrig VARCHAR2, cCodCptoMovDest VARCHAR2) IS
CURSOR MOV_Q IS
   SELECT TipoMov, IndAutomatico, StsMovFondo, FecStatus, CantTransac, MtoMinimo,
          MtoMaximo, PorcCptoMov, IndAplicaCargo, CodCargo, IndAplicaBono,
          CodBono, IndComision, IndIncentivo, IndGenContab, NomRepMov, CodRutinaCalc, 
          IndAplicaRet, CodCptoRet, IndAcumMovAsoc, IndReverso, CptoMovRev, 
          IndNoAplicaSaldo, IndAplicaAjuste, CodCptoAju, IndEnviaEmail, IndImpuesto,
          CodImpuesto
     FROM FAI_MOVIMIENTOS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig
	   AND CodCptoMov  = cCodCptoMovOrig;
BEGIN
   -- Inserta Movimientos del Fondo
   FOR X IN MOV_Q LOOP
      INSERT INTO FAI_MOVIMIENTOS_FONDOS
             (CodCia, CodEmpresa, TipoFondo, CodCptoMov, TipoMov,
              IndAutomatico, StsMovFondo, FecStatus, CantTransac, MtoMinimo,
              MtoMaximo, PorcCptoMov, IndAplicaCargo, CodCargo,
              IndAplicaBono, CodBono, IndComision, IndIncentivo,
              IndGenContab, NomRepMov, CodRutinaCalc,  IndAplicaRet,
              CodCptoRet, IndAcumMovAsoc, IndReverso,
              CptoMovRev, IndNoAplicaSaldo, IndAplicaAjuste, 
              CodCptoAju, IndEnviaEmail, IndImpuesto, CodImpuesto)
      VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCptoMovDest, X.TipoMov,
              X.IndAutomatico, 'CONFIG', TRUNC(SYSDATE), X.CantTransac, X.MtoMinimo,
              X.MtoMaximo, X.PorcCptoMov, X.IndAplicaCargo, X.CodCargo,
              X.IndAplicaBono, X.CodBono, X.IndComision, X.IndIncentivo,
              X.IndGenContab, X.NomRepMov, X.CodRutinaCalc, X.IndAplicaRet,
              X.CodCptoRet, X.IndAcumMovAsoc, X.IndReverso,
              X.CptoMovRev, X.IndNoAplicaSaldo, X.IndAplicaAjuste, 
              X.CodCptoAju, X.IndEnviaEmail, X.IndImpuesto, X.CodImpuesto);
   END LOOP;
END COPIAR;

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2, cTipoIndic VARCHAR2) RETURN VARCHAR2 IS
cIndRetorno    VARCHAR2(1);
CURSOR IND_Q IS
   SELECT IndAutomatico, IndAplicaCargo, IndAplicaBono, IndComision,
          IndIncentivo, IndGenContab, IndAplicaRet, IndAcumMovAsoc,
          IndReverso, IndNoAplicaSaldo, IndAplicaAjuste, IndEnviaEmail,
          IndImpuesto
     FROM FAI_MOVIMIENTOS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
      AND CodCptoMov  = cCodCptoMov;
BEGIN
   FOR X IN IND_Q LOOP
      IF cTipoIndic = 'AU' THEN -- Concepto Automático
         cIndRetorno := X.IndAutomatico;
      ELSIF cTipoIndic = 'AC' THEN -- Aplica Cargo
         cIndRetorno := X.IndAplicaCargo;
      ELSIF cTipoIndic = 'AB' THEN -- Aplica Bono
         cIndRetorno := X.IndAplicaBono;
      ELSIF cTipoIndic = 'CO' THEN -- Genera Comisión
         cIndRetorno := X.IndComision;
      ELSIF cTipoIndic = 'IN' THEN -- Genera Incentivo
         cIndRetorno := X.IndIncentivo;
      ELSIF cTipoIndic = 'GC' THEN -- Genera Contabilidad
         cIndRetorno := X.IndGenContab;
      ELSIF cTipoIndic = 'AR' THEN -- Generar Retención
         cIndRetorno := X.IndAplicaRet;
      ELSIF cTipoIndic = 'AM' THEN -- Acumula Movimientos Asociados
         cIndRetorno := X.IndAcumMovAsoc;
      ELSIF cTipoIndic = 'RV' THEN -- Permite Reverso
         cIndRetorno := X.IndReverso;
      ELSIF cTipoIndic = 'NS' THEN -- NO Aplica al Saldo del Fondo
         cIndRetorno := X.IndNoAplicaSaldo;
      ELSIF cTipoIndic = 'AA' THEN -- Aplica Ajuste
         cIndRetorno := X.IndAplicaAjuste;
      ELSIF cTipoIndic = 'EE' THEN -- Envía Email
         cIndRetorno := X.IndEnviaEmail;
      ELSIF cTipoIndic = 'IMP' THEN -- Indicador de Impuesto
         cIndRetorno := X.IndImpuesto;
      END IF;
   END LOOP;
   RETURN(NVL(cIndRetorno,'N'));
END INDICADORES;

FUNCTION TIPO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cTipoMov       FAI_MOVIMIENTOS_FONDOS.TipoMov%TYPE;
BEGIN
   BEGIN
      SELECT TipoMov
        INTO cTipoMov
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cTipoMov);
END TIPO_MOVIMIENTO;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cCodRutinaCalc       FAI_MOVIMIENTOS_FONDOS.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
	       AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Rutina de Cálculo para Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION CONCEPTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cCodCargo       FAI_MOVIMIENTOS_FONDOS.CodCargo%TYPE;
BEGIN
   BEGIN
      SELECT CodCargo
        INTO cCodCargo
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
	       AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Cargo para Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodCargo);
END CONCEPTO_CARGO;

FUNCTION CONCEPTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cCodBono        FAI_MOVIMIENTOS_FONDOS.CodBono%TYPE;
BEGIN
   BEGIN
      SELECT CodBono
        INTO cCodBono
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Bono para Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodBono);
END CONCEPTO_BONO;

FUNCTION CONCEPTO_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cCodCptoRet       FAI_MOVIMIENTOS_FONDOS.CodCptoRet%TYPE;
BEGIN
   BEGIN
      SELECT CodCptoRet
        INTO cCodCptoRet
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Retención para Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodCptoRet);
END CONCEPTO_RETENCION;

FUNCTION CONCEPTO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMov VARCHAR2) RETURN VARCHAR2 IS
cCodCptoMov       FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
BEGIN
   BEGIN
      SELECT CodCptoMov
        INTO cCodCptoMov
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND TipoMov     = cTipoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Movimiento para el Tipo ' || cTipoMov || ' en el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento para el Tipo ' || cTipoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodCptoMov);
END CONCEPTO_MOVIMIENTO;

FUNCTION CONCEPTO_IMPUESTO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN VARCHAR2 IS
cCodImpuesto       FAI_MOVIMIENTOS_FONDOS.CodImpuesto%TYPE;
BEGIN
   BEGIN
      SELECT CodImpuesto
        INTO cCodImpuesto
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Impuesto para Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(cCodImpuesto);
END CONCEPTO_IMPUESTO;

FUNCTION CANTIDAD_POR_ANIO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCptoMov VARCHAR2) RETURN NUMBER IS
nCantTransac       FAI_MOVIMIENTOS_FONDOS.CantTransac%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantTransac,0)
        INTO nCantTransac
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo
         AND CodCptoMov  = cCodCptoMov;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Cantidad de Movimientos por Año para el Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Movimiento ' || cCodCptoMov || ' para el Tipo de Fondo '|| cTipoFondo);
   END;
   RETURN(nCantTransac);
END CANTIDAD_POR_ANIO;

END GT_FAI_MOVIMIENTOS_FONDOS;
/

--
-- GT_FAI_MOVIMIENTOS_FONDOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_MOVIMIENTOS_FONDOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_MOVIMIENTOS_FONDOS FOR SICAS_OC.GT_FAI_MOVIMIENTOS_FONDOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_MOVIMIENTOS_FONDOS TO PUBLIC
/
