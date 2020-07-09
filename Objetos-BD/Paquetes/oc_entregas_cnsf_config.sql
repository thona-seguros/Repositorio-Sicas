--
-- OC_ENTREGAS_CNSF_CONFIG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_ENTREGAS_CNSF_PLANTILLA (Package)
--   ENTREGAS_CNSF_CONFIG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENTREGAS_CNSF_CONFIG IS
   PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2);
   PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2);
   PROCEDURE ENTREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2);
   PROCEDURE PRORROGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2);
   PROCEDURE ACTUALIZA_USUARIO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2);
   PROCEDURE RECALENDARIZAR(nCodCia NUMBER, nCodEmpresa NUMBER);
   PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntregaOrig VARCHAR2, cCodEntregaDest VARCHAR2, cNomEntregaDest VARCHAR2);
   FUNCTION PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2;
   FUNCTION TIPO_CATALOGO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2;
   FUNCTION TIPO_OBJETO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2;
   FUNCTION SEPARADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2;
   FUNCTION NOMBRE_ENTREGA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2;
   --
   FUNCTION NOMBRE_ARCHIVO( nCodCia      NUMBER
                          , nCodEmpresa  NUMBER
                          , cCodEntrega  VARCHAR2 ) RETURN VARCHAR2;

END OC_ENTREGAS_CNSF_CONFIG;
/

--
-- OC_ENTREGAS_CNSF_CONFIG  (Package Body) 
--
--  Dependencies: 
--   OC_ENTREGAS_CNSF_CONFIG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENTREGAS_CNSF_CONFIG IS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) IS
cStsEntrega    ENTREGAS_CNSF_CONFIG.StsEntrega%TYPE;
BEGIN
   BEGIN
      SELECT StsEntrega
        INTO cStsEntrega
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'NO Existe Entrega '||cCodEntrega);
   END;

   IF cStsEntrega IN ('CONFIG','SUSPEN') THEN
      UPDATE ENTREGAS_CNSF_CONFIG
         SET StsEntrega  = 'ACTIVA',
             FecSts      = SYSDATE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodEntrega  = cCodEntrega;
   ELSE
      RAISE_APPLICATION_ERROR(-20220,'NO Puede Activar Entregas en Status '||cStsEntrega);
   END IF;
   OC_ENTREGAS_CNSF_CONFIG.ACTUALIZA_USUARIO(nCodCia, nCodEmpresa, cCodEntrega);
END ACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) IS
cStsEntrega    ENTREGAS_CNSF_CONFIG.StsEntrega%TYPE;
BEGIN
   BEGIN
      SELECT StsEntrega
        INTO cStsEntrega
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega
         AND StsEntrega = 'ACTIVA';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'NO Existe Entrega ACTIVA.  No Puede Suspenderla.');
   END;
   UPDATE ENTREGAS_CNSF_CONFIG
      SET StsEntrega  = 'SUSPEN',
          FecSts      = SYSDATE
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodEntrega  = cCodEntrega;
   OC_ENTREGAS_CNSF_CONFIG.ACTUALIZA_USUARIO(nCodCia, nCodEmpresa, cCodEntrega);
END SUSPENDER;

PROCEDURE ENTREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) IS
cStsEntrega    ENTREGAS_CNSF_CONFIG.StsEntrega%TYPE;
BEGIN
   UPDATE ENTREGAS_CNSF_CONFIG
      SET StsEntrega  = 'ENTREG',
          FecSts      = SYSDATE
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodEntrega  = cCodEntrega;
   OC_ENTREGAS_CNSF_CONFIG.ACTUALIZA_USUARIO(nCodCia, nCodEmpresa, cCodEntrega);
END ENTREGAR;

PROCEDURE PRORROGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) IS
cStsEntrega    ENTREGAS_CNSF_CONFIG.StsEntrega%TYPE;
BEGIN
   UPDATE ENTREGAS_CNSF_CONFIG
      SET StsEntrega  = 'PRORRO',
          FecSts      = SYSDATE
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodEntrega  = cCodEntrega;
   OC_ENTREGAS_CNSF_CONFIG.ACTUALIZA_USUARIO(nCodCia, nCodEmpresa, cCodEntrega);
