CREATE OR REPLACE PACKAGE OC_TRIANGULOS_SINIESTROS IS
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, nIdSiniestro NUMBER, dFecOcurr DATE, 
                     dFecNotif DATE, nMtoSiniestro NUMBER);
END OC_TRIANGULOS_SINIESTROS;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TRIANGULOS_SINIESTROS IS

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
