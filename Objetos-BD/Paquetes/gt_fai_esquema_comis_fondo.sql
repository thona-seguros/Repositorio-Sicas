--
-- GT_FAI_ESQUEMA_COMIS_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NIVEL (Table)
--   OC_AGENTE_POLIZA (Package)
--   POLIZAS (Table)
--   FAI_CONF_COMISIONES_FONDO (Table)
--   FAI_CONF_TIPO_INCENTIVO (Table)
--   FAI_ESQUEMA_COMIS_FONDO (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_ESQUEMA_COMIS_FONDO AS

PROCEDURE GENERAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                  nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoFondo VARCHAR2, 
                  cCod_Agente NUMBER, cIndPrincipal VARCHAR2, cNivelComision VARCHAR2,
                  cPlanComision  VARCHAR);

PROCEDURE VERIFICAR_COMISIONES_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

PROCEDURE VERIFICAR_COMIS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER,  nCodAsegurado NUMBER, nIdFondo NUMBER);

END GT_FAI_ESQUEMA_COMIS_FONDO;
/

--
-- GT_FAI_ESQUEMA_COMIS_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_ESQUEMA_COMIS_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_ESQUEMA_COMIS_FONDO AS

PROCEDURE GENERAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                  nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoFondo VARCHAR2, 
                  cCod_Agente NUMBER, cIndPrincipal VARCHAR2, cNivelComision VARCHAR2,
                  cPlanComision  VARCHAR) AS
cCodIncentivo     FAI_CONF_TIPO_INCENTIVO.CodIncentivo%TYPE; 
BEGIN
   BEGIN
      SELECT CodIncentivo
        INTO cCodIncentivo
        FROM FAI_CONF_TIPO_INCENTIVO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodIncentivo := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Incentivos para el Fondo No. ' || cTipoFondo);
   END;

   BEGIN
      INSERT INTO FAI_ESQUEMA_COMIS_FONDO
             (CodCia, CodEmpresa, IdPoliza, IDetPol, 
              CodAsegurado, IdFondo, Cod_Agente, IndPrincipal,
              NivelComision, PlanComision, CodIncentivo)
      VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 
              nCodAsegurado, nIdFondo, cCod_Agente, cIndPrincipal,
              cNivelComision, cPlanComision, cCodIncentivo);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Registro Duplicado en Esquema de Comisiones del Fondo No. ' || nIdFondo);
   END;
END GENERAR;

PROCEDURE VERIFICAR_COMISIONES_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) AS  
nRegs            NUMBER(8);
cStsPoliza       POLIZAS.StsPoliza%TYPE;
nCodNivel        NIVEL.CodNivel%TYPE;
cTipoFondo       FAI_CONF_COMISIONES_FONDO.TipoFondo%TYPE;
cInd_Principal   AGENTE_POLIZA.Ind_Principal%TYPE;

CURSOR FOND_Q IS
   SELECT DISTINCT IdPoliza, IDetPol, CodAsegurado, IdFondo, TipoFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

CURSOR AGENTE_PROM_Q IS
   SELECT A.Cod_Agente 
     FROM AGENTES A, AGENTES_DISTRIBUCION_POLIZA P
    WHERE P.CodCia      = nCodCia
      AND P.IdPoliza    = nIdPoliza
      AND P.CodNivel    = nCodNivel
      AND A.CodCia      = P.CodCia
      AND A.Cod_Agente  = P.Cod_Agente_Distr
      AND A.CodNivel    = P.CodNivel;

CURSOR CONF_COMIS_Q IS
   SELECT TipoFondo, NivelComision, PlanComision 
     FROM FAI_CONF_COMISIONES_FONDO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFOndo  = cTipoFondo
    GROUP BY TipoFondo, NivelComision, PlanComision;
