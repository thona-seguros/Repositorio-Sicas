--
-- OC_GENERALES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--   VALORES_DE_LISTAS (Table)
--   MONEDA (Table)
--   PARAMETROS_GLOBALES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   ASEGURADO (Table)
--   CLIENTES (Table)
--   TASAS_CAMBIO (Table)
--   EMPRESAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_generales IS
--

FUNCTION FUN_NOMBRECLIENTE (p_CodCliente IN NUMBER) RETURN VARCHAR2;

  -- Funcion FUN_NOMBREPERSONA trae el nombre de la persona de la tabla Persona_Natural_Juridica

FUNCTION FUN_NOMBREPERSONA(p_codasegurado IN NUMBER) RETURN  VARCHAR2;

  --Funcion FUN_DESCRIP_LVAL obtiene de la tabla Valores_de_Listas la descripcion
  --correspondiente al campo CodValor.
FUNCTION FUN_DESCRIP_LVAL(p_CodLista IN VARCHAR2, p_CodValor IN VARCHAR2) RETURN VARCHAR2;

  -- Funcion FUN_TASA_CAMBIO obtiene el Valores de la tasa de cambio del dia por
  -- Codigo de moneda

FUNCTION FUN_TASA_CAMBIO(cCod_Moneda VARCHAR2, dFecCambio DATE) RETURN NUMBER;

FUNCTION FUN_DIRECCLIENTE(p_CodCliente IN NUMBER) RETURN VARCHAR2;

FUNCTION BUSCA_PARAMETRO(p_CodCia IN NUMBER, p_Parametro IN VARCHAR2) RETURN VARCHAR2;

FUNCTION FUN_NOMBREAGENTE(p_codagente IN NUMBER) RETURN  VARCHAR2;

FUNCTION FUN_NOMBREUSUARIO(p_CodCia NUMBER, p_CodUsuario VARCHAR2) RETURN VARCHAR2;

FUNCTION FUN_NOMBREASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

