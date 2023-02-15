CREATE OR REPLACE PACKAGE oc_asegurado IS
--
--  BITACORA DE CAMBIOS , VERSION PRODUCTIVA   17/11/2015  1:17 pm
--
--  ------------------------------
-- SE COLOCO LA SECUENCIA PARA ASEGURADO Y SE AGREGO EL INDICE 1  JICO 20160504   SECUEN
--  16/12/2021  Reingenieria F2  SE AGREGO LA FUNCION NOMBRE_CLIENTE_TIPO 
--

  FUNCTION EDAD_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER, dFecEdad DATE) RETURN NUMBER;

  FUNCTION NOMBRE_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

  FUNCTION CODIGO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

  FUNCTION INSERTAR_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER;

  FUNCTION SEXO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

  FUNCTION FECHA_NACIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN DATE;

  FUNCTION ACTIVIDAD_ECONOMICA_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

  FUNCTION DIRECCION_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

  FUNCTION ID_ASEGURADO RETURN NUMBER; --SEQ XDS 11/07/2016

  FUNCTION IDENTIFICACION_TRIBUTARIA_ASEG (nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

  FUNCTION NOMBRE_ASEGURADO_TIPO(nCOD_ASEGURADO NUMBER) RETURN VARCHAR2;

END OC_ASEGURADO;

/

CREATE OR REPLACE PACKAGE BODY oc_asegurado IS

FUNCTION EDAD_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER, dFecEdad DATE) RETURN NUMBER IS
dFecNacimiento    PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
nEdad             NUMBER(5);
BEGIN
   BEGIN
      SELECT FecNacimiento
        INTO dFecNacimiento
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ASEGURADO
               WHERE CodCia        = nCodCia
                 AND CodEmpresa    = nCodEmpresa
                 AND Cod_Asegurado = nCodAsegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecNacimiento := TRUNC(SYSDATE);
   END;
   nEdad := FLOOR((TRUNC(dFecEdad) - TRUNC(dFecNacimiento)) / 365.25);
   RETURN(nEdad);
END EDAD_ASEGURADO;

FUNCTION NOMBRE_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) ||' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' ||
             DECODE(ApeCasada,NULL,'', ' de ' ||ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ASEGURADO
               WHERE CodCia        = nCodCia
                 AND CodEmpresa    = nCodEmpresa
                 AND Cod_Asegurado = nCodAsegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Asegurado - NO EXISTE!!!';
   END;
   RETURN(cNombre);
END NOMBRE_ASEGURADO;

FUNCTION CODIGO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipo_Doc_Identificacion VARCHAR2,
                          cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
nCod_Asegurado   ASEGURADO.Cod_Asegurado%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Asegurado
        INTO nCod_Asegurado
        FROM ASEGURADO
       WHERE CodCia                  = nCodCia
         AND CodEmpresa              = nCodEmpresa
         AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCod_Asegurado := 0;
      WHEN TOO_MANY_ROWS THEN
         BEGIN
            SELECT MAX(Cod_Asegurado)
              INTO nCod_Asegurado
              FROM ASEGURADO
             WHERE CodCia                  = nCodCia
               AND CodEmpresa              = nCodEmpresa
               AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
               AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
         END;
   END;
   RETURN(nCod_Asegurado);
END CODIGO_ASEGURADO;

FUNCTION INSERTAR_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER,
                            cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
nCod_Asegurado   ASEGURADO.Cod_Asegurado%TYPE;
BEGIN
  SELECT SQ_ASEGURADO.NEXTVAL      -- SECUEN
    INTO nCod_Asegurado            -- SECUEN
    FROM DUAL;                     -- SECUEN
   BEGIN
      INSERT INTO ASEGURADO
            (Cod_Asegurado, CodCia, CodEmpresa, Tipo_Doc_Identificacion,
             Num_Doc_Identificacion, CodParent)
      VALUES(nCod_Asegurado, nCodCia, nCodEmpresa, cTipo_Doc_Identificacion,
             cNum_Doc_Identificacion, '0001');
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Ya Existe el Codigo de Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)));
   END;
   RETURN(nCod_Asegurado);
END INSERTAR_ASEGURADO;

FUNCTION SEXO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cSexo    PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
BEGIN
   BEGIN
      SELECT Sexo
        INTO cSexo
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ASEGURADO
               WHERE CodCia        = nCodCia
                 AND CodEmpresa    = nCodEmpresa
                 AND Cod_Asegurado = nCodAsegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cSexo := 'M';
   END;
   RETURN(cSexo);
END SEXO_ASEGURADO;

