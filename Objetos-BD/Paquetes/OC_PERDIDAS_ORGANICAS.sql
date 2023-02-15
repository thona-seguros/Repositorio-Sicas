CREATE OR REPLACE PACKAGE OC_PERDIDAS_ORGANICAS IS

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);
  FUNCTION PORCENTAJE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                      cPlanCob VARCHAR2, cCodCobert VARCHAR2, cCodPerdOrganica VARCHAR2,
                      dFecVigencia DATE) RETURN NUMBER;
END OC_PERDIDAS_ORGANICAS;
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_PERDIDAS_ORGANICAS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR PERDORG_Q IS
   SELECT CodCobert,CodPerdOrganica, FecIniIndem, FecFinIndem, PorcenIndemnizacion
     FROM PERDIDAS_ORGANICAS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdTipoSeg   = cIdTipoSegOrig
      AND PlanCob     = cPlanCobOrig;
BEGIN
   FOR W IN PERDORG_Q LOOP
      INSERT INTO PERDIDAS_ORGANICAS
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert,
              CodPerdOrganica, FecIniIndem, FecFinIndem, PorcenIndemnizacion)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, W.CodCobert,
              W.CodPerdOrganica, W.FecIniIndem, W.FecFinIndem, W.PorcenIndemnizacion);
   END LOOP;
END COPIAR;


FUNCTION PORCENTAJE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                    cPlanCob VARCHAR2, cCodCobert VARCHAR2, cCodPerdOrganica VARCHAR2,
                    dFecVigencia DATE) RETURN NUMBER IS
nPorcenIndemnizacion   PERDIDAS_ORGANICAS.PorcenIndemnizacion%TYPE;
BEGIN
   BEGIN
      SELECT PorcenIndemnizacion
        INTO nPorcenIndemnizacion
        FROM PERDIDAS_ORGANICAS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND CodPerdOrganica = cCodPerdOrganica
         AND FecIniIndem    >= dFecVigencia
         AND FecFinIndem    <= dFecVigencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenIndemnizacion := 0;
   END;
   RETURN(nPorcenIndemnizacion);
END PORCENTAJE;

END OC_PERDIDAS_ORGANICAS;
