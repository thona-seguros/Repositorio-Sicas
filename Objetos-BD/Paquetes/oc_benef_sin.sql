--
-- OC_BENEF_SIN  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   XMLAGG (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   SYS_IXMLAGG (Function)
--   MEDIOS_DE_PAGO (Table)
--   SINIESTRO (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   ASEGURADO (Table)
--   BENEF_SIN (Table)
--   BENEF_SIN_PAGOS (Table)
--   OC_ASEGURADO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_BENEF_SIN IS
  --
  FUNCTION NOMBRE_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,
                               nBenef NUMBER) RETURN VARCHAR2;
  --
  FUNCTION PORCENTAJE_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,
                                   nBenef NUMBER) RETURN NUMBER;
  --
  FUNCTION INSERTA_ASEG_BENEF(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER;
  --
  FUNCTION INSERTA_BENEF_PROV(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER,
                            cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER;
  -- AEVS 02102017
  FUNCTION PARENTESCO_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,nBenef NUMBER) RETURN VARCHAR2;
  -- 
  FUNCTION FECHA_FIRMA_RECLAMO (nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,nBenef NUMBER) RETURN DATE;

  PROCEDURE ID_TRIBUTARIA_PORTAL (xRFC OUT XMLTYPE);

  PROCEDURE EXISTE_BENEF_SIN (cRFC VARCHAR2, nExiste OUT NUMBER);
  --
END OC_BENEF_SIN;
/

--
-- OC_BENEF_SIN  (Package Body) 
--
--  Dependencies: 
--   OC_BENEF_SIN (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_BENEF_SIN IS
--
--
--
FUNCTION NOMBRE_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,
                             nBenef NUMBER) RETURN VARCHAR2 IS
cNomBenef        VARCHAR2(300);
BEGIN
   BEGIN
      SELECT Nombre || ' ' || Apellido_Paterno || ' ' || Apellido_Materno
        INTO cNomBenef
        FROM BENEF_SIN
       WHERE IdSiniestro   = nIdSiniestro
         AND IdPoliza      = nIdPoliza
         AND Cod_Asegurado = nCod_Asegurado
         AND Benef         = nBenef;
      RETURN(cNomBenef);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            SELECT Nombre || ' ' || Apellido_Paterno || ' ' || Apellido_Materno
              INTO cNomBenef
              FROM BENEF_SIN
             WHERE IdSiniestro   = nIdSiniestro
               AND IdPoliza      = nIdPoliza
               AND Benef         = nBenef;
            RETURN(cNomBenef);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               --cNomBenef := 'NO EXISTE';
               RAISE_APPLICATION_ERROR(-20225,'NO Existe Beneficiario No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
         END;      
      WHEN TOO_MANY_ROWS THEN
         --cNomBenef := 'MAS DE UN BENEFICARIO';
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Beneficiarios No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
   END;
END NOMBRE_BENEFICIARIO;
--
--
--
FUNCTION PORCENTAJE_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,
                                 nBenef NUMBER) RETURN NUMBER IS
nPorcePart            BENEF_SIN.PorcePart%TYPE;
BEGIN
   BEGIN
      SELECT PorcePart
        INTO nPorcePart
        FROM BENEF_SIN
       WHERE IdSiniestro   = nIdSiniestro
         AND IdPoliza      = nIdPoliza
         AND Cod_Asegurado = nCod_Asegurado
         AND Benef         = nBenef;
      RETURN(nPorcePart);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN      ----  AEVS 11/09/2017
         BEGIN  
           SELECT PorcePart
            INTO nPorcePart
            FROM BENEF_SIN
           WHERE IdSiniestro   = nIdSiniestro
             AND IdPoliza      = nIdPoliza             
             AND Benef         = nBenef;
              RETURN(nPorcePart);
          EXCEPTION WHEN NO_DATA_FOUND THEN   
             RAISE_APPLICATION_ERROR(-20225,'NO Existe Beneficiario No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
          END; 
     WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Beneficiarios No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
   END;
END PORCENTAJE_BENEFICIARIO;
--
--
--
FUNCTION INSERTA_ASEG_BENEF(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER IS
  --
  nBenef         BENEF_SIN.BENEF%TYPE;
  cNombre        BENEF_SIN.NOMBRE%TYPE;
  cApellPaterno  BENEF_SIN.APELLIDO_PATERNO%TYPE;
  cApellMaterno  BENEF_SIN.APELLIDO_MATERNO%TYPE;
  cSexo          BENEF_SIN.SEXO%TYPE;
  cDireccion     BENEF_SIN.DIRECCION%TYPE;
  cEMail         BENEF_SIN.EMAIL%TYPE;
  cEntidad       BENEF_SIN.ENT_FINANCIERA%TYPE;
  cCuenta        BENEF_SIN.NUMCUENTABANCARIA%TYPE;
  cClabe         BENEF_SIN.CUENTA_CLAVE%TYPE;
  cCodCia        ASEGURADO.CODCIA%TYPE;
  dFecNac        PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
  cTipDocIdentif PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
  cNumDocIdentif PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
  --
BEGIN
  -- Si existe el Beneficiario, ya no se debe crear otro beneficiario a partir del Asegurado, porque sólo se procesa por reembolso.
  BEGIN
    SELECT BS.Benef
      INTO nBenef
      FROM BENEF_SIN BS, ASEGURADO AG
     WHERE BS.IdSiniestro        = nIdSiniestro
       AND BS.IdPoliza           = nIdPoliza
       AND BS.Cod_Asegurado      = AG.Cod_Asegurado
       AND BS.Tipo_Id_Tributario = AG.Tipo_Doc_Identificacion
       AND BS.Num_Doc_Tributario = AG.Num_Doc_Identificacion;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      nBenef := NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Beneficiario en OC_BENEF_SIN: '|| SQLERRM);
  END;
  --
dbms_output.put_line('Inserta Aseg nBenef '||nBenef);
  IF nBenef IS NULL THEN
     --
dbms_output.put_line('Inserta Aseg IS NULL nBenef '||nBenef);
     BEGIN
       SELECT TRIM(PN.Nombre) Nombre, TRIM(PN.Apellido_Paterno) ApellPaterno, TRIM(PN.Apellido_Materno) ApellMaterno,
              PN.FecNacimiento, PN.Tipo_Doc_Identificacion, PN.Num_Doc_Identificacion,
              OC_ASEGURADO.SEXO_ASEGURADO(AG.CodCia, AG.CodEmpresa, SI.Cod_Asegurado) Sexo,
              OC_ASEGURADO.DIRECCION_ASEGURADO(AG.CodCia, AG.CodEmpresa, SI.Cod_Asegurado) Direccion,
              PN.EMail, MP.CodEntidadFinan, MP.NumCuentaBancaria, MP.NumCuentaClabe
         INTO cNombre, cApellPaterno, cApellMaterno, dFecNac, cTipDocIdentif, cNumDocIdentif,
              cSexo, cDireccion, cEMail, cEntidad, cCuenta, cClabe
         FROM SINIESTRO SI, ASEGURADO AG, PERSONA_NATURAL_JURIDICA PN,
              MEDIOS_DE_PAGO MP
        WHERE SI.IdSiniestro             = nIdSiniestro
          AND SI.IdPoliza                = nIdPoliza
          AND SI.Cod_Asegurado           = AG.cod_asegurado
          AND AG.Tipo_Doc_Identificacion = PN.Tipo_Doc_Identificacion
          AND AG.Num_Doc_Identificacion  = PN.Num_Doc_Identificacion
          AND AG.Tipo_Doc_Identificacion = MP.Tipo_Doc_Identificacion(+)
          AND AG.Num_Doc_Identificacion  = MP.Num_Doc_Identificacion(+);
     EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Asegurado para Insertar Beneficiario '|| nIdSiniestro || ' ' || SQLERRM);
     END;
     --
     BEGIN
       SELECT NVL(MAX(Benef),0)+1
         INTO nBenef
         FROM BENEF_SIN
        WHERE IdSiniestro   = nIdSiniestro
          AND IdPoliza      = nIdPoliza;
     EXCEPTION
       WHEN OTHERS THEN
         nBenef := 1;
     END;
     --
dbms_output.put_line('Inserta Aseg Nuevo nBenef '||nBenef);
     BEGIN
       INSERT INTO BENEF_SIN
             (IdSiniestro, IdPoliza, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado, Sexo, FecEstado, FecAlta,
              Obervaciones, Direccion, EMAil, Cuenta_Clave, Ent_Financiera, NumCuentaBancaria, IndAplicaISR, PorcentISR,
              FecNac, Tipo_Id_Tributario, Num_Doc_Tributario, Apellido_Paterno, Apellido_Materno)
       VALUES(nIdSiniestro, nIdPoliza, nCod_Asegurado, nBenef, cNombre, 100, '0001', 'ACT', cSexo, TRUNC(SYSDATE), TRUNC(SYSDATE),
              'Pago por el Siniestro No. ' || nIdSiniestro, cDireccion, cEMail, cClabe, cEntidad, cCuenta, 'N', Null,
              dFecNac, cTipDocIdentif, cNumDocIdentif, cApellPaterno, cApellMaterno);
     EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago del Siniestro a partir del Asegurado '|| nIdSiniestro || ' ' || SQLERRM);
     END;
   --
  END IF;
  --
  RETURN (nBenef);
  --
END INSERTA_ASEG_BENEF;
--
--
--
FUNCTION INSERTA_BENEF_PROV(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER,
                            cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
  nBenef         BENEF_SIN.BENEF%TYPE;
  cNombre        BENEF_SIN.NOMBRE%TYPE;
  cApellPaterno  BENEF_SIN.APELLIDO_PATERNO%TYPE;
  cApellMaterno  BENEF_SIN.APELLIDO_MATERNO%TYPE;
  cSexo          BENEF_SIN.SEXO%TYPE;
  cDireccion     BENEF_SIN.DIRECCION%TYPE;
  cEMail         BENEF_SIN.EMAIL%TYPE;
  cEntidad       BENEF_SIN.ENT_FINANCIERA%TYPE;
  cCuenta        BENEF_SIN.NUMCUENTABANCARIA%TYPE;
  cClabe         BENEF_SIN.CUENTA_CLAVE%TYPE;
  cCodCia        ASEGURADO.CODCIA%TYPE;
  dFecNac        PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
  cTipDocIdentif PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
  cNumDocIdentif PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
BEGIN
  --
  BEGIN
    SELECT Benef
      INTO nBenef
      FROM BENEF_SIN
     WHERE IdSiniestro   = nIdSiniestro
       AND IdPoliza      = nIdPoliza
       AND Tipo_Id_Tributario = cTipo_Doc_Identificacion
       AND Num_Doc_Tributario = cNum_Doc_Identificacion;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      nBenef := NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Beneficiario en OC_BENEF_SIN para Proveedor: '|| SQLERRM);
  END;
  --
  IF nBenef IS NULL THEN
     --
     BEGIN
       SELECT TRIM(PN.Nombre) Nombre, TRIM(PN.Apellido_Paterno) ApellPaterno, TRIM(PN.Apellido_Materno) ApellMaterno,
              PN.FecNacimiento, PN.Tipo_Doc_Identificacion, PN.Num_Doc_Identificacion,
              'N' Sexo, NULL /*OC_PERSONA_NATURAL_JURIDICA.DIRECCION(PN.Tipo_Doc_Identificacion, PN.Num_Doc_Identificacion)*/ Direccion,
              PN.EMail, MP.CodEntidadFinan, MP.NumCuentaBancaria, MP.NumCuentaClabe 
         INTO cNombre, cApellPaterno, cApellMaterno, dFecNac, cTipDocIdentif, cNumDocIdentif,
              cSexo, cDireccion, cEMail, cEntidad, cCuenta, cClabe
         FROM SINIESTRO SI, PERSONA_NATURAL_JURIDICA PN, MEDIOS_DE_PAGO MP
        WHERE SI.IdSiniestro             = nIdSiniestro
          AND SI.IdPoliza                = nIdPoliza
          AND PN.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
          AND PN.Num_Doc_Identificacion  = cNum_Doc_Identificacion
          AND PN.Tipo_Doc_Identificacion = MP.Tipo_Doc_Identificacion(+)
          AND PN.Num_Doc_Identificacion  = MP.Num_Doc_Identificacion(+);
     EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Asegurado para Insertar Beneficiario '|| nIdSiniestro || ' ' || SQLERRM);
     END;
     --
     BEGIN
       SELECT NVL(MAX(Benef),0)+1
         INTO nBenef
         FROM BENEF_SIN
        WHERE IdSiniestro   = nIdSiniestro
          AND IdPoliza      = nIdPoliza;
     EXCEPTION
       WHEN OTHERS THEN
         nBenef := 1;
     END;
     --
     BEGIN
       INSERT INTO BENEF_SIN
             (IdSiniestro, IdPoliza, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado, Sexo, FecEstado, FecAlta,
              Obervaciones, Direccion, EMAil, Cuenta_Clave, Ent_Financiera, NumCuentaBancaria, IndAplicaISR, PorcentISR,
              FecNac, Tipo_Id_Tributario, Num_Doc_Tributario, Apellido_Paterno, Apellido_Materno)
       VALUES(nIdSiniestro, nIdPoliza, nCod_Asegurado, nBenef, cNombre, 100, '0001', 'ACT', cSexo, TRUNC(SYSDATE), TRUNC(SYSDATE),
              'Pago por el Siniestro No. ' || nIdSiniestro, cDireccion, cEMail, cClabe, cEntidad, cCuenta, 'N', Null,
              dFecNac, cTipDocIdentif, cNumDocIdentif, cApellPaterno, cApellMaterno);
     EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago del Siniestro a partir del Asegurado '|| nIdSiniestro || ' ' || SQLERRM);
     END;
  END IF;
  --
  RETURN (nBenef);
  --
END INSERTA_BENEF_PROV;
--
--
--
FUNCTION PARENTESCO_BENEFICIARIO(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,
                                 nBenef NUMBER) RETURN VARCHAR2 IS
cNomBenef        VARCHAR2(300);
BEGIN
   BEGIN
      SELECT OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT',CODPARENT)
        INTO cNomBenef
        FROM BENEF_SIN
       WHERE IdSiniestro   = nIdSiniestro
         AND IdPoliza      = nIdPoliza
         AND Cod_Asegurado = nCod_Asegurado
         AND Benef         = nBenef;
      RETURN(cNomBenef);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          BEGIN
          SELECT OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT',CODPARENT)
            INTO cNomBenef
            FROM BENEF_SIN
           WHERE IdSiniestro   = nIdSiniestro
             AND IdPoliza      = nIdPoliza
             AND Benef         = nBenef;
               RETURN(cNomBenef);
          EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'NO Existe Parentesco con el Asegurado. Beneficiario No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
          END;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Parentesco con el Asegurado. Beneficiarios No. ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro);
   END;
END PARENTESCO_BENEFICIARIO;
--
--
--
FUNCTION FECHA_FIRMA_RECLAMO (nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCod_Asegurado NUMBER,nBenef NUMBER) RETURN DATE IS
    dFecFirmaReclamacion BENEF_SIN.FecFirmaReclamacion%TYPE;
BEGIN
     SELECT FecFirmaReclamacion
       INTO dFecFirmaReclamacion
       FROM BENEF_SIN
      WHERE IdSiniestro   = nIdSiniestro
        AND IdPoliza      = nIdPoliza
        AND Cod_Asegurado = nCod_Asegurado
        AND Benef         = nBenef;
    RETURN(dFecFirmaReclamacion);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20225,'No Existe Beneficiario ' || nBenef || ' en el Siniestro No. ' || nIdSiniestro); 
END FECHA_FIRMA_RECLAMO;
--
--
--
PROCEDURE ID_TRIBUTARIA_PORTAL (xRFC OUT XMLTYPE) IS
  xPrevRFC      XMLTYPE;
BEGIN
  BEGIN
      SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("Beneficiario", 
                                                     XMLElement("RFC",RFC),
                                                     XMLElement("Nombre",Nombre),
                                                     XMLElement("ApellidoPaterno",NVL(Apellido_Paterno,'NAN')),
                                                     XMLElement("ApellidoMaterno",NVL(Apellido_Materno,'NAN')),
                                                     XMLElement("Curp",NVL(Curp,'NAN')),
                                                     XMLElement("Email",NVL(Email,'NAN'))
                                                  )
                                       )
                                 ) 
                             )
        INTO xPrevRFC
        FROM (
              SELECT DISTINCT A.Num_Doc_Identificacion RFC,PNJ.Nombre, 
                     PNJ.Apellido_Paterno, PNJ.Apellido_Materno,PNJ.Curp,
                     BS.Email
                FROM SINIESTRO S,BENEF_SIN BS, BENEF_SIN_PAGOS BSP,
                     ASEGURADO A, PERSONA_NATURAL_JURIDICA PNJ
               WHERE BS.ESTADO                 IN ('ACT','ACTIVO')
                 AND BS.Num_Doc_Tributario IS NOT NULL
                 AND PNJ.Tipo_Persona           = 'FISICA'
                 AND S.IdSiniestro              = BS.IdSiniestro
                 AND S.IdPoliza                 = BS.IdPoliza
                 AND BS.IdSiniestro             = BSP.IdSiniestro
                 AND BS.IdPoliza                = BSP.IdPoliza
                 AND BS.Benef                   = BSP.Benef
                 AND BS.Cod_Asegurado           = A.Cod_Asegurado
                 AND A.Tipo_Doc_Identificacion  = PNJ.Tipo_Doc_Identificacion
                 AND A.Num_Doc_Identificacion   = PNJ.Num_Doc_Identificacion);
  END;
  SELECT XMLROOT (xPrevRFC, VERSION '1.0" encoding="UTF-8')
    INTO xRFC
    FROM DUAL;
