--
-- OC_AGENTES_DISTRIBUCION_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DETALLE_POLIZA (Table)
--   AGENTES (Table)
--   AGENTES_DETALLES_POLIZAS (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTES_DISTRIBUCION_POLIZA IS

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER);
PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER);
PROCEDURE COPIAR_DETALLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);
PROCEDURE RECALCULA_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nCod_Agente NUMBER);

END OC_AGENTES_DISTRIBUCION_POLIZA;
/

--
-- OC_AGENTES_DISTRIBUCION_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_AGENTES_DISTRIBUCION_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTES_DISTRIBUCION_POLIZA IS

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER) IS
nCod_Agente    AGENTES.Cod_Agente%TYPE;
CURSOR COMAGE_Q IS
   SELECT CodCia, IdPoliza, Cod_Agente, Porc_Comision, Ind_Principal, Origen
     FROM AGENTE_POLIZA
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

CURSOR DETPOL_Q IS
   SELECT IdPoliza, IdetPol, IdTipoSeg
     FROM DETALLE_POLIZA
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPoliza
      AND StsDetalle IN ('XRE','SOL');

CURSOR DETAGP_Q IS
   SELECT CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
          Porc_com_distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
     FROM AGENTES_DISTRIBUCION_POLIZA
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND Cod_Agente = nCod_Agente;
BEGIN
   FOR X IN DETPOL_Q LOOP
      FOR Y IN COMAGE_Q LOOP
         INSERT INTO AGENTES_DETALLES_POLIZAS
               (CodCia, IdPoliza, IdetPol, IdTipoSeg, Cod_Agente, 
                Porc_Comision, Ind_Principal, Origen)
         VALUES(nCodCia, nIdPoliza, X.IdetPol, X.IdTipoSeg, Y.Cod_Agente,
                Y.Porc_Comision, Y.Ind_Principal, Y.Origen);

         nCod_Agente := Y.Cod_Agente;
         FOR W IN DETAGP_Q LOOP
            INSERT INTO AGENTES_DISTRIBUCION_COMISION
                   (CodCia, IdPoliza,IdetPol,CodNivel,Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
                    Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
            VALUES (nCodCia, nIdPoliza, X.IdetPol, W.CodNivel, W.Cod_Agente, W.Cod_Agente_Distr, W.Porc_Comision_Plan,
                    W.Porc_Comision_Agente, W.Porc_Com_Distribuida, W.Porc_Com_Proporcional, W.Cod_Agente_Jefe, W.Origen);
         END LOOP;
      END LOOP;
   END LOOP;
END COPIAR;

PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE AGENTES_DISTRIBUCION_POLIZA
     WHERE CodCia   = nCodCia 
       AND IdPoliza = nIdPoliza;
END BORRAR_REGISTRO;

PROCEDURE COPIAR_DETALLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
nCod_Agente    AGENTES.Cod_Agente%TYPE;
CURSOR COMAGE_Q IS
   SELECT CodCia, IdPoliza, Cod_Agente, Porc_Comision, Ind_Principal, Origen
     FROM AGENTE_POLIZA
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

CURSOR DETPOL_Q IS
   SELECT IdPoliza, IdetPol, IdTipoSeg
     FROM DETALLE_POLIZA
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPoliza
      AND IDetPol     = nIDetPol
      AND StsDetalle IN ('XRE','SOL');

CURSOR DETAGP_Q IS
   SELECT CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
          Porc_com_distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
     FROM AGENTES_DISTRIBUCION_POLIZA
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND Cod_Agente = nCod_Agente;
BEGIN
   FOR X IN DETPOL_Q LOOP
      FOR Y IN COMAGE_Q LOOP
         INSERT INTO AGENTES_DETALLES_POLIZAS
               (CodCia, IdPoliza, IdetPol, IdTipoSeg, Cod_Agente, 
                Porc_Comision, Ind_Principal, Origen)
         VALUES(nCodCia, nIdPoliza, X.IdetPol, X.IdTipoSeg, Y.Cod_Agente,
                Y.Porc_Comision, Y.Ind_Principal, Y.Origen);

         nCod_Agente := Y.Cod_Agente;
         FOR W IN DETAGP_Q LOOP
            INSERT INTO AGENTES_DISTRIBUCION_COMISION
                   (CodCia, IdPoliza,IdetPol,CodNivel,Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
                    Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
            VALUES (nCodCia, nIdPoliza, X.IdetPol, W.CodNivel, W.Cod_Agente, W.Cod_Agente_Distr, W.Porc_Comision_Plan,
                    W.Porc_Comision_Agente, W.Porc_Com_Distribuida, W.Porc_Com_Proporcional, W.Cod_Agente_Jefe, W.Origen);
         END LOOP;
      END LOOP;
   END LOOP;
END COPIAR_DETALLE;

PROCEDURE RECALCULA_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nCod_Agente NUMBER) IS
nPorc_Com_Poliza        POLIZAS.PorcGtoAdqui%TYPE;
nPorc_Comision_Plan     AGENTES_DISTRIBUCION_POLIZA.Porc_Comision_Plan%TYPE;
nPorc_Com_Proporcional  AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nPorc_com_distribuida   AGENTES_DISTRIBUCION_POLIZA.Porc_com_distribuida%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcGtoAdqui,0)
        INTO nPorc_Com_Poliza
        FROM POLIZAS 
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   END;
   BEGIN
      SELECT Porc_Comision_Plan, Porc_Com_Distribuida
        INTO nPorc_Comision_Plan, nPorc_Com_Distribuida
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza
         AND Cod_Agente = nCod_Agente;
   END;
   IF nPorc_Com_Poliza <> nPorc_Comision_Plan THEN
      nPorc_Com_Proporcional := nPorc_Com_Distribuida / nPorc_Com_Poliza * 100;
   ELSE
      nPorc_Com_Proporcional := TRUNC(ROUND((nPorc_Com_Distribuida * 100) / nPorc_Com_Poliza,2),2);
   END IF;
   
   UPDATE AGENTES_DISTRIBUCION_POLIZA
      SET Porc_Com_Distribuida   = nPorc_Com_Poliza,
          Porc_Com_Proporcional  = nPorc_Com_Proporcional
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND Cod_Agente = nCod_Agente;
      
END RECALCULA_COMISION;

END OC_AGENTES_DISTRIBUCION_POLIZA;
/
