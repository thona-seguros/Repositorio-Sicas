--
-- GT_FAI_TASAS_DE_INTERES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CONFIG_TASAS_FONDOS (Table)
--   FAI_PRECIOS_DIARIOS (Table)
--   FAI_TASAS_DE_INTERES (Table)
--   GT_FAI_PRECIOS_DIARIOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_TASAS_DE_INTERES AS

FUNCTION TASA_INTERES (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER;

FUNCTION TASA_CLIENTES (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER;

FUNCTION TASA_EMPRESA (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER;

END GT_FAI_TASAS_DE_INTERES;
/

--
-- GT_FAI_TASAS_DE_INTERES  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_TASAS_DE_INTERES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_TASAS_DE_INTERES AS

FUNCTION TASA_INTERES (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER IS
nTasaInteres       FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nTasaReferencia    FAI_TASAS_DE_INTERES.TasaReferencia%TYPE;
cTipoConfig        FAI_CONFIG_TASAS_FONDOS.TipoConfig%TYPE;
nFactorAjuste      FAI_CONFIG_TASAS_FONDOS.FactorAjuste%TYPE;
nPrecioAyer        FAI_PRECIOS_DIARIOS.PrecioDiario%TYPE;
nPrecioHoy         FAI_PRECIOS_DIARIOS.PrecioDiario%TYPE;

BEGIN
   BEGIN
      SELECT TasaReferencia, TasaInteres
        INTO nTasaReferencia, nTasaInteres
        FROM FAI_TASAS_DE_INTERES
       WHERE TipoInteres = cTipoInteres
         AND (FecIniVig, FecFinVig) IN 
             (SELECT MAX(FecIniVig), MAX(FecFinVig)
                FROM FAI_TASAS_DE_INTERES
               WHERE TipoInteres = cTipoInteres
                 AND FecIniVig   <= TRUNC(dFecAplica)
                 AND FecFinVig   >= TRUNC(dFecAplica));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No existe ls Tasa de Interés '||cTipoInteres||
                                        ' para la Fecha: '||TO_DATE(dFecAplica,'DD/MM/YYYY'));
   END;
   IF cTipoFondo IS NOT NULL THEN
      BEGIN
         SELECT TipoConfig, FactorAjuste
           INTO cTipoConfig, nFactorAjuste
           FROM FAI_CONFIG_TASAS_FONDOS
          WHERE TipoFondo  = cTipoFondo
            AND FecIniConf <= TRUNC(dFecAplica)
            AND FecFinConf >= TRUNC(dFecAplica);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cTipoConfig   := 'SA';
            nFactorAjuste := 0;
      END;
      IF NVL(nTasaReferencia,0) <> 0 THEN
         IF cTipoConfig = 'PB' THEN  -- Puntos Base
            nTasaInteres := ((1 + (NVL(nTasaReferencia,0)/100)) / (1 + (nFactorAjuste/10000)) - 1);
         ELSIF cTipoConfig = 'PC' THEN -- Porcentaje
            nTasaInteres := (NVL(nTasaReferencia,0) / 100) * (nFactorAjuste / 100);
         ELSIF cTipoConfig = 'RP' THEN -- Resta Puntos Base
            nTasaInteres := (NVL(nTasaReferencia,0) / 100) - (NVL(nFactorAjuste,0) / 10000);
         ELSIF cTipoConfig = 'DI' THEN -- Diario
            nTasaInteres := (NVL(nTasaReferencia,0) / 100) - (NVL(nFactorAjuste,0) / 3650000);
         ELSIF cTipoConfig = 'PD' THEN -- Precio Diario
            nPrecioAyer   := NVL(GT_FAI_PRECIOS_DIARIOS.PRECIO(cTipoInteres, dFecAplica - 1),0);
            nPrecioHoy    := NVL(GT_FAI_PRECIOS_DIARIOS.PRECIO(cTipoInteres, dFecAplica),0);
            nTasaInteres  := (nPrecioHoy / nPrecioAyer) - 1;
         ELSE -- Sin Ajuste
            nTasaInteres := NVL(nTasaReferencia,0) / 100;
         END IF;
      ELSE
         IF cTipoConfig = 'DI' THEN
            nTasaInteres := (NVL(nTasaInteres,0) / 100) - (NVL(nFactorAjuste,0) / 3600000);
         ELSE
            nTasaInteres := nTasaInteres;
         END IF;
      END IF;
      RETURN(NVL(nTasaInteres,0));
   ELSE
      RETURN(NVL(nTasaReferencia,0));
   END IF;
END TASA_INTERES;

FUNCTION TASA_CLIENTES (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER IS
nTasaReferencia    FAI_TASAS_DE_INTERES.TasaReferencia%TYPE;
BEGIN
   BEGIN
      SELECT TasaReferencia
        INTO nTasaReferencia
        FROM FAI_TASAS_DE_INTERES
       WHERE TipoInteres = cTipoInteres
         AND (FecIniVig, FecFinVig) IN 
             (SELECT MAX(FecIniVig), MAX(FecFinVig)
                FROM FAI_TASAS_DE_INTERES
               WHERE TipoInteres = cTipoInteres
                 AND FecIniVig   <= TRUNC(dFecAplica)
                 AND FecFinVig   >= TRUNC(dFecAplica));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No existe ls Tasa de Interés para Clientes '||cTipoInteres||
                                        ' para la Fecha: '||TO_DATE(dFecAplica,'DD/MM/YYYY'));
   END;
   RETURN(NVL(nTasaReferencia,0));
END TASA_CLIENTES;

FUNCTION TASA_EMPRESA (cTipoInteres VARCHAR2, cTipoFondo VARCHAR2, dFecAplica DATE) RETURN NUMBER IS
nTasaInteres       FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
BEGIN
   BEGIN
      SELECT TasaInteres
        INTO nTasaInteres
        FROM FAI_TASAS_DE_INTERES
       WHERE TipoInteres = cTipoInteres
         AND (FecIniVig, FecFinVig) IN 
             (SELECT MAX(FecIniVig), MAX(FecFinVig)
                FROM FAI_TASAS_DE_INTERES
               WHERE TipoInteres = cTipoInteres
                 AND FecIniVig   <= TRUNC(dFecAplica)
                 AND FecFinVig   >= TRUNC(dFecAplica));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No existe ls Tasa de Interés para Clientes '||cTipoInteres||
                                        ' para la Fecha: '||TO_DATE(dFecAplica,'DD/MM/YYYY'));
   END;
   RETURN(NVL(nTasaInteres,0));
END TASA_EMPRESA;

END GT_FAI_TASAS_DE_INTERES;
/

--
-- GT_FAI_TASAS_DE_INTERES  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_TASAS_DE_INTERES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_TASAS_DE_INTERES FOR SICAS_OC.GT_FAI_TASAS_DE_INTERES
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_TASAS_DE_INTERES TO PUBLIC
/
