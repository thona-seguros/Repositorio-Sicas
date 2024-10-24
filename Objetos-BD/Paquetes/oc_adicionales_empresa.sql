CREATE OR REPLACE PACKAGE SICAS_OC.OC_ADICIONALES_EMPRESA IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : OC CONSULTORES                                                                                                   |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ??                                                                                                               |    
    | Nombre     : OC_ADICIONALES_EMPRESA                                                                                           |
    | Versión    : v2 [ Modificada en Jun 2021 ]                                                                                    |
    | Objetivo   : Package que obtiene los datos adicionales de la Empresa tales como: Rurtas de Logo y Firmantes, Num. telefonicos,|
    |              textos adicionales, etc.                                                                                         |
    |                                                                                                                               |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 18/06/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
    | Obj. Modif.: Se agreg0 funcion que obtiene la ruta de firma para Carta de bienvenida del agente para platasforma Digital.     |
    |               - RUTA_FIRMA_CBA                                                                                                |
    |                                                                                                                               |
    |   DEPENDENCIAS:                                                                                                               |
    |               STANDARD            (Package)                                                                                   |
    |               STANDARD            (Package)                                                                                   |
    |               DBMS_STANDARD       (Package)                                                                                   |
    |               ADICIONALES_EMPRESA (Table)                                                                                     |
    |_______________________________________________________________________________________________________________________________|
*/ 

  FUNCTION NOMBRE_FIRMA(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION DEPARTAMENTO_FIRMA(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION PUESTO_FIRMANTE(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION NOMBRE_FIRMANTE(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION RUTA_FIRMA(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION NUMERO_TELEFONO(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION EXTENSION_TELEFONICA(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION TEXTO_ENCABEZADO(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION TEXTO_PIE_PAGINA(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION TEXTO_TELEFONO(nCodCia NUMBER) RETURN VARCHAR2;

  FUNCTION RUTA_LOGOTIPO(nCodCia NUMBER) RETURN VARCHAR2;
  
  FUNCTION RUTA_CEDULA(nCodCia NUMBER) RETURN VARCHAR2;
  
  FUNCTION RUTA_PIE_PAG(nCodCia NUMBER) RETURN VARCHAR2;
  
  FUNCTION RUTA_DIRECCION(nCodCia NUMBER) RETURN VARCHAR2;   --LARPLA
 
  FUNCTION RUTA_LOGOTIPO_ADICIONAL(nCodCia NUMBER) RETURN VARCHAR2;  --LARPLA
  
  FUNCTION RUTA_FIRMA_CBA(nCodCia NUMBER) RETURN VARCHAR2;

END OC_ADICIONALES_EMPRESA;
/

--
-- OC_ADICIONALES_EMPRESA  (Package Body) 
--
--  Dependencies: 
--   OC_ADICIONALES_EMPRESA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ADICIONALES_EMPRESA IS
--
-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCIONALIDA DE LARGO PLAZO                              JICO 10/04/2019  LARPLA
--
FUNCTION NOMBRE_FIRMA(nCodCia NUMBER) RETURN VARCHAR2 IS
cNombre_Firma   ADICIONALES_EMPRESA.Nombre_Firma%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Nombre_Firma
        INTO cNombre_Firma
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cNombre_Firma);
END NOMBRE_FIRMA;

FUNCTION DEPARTAMENTO_FIRMA(nCodCia NUMBER) RETURN VARCHAR2 IS
cDepartamento_Firma   ADICIONALES_EMPRESA.Departamento_Firma%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Departamento_Firma
        INTO cDepartamento_Firma
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cDepartamento_Firma);
END DEPARTAMENTO_FIRMA;

FUNCTION PUESTO_FIRMANTE(nCodCia NUMBER) RETURN VARCHAR2 IS
cPuesto_Firmante   ADICIONALES_EMPRESA.Puesto_Firmante%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Puesto_Firmante
        INTO cPuesto_Firmante
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPuesto_Firmante);
END PUESTO_FIRMANTE;

FUNCTION NOMBRE_FIRMANTE(nCodCia NUMBER) RETURN VARCHAR2 IS
cNombre_Firmante   ADICIONALES_EMPRESA.Nombre_Firmante%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Nombre_Firmante
        INTO cNombre_Firmante
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cNombre_Firmante);
END NOMBRE_FIRMANTE;

FUNCTION RUTA_FIRMA(nCodCia NUMBER) RETURN VARCHAR2 IS
cPath_Firma   ADICIONALES_EMPRESA.Path_Firma%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Path_Firma
        INTO cPath_Firma
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPath_Firma);
END RUTA_FIRMA;

FUNCTION NUMERO_TELEFONO(nCodCia NUMBER) RETURN VARCHAR2 IS
cNum_Telefono   ADICIONALES_EMPRESA.Num_Telefono%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Num_Telefono
        INTO cNum_Telefono
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cNum_Telefono);
END NUMERO_TELEFONO;

FUNCTION EXTENSION_TELEFONICA(nCodCia NUMBER) RETURN VARCHAR2 IS
cExt_Telefono   ADICIONALES_EMPRESA.Ext_Telefono%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Ext_Telefono
        INTO cExt_Telefono
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cExt_Telefono);
END EXTENSION_TELEFONICA;

FUNCTION TEXTO_ENCABEZADO(nCodCia NUMBER) RETURN VARCHAR2 IS
cTxt_Encabezado_Pagina   ADICIONALES_EMPRESA.Txt_Encabezado_Pagina%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Txt_Encabezado_Pagina
        INTO cTxt_Encabezado_Pagina
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cTxt_Encabezado_Pagina);
END TEXTO_ENCABEZADO;

FUNCTION TEXTO_PIE_PAGINA(nCodCia NUMBER) RETURN VARCHAR2 IS
cTxt_Pie_Pagina   ADICIONALES_EMPRESA.Txt_Pie_Pagina%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Txt_Pie_Pagina
        INTO cTxt_Pie_Pagina
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cTxt_Pie_Pagina);
END TEXTO_PIE_PAGINA;

