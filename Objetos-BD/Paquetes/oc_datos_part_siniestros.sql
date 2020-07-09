--
-- OC_DATOS_PART_SINIESTROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   DATOS_PART_SINIESTROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DATOS_PART_SINIESTROS IS

  FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdSiniestro NUMBER,
                       cCodPlantilla VARCHAR2, nOrdenProceso NUMBER, cCodCampo VARCHAR2) RETURN VARCHAR2;
  FUNCTION EXISTE_DATO_PARTICULAR(nCodCia NUMBER,  nIdPoliza NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2 ;

END OC_DATOS_PART_SINIESTROS;
/

--
-- OC_DATOS_PART_SINIESTROS  (Package Body) 
--
--  Dependencies: 
--   OC_DATOS_PART_SINIESTROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DATOS_PART_SINIESTROS IS

FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdSiniestro NUMBER,
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
             '  FROM DATOS_PART_SINIESTROS ' ||
             ' WHERE CodCia       = ' || nCodCia ||
             '   AND IdPoliza     = ' || nIdPoliza ||
             '   AND IdSiniestro  = ' || nIdSiniestro;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(cValorCampo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20201, SQLERRM);
END VALOR_CAMPO;

FUNCTION EXISTE_DATO_PARTICULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM DATOS_PART_SINIESTROS
       WHERE CodCia      = nCodCia
         AND IdPoliza    = nIdPoliza
         AND IdSiniestro = nIdSiniestro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
         RAISE_APPLICATION_ERROR(-20220,'Siniestro '|| nIdSiniestro || ' NO tiene Datos Particulares Cargados');
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_DATO_PARTICULAR;

END OC_DATOS_PART_SINIESTROS;
/

--
-- OC_DATOS_PART_SINIESTROS  (Synonym) 
--
--  Dependencies: 
--   OC_DATOS_PART_SINIESTROS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DATOS_PART_SINIESTROS FOR SICAS_OC.OC_DATOS_PART_SINIESTROS
/


GRANT EXECUTE ON SICAS_OC.OC_DATOS_PART_SINIESTROS TO PUBLIC
/
