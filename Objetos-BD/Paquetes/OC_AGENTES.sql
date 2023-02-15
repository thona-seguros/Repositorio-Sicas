CREATE OR REPLACE PACKAGE          OC_AGENTES IS
  FUNCTION NOMBRE_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2;
  FUNCTION AUXILIAR_CONTABLE(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER;
  FUNCTION DIRECCION_AGENTE(nCodAgente NUMBER) RETURN VARCHAR2;
  FUNCTION NIVEL_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER;
  FUNCTION TIPO_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2;
  FUNCTION EJECUTIVO_COMERCIAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER;
  FUNCTION ES_AGENTE(cTipoDocIdentEmp VARCHAR2, 
                     cNumDocIdentEmp  VARCHAR2) RETURN VARCHAR2;

--
  FUNCTION FIND_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER;
  FUNCTION FIND_TPO_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2;
  FUNCTION FIND_REGIONAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER;
  FUNCTION FIND_TPO_REGIONAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2;   
  FUNCTION FIND_CODCPTO_DR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER)  RETURN VARCHAR2;
  FUNCTION FIND_CODCPTO_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER)  RETURN VARCHAR2;
  FUNCTION FIND_MNTOCOMI_DR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER;
  FUNCTION FIND_MNTOCOMI_PROMTR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER;
  FUNCTION ES_AGENTE_DIRECTO(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2;
  --
  PROCEDURE ESTRUCTURA_AGENTE( nCodCia        IN  AGENTES.CodCia%TYPE
                             , nCodEmpresa    IN  AGENTES.CodEmpresa%TYPE
                             , nCodAgente1    IN  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct1  OUT  AGENTES.CODNIVEL%TYPE
                             , nCodAgente2   OUT  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct2  OUT  AGENTES.CODNIVEL%TYPE
                             , nCodAgente3   OUT  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct3  OUT  AGENTES.CODNIVEL%TYPE );

END OC_AGENTES;

/

CREATE OR REPLACE PACKAGE BODY          oc_agentes IS
--
-- BITACORA DE CAMBIO
-- CAMBIO - SE AGREGO LA FUNCION ES_AGENTE   JICO 20170518  LAVADO DE DINERO

FUNCTION DIRECCION_AGENTE(nCodAgente NUMBER) RETURN VARCHAR2 IS
cDireccion  VARCHAR2(2000);
BEGIN
   BEGIN
      SELECT  TRIM(PNJ.DirecRes)||' '||TRIM(NumExterior)||' ' ||DECODE(NumInterior, NULL, NULL, 'Interior') ||' '||TRIM(NumInterior)||' '
              || TRIM (OC_COLONIA.DESCRIPCION_COLONIA(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrres, PNJ.CodPosRes, CodColRes))
              ||', '||TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.CodPaisRes, PNJ.CodProvRes))
              ||', '||TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrRes)) 
              ||', CP '|| TRIM(PNJ.CodPosRes)
        INTO cDireccion
        FROM AGENTES AGE, PERSONA_NATURAL_JURIDICA PNJ
       WHERE AGE.TIPO_DOC_IDENTIFICACION = PNJ.TIPO_DOC_IDENTIFICACION
         AND AGE.NUM_DOC_IDENTIFICACION  = PNJ.NUM_DOC_IDENTIFICACION
         AND AGE.COD_Agente = nCodAgente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDireccion  := ' NO VALIDA';
   END;
  RETURN UPPER(TRIM(cDireccion));
END DIRECCION_AGENTE;

FUNCTION NOMBRE_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2 IS
cNombre   PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
BEGIN
   BEGIN
      SELECT Nombre||' '||Apellido_paterno||' '||Apellido_Materno
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA PNJ, AGENTES AG
       WHERE PNJ.TIPO_DOC_IDENTIFICACION = AG.TIPO_DOC_IDENTIFICACION
         AND PNJ.NUM_DOC_IDENTIFICACION = AG.NUM_DOC_IDENTIFICACION
         AND AG.CODCIA = nCodCia
         AND AG.COD_AGENTE = cCodAgente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'NO TIENE JEFE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Agente ' || cCodAgente || ' Duplicada ');
   END;
   RETURN(cNombre);
END NOMBRE_AGENTE;