FUNCTION FUN_NOMBREPERSONA_NATURAL(p_Tipo_Doc_Identificacion VARCHAR2, p_Num_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

FUNCTION TASA_DE_CAMBIO(cCod_Moneda VARCHAR2, dFecCambio DATE) RETURN NUMBER;

FUNCTION EDAD_PERSONA (nTipo_Doc_Identificacion VARCHAR2, nNum_Doc_Identificacion VARCHAR2) RETURN NUMBER ;

FUNCTION EDAD (nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN NUMBER;

FUNCTION FECHA_EN_LETRAS(dFecha DATE) RETURN VARCHAR2;

FUNCTION ANIO_BISIESTO(dFecVal DATE) RETURN NUMBER;

FUNCTION DIAS_ANIO(dFecDesde DATE, dFecHasta DATE) RETURN NUMBER;

FUNCTION Fecha_En_Letra (dfecha DATE) RETURN VARCHAR2;

FUNCTION PRORRATA (dFecIniVig DATE, dFecFinVig DATE, dFecEvento DATE) RETURN NUMBER;

FUNCTION MONEDA_ALTERNA(cCodMoneda VARCHAR2) RETURN VARCHAR2;
FUNCTION VALIDA_FECHA(dfecha DATE) RETURN VARCHAR2;

FUNCTION VALIDA_FECHA_FACTURA(dFecDesde DATE, dFecHasta DATE ) RETURN NUMBER;

FUNCTION CODCIA_USUARIO(p_CodUsuario VARCHAR2) RETURN NUMBER;
END OC_GENERALES;
/

--
-- OC_GENERALES  (Package Body) 
--
--  Dependencies: 
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_generales IS

FUNCTION fun_nombrecliente(p_codcliente IN NUMBER) RETURN VARCHAR2 IS
cnombrecliente  VARCHAR2(2000);
BEGIN
  BEGIN
    SELECT TRIM(pnj.nombre) || ' ' || TRIM(pnj.apellido_paterno) || ' ' ||
           TRIM(pnj.apellido_materno) || ' ' || DECODE(pnj.apecasada, NULL, ' ', ' de ' ||pnj.apecasada)
      INTO cnombrecliente
      FROM CLIENTES cli, PERSONA_NATURAL_JURIDICA pnj
     WHERE cli.tipo_doc_identificacion = pnj.tipo_doc_identificacion
       AND cli.num_doc_identificacion  = pnj.num_doc_identificacion
       AND cli.codcliente              = p_codcliente;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       cnombrecliente := 'CLIENTE NO VALIDO';
     WHEN TOO_MANY_ROWS THEN
       cnombrecliente := 'CLIENTE DUPLICADO';
  END;
    RETURN UPPER(cnombrecliente);
END fun_nombrecliente;

-- Funcion FUN_NOMBREPERSONA trae el nombre de la persona de la tabla Persona_Natural_Juridica

FUNCTION fun_nombrepersona(p_codasegurado IN NUMBER) RETURN VARCHAR2 IS
cnombreasegurado  VARCHAR2(200);
BEGIN
  BEGIN
    SELECT TRIM(pnj.nombre) || ' ' || TRIM(pnj.apellido_paterno) || ' ' ||
           TRIM(pnj.apellido_materno) || ' ' || DECODE(pnj.apecasada, NULL, ' ', ' de ' ||pnj.apecasada)
      INTO cnombreasegurado
      FROM ASEGURADO A, PERSONA_NATURAL_JURIDICA pnj
     WHERE A.tipo_doc_identificacion = pnj.tipo_doc_identificacion
       AND A.num_doc_identificacion  = pnj.num_doc_identificacion
       AND A.cod_asegurado           = p_codasegurado;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       cnombreasegurado := 'PERSONA NO VALIDO';
     WHEN TOO_MANY_ROWS THEN
       cnombreasegurado := 'PERSONA DUPLICADO';
  END;
    RETURN UPPER(cnombreasegurado);
END fun_nombrepersona;

FUNCTION fun_nombreagente(p_codagente IN NUMBER) RETURN VARCHAR2 IS
cnombreasegurado  VARCHAR2(200);
BEGIN
  BEGIN
    SELECT TRIM(pnj.nombre) || ' ' || TRIM(pnj.apellido_paterno) || ' ' ||
           TRIM(pnj.apellido_materno) || ' ' || DECODE(pnj.apecasada, NULL, ' ', ' de ' ||pnj.apecasada)
      INTO cnombreasegurado
      FROM AGENTES A, PERSONA_NATURAL_JURIDICA pnj
     WHERE A.tipo_doc_identificacion = pnj.tipo_doc_identificacion
       AND A.num_doc_identificacion  = pnj.num_doc_identificacion
       AND A.cod_agente              = p_codagente;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       cnombreasegurado := 'PERSONA NO VALIDO';
     WHEN TOO_MANY_ROWS THEN
       cnombreasegurado := 'PERSONA DUPLICADO';
  END;
    RETURN UPPER(cnombreasegurado);
END fun_nombreagente;

--Funcion FUN_DESCRIP_LVAL obtiene de la tabla Valores_de_Listas la descripcion
--correspondiente al campo CodValor.

FUNCTION fun_descrip_lval(p_codlista IN VARCHAR2, p_codvalor IN VARCHAR2) RETURN VARCHAR2 IS
p_descrip VALORES_DE_LISTAS.descvallst %TYPE;
   -- Declare program variables as shown above
BEGIN
  BEGIN
    SELECT A.descvallst
      INTO p_descrip
      FROM VALORES_DE_LISTAS A
     WHERE A.codlista = p_codlista
       AND A.codvalor = p_codvalor;
  EXCEPTION
    WHEN OTHERS THEN
       p_descrip := 'VALOR NO VALIDO';
  END;
    RETURN p_descrip;
END fun_descrip_lval;

FUNCTION fun_tasa_cambio(ccod_moneda VARCHAR2, dfeccambio DATE) RETURN NUMBER IS
ntasa     TASAS_CAMBIO.tasa_cambio%TYPE;
dummy     NUMBER;
BEGIN
   BEGIN
      SELECT tasa_cambio
        INTO ntasa
        FROM TASAS_CAMBIO
       WHERE fecha_hora_cambio = dfeccambio
         AND cod_moneda        = ccod_moneda;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         ntasa := 0;
      WHEN TOO_MANY_ROWS THEN
         ntasa := 0;
   END;
   RETURN(ntasa);
END fun_tasa_cambio;

  -- Funcion FUN_NOMBRECLIENTE trae el nombre del cliente haciendo referencia
  --a las tablas clientes y persona_natural_juridica, tomando como llave primaria
  --Tipo_Doc_Identificacion y Num_Doc_Identificacion

FUNCTION fun_direccliente(p_codcliente IN NUMBER) RETURN  VARCHAR2 IS
cdireccliente  VARCHAR2(200);
BEGIN
   BEGIN
      SELECT TRIM(pnj.direcres)
        INTO cdireccliente
        FROM CLIENTES cli, PERSONA_NATURAL_JURIDICA pnj
       WHERE cli.tipo_doc_identificacion = pnj.tipo_doc_identificacion
         AND cli.num_doc_identificacion  = pnj.num_doc_identificacion
         AND cli.codcliente = p_codcliente;
   EXCEPTION
      WHEN No_Data_Found THEN
         cdireccliente := 'CLIENTE NO VALIDO';
      WHEN TOO_MANY_ROWS THEN
         cdireccliente := 'CLIENTE DUPLICADO';
   END;
   RETURN UPPER(cdireccliente);
END fun_direccliente;

FUNCTION fun_nombreusuario (p_codcia NUMBER, p_codusuario VARCHAR2) RETURN VARCHAR2 IS
cnombre VARCHAR2(250);
BEGIN
   BEGIN
      SELECT nomusuario
        INTO cnombre
        FROM USUARIOS
       WHERE codcia     = p_codcia
         AND codusuario = p_codusuario;
   EXCEPTION
      WHEN OTHERS THEN
         cnombre := 'INVALIDO';
   END;
   RETURN (cnombre);
END fun_nombreusuario;

FUNCTION busca_parametro (p_codcia IN NUMBER, p_parametro IN VARCHAR2 ) RETURN VARCHAR2 IS
cparametro VARCHAR2(200);
BEGIN
  BEGIN
     SELECT descripcion
       INTO cparametro
       FROM PARAMETROS_GLOBALES
      WHERE codcia = p_codcia
        AND codigo = p_parametro;
  EXCEPTION
     WHEN OTHERS THEN
        cparametro := 'INVALIDO';
  END;
  RETURN (cparametro);
END busca_parametro;

FUNCTION fun_nombreasegurado (ncodcia NUMBER, ncodempresa NUMBER, ncodasegurado NUMBER) RETURN VARCHAR2 IS
cnombre                  VARCHAR2(500);
BEGIN
   SELECT TRIM(nombre) || ' ' || TRIM(apellido_paterno) || ' ' ||
           TRIM(apellido_materno) || ' ' || DECODE(apecasada, NULL, ' ', ' de ' ||apecasada)
     INTO cnombre
     FROM PERSONA_NATURAL_JURIDICA
    WHERE (tipo_doc_identificacion, num_doc_identificacion) IN
          (SELECT tipo_doc_identificacion, num_doc_identificacion
             FROM ASEGURADO
            WHERE codcia        = ncodcia
              AND codempresa    = ncodempresa
              AND cod_asegurado = ncodasegurado);
   RETURN(cnombre);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cnombre := 'Asegurado - NO EXISTE!!!';
      RETURN(cnombre);
END fun_nombreasegurado;

FUNCTION fun_nombrepersona_natural( p_tipo_doc_identificacion VARCHAR2, p_num_doc_identificacion VARCHAR2)
  RETURN  VARCHAR2 IS
   cnombrecliente  VARCHAR2(2000);

BEGIN
   BEGIN
      SELECT TRIM(pnj.nombre) || ' ' || TRIM(pnj.apellido_paterno) || ' ' ||
             TRIM(pnj.apellido_materno) || ' ' || DECODE(pnj.apecasada, NULL, ' ', ' de ' ||pnj.apecasada)
        INTO cnombrecliente
        FROM PERSONA_NATURAL_JURIDICA pnj
       WHERE pnj.tipo_doc_identificacion = p_tipo_doc_identificacion
         AND pnj.num_doc_identificacion  = p_num_doc_identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cnombrecliente := 'CLIENTE NO VALIDO';
      WHEN TOO_MANY_ROWS THEN
        cnombrecliente := 'CLIENTE DUPLICADO';
   END;
   RETURN UPPER(cnombrecliente);
END fun_nombrepersona_natural;

FUNCTION tasa_de_cambio(ccod_moneda VARCHAR2, dfeccambio DATE) RETURN NUMBER IS
ntasa     TASAS_CAMBIO.tasa_cambio%TYPE;
dummy     NUMBER;
BEGIN
   BEGIN
      SELECT tasa_cambio
        INTO ntasa
        FROM TASAS_CAMBIO
       WHERE fecha_hora_cambio = dfeccambio
         AND cod_moneda        = ccod_moneda;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe  Tasa de Cambio de la Moneda ' ||ccod_moneda||
                                  ' para la Fecha '||TO_CHAR(dfeccambio,'DD/MM/YYYY'));
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Existen varias Tasas de Cambio de la Moneda ' ||ccod_moneda||
                                  ' para la Fecha '||TO_CHAR(dfeccambio,'DD/MM/YYYY'));
   END;
   RETURN(ntasa);
