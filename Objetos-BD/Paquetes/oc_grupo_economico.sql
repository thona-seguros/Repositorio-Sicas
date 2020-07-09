--
-- OC_GRUPO_ECONOMICO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   GRUPO_ECONOMICO (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   CLIENTES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_GRUPO_ECONOMICO  IS
--
FUNCTION NOMBRE_GRUPO_ECONOMICO(nCodCia     NUMBER, 
                                cCodGrupoEc VARCHAR2) RETURN VARCHAR2;
--
FUNCTION VALIDA_CREA(nCodCia                  NUMBER,
                     cTipo_Doc_Identificacion VARCHAR2, 
                     cNum_Doc_Identificacion  VARCHAR2,
                     nIdSolicitud             NUMBER) RETURN VARCHAR2;
--
FUNCTION ALTA_AUTOMATICA(P_CODCLIENTE VARCHAR2,
                         P_CODCIA     NUMBER) RETURN VARCHAR2;        
--
END OC_GRUPO_ECONOMICO;
/

--
-- OC_GRUPO_ECONOMICO  (Package Body) 
--
--  Dependencies: 
--   OC_GRUPO_ECONOMICO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_GRUPO_ECONOMICO IS
--
--
-- BITACORA DE CAMBIOS
--
-- SE COLOCO EL PROCEDIMIENTO DE GENERACION AUTOMATICA   01/12/2019  RENOV   JICO
--
FUNCTION NOMBRE_GRUPO_ECONOMICO(nCodCia     NUMBER, 
                                cCodGrupoEc VARCHAR2) RETURN  VARCHAR2 IS
cNombre VARCHAR2(200);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
             TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM GRUPO_ECONOMICO
               WHERE CodCia     = nCodCia
                 AND CodGrupoEc = cCodgrupoEc);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'NO EXISTE';
   END;
   RETURN(cNombre);
END NOMBRE_GRUPO_ECONOMICO;

FUNCTION VALIDA_CREA(nCodCia                  NUMBER, 
                     cTipo_Doc_Identificacion VARCHAR2,
                     cNum_Doc_Identificacion  VARCHAR2, 
                     nIdSolicitud             NUMBER) RETURN VARCHAR2 IS
cCodGrupoEc       GRUPO_ECONOMICO.CodGrupoEc%TYPE;
BEGIN
   BEGIN
      SELECT CodGrupoEc
        INTO cCodGrupoEc
        FROM GRUPO_ECONOMICO
       WHERE CodCia                  = nCodCia
         AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodGrupoEc := 'GEDR-'||TRIM(TO_CHAR(nIdSolicitud,'00000000'));
         INSERT INTO GRUPO_ECONOMICO
                (CodGrupoEc, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
                 CodCia, Observaciones, Estado)
         VALUES (cCodGrupoEc, cTipo_Doc_Identificacion, cNum_Doc_Identificacion,
                 nCodCia, 'GRUPO ECONOMICO X DIRECCION REGIONAL', 'ACTIVO');
      WHEN TOO_MANY_ROWS THEN
         SELECT MAX(CodGrupoEc)
           INTO cCodGrupoEc
           FROM GRUPO_ECONOMICO
          WHERE CodCia                  = nCodCia
            AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
            AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   END;
   RETURN(cCodGrupoEc);
END VALIDA_CREA;

FUNCTION ALTA_AUTOMATICA(P_CODCLIENTE VARCHAR2,         --01/12/2019  RENOV
                         P_CODCIA     NUMBER) RETURN VARCHAR2 IS
--
CCODGRUPOEC                GRUPO_ECONOMICO.CODGRUPOEC%TYPE;
CTIPO_DOC_IDENTIFICACION   CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
CNUM_DOC_IDENTIFICACION    CLIENTES.NUM_DOC_IDENTIFICACION%TYPE;
NCODCLIENTE                CLIENTES.CODCLIENTE%TYPE;
NGRABADOS                  NUMBER;
--
BEGIN
  --
  CCODGRUPOEC := '';
  NGRABADOS   := 0;
  NCODCLIENTE := TO_NUMBER(P_CODCLIENTE);
  --
  BEGIN
    SELECT GE.CODGRUPOEC
      INTO CCODGRUPOEC
      FROM GRUPO_ECONOMICO GE
     WHERE GE.CODGRUPOEC = P_CODCLIENTE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CCODGRUPOEC := '';
    WHEN OTHERS THEN
         CCODGRUPOEC := '';
  END;
  --
  IF CCODGRUPOEC IS NULL THEN
     BEGIN
       SELECT C.TIPO_DOC_IDENTIFICACION,
              C.NUM_DOC_IDENTIFICACION
         INTO CTIPO_DOC_IDENTIFICACION,
              CNUM_DOC_IDENTIFICACION
         FROM CLIENTES C
        WHERE C.CODCLIENTE = NCODCLIENTE;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            NCODCLIENTE := 0;
       WHEN OTHERS THEN
            NCODCLIENTE := 0;
     END;  
     --
     IF NCODCLIENTE != 0 THEN
        INSERT INTO GRUPO_ECONOMICO GE
          (CODGRUPOEC,        TIPO_DOC_IDENTIFICACION,          NUM_DOC_IDENTIFICACION, 
           CODCIA,            OBSERVACIONES,                    ESTADO)
        VALUES
          (P_CODCLIENTE,      CTIPO_DOC_IDENTIFICACION,         CNUM_DOC_IDENTIFICACION,
           P_CODCIA,          'ALTA AUTOMATICA',                'VALIDO');
        --
        NGRABADOS :=  SQL%ROWCOUNT;
        --
        IF NGRABADOS > 0 THEN
           --
          COMMIT;
           --
        END IF;
     END IF;
  END IF;
  RETURN(NCODCLIENTE);    --01/12/2019  RENOV
END;
--
--
END OC_GRUPO_ECONOMICO;
/

--
-- OC_GRUPO_ECONOMICO  (Synonym) 
--
--  Dependencies: 
--   OC_GRUPO_ECONOMICO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_GRUPO_ECONOMICO FOR SICAS_OC.OC_GRUPO_ECONOMICO
/


GRANT EXECUTE ON SICAS_OC.OC_GRUPO_ECONOMICO TO PUBLIC
/