FUNCTION AUXILIAR_CONTABLE(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS
nAuxContable    PERSONA_NATURAL_JURIDICA.AuxContable%TYPE;
BEGIN
   BEGIN
      SELECT AuxContable
        INTO nAuxContable
        FROM AGENTES AGE, PERSONA_NATURAL_JURIDICA PNJ
       WHERE AGE.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND AGE.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND AGE.Cod_Agente              = cCodAgente
         AND AGE.CodCia                  = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(nAuxContable);
END AUXILIAR_CONTABLE;

FUNCTION NIVEL_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS
nCodNivel    AGENTES.CodNivel%TYPE;
BEGIN
   BEGIN
      SELECT CodNivel
        INTO nCodNivel
        FROM AGENTES
       WHERE Cod_Agente  = cCodAgente
         AND CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(nCodNivel);
END NIVEL_AGENTE;

FUNCTION TIPO_AGENTE(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2 IS
cCodTipo    AGENTES.CodTipo%TYPE;
BEGIN
   BEGIN
      SELECT CodTipo
        INTO cCodTipo
        FROM AGENTES
       WHERE Cod_Agente  = cCodAgente
         AND CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(cCodTipo);
END TIPO_AGENTE;

FUNCTION EJECUTIVO_COMERCIAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS
nCodEjecutivo    AGENTES.CodEjecutivo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CodEjecutivo,0)
        INTO nCodEjecutivo
        FROM AGENTES
       WHERE Cod_Agente  = cCodAgente
         AND CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(nCodEjecutivo);
END EJECUTIVO_COMERCIAL;

FUNCTION ES_AGENTE(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2 IS
cESAGENTE     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cESAGENTE
        FROM AGENTES
       WHERE TIPO_DOC_IDENTIFICACION   = cTipoDocIdentEmp
         AND NUM_DOC_IDENTIFICACION    = cNumDocIdentEmp;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cESAGENTE := 'N';
      WHEN TOO_MANY_ROWS THEN
         cESAGENTE := 'S';
   END;

   RETURN(cESAGENTE);
END ES_AGENTE;


/*FUNCTION FIND_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS

CODIGO_PROMOTOR AGENTES.cod_agente_jefe%TYPE;
BEGIN
   BEGIN
      SELECT 
        CASE                
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(1,AGE.cod_agente_jefe))  = 2 THEN AGE.cod_agente_jefe
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(1,AGE.cod_agente_jefe))  != 2 THEN NULL
        END       
        INTO CODIGO_PROMOTOR
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         CODIGO_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;

   DBMS_OUTPUT.PUT_LINE('CODIGO_PROMOTOR  '||CODIGO_PROMOTOR);

   RETURN(CODIGO_PROMOTOR);
END FIND_PROMOTOR;*/
FUNCTION FIND_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS

CODIGO_PROMOTOR AGENTES.cod_agente_jefe%TYPE;
BEGIN
   BEGIN
      SELECT 
       CASE                
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 2 THEN AGE.cod_agente_jefe
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 2 THEN NULL
        END       
        INTO CODIGO_PROMOTOR
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         CODIGO_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(CODIGO_PROMOTOR);
END FIND_PROMOTOR;

FUNCTION FIND_TPO_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2 IS
cCodTipo         AGENTES.CodTipo%TYPE;
TIPO_DE_PROMOTOR AGENTES.CodTipo%TYPE;

BEGIN
   BEGIN
     SELECT 
      CASE                
       WHEN AGE.cod_agente_jefe IS NOT NULL AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 2 THEN  (Select CODTIPO from agentes where COD_AGENTE = AGE.cod_agente_jefe)
       WHEN AGE.cod_agente_jefe IS NOT NULL AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 2 THEN NULL
      END     
        INTO TIPO_DE_PROMOTOR
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         TIPO_DE_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         TIPO_DE_PROMOTOR := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(TIPO_DE_PROMOTOR);
END FIND_TPO_PROMOTOR;


FUNCTION FIND_REGIONAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN NUMBER IS

CODIGO_REGIONAL AGENTES.cod_agente_jefe%TYPE;
BEGIN
   BEGIN
      SELECT 
       CASE
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 1 THEN AGE.cod_agente_jefe                              
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) = 1 then (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 1 THEN NULL  
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) != 1 then NULL
       END        
        INTO CODIGO_REGIONAL
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_REGIONAL := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         CODIGO_REGIONAL := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(CODIGO_REGIONAL);
END FIND_REGIONAL;

FUNCTION FIND_TPO_REGIONAL(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2 IS
cCodTipo         AGENTES.CodTipo%TYPE;
TIPO_DE_REGIONAL AGENTES.CodTipo%TYPE;

BEGIN
   BEGIN
     SELECT 
      CASE
      WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 1 THEN (Select CODTIPO from agentes where COD_AGENTE = AGE.cod_agente_jefe)                              
      WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) = 1 then ( Select CODTIPO from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe))
      WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 1 THEN NULL  
      WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) != 1 then NULL
      END      
        INTO TIPO_DE_REGIONAL
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         TIPO_DE_REGIONAL := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         TIPO_DE_REGIONAL := NULL; --RAISE_APPLICATION_ERROR(-20225,'Codigo de Agente: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   RETURN(TIPO_DE_REGIONAL);
END FIND_TPO_REGIONAL;

FUNCTION FIND_CODCPTO_DR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
cCodTipo         AGENTES.CodTipo%TYPE;
TIPO_DE_REGIONAL AGENTES.CodTipo%TYPE;
CODCPTO_DR       DETALLE_COMISION.CODCONCEPTO%TYPE;
CODIGO_REGIONAL  AGENTES.COD_AGENTE%TYPE; 

BEGIN

   dbms_output.put_line('cCodAgente '||cCodAgente||'  nIdPoliza  '||nIdPoliza||'   nIdFactura  '||nIdFactura);

  BEGIN
      SELECT 
       CASE
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 1 THEN AGE.cod_agente_jefe                              
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) = 1 then (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 1 THEN NULL  
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) != 1 then NULL
       END        
        INTO CODIGO_REGIONAL
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_REGIONAL := NULL;  
      WHEN TOO_MANY_ROWS THEN
         CODIGO_REGIONAL := NULL;  
   END;

   dbms_output.put_line('CODIGO_REGIONAL '||CODIGO_REGIONAL);


   BEGIN
    SELECT DCO.CodConcepto INTO  CODCPTO_DR
      FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
      WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.COD_AGENTE = COM.COD_AGENTE
       AND AGE.COD_AGENTE = CODIGO_REGIONAL
       AND COM.idpoliza    = nIdPoliza
       AND COM.IdFactura   = nIdFactura
       ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
         CODCPTO_DR := NULL;  
      WHEN TOO_MANY_ROWS THEN
         CODCPTO_DR := NULL;  
   END;

   dbms_output.put_line('CODCPTO_DR  '||CODCPTO_DR);


   RETURN(CODCPTO_DR);