END tasa_de_cambio;

FUNCTION edad_persona (ntipo_doc_identificacion VARCHAR2, nnum_doc_identificacion VARCHAR2) RETURN NUMBER IS
nedad                  number(10);
BEGIN
    BEGIN
       SELECT TRUNC(SYSDATE) - TRUNC(fecnacimiento)
         INTO nedad
         FROM PERSONA_NATURAL_JURIDICA
        WHERE tipo_doc_identificacion = ntipo_doc_identificacion AND
              num_doc_identificacion = nnum_doc_identificacion;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nedad := 0;
   END;
   RETURN(nedad);
END edad_persona;

FUNCTION edad (ncodcia NUMBER, ncodempresa NUMBER, ncodasegurado NUMBER) RETURN NUMBER IS
nedad                  number(10);
BEGIN
   SELECT TRUNC(SYSDATE) - TRUNC(fecnacimiento)
     INTO nedad
     FROM PERSONA_NATURAL_JURIDICA
    WHERE (tipo_doc_identificacion, num_doc_identificacion) IN
          (SELECT tipo_doc_identificacion, num_doc_identificacion
             FROM ASEGURADO
            WHERE codcia       = ncodcia
              AND codempresa   = ncodempresa
              AND cod_asegurado = ncodasegurado);
   RETURN(nedad);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      nedad := 0;
      RETURN(nedad);
