--
-- OC_CLIENTES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   SQ_COD_CLIENTE (Sequence)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_CORREGIMIENTO (Package)
--   CLIENTES (Table)
--   OC_COLONIA (Package)
--   OC_PROVINCIA (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CLIENTES IS
  FUNCTION CODIGO_CLIENTE   (cTipo_Doc_Identificacion VARCHAR2, 
                             cNum_Doc_Identificacion  VARCHAR2) RETURN NUMBER;
  FUNCTION NOMBRE_CLIENTE   (nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION INSERTAR_CLIENTE (cTipo_Doc_Identificacion VARCHAR2, 
                             cNum_Doc_Identificacion  VARCHAR2) RETURN NUMBER;
  FUNCTION IDENTIFICACION_TRIBUTARIA(nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION AUXILIAR_CONTABLE        (nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION DIRECCION_CLIENTE        (nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION EN_LISTA_DE_REFERENCIA   (nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION CODIGO_LISTA_REFERENCIA  (nCodCliente NUMBER) RETURN VARCHAR2;
  FUNCTION ID_COD_CLIENTE RETURN NUMBER; --SEQ XDS 14/07/2016
  FUNCTION ES_CLIENTE_ALTO          (cTipoDocIdentEmp VARCHAR2, 
                                     cNumDocIdentEmp  VARCHAR2) RETURN VARCHAR2;
END OC_CLIENTES;
/

--
-- OC_CLIENTES  (Package Body) 
--
--  Dependencies: 
--   OC_CLIENTES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CLIENTES IS
--
-- BITACORA DE CAMBIO
-- CAMBIO - SE AGREGO LA FUNCION ES_CLIENTE_ALTO   JICO 20170518  LAVADO DE DINERO
--
FUNCTION CODIGO_CLIENTE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
nCodCliente   CLIENTES.CodCliente%TYPE;
BEGIN
   BEGIN
      SELECT CodCliente
        INTO nCodCliente
        FROM CLIENTES
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCodCliente := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Clientes con la Identificacion: '||
                                 TRIM(cTipo_Doc_Identificacion)||'-'||TRIM(cNum_Doc_Identificacion)|| ' !Verificar Registros!');
   END;
   RETURN(nCodCliente);
END CODIGO_CLIENTE;

FUNCTION NOMBRE_CLIENTE(nCodCliente NUMBER) RETURN VARCHAR2 IS
cNombreCliente  VARCHAR2(2000);
BEGIN
   BEGIN
      SELECT TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
             DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada)
        INTO cNombreCliente
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente = nCodCliente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombreCliente := 'CLIENTE NO VALIDO';
      WHEN TOO_MANY_ROWS THEN
         cNombreCliente := 'CLIENTE DUPLICADO';
   END;
   RETURN UPPER(TRIM(cNombreCliente));
END NOMBRE_CLIENTE;

FUNCTION INSERTAR_CLIENTE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
nCodCliente   CLIENTES.CodCliente%TYPE;
BEGIN
   BEGIN
      SELECT CodCliente
        INTO nCodCliente
        FROM CLIENTES
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCodCliente   := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe varios Clientes con el Mismo Documento de Identificación.');
   END;
   IF NVL(nCodCliente,0) = 0 THEN
/*       SELECT NVL(MAX(CodCliente),0)+1
        INTO nCodCliente
        FROM CLIENTES;
*/        
       /*Cambio de  Sequencia XDS*/
      SELECT  SQ_COD_CLIENTE.NEXTVAL
          INTO nCodCliente
          FROM DUAL;


      BEGIN
         INSERT INTO CLIENTES
               (CodCliente, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
                Cod_Cliente_Ref, TipoCliente, ClaseCli, StsCliente, FecSts,
                FecIngreso, CodListaRef, FecListaRef, CtaCBU, Cod_Agente,
                IdeCuenta, ClienteUnico)
         VALUES(nCodCliente, cTipo_Doc_Identificacion, cNum_Doc_Identificacion,
                NULL, 'CERO', 'REI', 'ACT', TRUNC(SYSDATE),
                TRUNC(SYSDATE), NULL, NULL, NULL, NULL,
                NULL, NULL);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Ya Existe el Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)));
      END;
   END IF;
   RETURN(nCodCliente);
END INSERTAR_CLIENTE;

FUNCTION IDENTIFICACION_TRIBUTARIA(nCodCliente NUMBER) RETURN VARCHAR2 IS
cTipo_Doc_Identificacion    CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNum_Doc_Identificacion     CLIENTES.Num_Doc_Identificacion%TYPE;
cNum_Tributario             PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
BEGIN
   BEGIN
      SELECT Tipo_Doc_Identificacion , Num_Doc_Identificacion
        INTO cTipo_Doc_Identificacion, cNum_Doc_Identificacion
        FROM CLIENTES
       WHERE CodCliente  = nCodCliente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' Duplicado');
   END;

