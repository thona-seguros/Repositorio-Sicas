CREATE OR REPLACE PACKAGE OC_AGENTES_DETALLES_POLIZAS IS

  PROCEDURE COPIAR_DISTR_INCLUSION_CERT(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,cIdTipoSeg VARCHAR2);

  PROCEDURE INSERTA_AGENTE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                           cIdTipoSeg VARCHAR2, nCodAgente NUMBER);
  PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER);                   

  PROCEDURE INSERTA_AGENTE_PLAN_COB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                    cPlanCob VARCHAR2, nIdPoliza NUMBER, nIdetPol NUMBER);
  FUNCTION EXISTE_AGENTE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, nCodAgente NUMBER) RETURN VARCHAR2;
END OC_AGENTES_DETALLES_POLIZAS;
/

CREATE OR REPLACE PACKAGE BODY OC_AGENTES_DETALLES_POLIZAS IS

PROCEDURE COPIAR_DISTR_INCLUSION_CERT(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,cIdTipoSeg VARCHAR2) IS
CURSOR COMAGE_Q IS
   SELECT CodCia, IdPoliza, Cod_Agente, Porc_Comision, 
          Ind_Principal, Origen
     FROM AGENTE_POLIZA
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

CURSOR DETAGP_Q (nCod_Agente NUMBER) IS
  SELECT CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, 
         Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
         Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
    FROM AGENTES_DISTRIBUCION_POLIZA
   WHERE CodCia     = nCodCia
     AND IdPoliza   = nIdPoliza
     AND Cod_Agente = nCod_Agente;
BEGIN
   FOR Y IN COMAGE_Q LOOP
      INSERT INTO AGENTES_DETALLES_POLIZAS
            (CodCia, IdPoliza, IdetPol, IdTipoSeg, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
      VALUES(nCodCia, nIdPoliza, nIDetPol, cIdTipoSeg, Y.Cod_Agente, Y.Porc_Comision, Y.Ind_Principal, Y.Origen);
      FOR W IN DETAGP_Q(Y.Cod_Agente) LOOP
         INSERT INTO AGENTES_DISTRIBUCION_COMISION
               (CodCia, IdPoliza,IdetPol,CodNivel,Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
                Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
         VALUES(nCodCia, nIdPoliza, nIDetPol, W.CodNivel, W.Cod_Agente, W.Cod_Agente_Distr, W.Porc_Comision_Plan,
                W.Porc_Comision_Agente, W.Porc_Com_Distribuida, W.Porc_Com_Proporcional, W.Cod_Agente_Jefe, W.Origen);
      END LOOP;
   END LOOP;
END COPIAR_DISTR_INCLUSION_CERT;

PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE AGENTES_DETALLES_POLIZAS
     WHERE CodCia   = nCodCia 
       AND IdPoliza = nIdPoliza;
END BORRAR_REGISTRO;

PROCEDURE INSERTA_AGENTE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, nCodAgente NUMBER) IS
cOrigen     AGENTES_DETALLES_POLIZAS.Origen%TYPE;
BEGIN
   SELECT NVL(MAX(Origen),'C')
     INTO cOrigen
     FROM AGENTE_POLIZA
    WHERE IdPoliza  = nIdPoliza
      AND CodCia    = nCodCia;
   BEGIN
      INSERT INTO AGENTES_DETALLES_POLIZAS
            (IdPoliza, IDetPol, IdTipoSeg, Cod_Agente,
             Porc_Comision, Ind_Principal, CodCia, Origen)
      VALUES(nIdPoliza, nIdetPol, cIdTipoSeg, nCodAgente,
             100, 'S', nCodCia, cOrigen);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Agentes en Detalle de Póliza');
   END;
END INSERTA_AGENTE;

PROCEDURE INSERTA_AGENTE_PLAN_COB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                  cPlanCob VARCHAR2, nIdPoliza NUMBER, nIdetPol NUMBER) IS
nCod_Agente   AGENTES.Cod_Agente%TYPE;
cOrigen     AGENTES_DETALLES_POLIZAS.Origen%TYPE;
BEGIN
   SELECT NVL(MAX(Origen),'C')
     INTO cOrigen
     FROM AGENTE_POLIZA
    WHERE IdPoliza  = nIdPoliza
      AND CodCia    = nCodCia;
   BEGIN
      SELECT Cod_Agente
        INTO nCod_Agente
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCod_Agente := 0;
   END;

   IF nCod_Agente != 0 THEN
      BEGIN
         INSERT INTO AGENTES_DETALLES_POLIZAS
               (Idpoliza, IdetPol, IdTipoSeg, Cod_Agente, Porc_Comision,
                Ind_Principal, CodCia, Origen)
         VALUES(nIdPoliza, nIdetPol, cIdTipoSeg, nCod_Agente, 100,
                'S', nCodCia, cOrigen);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Agentes en Detalle de Póliza');
      END;
   END IF;
END;

FUNCTION EXISTE_AGENTE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, nCodAgente NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM AGENTES_DETALLES_POLIZAS
       WHERE CodCia      = nCodCia
         AND IdPoliza    = nIdpoliza
         AND IDetPol     = nIDetPol
         AND IdTipoSeg   = cIdTipoSeg
         AND Cod_Agente  = nCodAgente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_AGENTE;

END OC_AGENTES_DETALLES_POLIZAS;