END edad;


FUNCTION fecha_en_letras (dfecha DATE) RETURN VARCHAR2 IS
cfecha_en_letra VARCHAR2(40);
BEGIN
   BEGIN
      SELECT TO_CHAR(dfecha,'DD')||' de '||NLS_INITCAP(OC_GENERALES.fun_descrip_lval('MESES',TO_CHAR(dfecha,'MM')))||' del '||TO_CHAR(dfecha,'YYYY') cfechaenletra
        INTO cfecha_en_letra
        FROM dual;
   END;
   RETURN cfecha_en_letra;
END fecha_en_letras;

FUNCTION anio_bisiesto(dfecval DATE) RETURN NUMBER IS
nanioval   NUMBER(4);
BEGIN
   nanioval := TO_NUMBER(TO_CHAR(dfecval,'RRRR'));
   IF MOD(nanioval,4) = 0 THEN
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END anio_bisiesto;

FUNCTION dias_anio(dfecdesde DATE, dfechasta DATE) RETURN NUMBER IS
ndiasano  NUMBER(6) := 365;
BEGIN
   IF OC_GENERALES.anio_bisiesto(dfecdesde) = 1 AND
      OC_GENERALES.anio_bisiesto(dfechasta) = 0 THEN
      IF TO_NUMBER(TO_CHAR(dfecdesde,'MMDD')) <= 229 THEN
         ndiasano := 366;
      END IF;
   ELSIF OC_GENERALES.anio_bisiesto(dfecdesde) = 0 AND
         OC_GENERALES.anio_bisiesto(dfechasta) = 1 THEN
      IF TO_NUMBER(TO_CHAR(dfechasta,'MMDD')) >= 229 THEN
         ndiasano := 366;
      END IF;
   ELSIF OC_GENERALES.anio_bisiesto(dfecdesde) = 1 AND
         OC_GENERALES.anio_bisiesto(dfechasta) = 1 THEN
      ndiasano := 366;
   END IF;
   RETURN(ndiasano);
END dias_anio;
FUNCTION FECHA_EN_LETRA (dfecha DATE) RETURN VARCHAR2 IS
  cfecha_en_letra VARCHAR2(40);
  BEGIN
   BEGIN
     SELECT TO_CHAR(dfecha,'DD')||' de '||NLS_INITCAP(OC_GENERALES.fun_descrip_lval('MESES',TO_CHAR(dfecha,'MM')))||' del '||TO_CHAR(dfecha,'YYYY') cfechaenletra
       INTO cfecha_en_letra
       FROM dual;
   END;
  RETURN cfecha_en_letra;