FUNCTION TEXTO_TELEFONO(nCodCia NUMBER) RETURN VARCHAR2 IS
cTxt_ComTel   ADICIONALES_EMPRESA.Txt_ComTel%TYPE := NULL;
BEGIN
   BEGIN
      SELECT Txt_ComTel
        INTO cTxt_ComTel
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cTxt_ComTel);
END TEXTO_TELEFONO;

FUNCTION RUTA_LOGOTIPO(nCodCia NUMBER) RETURN VARCHAR2 IS
cPathLogoRep   ADICIONALES_EMPRESA.PathLogoRep%TYPE := NULL;
BEGIN
   BEGIN
      SELECT PathLogoRep
        INTO cPathLogoRep
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPathLogoRep);
END RUTA_LOGOTIPO;

FUNCTION RUTA_CEDULA(nCodCia NUMBER) RETURN VARCHAR2 IS
    cPathCedulaFiscal   ADICIONALES_EMPRESA.PathCedulaFiscal%TYPE := NULL;
BEGIN
   BEGIN
      SELECT PathCedulaFiscal
        INTO cPathCedulaFiscal
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPathCedulaFiscal);
END RUTA_CEDULA;

FUNCTION RUTA_PIE_PAG(nCodCia NUMBER) RETURN VARCHAR2 IS
cImagenPiePaginaReporte ADICIONALES_EMPRESA.ImagenPiePaginaReporte%TYPE;
BEGIN
   BEGIN
      SELECT ImagenPiePaginaReporte
        INTO cImagenPiePaginaReporte
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN cImagenPiePaginaReporte;
END RUTA_PIE_PAG;

FUNCTION RUTA_DIRECCION(nCodCia NUMBER) RETURN VARCHAR2 IS   ----LARPLA INICIO
cPATH_DIRECCION   ADICIONALES_EMPRESA.PATH_DIRECCION%TYPE := NULL;
BEGIN
   BEGIN
      SELECT A.PATH_DIRECCION
        INTO cPATH_DIRECCION
        FROM ADICIONALES_EMPRESA A
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPATH_DIRECCION);
END RUTA_DIRECCION;

FUNCTION RUTA_LOGOTIPO_ADICIONAL(nCodCia NUMBER) RETURN VARCHAR2 IS
cPATH_LOGO_ADICIONAL   ADICIONALES_EMPRESA.PATH_LOGO_ADICIONAL_1%TYPE := NULL;
BEGIN
   BEGIN
      SELECT A.PATH_LOGO_ADICIONAL_1
        INTO cPATH_LOGO_ADICIONAL
        FROM ADICIONALES_EMPRESA A
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración de Parámetros Adicionales de la Empresa: '|| nCodCia);
   END;
   RETURN(cPATH_LOGO_ADICIONAL);
END RUTA_LOGOTIPO_ADICIONAL;  ----LARPLA FIN

FUNCTION RUTA_FIRMA_CBA(nCodCia NUMBER) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 18/06/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
    | Nombre     : RUTA_FIRMA_CBA                                                                                                   |
    | Objetivo   : Funcion que obtiene la Ruta donde se encuentra la firma (Digitalizada) para la Carta de bienvenida del agente    |
    |              en Plataforma Digital.                                                                                           |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compańia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nCodAgente			Numero o Codigo del Agente  (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/ 
cPath_Firma_CBA   ADICIONALES_EMPRESA.PathFirma_CBA%TYPE := NULL;

BEGIN
   BEGIN
      SELECT PathFirma_CBA
        INTO cPath_Firma_CBA
        FROM ADICIONALES_EMPRESA
       WHERE nCodCia    = nCodCia
         AND Correlativo IN (SELECT MAX(Correlativo)
                               FROM ADICIONALES_EMPRESA
                              WHERE CodCia  = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe la Configuración del parametro de Firma para Carta de Bienvenida del Agente de la Empresa: '|| nCodCia);
   END;
   RETURN(cPath_Firma_CBA);
END RUTA_FIRMA_CBA;

END OC_ADICIONALES_EMPRESA;
/