--   RSR Si existe el Tributario, es el que regresa, si es nulo regresa el Doc_identificacion.
--   IF cTipo_Doc_Identificacion = 'RFC' THEN
--      RETURN(cNum_Doc_Identificacion);
--   ELSE
      BEGIN
      -- RSR Si existe el Tributario, es el que regresa, si es nulo regresa el Doc_identificacion.
      -- SELECT num_tributario --Linea Original
SELECT DECODE(  NVL(LTRIM(RTRIM(pnj.num_tributario)),'N'),'N',pnj.num_doc_identificacion,pnj.num_tributario)  --  AEVS     
           INTO cNum_Tributario
           FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
          WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
            AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
            AND CLI.CodCliente              = nCodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' NO Existe');
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' Duplicado');
      END;
      IF cNum_Tributario IS NULL THEN
         RAISE_APPLICATION_ERROR(-20225,'Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' No Posee Identificación Tributaria');
      ELSE
         RETURN(cNum_Tributario);
      END IF;
--   END IF;
--   RSR Si existe el Tributario, es el que regresa, si es nulo regresa el Doc_identificacion.
END IDENTIFICACION_TRIBUTARIA;

FUNCTION AUXILIAR_CONTABLE(nCodCliente NUMBER) RETURN VARCHAR2 IS
cAuxContable    PERSONA_NATURAL_JURIDICA.AuxContable%TYPE;
BEGIN
   BEGIN
      SELECT AuxContable
        INTO cAuxContable
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente              = nCodCliente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Codigo de Cliente: '||TRIM(TO_CHAR(nCodCliente)) || ' Duplicado');
   END;
   RETURN(cAuxContable);
END AUXILIAR_CONTABLE;

FUNCTION DIRECCION_CLIENTE(nCodCliente NUMBER) RETURN VARCHAR2 IS
cDireccion  VARCHAR2(2000);
BEGIN
   BEGIN
     SELECT  TRIM(PNJ.DirecRes)||' '||TRIM(NumExterior)||' ' ||DECODE(NumInterior, NULL, NULL, 'Interior') ||' '||TRIM(NumInterior)||' '
              || TRIM (OC_COLONIA.DESCRIPCION_COLONIA(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrres, PNJ.CodPosRes, CodColRes))
              ||', '||TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrRes)) 
              ||', '||TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.CodPaisRes, PNJ.CodProvRes))
              ||', CP '|| TRIM(PNJ.CodPosRes)
        INTO cDireccion
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente              = nCodCliente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDireccion  := ' NO VALIDA';
   END;
  RETURN UPPER(TRIM(cDireccion));
END DIRECCION_CLIENTE;

FUNCTION EN_LISTA_DE_REFERENCIA(nCodCliente NUMBER) RETURN VARCHAR2 IS
cEnLista     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEnLista
        FROM CLIENTES
       WHERE CodCliente   = nCodCliente
         AND CodListaRef IS NOT NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEnLista := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEnLista := 'S';
   END;
   RETURN(cEnLista);
END EN_LISTA_DE_REFERENCIA;

FUNCTION CODIGO_LISTA_REFERENCIA(nCodCliente NUMBER) RETURN VARCHAR2 IS
cCodListaRef     CLIENTES.CodListaRef%TYPE;
BEGIN
   BEGIN
      SELECT CodListaRef
        INTO cCodListaRef
        FROM CLIENTES
       WHERE CodCliente   = nCodCliente
         AND CodListaRef IS NOT NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodListaRef := NULL;
      WHEN TOO_MANY_ROWS THEN
         cCodListaRef := NULL;
   END;
   RETURN(cCodListaRef);
END CODIGO_LISTA_REFERENCIA;

FUNCTION ID_COD_CLIENTE RETURN NUMBER IS --IN. SEQ XDS 14/07/2016
nIdCodCliente CLIENTES.CODCLIENTE%TYPE;
BEGIN
    BEGIN
/*      SELECT NVL(MAX(CodCliente),0)+1
        INTO nIdCodCliente
        FROM CLIENTES;
*/        
          SELECT  SQ_COD_CLIENTE.NEXTVAL
          INTO nIdCodCliente
          FROM DUAL;

    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'YA Existe la Secuencia  para Cliente ');
    END;
    RETURN(nIdCodCliente);
END ID_COD_CLIENTE;                       --FIN SEQ XDS 11/07/2016

  
FUNCTION ES_CLIENTE_ALTO(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2 IS
cESCLIENTE     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cESCLIENTE
        FROM CLIENTES A
       WHERE TIPO_DOC_IDENTIFICACION   = cTipoDocIdentEmp
         AND NUM_DOC_IDENTIFICACION    = cNumDocIdentEmp
         AND A.TIPOCLIENTE = 'ALTO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cESCLIENTE := 'N';
      WHEN TOO_MANY_ROWS THEN
         cESCLIENTE := 'S';
   END;
   
   RETURN(cESCLIENTE);
END ES_CLIENTE_ALTO;

END OC_CLIENTES;
/

--
-- OC_CLIENTES  (Synonym) 
--
--  Dependencies: 
--   OC_CLIENTES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CLIENTES FOR SICAS_OC.OC_CLIENTES
/


GRANT EXECUTE ON SICAS_OC.OC_CLIENTES TO PUBLIC
/