END PRORROGAR;

PROCEDURE ACTUALIZA_USUARIO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) IS
BEGIN
   UPDATE ENTREGAS_CNSF_CONFIG
      SET CodUsuario   = USER,
          FecUltCambio = SYSDATE
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodEntrega   = cCodEntrega;
END ACTUALIZA_USUARIO;

PROCEDURE RECALENDARIZAR(nCodCia NUMBER, nCodEmpresa NUMBER) IS
dFecLimite   ENTREGAS_CNSF_CONFIG.FecLimEntrega%TYPE;
nCantMeses   NUMBER(5);
CURSOR ENT_Q IS
   SELECT CodEntrega, TotDiasEntrega, FrecEntrega, StsEntrega
     FROM ENTREGAS_CNSF_CONFIG
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND StsEntrega <> 'SUSPEN';
BEGIN
   FOR X IN ENT_Q LOOP
      IF NVL(X.TotDiasEntrega,0) != 0 THEN
         dFecLimite := TO_DATE('01/01/'||TO_CHAR(SYSDATE,'YYYY'),'DD/MM/YYYY') + (X.TotDiasEntrega - 1);
      ELSE
         IF X.FrecEntrega = 'SEM' THEN
            nCantMeses := 6;
         ELSIF X.FrecEntrega = 'TRI' THEN
            nCantMeses := 3;
         ELSIF X.FrecEntrega = 'MEN' THEN
            nCantMeses := 1;
         END IF;
         dFecLimite := ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(SYSDATE,'YYYY'),'DD/MM/YYY'), nCantMeses);
      END IF;
      IF TO_CHAR(dFecLimite,'D') = 6 THEN -- Si es Sábado se mueve al Lunes
         dFecLimite := dFecLimite + 2;
      ELSIF TO_CHAR(dFecLimite,'D') = 7 THEN -- Si es Domingo se mueve al Lunes
         dFecLimite := dFecLimite + 1;
      END IF;

      BEGIN
         UPDATE ENTREGAS_CNSF_CONFIG
            SET FecLimEntrega = dFecLimite,
                FecProrroga   = NULL,
                StsEntrega    = DECODE(X.StsEntrega,'CONFIG','CONFIG','ACTIVA'),
                FecSts        = SYSDATE
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodEntrega = X.CodEntrega;
      END;
      OC_ENTREGAS_CNSF_CONFIG.ACTUALIZA_USUARIO(nCodCia, nCodEmpresa, X.CodEntrega);
   END LOOP;
END RECALENDARIZAR;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntregaOrig VARCHAR2, cCodEntregaDest VARCHAR2, cNomEntregaDest VARCHAR2) IS
CURSOR ENT_Q IS
   SELECT TipoEntrega, AreaEntrega, FrecEntrega, FecLimEntrega,
          FecProrroga, TotDiasEntrega, FormaEntrega, StsEntrega,
          FecSts, DescEntrega, TipoObjeto, NomRepProc, NomArchivo, 
          CodPlantilla, CodLista, Separador
     FROM ENTREGAS_CNSF_CONFIG
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodEntrega = cCodEntregaOrig;
BEGIN
   FOR X IN ENT_Q LOOP
      BEGIN
         INSERT INTO ENTREGAS_CNSF_CONFIG
               (CodCia, CodEmpresa, CodEntrega, NomEntrega, TipoEntrega, AreaEntrega, 
                FrecEntrega, FecLimEntrega, FecProrroga, TotDiasEntrega, FormaEntrega, 
                StsEntrega,FecSts, DescEntrega, TipoObjeto, NomRepProc, NomArchivo, 
                CodPlantilla, CodLista, Separador, CodUsuario, FecUltCambio)
         VALUES(nCodCia, nCodEmpresa, cCodEntregaDest, cNomEntregaDest, X.TipoEntrega, X.AreaEntrega, 
                X.FrecEntrega, X.FecLimEntrega, X.FecProrroga, X.TotDiasEntrega, X.FormaEntrega,
                'CONFIG', SYSDATE, X.DescEntrega, X.TipoObjeto, X.NomRepProc, X.NomArchivo, 
                X.CodPlantilla, X.CodLista, X.Separador, USER, SYSDATE);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Copia en ENTREGAS_CNSF_CONFIG CodEntrega ' ||
                                    cCodEntregaDest ||'-'||cNomEntregaDest);
      END;
      OC_ENTREGAS_CNSF_PLANTILLA.COPIAR(nCodCia, nCodEmpresa, cCodEntregaOrig, cCodEntregaDest);            
   END LOOP; 
