--
-- OC_TARIFA_SEXO_EDAD_RIESGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   TARIFA_SEXO_EDAD_RIESGO (Table)
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TARIFA_SEXO_EDAD_RIESGO IS

  FUNCTION PRIMA_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                        cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2,
                        nSumaAsegurada NUMBER, nIdTarifa NUMBER) RETURN NUMBER;

  FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                          cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER;

  FUNCTION TASA_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                       cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER;

  PROCEDURE COPIAR_TARIFA_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                               cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2,
                               nIdTarifaOrig NUMBER);

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2, nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER);

  FUNCTION TASA_NIVELADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                         cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER;

  FUNCTION TASA_TARIFA_EDAD_MINIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                   cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER;

  FUNCTION PORCEN_GASTOS_ADMIN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                               cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER;

END OC_TARIFA_SEXO_EDAD_RIESGO;
/

--
-- OC_TARIFA_SEXO_EDAD_RIESGO  (Package Body) 
--
--  Dependencies: 
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TARIFA_SEXO_EDAD_RIESGO IS

FUNCTION PRIMA_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                      cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2,
                      nSumaAsegurada NUMBER, nIdTarifa NUMBER) RETURN NUMBER IS
nPrimaTarifa    TARIFA_SEXO_EDAD_RIESGO.PrimaTarifa%TYPE;
BEGIN
   BEGIN
      SELECT PrimaTarifa
        INTO nPrimaTarifa
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdad
         AND EdadFinTarifa  >= nEdad
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA')
         AND SumaAsegTarifa  = nSumaAsegurada;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Prima en Tarifa por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo ||
                                 '-' || nSumaAsegurada);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'TMR PRIMA Tarifa Mal Configurada por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo ||
                                 '-' || nSumaAsegurada||SQLERRM );
   END;
   RETURN(nPrimaTarifa);
END PRIMA_TARIFA;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                        cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER IS
nSumaAsegTarifa    TARIFA_SEXO_EDAD_RIESGO.SumaAsegTarifa%TYPE;
BEGIN
   BEGIN
      SELECT SumaAsegTarifa
        INTO nSumaAsegTarifa
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdad
         AND EdadFinTarifa  >= nEdad
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Suma Asegurada en Tarifa por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'TMR SUMA Tarifa Mal Configurada por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo|| SQLERRM );
   END;
   RETURN(nSumaAsegTarifa);
END SUMA_ASEGURADA;

FUNCTION TASA_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                     cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER IS
nTasaTarifa    TARIFA_SEXO_EDAD_RIESGO.TasaTarifa%TYPE;
BEGIN
   BEGIN
      SELECT NVL(TasaTarifa,0)
        INTO nTasaTarifa
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdad
         AND EdadFinTarifa  >= nEdad
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Tasa en Tarifa por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'TMR TASA Tarifa Mal Configurada por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo|| SQLERRM );
   END;
   RETURN(nTasaTarifa);
END TASA_TARIFA;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2,
                 nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER) IS
CURSOR COB_Q IS
   SELECT CodCobert, EdadIniTarifa, EdadFinTarifa, SexoTarifa, 
          RiesgoTarifa, SumaAsegTarifa, PrimaTarifa, TasaTarifa,
          TasaNivelada, PorcGtoAdmin
     FROM TARIFA_SEXO_EDAD_RIESGO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig
      AND IdTarifa   = nIdTarifaOrig;
BEGIN
   FOR X IN COB_Q  LOOP
      INSERT INTO TARIFA_SEXO_EDAD_RIESGO
             (IdTarifa, CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, 
              EdadIniTarifa, EdadFinTarifa, SexoTarifa, RiesgoTarifa, 
              SumaAsegTarifa, PrimaTarifa, TasaTarifa, TasaNivelada, PorcGtoAdmin)
      VALUES (nIdTarifaDest, nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.CodCobert,
              X.EdadIniTarifa, X.EdadFinTarifa, X.SexoTarifa, X.RiesgoTarifa, 
              X.SumaAsegTarifa, X.PrimaTarifa, X.TasaTarifa, X.TasaNivelada, X.PorcGtoAdmin);
   END LOOP;
