--
-- OC_TRIANGULOS_SINIESTROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   TRIANGULOS_SINIESTROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TRIANGULOS_SINIESTROS IS
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, nIdSiniestro NUMBER, dFecOcurr DATE, 
                     dFecNotif DATE, nMtoSiniestro NUMBER);
END OC_TRIANGULOS_SINIESTROS;
/

--
-- OC_TRIANGULOS_SINIESTROS  (Package Body) 
--
--  Dependencies: 
--   OC_TRIANGULOS_SINIESTROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TRIANGULOS_SINIESTROS IS

PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, nIdSiniestro NUMBER, dFecOcurr DATE, 
                   dFecNotif DATE, nMtoSiniestro NUMBER) IS
BEGIN
   INSERT INTO TRIANGULOS_SINIESTROS
          (CodCia, IdTriangulo, IdSiniestro, FecOcurr, FecNotif, MtoSiniestro) 
   VALUES (nCodCia, nIdTriangulo, nIdSiniestro, dFecOcurr, dFecNotif, nMtoSiniestro);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      NULL;
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Insertar en TRIANGULOS_SINIESTROS IdTriangulo '|| nIdTriangulo ||
                              ' y Siniestro No. ' || nIdSiniestro);
END INSERTAR;

END OC_TRIANGULOS_SINIESTROS;
/
