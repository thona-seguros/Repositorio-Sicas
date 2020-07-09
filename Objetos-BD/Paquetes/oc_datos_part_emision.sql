--
-- OC_DATOS_PART_EMISION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   DATOS_PART_EMISION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DATOS_PART_EMISION IS

  FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                       cCodPlantilla VARCHAR2, nOrdenProceso NUMBER, cCodCampo VARCHAR2) RETURN VARCHAR2;
FUNCTION EXISTE_DATO_PARTICULAR(nCodCia NUMBER,  nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 ;
END OC_DATOS_PART_EMISION;
/

--
-- OC_DATOS_PART_EMISION  (Package Body) 
--
--  Dependencies: 
--   OC_DATOS_PART_EMISION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DATOS_PART_EMISION IS

FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                     cCodPlantilla VARCHAR2, nOrdenProceso NUMBER, cCodCampo VARCHAR2) RETURN VARCHAR2 IS
cValorCampo   VARCHAR2(500);
cQuery        VARCHAR2(4000);
cCampo        VARCHAR2(30);
BEGIN
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart)) Campo
        INTO cCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla
         AND OrdenProceso = nOrdenProceso
         AND NomCampo     = cCodCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'NO Existe Campo  '|| cCodCampo || ' en Plantilla ' || cCodPlantilla ||
                                 ' para la Tabla con No. de Orden ' || nOrdenProceso);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Plantilla ' || cCodPlantilla ||
                                 ' Campo '|| cCodCampo || ' Duplicado');
   END;

   cQuery := 'SELECT ' || cCampo ||
             '  FROM DATOS_PART_EMISION ' ||
             ' WHERE CodCia   = ' || nCodCia ||
             '   AND IdPoliza = ' || nIdPoliza ||
             '   AND IDetPol  = ' || nIDetPol;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(cValorCampo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20201, SQLERRM);
END VALOR_CAMPO;
FUNCTION EXISTE_DATO_PARTICULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM DATOS_PART_EMISION
       WHERE CodCia     = nCodCia
         AND idpoliza   = nIdPoliza
         AND IDetPol    = nIDetPol;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
         RAISE_APPLICATION_ERROR(-20220,'Certificado  '|| nIDetPol || ' NO tiene Datos Particulares Cargados  ' );

      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_DATO_PARTICULAR;
END OC_DATOS_PART_EMISION;
/

--
-- OC_DATOS_PART_EMISION  (Synonym) 
--
--  Dependencies: 
--   OC_DATOS_PART_EMISION (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DATOS_PART_EMISION FOR SICAS_OC.OC_DATOS_PART_EMISION
/


GRANT EXECUTE ON SICAS_OC.OC_DATOS_PART_EMISION TO PUBLIC
/