END ID_TRIBUTARIA_PORTAL;
--
--
--
PROCEDURE EXISTE_BENEF_SIN (cRFC VARCHAR2, nExiste OUT NUMBER) IS
cExiste VARCHAR2(1);
BEGIN
  BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SINIESTRO S,BENEF_SIN BS, BENEF_SIN_PAGOS BSP
       WHERE BS.ESTADO                 IN ('ACT','ACTIVO')
         AND BS.Num_Doc_Tributario      = cRFC
         AND S.IdSiniestro              = BS.IdSiniestro
         AND S.IdPoliza                 = BS.IdPoliza
         AND BS.IdSiniestro             = BSP.IdSiniestro
         AND BS.IdPoliza                = BSP.IdPoliza
         AND BS.Benef                   = BSP.Benef;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
  END;
  IF NVL(cExiste,'N') = 'S' THEN
    nExiste := 1;
  ELSE 
    nExiste := 0;
  END IF;
END EXISTE_BENEF_SIN;
--
--
--
END OC_BENEF_SIN;
/

--
-- OC_BENEF_SIN  (Synonym) 
--
--  Dependencies: 
--   OC_BENEF_SIN (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_BENEF_SIN FOR SICAS_OC.OC_BENEF_SIN
/


GRANT EXECUTE ON SICAS_OC.OC_BENEF_SIN TO PUBLIC
/
