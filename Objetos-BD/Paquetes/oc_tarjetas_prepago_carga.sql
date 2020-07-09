--
-- OC_TARJETAS_PREPAGO_CARGA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PROCESOS_MASIVOS (Table)
--   TARJETAS_PREPAGO (Table)
--   OC_PROCESOS_MASIVOS (Package)
--   OC_PROCESOS_MASIVOS_LOG (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TARJETAS_PREPAGO_CARGA IS


PROCEDURE CARGA_FOLIO (nIdProcMasivo NUMBER);


END OC_TARJETAS_PREPAGO_CARGA;
/

--
-- OC_TARJETAS_PREPAGO_CARGA  (Package Body) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO_CARGA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TARJETAS_PREPAGO_CARGA IS


PROCEDURE CARGA_FOLIO (nIdProcMasivo NUMBER)IS
cTipoTarjeta    TARJETAS_PREPAGO.TipoTarjeta%TYPE;
nNumTarjeta     TARJETAS_PREPAGO.NumTarjeta%TYPE;
cCodPromotor    TARJETAS_PREPAGO.CodPromotor%TYPE;
cExiste         VARCHAR2(1);
cStsTarjeta     TARJETAS_PREPAGO.StsTarjeta%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cIdGrupoTarj    TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
CURSOR C_TARJETA IS
    SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob,TipoProceso,
          NumPolUnico, NumDetUnico, RegDatosProc
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

BEGIN
 BEGIN
  FOR X IN C_TARJETA LOOP
    cTipoTarjeta     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
    nNumTarjeta      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
    cCodPromotor     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')) ;
    cIdGrupoTarj     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,',')) ;
    IF cTipoTarjeta IS NULL THEN
       RAISE_APPLICATION_ERROR(-20225,'Debe Ingresar el Tipo de Tarjeta a Generar :'||nNumTarjeta);
    ELSIF nNumTarjeta IS NULL THEN
      RAISE_APPLICATION_ERROR(-20225,'El No. de Tarjeta No puede ser NULO');
    END IF;
    IF cCodPromotor IS NOT NULL THEN
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM TARJETAS_PREPAGO
             WHERE CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND IdTipoSeg   = X.IdTipoSeg
               AND PlanCob     = X.PlanCob
               AND TipoTarjeta = cTipoTarjeta
               AND CodPromotor = cCodPromotor
               AND NumTarjeta  = nNumTarjeta;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
               cExiste := 'S';
         END;
      ELSE
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM TARJETAS_PREPAGO
             WHERE CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND IdTipoSeg   = X.IdTipoSeg
               AND PlanCob     = X.PlanCob
               AND TipoTarjeta = cTipoTarjeta
              AND NumTarjeta   = nNumTarjeta;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
               cExiste := 'S';
         END;
      END IF;
      IF cExiste = 'N' THEN
         IF cCodPromotor IS NOT NULL THEN
            cStsTarjeta := 'ASIG';
         ELSE
            cStsTarjeta := 'PEND';
         END IF;
         INSERT INTO TARJETAS_PREPAGO
                     (CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoTarjeta,
                      NumTarjeta, StsTarjeta, FecSts, CodPromotor, IdGrupoTarj)
               VALUES(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                      cTipoTarjeta, nNumTarjeta, cStsTarjeta, SYSDATE, cCodPromotor,
                      cIdGrupoTarj);
          OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
      ELSE
          RAISE_APPLICATION_ERROR(-20225,'No. de Tarjeta '||nNumTarjeta|| ' ya Existe');
      END IF;

 END LOOP;
 EXCEPTION
    WHEN OTHERS THEN
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'CARFOL','20225','No se puede realizar la Carga de la  Tarjeta '||nNumTarjeta||' '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
 END ;

END CARGA_FOLIO;
END OC_TARJETAS_PREPAGO_CARGA;
/

--
-- OC_TARJETAS_PREPAGO_CARGA  (Synonym) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO_CARGA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TARJETAS_PREPAGO_CARGA FOR SICAS_OC.OC_TARJETAS_PREPAGO_CARGA
/


GRANT EXECUTE ON SICAS_OC.OC_TARJETAS_PREPAGO_CARGA TO PUBLIC
/