END FECHA_EN_LETRA;

FUNCTION PRORRATA (dFecIniVig DATE, dFecFinVig DATE, dFecEvento DATE) RETURN NUMBER IS
nDiasAno          NUMBER(6) := 365;
nDiasProrrata     NUMBER(6);
nFactProrrata     NUMBER(11,8);
nFactor           NUMBER(14,8);
BEGIN
   --nDiasAno      := OC_GENERALES.DIAS_ANIO(dFecIniVig, dFecFinVig);
   nDiasAno      := TRUNC(dFecFinVig) - TRUNC(dFecIniVig);
   nDiasProrrata := TRUNC(dFecFinVig) - TRUNC(dFecEvento);

   IF TO_CHAR(dFecIniVig,'DDMM') = '2902' AND
      TO_CHAR(dFecFinVig,'DDMM') = '2802' THEN
      nDiasProrrata := nDiasProrrata + 1;
   END IF;

   nFactProrrata := nDiasProrrata / nDiasAno;
   RETURN(nFactProrrata);
END PRORRATA;

FUNCTION MONEDA_ALTERNA(cCodMoneda VARCHAR2) RETURN VARCHAR2 IS
cCodAlterno   MONEDA.CodAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodAlterno
        INTO cCodAlterno
        FROM MONEDA
       WHERE Cod_Moneda = cCodMoneda;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodAlterno := NULL;
   END;
   RETURN(cCodAlterno);
END MONEDA_ALTERNA;
FUNCTION VALIDA_FECHA(dfecha DATE) RETURN VARCHAR2 IS
dultDia  DATE ;
BEGIN
 BEGIN
  SELECT TRUNC (LAST_DAY (SYSDATE))
    INTO dultDia
    FROM DUAL
  END ;
 RETURN('S');
/*   IF TRUNC(dfecha) BETWEEN   TRUNC (TO_DATE(('01'||'-'||TO_CHAR(SYSDATE,'MM')||'-'||TO_CHAR(SYSDATE,'YYYY')))) AND  dultDia THEN
 -- IF dfecha BETWEEN  ADD_MONTHS( TO_DATE(('01'||'-'||TO_CHAR(SYSDATE,'MM')||'-'||TO_CHAR(SYSDATE,'YYYY'))),2) AND  ADD_MONTHS(dultDia,2) THEN
     RETURN('S');
   ELSE
     RETURN('N');
   END IF;*/
 END;
 EXCEPTION
  WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20100,'Error ' ||dfecha );
END VALIDA_FECHA;
FUNCTION VALIDA_FECHA_FACTURA(dFecDesde DATE, dFecHasta DATE ) RETURN NUMBER IS
nMes  NUMBER(10)  ;
BEGIN
   BEGIN
     SELECT  NVL( round(MONTHS_BETWEEN (TRUNC(LAST_DAY(dFecHasta)), TO_DATE(('01'||'-'||TO_CHAR(dFecDesde,'MM')||'-'||TO_CHAR(dFecDesde,'YYYY')))),1)-1,0)
     --NVL(MONTHS_BETWEEN (dFecHasta,dFecDesde) - 1,0)
       INTO nMes
       FROM DUAL;
  EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20100,'Error ' ||dFecDesde );
  END ;
  RETURN(nMes);

END VALIDA_FECHA_FACTURA;

FUNCTION CODCIA_USUARIO(p_CodUsuario VARCHAR2) RETURN NUMBER IS
    nCodCia EMPRESAS.CODCIA%TYPE;
BEGIN
    BEGIN
        SELECT CodCia
          INTO nCodCia
          FROM USUARIOS
         WHERE CodUsuario = p_CodUsuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR (-20100,'No Existe Usuario: '||p_CodUsuario );
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20100,'Error Al Obtener El Codigo De La Compañia Para El Usuario: '||p_CodUsuario);
    END;
    RETURN nCodCia;
END CODCIA_USUARIO;


END OC_GENERALES;
/

--
-- OC_GENERALES  (Synonym) 
--
--  Dependencies: 
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_GENERALES FOR SICAS_OC.OC_GENERALES
/


GRANT EXECUTE ON SICAS_OC.OC_GENERALES TO PUBLIC
/