FUNCTION FECHA_NACIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN DATE IS
dFecNacimiento    PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
BEGIN
   BEGIN
      SELECT FecNacimiento
        INTO dFecNacimiento
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ASEGURADO
               WHERE CodCia        = nCodCia
                 AND CodEmpresa    = nCodEmpresa
                 AND Cod_Asegurado = nCodAsegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecNacimiento := NULL;
   END;
   RETURN(dFecNacimiento);
END FECHA_NACIMIENTO;

FUNCTION ACTIVIDAD_ECONOMICA_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cCodActividad   PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
BEGIN
   BEGIN
      SELECT CodActividad
        INTO cCodActividad
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ASEGURADO
               WHERE CodCia        = nCodCia
                 AND CodEmpresa    = nCodEmpresa
                 AND Cod_Asegurado = nCodAsegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodActividad := NULL;
   END;
   RETURN(cCodActividad);
END ACTIVIDAD_ECONOMICA_ASEG;

FUNCTION DIRECCION_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cDireccion  VARCHAR2(2000);
BEGIN
   BEGIN
      SELECT  TRIM(PNJ.DirecRes)||' '||
              TRIM(NumExterior)||' ' ||
              DECODE(NumInterior, NULL, NULL, 'Interior')||' '||TRIM(NumInterior)||' '||
              TRIM(OC_COLONIA.DESCRIPCION_COLONIA(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrres, PNJ.CodPosRes, CodColRes))||', '||
              TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.CodPaisRes, PNJ.CodProvRes))||', '||
              TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrRes))||', CP '||
              TRIM(PNJ.CodPosRes)
        INTO cDireccion
        FROM ASEGURADO A, PERSONA_NATURAL_JURIDICA PNJ
       WHERE A.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND A.Cod_Asegurado           = nCodAsegurado
         AND A.CodCia                  = nCodCia
         AND A.CodEmpresa              = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDireccion  := ' NO VALIDA';
   END;
  RETURN UPPER(TRIM(cDireccion));
END DIRECCION_ASEGURADO;


FUNCTION ID_ASEGURADO  RETURN NUMBER IS  --IN. SEQ XDS 11/07/2016
nIdAsegurado ASEGURADO.COD_ASEGURADO%TYPE;
BEGIN
    BEGIN
      SELECT SQ_ASEGURADO.NEXTVAL
        INTO nIdAsegurado
        FROM DUAL;
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'YA Existe la Secuencia para la Compañia, ');
    END;
    RETURN(nIdAsegurado);
END ID_ASEGURADO;                         --FIN SEQ XDS 11/07/2016


FUNCTION IDENTIFICACION_TRIBUTARIA_ASEG (nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
    cNum_Tributario PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
BEGIN
    BEGIN
        SELECT DECODE(P.Tipo_Doc_Identificacion,'RFC',P.Num_Doc_Identificacion,P.Num_Tributario) Num_Tributario
          INTO cNum_Tributario
          FROM PERSONA_NATURAL_JURIDICA P,ASEGURADO A
         WHERE A.Cod_Asegurado           = nCodAsegurado
           AND A.CodCia                  = nCodCia
           AND A.CodEmpresa              = nCodEmpresa
           AND P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
           AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion;

        RETURN cNum_Tributario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'Asegurado '||nCodAsegurado||' NO es Valido o No Existe, Por Favor Valide');
    END;
END IDENTIFICACION_TRIBUTARIA_ASEG;

FUNCTION NOMBRE_ASEGURADO_TIPO(nCOD_ASEGURADO NUMBER) RETURN VARCHAR2 IS
cNombreasegurado  VARCHAR2(2000);
BEGIN
   BEGIN
      SELECT DECODE(NVL(PNJ.TIPO_PERSONA,'FISICA'),'FISICA',
                                      INITCAP(TRIM(PNJ.Nombre)||' '||TRIM(PNJ.Apellido_Paterno)||' '||TRIM(PNJ.Apellido_Materno)),
                                        UPPER(TRIM(PNJ.Nombre)||' '||TRIM(PNJ.Apellido_Paterno)||' '||TRIM(PNJ.Apellido_Materno)))                                   
        INTO cNombreasegurado
        FROM ASEGURADO ASE, 
             PERSONA_NATURAL_JURIDICA PNJ
       WHERE ASE.COD_ASEGURADO = nCOD_ASEGURADO
         --
         AND PNJ.Tipo_Doc_Identificacion = ASE.Tipo_Doc_Identificacion
         AND PNJ.Num_Doc_Identificacion  = ASE.Num_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombreasegurado := 'ASEGURADO NO VALIDO';
      WHEN TOO_MANY_ROWS THEN
         cNombreasegurado := 'ASEGURADO DUPLICADO';
   END;
   RETURN TRIM(cNombreasegurado);
END NOMBRE_ASEGURADO_TIPO;


END OC_ASEGURADO;