END FIND_CODCPTO_DR;

FUNCTION FIND_CODCPTO_PROMOTOR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS

CODIGO_PROMOTOR  AGENTES.cod_agente_jefe%TYPE;
CODCPTO_PROMOTOR       DETALLE_COMISION.CODCONCEPTO%TYPE;


BEGIN
   BEGIN
      SELECT 
       CASE                
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 2 THEN AGE.cod_agente_jefe
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 2 THEN NULL
        END       
        INTO CODIGO_PROMOTOR
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_PROMOTOR := NULL; 
      WHEN TOO_MANY_ROWS THEN
         CODIGO_PROMOTOR := NULL; 
   END;

   BEGIN
    SELECT DCO.CodConcepto INTO  CODCPTO_PROMOTOR
      FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
      WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.COD_AGENTE = COM.COD_AGENTE
       AND AGE.COD_AGENTE = CODIGO_PROMOTOR
       AND COM.idpoliza    = nIdPoliza
       AND COM.IdFactura   = nIdFactura
       ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
         CODCPTO_PROMOTOR := NULL;  
      WHEN TOO_MANY_ROWS THEN
         CODCPTO_PROMOTOR := NULL;  
   END;

   dbms_output.put_line('CODCPTO_PROMOTOR  '||CODCPTO_PROMOTOR);


   RETURN(CODCPTO_PROMOTOR);

END FIND_CODCPTO_PROMOTOR;

FUNCTION FIND_MNTOCOMI_DR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER IS

CODIGO_REGIONAL     AGENTES.cod_agente_jefe%TYPE;
MONTO_COMISION_DR   COMISIONES.COMISION_MONEDA%TYPE;

BEGIN
   BEGIN
      SELECT 
       CASE
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 1 THEN AGE.cod_agente_jefe                              
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) = 1 then (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)
        WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 1 THEN NULL  
        WHEN (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe) is not null  AND  ( Select CODNIVEL from Agentes where COD_AGENTE = (Select cod_agente_jefe from agentes where COD_AGENTE = AGE.cod_agente_jefe)) != 1 then NULL
       END        
        INTO CODIGO_REGIONAL
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_REGIONAL := NULL; 
      WHEN TOO_MANY_ROWS THEN
         CODIGO_REGIONAL := NULL; 
   END;

   BEGIN
          SELECT NVL(SUM(C.Comision_Moneda),0) 
          INTO MONTO_COMISION_DR
          FROM COMISIONES C
         WHERE C.Cod_Agente   = CODIGO_REGIONAL
           AND C.CodCia       = nCodCia
           AND C.IdPoliza     = nIdPoliza
           AND C.IdFactura    = nIdFactura           
           AND C.ESTADO       <> 'ANU';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         MONTO_COMISION_DR := NULL; 
      WHEN TOO_MANY_ROWS THEN
         MONTO_COMISION_DR := NULL; 
   END;

   RETURN(MONTO_COMISION_DR);
