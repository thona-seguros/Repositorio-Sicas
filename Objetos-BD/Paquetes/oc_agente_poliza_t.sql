--
-- OC_AGENTE_POLIZA_T  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_POLIZA (Table)
--   AGENTES_DETALLES_POLIZAS (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTES_DISTRIBUCION_POLIZA_T (Table)
--   AGENTE_POLIZA (Table)
--   AGENTE_POLIZA_T (Table)
--   OC_AGENTES_DETALLES_POLIZAS (Package)
--   OC_AGENTES_DISTRIBUCION_POLIZA (Package)
--   OC_AGENTE_POLIZA (Package)
--   OC_AGE_DISTRIBUCION_COMISION (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTE_POLIZA_T IS

  PROCEDURE CAMBIAR_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER);

END OC_AGENTE_POLIZA_T;
/

--
-- OC_AGENTE_POLIZA_T  (Package Body) 
--
--  Dependencies: 
--   OC_AGENTE_POLIZA_T (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTE_POLIZA_T IS

PROCEDURE CAMBIAR_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER) IS
nPorc_Com_Distribuida   AGENTES_DISTRIBUCION_COMISION.Porc_Com_Distribuida%TYPE;
nCod_Agente             AGENTE_POLIZA_T.Cod_Agente%TYPE;

CURSOR COMAGE_Q IS
   SELECT CodCia, IdPoliza, Cod_Agente, Porc_Comision,
          Ind_Principal, Origen
     FROM AGENTE_POLIZA_T
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza ;

CURSOR DETPOL_Q IS
  SELECT IdPoliza, IdetPol, IdTipoSeg
    FROM DETALLE_POLIZA
   WHERE CodCia      = nCodCia
     AND IdPoliza    = nIdPoliza
     AND StsDetalle IN ('EMI');

CURSOR DETAGP_Q IS
  SELECT CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr,
         Porc_Comision_Plan, Porc_Comision_Agente, Origen, 
         Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe
    FROM AGENTES_DISTRIBUCION_POLIZA_T
   WHERE CodCia      = nCodCia
     AND IdPoliza    = nIdPoliza
     AND Cod_Agente  = nCod_Agente;
BEGIN
   OC_AGENTE_POLIZA.BORRAR_REGISTRO(nCodCia, nIdPoliza);
   OC_AGENTES_DISTRIBUCION_POLIZA.BORRAR_REGISTRO(nCodCia, nIdPoliza);
   OC_AGE_DISTRIBUCION_COMISION.BORRAR_REGISTRO(nCodCia, nIdPoliza);
   OC_AGENTES_DETALLES_POLIZAS.BORRAR_REGISTRO(nCodCia, nIdPoliza);

   SELECT NVL(SUM(Porc_Com_Distribuida),0)
     INTO nPorc_Com_Distribuida
     FROM AGENTES_DISTRIBUCION_POLIZA_T
    WHERE IdPoliza  = nIdPoliza
      AND CodCia    = nCodCia;

   UPDATE DETALLE_POLIZA
      SET PorcComis = nPorc_Com_Distribuida
    WHERE IdPoliza  = nIdPoliza
      AND CodCia    = nCodCia;

   INSERT INTO AGENTE_POLIZA
   SELECT IdPoliza, CodCia, Cod_Agente, 
          Porc_Comision, Ind_Principal, Origen
     FROM AGENTE_POLIZA_T
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

   INSERT INTO AGENTES_DISTRIBUCION_POLIZA
   SELECT CodCia, IdPoliza, Cod_Agente, CodNivel, 
          Cod_Agente_Distr, Porc_Comision_Agente,
          Porc_Com_Distribuida, Porc_Comision_Plan,
          Porc_Com_Proporcional, Cod_Agente_Jefe,
          Porc_Com_Poliza, Origen
     FROM AGENTES_DISTRIBUCION_POLIZA_T
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

   FOR X IN DETPOL_Q LOOP
      FOR Y IN COMAGE_Q LOOP
         BEGIN
            INSERT INTO AGENTES_DETALLES_POLIZAS
                  (CodCia, IdPoliza, IdetPol, IdTipoSeg,
                   Cod_Agente, Porc_Comision, Ind_Principal, Origen)
            VALUES(nCodCia, nIdPoliza, X.IdetPol, X.IdTipoSeg,
                   Y.Cod_Agente, Y.Porc_Comision, Y.Ind_Principal, Y.Origen);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Registro de Agente No. ' || Y.Cod_Agente || ' está Duplicado en Póliza '|| nIdPoliza);
         END;
         
         nCod_Agente := Y.Cod_Agente;
         FOR W IN DETAGP_Q LOOP
            BEGIN
               INSERT INTO AGENTES_DISTRIBUCION_COMISION
                     (CodCia, IdPoliza, IdetPol, CodNivel, Cod_Agente, Cod_Agente_Distr,
                      Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
                      Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
               VALUES(nCodCia, nIdPoliza, X.IDetPol, W.CodNivel, W.Cod_Agente, W.Cod_Agente_Distr,
                      W.Porc_Comision_Plan, W.Porc_Comision_Agente, W.Porc_Com_Distribuida,
                      W.Porc_Com_Proporcional, W.Cod_Agente_Jefe, W.Origen);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Registro de Agente No. ' || W.Cod_Agente_Distr || ' en Nivel ' || W.CodNivel ||
                                          ' está Duplicado en Póliza '|| nIdPoliza);
            END;
         END LOOP;
      END LOOP;
   END LOOP;
END CAMBIAR_DISTRIBUCION;

END OC_AGENTE_POLIZA_T;
/
