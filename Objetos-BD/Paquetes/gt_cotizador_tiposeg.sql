--
-- GT_COTIZADOR_TIPOSEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PLAN_COBERTURAS (Table)
--   GT_COTIZADOR_PLANCOB (Package)
--   COTIZADOR_CONFIG (Table)
--   COTIZADOR_PLANCOB (Table)
--   COTIZADOR_TIPOSEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZADOR_TIPOSEG IS

  PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2);
  PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER,  nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2);
  PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador  VARCHAR2,
                    cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);
  FUNCTION ASIGNADO_A_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  FUNCTION EXISTEN_TIPOS_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;

END GT_COTIZADOR_TIPOSEG;
/

--
-- GT_COTIZADOR_TIPOSEG  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZADOR_TIPOSEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZADOR_TIPOSEG IS

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2) IS
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM COTIZADOR_PLANCOB
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanCot   = 'ACTIVO';
BEGIN
   FOR X IN PLAN_Q LOOP
      GT_COTIZADOR_PLANCOB.CONFIGURAR(nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, X.PlanCob);
   END LOOP;

   UPDATE COTIZADOR_TIPOSEG
      SET StsTipoSegCot = 'CONFIG'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2) IS
cStsTipoSegCot  COTIZADOR_TIPOSEG.StsTipoSegCot%TYPE;
cStsPlan        COTIZADOR_PLANCOB.StsPlanCot%TYPE;
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM COTIZADOR_PLANCOB
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanCot   = cStsPlan;
BEGIN
   BEGIN
      SELECT StsTipoSegCot
        INTO cStsTipoSegCot
        FROM COTIZADOR_TIPOSEG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCotizador = cCodCotizador
         AND IdTipoSeg    = cIdTipoSeg;
   END;
   IF cStsTipoSegCot = 'CONFIG' THEN
      cStsPlan := 'CONFIG';
      FOR X IN PLAN_Q LOOP
         GT_COTIZADOR_PLANCOB.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, X.PlanCob);
      END LOOP;
   ELSE
      cStsPlan := 'SUSPEN';
      FOR X IN PLAN_Q LOOP
         GT_COTIZADOR_PLANCOB.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, X.PlanCob);
      END LOOP;
   END IF;

   UPDATE COTIZADOR_TIPOSEG
      SET StsTipoSegCot = 'SUSPEN'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2) IS
cStsTipoSegCot  COTIZADOR_TIPOSEG.StsTipoSegCot%TYPE;
cStsPlan        COTIZADOR_PLANCOB.StsPlanCot%TYPE;
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM COTIZADOR_PLANCOB
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanCot   = cStsPlan;
BEGIN
   BEGIN
      SELECT StsTipoSegCot
        INTO cStsTipoSegCot
        FROM COTIZADOR_TIPOSEG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCotizador = cCodCotizador
         AND IdTipoSeg    = cIdTipoSeg;
   END;
   IF cStsTipoSegCot = 'CONFIG' THEN
      cStsPlan := 'CONFIG';
      FOR X IN PLAN_Q LOOP
         GT_COTIZADOR_PLANCOB.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, X.PlanCob);
      END LOOP;
   ELSE
      cStsPlan := 'SUSPEN';
      FOR X IN PLAN_Q LOOP
         GT_COTIZADOR_PLANCOB.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, X.PlanCob);
      END LOOP;
   END IF;
   UPDATE COTIZADOR_TIPOSEG
      SET StsTipoSegCot = 'ACTIVO'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND IdTipoSeg    = cIdTipoSeg;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER,  nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO COTIZADOR_TIPOSEG
                 (CodCia, CodEmpresa, CodCotizador, IdTipoSeg,
                  FecAlta, StsTipoSegCot, FecStatus, CodUsuario)
           SELECT nCodCia, CodEmpresa, cCodCotizadorDest, IdTipoSeg,
                  FecAlta, 'CONFIG', TRUNC(SYSDATE), USER
             FROM COTIZADOR_TIPOSEG
            WHERE CodCia        = nCodCia
              AND CodEmpresa    = nCodEmpresa
              AND CodCotizador  = cCodCotizadorOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de COTIZADOR_TIPOSEG  '|| SQLERRM );
   END;
END COPIAR;

PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2,
                  cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2) IS
cStsCotizador   COTIZADOR_CONFIG.StsCotizador%TYPE;
BEGIN
   BEGIN
      SELECT StsCotizador
        INTO cStsCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCotizador = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20220,'No existe el Cotizador '|| cCodCotizador);
   END;
   BEGIN
      INSERT INTO COTIZADOR_TIPOSEG
             (CodCia, CodEmpresa, CodCotizador, IdTipoSeg,
              FecAlta, StsTipoSegCot, FecStatus, CodUsuario)
      VALUES (nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSegDest,
              TRUNC(SYSDATE), cStsCotizador, TRUNC(SYSDATE), USER);
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar el Insert en COTIZADOR_TIPOSEG  '|| SQLERRM );
   END;
END AGREGAR;

FUNCTION ASIGNADO_A_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cIdTipoSeg VARCHAR2)  RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZADOR_TIPOSEG TS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador != cCodCotizador
         AND IdTipoSeg     = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;

   -- Se determina si Aun Tiene Planes de Coberturas Pendientes de Asignar
   IF cExiste = 'S' THEN
      BEGIN
         SELECT 'N'
           INTO cExiste
           FROM PLAN_COBERTURAS PC
          WHERE PC.CodCia       = nCodCia
            AND PC.CodEmpresa   = nCodEmpresa
            AND PC.IdTipoSeg    = cIdTipoSeg
            AND NOT EXISTS (SELECT 'S'
                              FROM COTIZADOR_PLANCOB
                             WHERE CodCia     = PC.CodCia
                               AND CodEmpresa = PC.CodEmpresa
                               AND IdTipoSeg  = PC.IdTipoSeg
                               AND PlanCob    = PC.PlanCob);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste  := 'S';
         WHEN TOO_MANY_ROWS THEN
            cExiste  := 'N';
      END;
   END IF;

   RETURN(cExiste);
END ASIGNADO_A_COTIZADOR;

FUNCTION EXISTEN_TIPOS_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZADOR_TIPOSEG
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
END EXISTEN_TIPOS_DE_SEGURO;

END GT_COTIZADOR_TIPOSEG;
/

--
-- GT_COTIZADOR_TIPOSEG  (Synonym) 
--
--  Dependencies: 
--   GT_COTIZADOR_TIPOSEG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_COTIZADOR_TIPOSEG FOR SICAS_OC.GT_COTIZADOR_TIPOSEG
/


GRANT EXECUTE ON SICAS_OC.GT_COTIZADOR_TIPOSEG TO PUBLIC
/
