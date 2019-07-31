--
-- GT_COTIZADOR_PLANCOB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   COTIZADOR_CONFIG (Table)
--   COTIZADOR_PLANCOB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZADOR_PLANCOB IS

  PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2);
  PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSegOrig VARCHAR2,
                    cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);
  FUNCTION ASIGNADO_A_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2,
                                cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION EXISTEN_PLANES_DE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;

END GT_COTIZADOR_PLANCOB;
/

--
-- GT_COTIZADOR_PLANCOB  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZADOR_PLANCOB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZADOR_PLANCOB IS

PROCEDURE CONFIGURAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_PLANCOB
      SET StsPlanCot = 'CONFIG'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND PlanCob      = cPlanCob;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_PLANCOB
      SET StsPlanCot = 'SUSPEN'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND PlanCob      = cPlanCob;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_PLANCOB
      SET StsPlanCot = 'ACTIVO'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND PlanCob      = cPlanCob;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO COTIZADOR_PLANCOB
                 (CodCia, CodEmpresa, CodCotizador, IdTipoSeg, PlanCob,
                  FecAltaPlan, StsPlanCot, FecStatus, CodUsuario)
           SELECT nCodCia, CodEmpresa, cCodCotizadorDest, IdTipoSeg, PlanCob,
                  FecAltaPlan, 'CONFIG', TRUNC(SYSDATE), USER
             FROM COTIZADOR_PLANCOB
            WHERE CodCia       = nCodCia
              AND CodEmpresa   = nCodEmpresa
              AND CodCotizador = cCodCotizadorOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de COTIZADOR_PLANCOB  '|| SQLERRM);
   END;
END COPIAR;

PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSegOrig VARCHAR2,
                  cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
cStsCotizador   COTIZADOR_CONFIG.StsCotizador%TYPE;
BEGIN
   BEGIN
      SELECT StsCotizador
        INTO cStsCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia       = nCodCia
         AND CodCotizador = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20220,'No existe el Cotizador '|| cCodCotizador);
   END;
   BEGIN
      INSERT INTO COTIZADOR_PLANCOB
             (CodCia, CodEmpresa, CodCotizador, IdTipoSeg, PlanCob,
              FecAltaPlan, StsPlanCot, FecStatus, CodUsuario)
      VALUES (nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSegDest, cPlanCobDest,
              TRUNC(SYSDATE), cStsCotizador, TRUNC(SYSDATE), USER);
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar Insert en COTIZADOR_PLANCOB,  '|| SQLERRM);
   END;
END AGREGAR;

FUNCTION ASIGNADO_A_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, 
                              cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2)  RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZADOR_PLANCOB
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador != cCodCotizador
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END ASIGNADO_A_COTIZADOR;

FUNCTION EXISTEN_PLANES_DE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZADOR_PLANCOB
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_PLANES_DE_COBERTURAS;

END GT_COTIZADOR_PLANCOB;
/
