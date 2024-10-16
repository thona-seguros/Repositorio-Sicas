--
-- GT_COTIZACIONES_CLAUSULAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   COTIZACIONES (Table)
--   COTIZACIONES_CLAUSULAS (Table)
--   CLAUSULAS_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES_CLAUSULAS IS

  PROCEDURE RECOTIZACION_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  PROCEDURE CREAR_CLAUSULAS_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);
  
END GT_COTIZACIONES_CLAUSULAS;
/

--
-- GT_COTIZACIONES_CLAUSULAS  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZACIONES_CLAUSULAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES_CLAUSULAS IS

PROCEDURE RECOTIZACION_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR DET_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, CodClausula
     FROM COTIZACIONES_CLAUSULAS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN DET_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_CLAUSULAS
                (CodCia, CodEmpresa, IdCotizacion, CodClausula)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.CodClausula);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicada Cl�usula de Cotizaci�n No. ' || nIdReCotizacion);
      END;
   END LOOP;
END RECOTIZACION_CLAUSULAS;

PROCEDURE CREAR_CLAUSULAS_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER) IS

nCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE;
   
CURSOR COTCLA_Q IS
   SELECT L.CodClausula TipoClausula, L.TextoClausula,
          --L.CodClausula, '0000' TipoClausula, L.TextoClausula,
          C.FecIniVigCot, C.FecFinVigCot
     FROM COTIZACIONES_CLAUSULAS L,
          COTIZACIONES C
    WHERE L.CodCia       = C.CodCia
      AND L.CodEmpresa   = C.CodEmpresa
      AND L.IdCotizacion = C.IdCotizacion
      AND C.CodCia       = nCodCia
      AND C.CodEmpresa   = nCodEmpresa
      AND C.IdCotizacion = nIdCotizacion;
BEGIN
   nCodClausula := 0;
   FOR X IN COTCLA_Q LOOP
      nCodClausula := nCodClausula + 1;

      INSERT INTO CLAUSULAS_POLIZA
            (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula, Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
      VALUES(nCodCia, nIdPoliza, nCodClausula, X.TipoClausula, X.TextoClausula, X.FecIniVigCot, X.FecFinVigCot, 'SOL');
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear las Coberturas '||SQLERRM);
END CREAR_CLAUSULAS_POL;

END GT_COTIZACIONES_CLAUSULAS;
/