END COPIAR;

PROCEDURE COPIAR_TARIFA_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                             cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2,
                             nIdTarifaOrig NUMBER) IS
nIdTarifaDest     TARIFA_SEXO_EDAD_RIESGO.IdTarifa%TYPE;

CURSOR TARIF_Q IS
   SELECT DISTINCT IdTarifa
     FROM TARIFA_SEXO_EDAD_RIESGO
    WHERE IdTarifa   = nIdTarifaOrig
      AND CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR W IN TARIF_Q LOOP
      nIdTarifaDest := GT_TARIFA_CONTROL_VIGENCIAS.NUMERO_TARIFA;
      GT_TARIFA_CONTROL_VIGENCIAS.COPIAR(W.IdTarifa, nIdTarifaDest);
   END LOOP;
END COPIAR_TARIFA_PLAN;

FUNCTION TASA_NIVELADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                      cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER IS
nTasaNivelada    TARIFA_SEXO_EDAD_RIESGO.TasaNivelada%TYPE;
BEGIN
   BEGIN
      SELECT NVL(TasaNivelada,0)
        INTO nTasaNivelada
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdad
         AND EdadFinTarifa  >= nEdad
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Tasa Nivelada en Tarifa por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'TMR TASA Tarifa Nivelada Mal Configurada por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo|| SQLERRM );
   END;
   RETURN(nTasaNivelada);
END TASA_NIVELADA;

FUNCTION TASA_TARIFA_EDAD_MINIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                 cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER IS
nTasaTarifa    TARIFA_SEXO_EDAD_RIESGO.TasaTarifa%TYPE;
nEdadMinima    TARIFA_SEXO_EDAD_RIESGO.EdadIniTarifa%TYPE;
BEGIN
   BEGIN
      SELECT MIN(NVL(EdadIniTarifa,0))
        INTO nEdadMinima
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   END;

   BEGIN
      SELECT NVL(TasaTarifa,0)
        INTO nTasaTarifa
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdadMinima
         AND EdadFinTarifa  >= nEdadMinima
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Tasa en Tarifa de Edad Mínima por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'TMR TASA Tarifa Mal Configurada de Edad Mínima por Sexo, Edad y Riesgo '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo|| SQLERRM );
   END;
   RETURN(nTasaTarifa);
END TASA_TARIFA_EDAD_MINIMA;

FUNCTION PORCEN_GASTOS_ADMIN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                      cCodCobert VARCHAR2, nEdad NUMBER, cSexo VARCHAR2, cRiesgo VARCHAR2, nIdTarifa NUMBER) RETURN NUMBER IS
nPorcGtoAdmin    TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcGtoAdmin,0)
        INTO nPorcGtoAdmin
        FROM TARIFA_SEXO_EDAD_RIESGO
       WHERE IdTarifa        = nIdTarifa
         AND CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND CodCobert       = cCodCobert
         AND EdadIniTarifa  <= nEdad
         AND EdadFinTarifa  >= nEdad
         AND SexoTarifa     IN (cSexo, 'U')
         AND RiesgoTarifa   IN (cRiesgo,'NA');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No existe Porcentaje de Gastos de Administración por Edad '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Porcentaje de Gastos de Administración por Edad Configurada '|| cIdTipoSeg || '-' ||
                                 cPlanCob || '-'|| cCodCobert || '-' || nEdad || '-' || cSexo || '-' || cRiesgo|| SQLERRM );
   END;
   RETURN(nPorcGtoAdmin);
END PORCEN_GASTOS_ADMIN;

END OC_TARIFA_SEXO_EDAD_RIESGO;
/