END COPIAR;

FUNCTION PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2 IS
cCodPlantilla   ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
BEGIN
   BEGIN
      SELECT CodPlantilla
        INTO cCodPlantilla
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Determinar la Plantilla que Utiliza');
   END;
   RETURN(cCodPlantilla);
END PLANTILLA;

FUNCTION TIPO_CATALOGO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2 IS
cCodLista   ENTREGAS_CNSF_CONFIG.CodLista%TYPE;
BEGIN
   BEGIN
      SELECT CodLista
        INTO cCodLista
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Determinar el Tipo de Catálogo que Utiliza');
   END;
   RETURN(cCodLista);
END TIPO_CATALOGO;

FUNCTION TIPO_OBJETO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2 IS
cTipoObjeto   ENTREGAS_CNSF_CONFIG.TipoObjeto%TYPE;
BEGIN
   BEGIN
      SELECT TipoObjeto
        INTO cTipoObjeto
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Determinar el Tipo de Objeto a Ejecutar');
   END;
   RETURN(cTipoObjeto);
END TIPO_OBJETO;

FUNCTION SEPARADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2 IS
cSeparador   ENTREGAS_CNSF_CONFIG.Separador%TYPE;
BEGIN
   BEGIN
      SELECT Separador
        INTO cSeparador
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Determinar el Separador que Utiliza');
   END;
   RETURN(cSeparador);
END SEPARADOR;

FUNCTION NOMBRE_ENTREGA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2) RETURN VARCHAR2 IS
cNomEntrega   ENTREGAS_CNSF_CONFIG.NomEntrega%TYPE;
BEGIN
   BEGIN
      SELECT NomEntrega
        INTO cNomEntrega
        FROM ENTREGAS_CNSF_CONFIG
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND CodEntrega = cCodEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Saber su Nombre o Descripción');
   END;
   RETURN(cNomEntrega);
END NOMBRE_ENTREGA;

   FUNCTION NOMBRE_ARCHIVO( nCodCia      NUMBER
                          , nCodEmpresa  NUMBER
                          , cCodEntrega  VARCHAR2 ) RETURN VARCHAR2 IS
      cNomArchivo   ENTREGAS_CNSF_CONFIG.NomArchivo%TYPE;
   BEGIN
      SELECT NomArchivo
      INTO   cNomArchivo
      FROM   ENTREGAS_CNSF_CONFIG 
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  CodEntrega = cCodEntrega;
      --
      RETURN cNomArchivo;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20100,'NO Existe Entrega ' ||cCodEntrega || ' para Saber su Nombre o Descripción');
   END NOMBRE_ARCHIVO;

END OC_ENTREGAS_CNSF_CONFIG;
/

--
-- OC_ENTREGAS_CNSF_CONFIG  (Synonym) 
--
--  Dependencies: 
--   OC_ENTREGAS_CNSF_CONFIG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ENTREGAS_CNSF_CONFIG FOR SICAS_OC.OC_ENTREGAS_CNSF_CONFIG
/


GRANT EXECUTE ON SICAS_OC.OC_ENTREGAS_CNSF_CONFIG TO PUBLIC
/
