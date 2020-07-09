--
-- OC_ACTIVIDADES_ECONOMICAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   XMLAGG (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   SYS_IXMLAGG (Function)
--   OC_VALORES_DE_LISTAS (Package)
--   ACTIVIDADES_ECONOMICAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ACTIVIDADES_ECONOMICAS IS

  FUNCTION DESCRIPCION(cCodActividad VARCHAR2) RETURN VARCHAR2;

  FUNCTION RIESGO_ACTIVIDAD(cCodActividad VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPORIESGO(cCodActividad VARCHAR2) RETURN VARCHAR2;
  
  PROCEDURE ACT_ECONOMICA_DIGITAL(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2, xDatosActE OUT XMLTYPE);

END OC_ACTIVIDADES_ECONOMICAS;
/

--
-- OC_ACTIVIDADES_ECONOMICAS  (Package Body) 
--
--  Dependencies: 
--   OC_ACTIVIDADES_ECONOMICAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ACTIVIDADES_ECONOMICAS IS

-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCION RIESGO_TIPOCLIENTE   -- JICO 20170503

FUNCTION DESCRIPCION(cCodActividad VARCHAR2) RETURN VARCHAR2 IS
cDescActividad    ACTIVIDADES_ECONOMICAS.DescActividad%TYPE;
BEGIN
   BEGIN
      SELECT DescActividad
        INTO cDescActividad
        FROM ACTIVIDADES_ECONOMICAS
       WHERE CodActividad   = cCodActividad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescActividad := 'NO EXISTE ACTIVIDAD';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Actividad Economica ' || cCodActividad || ' Duplicada ');
   END;
   RETURN(cDescActividad);
END DESCRIPCION;

FUNCTION RIESGO_ACTIVIDAD(cCodActividad VARCHAR2) RETURN VARCHAR2 IS
cRiesgoActividad    ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
BEGIN
   BEGIN
      SELECT RiesgoActividad
        INTO cRiesgoActividad
        FROM ACTIVIDADES_ECONOMICAS
       WHERE CodActividad   = cCodActividad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRiesgoActividad := 'NA';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Riesgo de Actividad Economica ' || cCodActividad || ' Duplicado');
   END;
   RETURN(cRiesgoActividad);
END RIESGO_ACTIVIDAD;

FUNCTION TIPORIESGO(cCodActividad VARCHAR2) RETURN VARCHAR2 IS
CTIPORIESGO    ACTIVIDADES_ECONOMICAS.TIPORIESGO%TYPE;
BEGIN
   BEGIN
      SELECT TIPORIESGO
        INTO CTIPORIESGO
        FROM ACTIVIDADES_ECONOMICAS 
       WHERE CODACTIVIDAD   = cCodActividad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CTIPORIESGO := 'NA';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Riesgo por Actividad Economica ' || cCodActividad || ' Duplicado');
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20220,'Riesgo por Actividad Economica ' || cCodActividad || ' Otro');
   END;
   RETURN(CTIPORIESGO);
END TIPORIESGO;

PROCEDURE ACT_ECONOMICA_DIGITAL(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2, xDatosActE OUT XMLTYPE) IS
xPrevDatActividad XMLTYPE;   
BEGIN
   BEGIN
      SELECT XMLElement("DATA",
                        XMLAGG(
                           XMLCONCAT(
                                     XMLElement("InfoActEconomica", 
                                                  XMLElement("CodActividad",CodActividad),
                                                  XMLElement("DescActividad",DescActividad),
                                                  XMLElement("RiesgoActividad",RiesgoActividad),
                                                  XMLElement("DescRiesgoAct",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TPRIESACTI',RiesgoActividad)),
                                                  XMLElement("TipoRiesgo",TipoRiesgo),
                                                  XMLElement("DescTipoRiesgo",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPOCLIE',TipoRiesgo))
                                               )
                                    )
                              ) 
                        )
        INTO xPrevDatActividad
        FROM ACTIVIDADES_ECONOMICAS
       WHERE RiesgoActividad  = NVL(cRiesgoActividad, RiesgoActividad)
         AND TipoRiesgo       = NVL(cTipoRiesgo, TipoRiesgo);
   END;
   SELECT XMLROOT (xPrevDatActividad, VERSION '1.0" encoding="UTF-8')
     INTO xDatosActE
     FROM DUAL;
END ACT_ECONOMICA_DIGITAL;

END OC_ACTIVIDADES_ECONOMICAS;
/

--
-- OC_ACTIVIDADES_ECONOMICAS  (Synonym) 
--
--  Dependencies: 
--   OC_ACTIVIDADES_ECONOMICAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ACTIVIDADES_ECONOMICAS FOR SICAS_OC.OC_ACTIVIDADES_ECONOMICAS
/


GRANT EXECUTE ON SICAS_OC.OC_ACTIVIDADES_ECONOMICAS TO PUBLIC
/