BEGIN
   BEGIN
      SELECT StsPoliza
        INTO cStsPoliza
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-22052,'NO Existe Póliza No. '||nIdPoliza);
   END;

   IF cStsPoliza IS NOT NULL THEN
      FOR W IN FOND_Q LOOP
         SELECT COUNT(*)
           INTO nRegs
           FROM FAI_ESQUEMA_COMIS_FONDO
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
	         AND IdFondo    = W.IdFondo;

         IF nRegs > 0 AND cStsPoliza IN ( 'SOL', 'XRE' ) THEN
            DELETE FAI_ESQUEMA_COMIS_FONDO
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
	            AND IdFondo    = W.IdFondo;
            nRegs := 0;
         END IF;

         IF nRegs = 0 THEN  -- Verifica si existe la definición de la comisiones a nivel de la póliza
            cTipoFondo  := W.TipoFondo;
            FOR Y IN CONF_COMIS_Q LOOP
               nCodNivel   := Y.NivelComision;
               FOR Z IN AGENTE_PROM_Q LOOP
                  IF Z.Cod_Agente = OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(nCodCia, nIdPoliza) THEN
                     cInd_Principal := 'S';
                  ELSE
                     cInd_Principal := 'N';
                  END IF;
                  GT_FAI_ESQUEMA_COMIS_FONDO.GENERAR(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol, 
                                                     W.CodAsegurado,  W.IdFondo, Y.TipoFondo, Z.Cod_Agente, 
                                                     cInd_Principal, Y.NivelComision, Y.PlanComision);
               END LOOP;
            END LOOP;
         END IF;
      END LOOP;
   END IF;
END VERIFICAR_COMISIONES_POLIZA;

PROCEDURE VERIFICAR_COMIS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER,  nCodAsegurado NUMBER, nIdFondo NUMBER) AS
nRegs            NUMBER(8);
cStsPoliza       POLIZAS.StsPoliza%TYPE;
nCodNivel        NIVEL.CodNivel%TYPE;
cTipoFondo       FAI_CONF_COMISIONES_FONDO.TipoFondo%TYPE;
cInd_Principal   AGENTE_POLIZA.Ind_Principal%TYPE;

CURSOR FOND_Q IS
   SELECT DISTINCT IdPoliza, IDetPol, CodAsegurado, IdFondo, TipoFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo;

CURSOR AGENTE_PROM_Q IS
   SELECT A.Cod_Agente, A.CodNivel
     FROM AGENTES A, AGENTES_DISTRIBUCION_POLIZA P
    WHERE P.CodCia      = nCodCia
      AND P.IdPoliza    = nIdPoliza
      AND P.CodNivel    = nCodNivel
      AND A.CodCia      = P.CodCia
      AND A.Cod_Agente  = P.Cod_Agente_Distr
      AND A.CodNivel    = P.CodNivel;

CURSOR CONF_COMIS_Q IS
   SELECT TipoFondo, NivelComision, PlanComision 
     FROM FAI_CONF_COMISIONES_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND TipoFondo     = cTipoFondo
    GROUP BY TipoFondo, NivelComision, PlanComision;
BEGIN
   BEGIN
      SELECT StsPoliza
        INTO cStsPoliza
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-22052,'NO Existe Póliza No. '||nIdPoliza);
   END;

   IF cStsPoliza IS NOT NULL THEN
      FOR W IN FOND_Q LOOP
         SELECT COUNT(*)
           INTO nRegs
           FROM FAI_ESQUEMA_COMIS_FONDO
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
	         AND IdFondo    = W.IdFondo;

         IF nRegs > 0 AND cStsPoliza IN ( 'SOL', 'XRE' ) THEN
            DELETE FAI_ESQUEMA_COMIS_FONDO
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
	            AND IdFondo    = W.IdFondo;
            nRegs := 0;
         END IF;

         IF nRegs = 0 THEN  -- Verifica si existe la definición de la comisiones a nivel de la póliza
            cTipoFondo  := W.TipoFondo;
            FOR Y IN CONF_COMIS_Q LOOP
               nCodNivel   := Y.NivelComision;
               FOR Z IN AGENTE_PROM_Q LOOP
                  GT_FAI_ESQUEMA_COMIS_FONDO.GENERAR(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol, 
                                                     W.CodAsegurado,  W.IdFondo, Y.TipoFondo, Z.Cod_Agente, 
                                                     cInd_Principal, Y.NivelComision, Y.PlanComision);
               END LOOP;

            END LOOP;
          END IF;
      END LOOP;
   END IF;
END VERIFICAR_COMIS_FONDO;

END GT_FAI_ESQUEMA_COMIS_FONDO;
/

--
-- GT_FAI_ESQUEMA_COMIS_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_ESQUEMA_COMIS_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_ESQUEMA_COMIS_FONDO FOR SICAS_OC.GT_FAI_ESQUEMA_COMIS_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_ESQUEMA_COMIS_FONDO TO PUBLIC
/