END FIND_MNTOCOMI_DR;




FUNCTION FIND_MNTOCOMI_PROMTR(nCodCia NUMBER, cCodAgente NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER IS


MONTO_COMISION_DR   COMISIONES.COMISION_MONEDA%TYPE;

CODIGO_PROMOTOR AGENTES.cod_agente_jefe%TYPE;
BEGIN
   BEGIN
      SELECT 
       CASE                
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  = 2 THEN AGE.cod_agente_jefe
          WHEN AGE.cod_agente_jefe IS NOT NULL  AND (oc_agentes.NIVEL_AGENTE(nCodCia,AGE.cod_agente_jefe))  != 2 THEN NULL
        END       
        INTO CODIGO_PROMOTOR
        FROM AGENTES AGE
       WHERE AGE.Cod_Agente  = cCodAgente
         AND AGE.CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CODIGO_PROMOTOR := NULL;  
      WHEN TOO_MANY_ROWS THEN
         CODIGO_PROMOTOR := NULL;  
   END;
   dbms_output.put_line('CODIGO_PROMOTOR  '||CODIGO_PROMOTOR);

   BEGIN
     SELECT NVL(SUM(C.Comision_Moneda),0) 
          INTO MONTO_COMISION_DR
          FROM COMISIONES C
         WHERE C.Cod_Agente   = CODIGO_PROMOTOR
           AND C.CodCia       = nCodCia
           AND C.IdPoliza     = nIdPoliza
           AND C.IdFactura    = nIdFactura
           AND C.ESTADO       <> 'ANU';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         MONTO_COMISION_DR := NULL; 
      WHEN TOO_MANY_ROWS THEN
         MONTO_COMISION_DR := NULL; 
   END;
   dbms_output.put_line('MONTO_COMISION_DR  '||MONTO_COMISION_DR);



   RETURN(MONTO_COMISION_DR);
END FIND_MNTOCOMI_PROMTR;

FUNCTION ES_AGENTE_DIRECTO(nCodCia NUMBER, cCodAgente NUMBER) RETURN VARCHAR2 IS
cTipo_Agente    AGENTES.Tipo_Agente%TYPE;
BEGIN
   BEGIN
      SELECT Tipo_Agente
        INTO cTipo_Agente
        FROM AGENTES
       WHERE Cod_Agente  = cCodAgente
         AND CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Tipo de Agente para Código: '||TRIM(TO_CHAR(cCodAgente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Tipo de Agente para Código: '||TRIM(TO_CHAR(cCodAgente)) || ' Duplicado');
   END;
   IF cTipo_Agente = 'DIREC' THEN
      RETURN('S');
   ELSE
      RETURN('N');
   END IF;
END ES_AGENTE_DIRECTO;

  PROCEDURE ESTRUCTURA_AGENTE( nCodCia        IN  AGENTES.CodCia%TYPE
                             , nCodEmpresa    IN  AGENTES.CodEmpresa%TYPE
                             , nCodAgente1    IN  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct1  OUT  AGENTES.CODNIVEL%TYPE
                             , nCodAgente2   OUT  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct2  OUT  AGENTES.CODNIVEL%TYPE
                             , nCodAgente3   OUT  AGENTES.Cod_Agente%TYPE
                             , nNivEstruct3  OUT  AGENTES.CODNIVEL%TYPE ) IS
   BEGIN
      SELECT A.CodNivel  , B.Cod_Agente, B.CodNivel  , C.Cod_Agente, C.CodNivel
      INTO   nNivEstruct1, nCodAgente2 , nNivEstruct2, nCodAgente3 , nNivEstruct3
      FROM   AGENTES  A
         ,   AGENTES  B
         ,   AGENTES  C
      WHERE  A.Cod_Agente    = nCodAgente1
        AND  A.CodCia        = nCodCia
        AND  A.CodEmpresa    = nCodEmpresa
        AND  B.Cod_Agente(+) = A.Cod_Agente_Jefe
        AND  B.CodCia(+)     = A.CodCia
        AND  B.CodEmpresa(+) = A.CodEmpresa
        AND  C.Cod_Agente(+) = B.Cod_Agente_Jefe
        AND  C.CodCia(+)     = B.CodCia
        AND  C.CodEmpresa(+) = B.CodEmpresa;
   EXCEPTION
   WHEN OTHERS THEN
        nNivEstruct1 := NULL;
        nCodAgente2  := NULL;
        nNivEstruct2 := NULL;
        nCodAgente3  := NULL;
        nNivEstruct3 := NULL;
   END ESTRUCTURA_AGENTE;

END OC_AGENTES;
