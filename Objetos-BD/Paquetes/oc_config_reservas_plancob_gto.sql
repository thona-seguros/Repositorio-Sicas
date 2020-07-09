--
-- OC_CONFIG_RESERVAS_PLANCOB_GTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_RESERVAS_PLANCOB_GTO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_PLANCOB_GTO IS

  PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
  FUNCTION DEVUELVE_GASTO(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                          cPlanCob VARCHAR2, cTipoGasto VARCHAR2) RETURN NUMBER;
  PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                    cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_CONFIG_RESERVAS_PLANCOB_GTO;
/

--
-- OC_CONFIG_RESERVAS_PLANCOB_GTO  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_PLANCOB_GTO IS

PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   BEGIN
      DELETE CONFIG_RESERVAS_PLANCOB_GTO
       WHERE CodCia     = nCodCia
         AND CodReserva = cCodReserva
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
                   AND PlanCob    = cPlanCob;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar Eliminar CONFIG_RESERVAS_PLANCOB_GTO,  '|| SQLERRM );
   END;
END ELIMINAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_PLANCOB_GTO
                 (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob, InteresTecnico, 
                                           PorcGtoAdmin, MillarGtoAdmin, PorcGtoAdqui, PorcUtilidad, ValorAlfa)
           SELECT nCodCia, cCodReservaDest, CodEmpresa, IdTipoSeg, PlanCob, InteresTecnico,
                                 PorcGtoAdmin, MillarGtoAdmin, PorcGtoAdqui, PorcUtilidad, ValorAlfa
             FROM CONFIG_RESERVAS_PLANCOB_GTO
            WHERE CodCia     = nCodCia
              AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia CONFIG_RESERVAS_PLANCOB_GTO,  '|| SQLERRM );
   END;
END COPIAR;

FUNCTION DEVUELVE_GASTO(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                        cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cTipoGasto VARCHAR2) RETURN NUMBER IS
nInteresTecnico     CONFIG_RESERVAS_PLANCOB_GTO.InteresTecnico%TYPE;
nPorcGtoAdmin       CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdmin%TYPE;
nMillarGtoAdmin     CONFIG_RESERVAS_PLANCOB_GTO.MillarGtoAdmin%TYPE;
nPorcGtoAdqui       CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdqui%TYPE;
nPorcUtilidad       CONFIG_RESERVAS_PLANCOB_GTO.PorcUtilidad%TYPE;
nValorAlfa          CONFIG_RESERVAS_PLANCOB_GTO.ValorAlfa%TYPE;
BEGIN
   SELECT NVL(InteresTecnico,0) / 100, NVL(PorcGtoAdmin,0) / 100,
          NVL(MillarGtoAdmin,0), NVL(PorcGtoAdqui,0) / 100,
          NVL(PorcUtilidad,0) / 100, NVL(ValorAlfa,0)
     INTO nInteresTecnico, nPorcGtoAdmin, nMillarGtoAdmin, nPorcGtoAdqui, 
          nPorcUtilidad, nValorAlfa
     FROM CONFIG_RESERVAS_PLANCOB_GTO
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob;
   IF cTipoGasto = 'INT' THEN
      RETURN(nInteresTecnico);
   ELSIF cTipoGasto = 'PGA' THEN
      RETURN(nPorcGtoAdmin);
   ELSIF cTipoGasto = 'GAM' THEN
      RETURN(nMillarGtoAdmin);
   ELSIF cTipoGasto = 'PAD' THEN
      RETURN(nPorcGtoAdqui);
   ELSIF cTipoGasto = 'PUT' THEN
      RETURN(nPorcUtilidad);
   ELSIF cTipoGasto = 'ALF' THEN
      RETURN(nValorAlfa);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END DEVUELVE_GASTO;

PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                  cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GTO_Q IS
   SELECT InteresTecnico, PorcGtoAdmin, MillarGtoAdmin, PorcGtoAdqui,
          PorcUtilidad, ValorAlfa
     FROM CONFIG_RESERVAS_PLANCOB_GTO
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GTO_Q LOOP
      INSERT INTO CONFIG_RESERVAS_PLANCOB_GTO
             (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob, InteresTecnico,
                                  PorcGtoAdmin, MillarGtoAdmin, PorcGtoAdqui, PorcUtilidad, ValorAlfa)
      VALUES (nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.InteresTecnico,
                                  X.PorcGtoAdmin, X.MillarGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad, X.ValorAlfa);
   END LOOP;
END AGREGAR;

END OC_CONFIG_RESERVAS_PLANCOB_GTO;
/

--
-- OC_CONFIG_RESERVAS_PLANCOB_GTO  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_RESERVAS_PLANCOB_GTO FOR SICAS_OC.OC_CONFIG_RESERVAS_PLANCOB_GTO
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_RESERVAS_PLANCOB_GTO TO PUBLIC
/
