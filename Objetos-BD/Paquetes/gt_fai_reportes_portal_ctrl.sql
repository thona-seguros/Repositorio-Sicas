--
-- GT_FAI_REPORTES_PORTAL_CTRL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   UTL_FILE (Synonym)
--   DUAL (Synonym)
--   DBMS_LOB (Synonym)
--   ALL_DIRECTORIES (Synonym)
--   XMLAGG (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   SYS_IXMLAGG (Function)
--   VALORES_DE_LISTAS (Table)
--   GT_REPORTE_FORMATO (Package)
--   POLIZAS (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   FAI_REPORTES_PORTAL_CTRL (Table)
--   GT_FAI_FONDOS_DETALLE_POLIZA (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   PARAMETROS_GLOBALES (Table)
--   REPORTE (Table)
--   REPORTE_FORMATO (Table)
--   REPORTE_PARAMETRO (Table)
--   OC_GENERALES (Package)
--   DETALLE_POLIZA (Table)
--   ENDOSOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_REPORTES_PORTAL_CTRL AS
    FUNCTION NUMERO_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER) RETURN NUMBER;
    FUNCTION NOMBRE_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2;
    FUNCTION RUTA_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2;
    FUNCTION DIRECTORIOBD_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2;
    FUNCTION TIPO_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2;
    FUNCTION EXISTE_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER,
                            nIdPoliza IN NUMBER, cTipoReporte IN VARCHAR2, cMesReporte IN VARCHAR2,
                            cAnioReporte IN VARCHAR2) RETURN VARCHAR2;
    PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, nIdPoliza IN NUMBER, 
                      cTipoReporte IN VARCHAR2, dFechaGenReporte IN DATE, cHoraGenReporte IN VARCHAR2, 
                      cMesReporte IN VARCHAR2, cAnioReporte IN VARCHAR2, cNombreReporte IN VARCHAR2, 
                      cRutaReporte IN VARCHAR2, cDirectorioBd IN VARCHAR2);
    PROCEDURE TIPOS_REPORTES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, xTiposReportes OUT XMLTYPE);
    PROCEDURE CONTROL_ARCHIVOS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                               nIdPoliza IN NUMBER, cTipoReporte IN VARCHAR2, dFechaGenReporte IN DATE,
                               xReportes OUT XMLTYPE);
    PROCEDURE GENERA_REPORTERIA (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFecEmision IN DATE, 
                                 cNomReporte VARCHAR2);
END GT_FAI_REPORTES_PORTAL_CTRL;
/

--
-- GT_FAI_REPORTES_PORTAL_CTRL  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_REPORTES_PORTAL_CTRL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_REPORTES_PORTAL_CTRL AS

FUNCTION NUMERO_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER) RETURN NUMBER IS
nIdReporte FAI_REPORTES_PORTAL_CTRL.IdReporte%TYPE;
BEGIN
   SELECT NVL(MAX(IdReporte),0) + 1
     INTO nIdReporte
     FROM FAI_REPORTES_PORTAL_CTRL
    WHERE CodCia     = nCodCia 
      AND CodEmpresa = nCodEmpresa;
   RETURN nIdReporte;
END NUMERO_REPORTE;

FUNCTION NOMBRE_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2 IS
cNombreReporte FAI_REPORTES_PORTAL_CTRL.NombreReporte%TYPE;
BEGIN
    BEGIN
        SELECT NombreReporte
          INTO cNombreReporte
          FROM FAI_REPORTES_PORTAL_CTRL
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND IdReporte    = nIdReporte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cNombreReporte := 'SIN NOMBRE';
    END;
    RETURN cNombreReporte;
END NOMBRE_REPORTE;

FUNCTION RUTA_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2 IS
cRutaReporte FAI_REPORTES_PORTAL_CTRL.RutaReporte%TYPE;
BEGIN
    BEGIN
        SELECT RutaReporte
          INTO cRutaReporte
          FROM FAI_REPORTES_PORTAL_CTRL
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND IdReporte    = nIdReporte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cRutaReporte := 'SIN NOMBRE';
    END;
    RETURN cRutaReporte;
END RUTA_REPORTE;

FUNCTION DIRECTORIOBD_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2 IS
cDirectorioBd FAI_REPORTES_PORTAL_CTRL.DirectorioBd%TYPE;
BEGIN
    BEGIN
        SELECT DirectorioBd
          INTO cDirectorioBd
          FROM FAI_REPORTES_PORTAL_CTRL
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND IdReporte    = nIdReporte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cDirectorioBd := 'SIN NOMBRE';
    END;
    RETURN cDirectorioBd;
END DIRECTORIOBD_REPORTE;

FUNCTION TIPO_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdReporte IN NUMBER) RETURN VARCHAR2 IS
cTipoReporte FAI_REPORTES_PORTAL_CTRL.TipoReporte%TYPE;
BEGIN
    BEGIN
        SELECT TipoReporte
          INTO cTipoReporte
          FROM FAI_REPORTES_PORTAL_CTRL
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND IdReporte    = nIdReporte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cTipoReporte := 'SIN NOMBRE';
    END;
    RETURN cTipoReporte;
END TIPO_REPORTE;

FUNCTION EXISTE_REPORTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER,
                            nIdPoliza IN NUMBER, cTipoReporte IN VARCHAR2, cMesReporte IN VARCHAR2,
                            cAnioReporte IN VARCHAR2) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);                            
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_REPORTES_PORTAL_CTRL
       WHERE CodCia                       = nCodCia
         AND CodEmpresa                   = nCodEmpresa
         AND CodCliente                   = nCodCliente
         AND IdPoliza                     = nIdPoliza
         AND TipoReporte                  = cTipoReporte
         AND NVL(MesReporte,cMesReporte)  = NVL(cMesReporte,MesReporte)
         AND NVL(AnioReporte,cAnioReporte)= NVL(cAnioReporte,AnioReporte);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cExiste := 'N';
   END;
   RETURN cExiste;
END EXISTE_REPORTE;

PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, nIdPoliza IN NUMBER, 
                   cTipoReporte IN VARCHAR2, dFechaGenReporte IN DATE, cHoraGenReporte IN VARCHAR2, 
                   cMesReporte IN VARCHAR2, cAnioReporte IN VARCHAR2, cNombreReporte IN VARCHAR2, 
                   cRutaReporte IN VARCHAR2, cDirectorioBd IN VARCHAR2) IS
nIdReporte FAI_REPORTES_PORTAL_CTRL.IdReporte%TYPE;
BEGIN
    nIdReporte := GT_FAI_REPORTES_PORTAL_CTRL.NUMERO_REPORTE(nCodCia,nCodEmpresa);
    INSERT INTO FAI_REPORTES_PORTAL_CTRL (CodCia, CodEmpresa, IdReporte, CodCliente, IdPoliza, 
                                          TipoReporte, FechaGenReporte, HoraGenReporte, MesReporte,
                                          AnioReporte, NombreReporte, RutaReporte, DirectorioBd, 
                                          EstadoReporte, FechaEstado)
                                  VALUES (nCodCia, nCodEmpresa, nIdReporte, nCodCliente, nIdPoliza,
                                          cTipoReporte, dFechaGenReporte, cHoraGenReporte, cMesReporte,
                                          cAnioReporte, cNombreReporte, cRutaReporte, cDirectorioBd, 
                                          'GENERADO', TRUNC(SYSDATE));
END INSERTAR;

PROCEDURE TIPOS_REPORTES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, xTiposReportes OUT XMLTYPE) IS
xPrevTiposReportes      XMLTYPE;
BEGIN
  BEGIN
      SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("TiposReportes", 
                                                     XMLElement("CodigoTipo",CodValor),
                                                     XMLElement("Descripcion",DescValLst)
                                                  )
                                       )
                                 ) 
                           )
        INTO xPrevTiposReportes
        FROM VALORES_DE_LISTAS
        WHERE CODLISTA = 'TIPOREP';
  END;
  SELECT XMLROOT (xPrevTiposReportes, VERSION '1.0" encoding="UTF-8')
    INTO xTiposReportes
    FROM DUAL;
END TIPOS_REPORTES;

PROCEDURE CONTROL_ARCHIVOS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                           nIdPoliza IN NUMBER, cTipoReporte IN VARCHAR2, dFechaGenReporte IN DATE,
                           xReportes OUT XMLTYPE) IS
xPrevReportes      XMLTYPE;                             
BEGIN
  BEGIN
      SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("Documentacion", 
                                                     XMLElement("IdReporte",IdReporte),
                                                     XMLElement("CodCliente",CodCliente),
                                                     XMLElement("IdPoliza",IdPoliza),
                                                     XMLElement("TipoReporte",TipoReporte),
                                                     XMLElement("FechaGenReporte",FechaGenReporte),
                                                     XMLElement("HoraGenReporte",HoraGenReporte),
                                                     XMLElement("MesReporte",MesReporte),
                                                     XMLElement("AnioReporte",AnioReporte),
                                                     XMLElement("NombreReporte",NombreReporte),
                                                     XMLElement("RutaReporte",RutaReporte),
                                                     XMLElement("DirectorioBd",DirectorioBd)
                                                  )
                                       )
                                 ) 
                           )
        INTO xPrevReportes
        FROM FAI_REPORTES_PORTAL_CTRL
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND CodCliente       = nCodCliente
         AND IdPoliza         = nIdPoliza
         AND TipoReporte      = NVL(cTipoReporte,TipoReporte)
         AND FechaGenReporte  = NVL(dFechaGenReporte,FechaGenReporte);
  END;
  SELECT XMLROOT (xPrevReportes, VERSION '1.0" encoding="UTF-8')
    INTO xReportes
    FROM DUAL;
END CONTROL_ARCHIVOS;

PROCEDURE GENERA_REPORTERIA (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFecEmision IN DATE, 
                                 cNomReporte VARCHAR2) IS
cCmd                VARCHAR2(2000);
cRutaReporte        PARAMETROS_GLOBALES.Descripcion%TYPE    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'002');
cRutaRepEjecutable  PARAMETROS_GLOBALES.Descripcion%TYPE    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'045');
cClienteFTP         PARAMETROS_GLOBALES.Descripcion%TYPE    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'046');
cDirectorio         VARCHAR2(50)                            := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'047');
cIpFTPNas           VARCHAR2(50)                            := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'048');
cDirSFTPNas         VARCHAR2(50)                            := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'049');
cSetHeader          VARCHAR2(100)                           := 'SET ECHO ON;';
cFooter             VARCHAR2(100)                           := 'EXIT;'||CHR(10)||'/';
cNomArchBat         VARCHAR2(500)                           := 'EjecutaRWServer.bat';
cNomArchSql         VARCHAR2(500);
cPathLog            PARAMETROS_GLOBALES.Descripcion%TYPE;
cNomFileLog         VARCHAR2(500);
cCmdFilesFtp        VARCHAR2(32000);
nIdReporte          REPORTE.IdReporte%TYPE;
cValorParam         VARCHAR2(300);
cFormato            REPORTE_FORMATO.Formato%TYPE;
cNombrePdf          VARCHAR2(200);
cTipoReporte        FAI_REPORTES_PORTAL_CTRL.TipoReporte%TYPE;
cLineaSql           VARCHAR2(32767);
fArchivoSql         UTL_FILE.FILE_TYPE;
fArchivoBat         UTL_FILE.FILE_TYPE;

nIDetPolIni         DETALLE_POLIZA.IDetPol%TYPE;
nIDetPolFin         DETALLE_POLIZA.IDetPol%TYPE;
nCodAsegIni         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nCodAsegFin         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nIdEndosoIni        ENDOSOS.IdEndoso%TYPE;
nIdEndosoFin        ENDOSOS.IdEndoso%TYPE;
nCodAsegurado       FAI_FONDOS_DETALLE_POLIZA.CodAsegurado%TYPE;
dFecIni             DATE; 
dFecFin             DATE;
cMesEdoCta          VARCHAR2(2);
cAnioEdoCta         VARCHAR2(4);
cIndGeneraEdoCta    VARCHAR2(1) := 'N';
cDiaIniVig          VARCHAR2(2);
dFecMesAniversario  DATE;
dIniMesAniversario  DATE;

cExisteReporte      VARCHAR2(1);

CURSOR POLIZAS_Q IS
    SELECT P.IdPoliza,DP.IDetPol,DP.Cod_Asegurado,DP.IdTipoSeg,
           P.CodCliente,P.FecIniVig,P.FecFinVig,
           TO_CHAR(P.FecIniVig,'DD') DiaIniVig,
           ROUND(MONTHS_BETWEEN(P.FecFinVig,P.FecIniVig)) MesesVigencia
      FROM POLIZAS P,DETALLE_POLIZA DP
     WHERE P.CodCia     = nCodCia
       AND P.CodEmpresa = nCodEmpresa 
       AND P.FecEmision>= NVL(dFecEmision,P.FecEmision)
       AND P.StsPoliza  = 'EMI' 
       AND P.CodCia     = DP.CodCia
       AND P.CodEmpresa = DP.CodEmpresa
       AND P.IdPoliza   = DP.IdPoliza
       AND OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(P.CodCia, P.CodEmpresa, DP.IdTipoSeg) = 'S'  
       AND GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(P.CodCia, P.CodEmpresa, P.IdPoliza, DP.IDetPol, DP.Cod_Asegurado) = 'S'
       AND P.IdPoliza = 27670
     /*  AND NOT EXISTS (SELECT 'S'
                         FROM FAI_REPORTES_PORTAL_CTRL
                        WHERE CodCia        = nCodCia
                          AND CodEmpresa    = nCodEmpresa
                          AND CodCliente    = P.CodCliente
                          AND IdPoliza      = P.IdPoliza
                          AND EstadoReporte = 'GENERADO')*/
                          ;
                          
CURSOR REPORTES_Q IS
    SELECT IdReporte,Reporte
      FROM REPORTE   
     --WHERE IdReporte IN (94,93)
     WHERE (REPORTE  = cNomReporte AND cNomReporte IS NOT NULL)
        OR (REPORTE IN ('POLIZAVF','ESTCTAFO') AND cNomReporte IS NULL)
     ORDER BY IdReporte;
     
CURSOR PARAMREP_Q IS
    SELECT UPPER(Nom_Param) Nom_Param,Tipo_Param
      FROM REPORTE_PARAMETRO
     WHERE IdReporte = nIdReporte
     ORDER BY NumOrden;                       
BEGIN
    IF DBMS_LOB.FILEEXISTS(BFILENAME(cDirectorio, cNomArchBat)) = 1 THEN
        UTL_FILE.FREMOVE(cDirectorio,cNomArchBat);
    END IF;
    fArchivoBat := UTL_FILE.FOPEN(cDirectorio,cNomArchBat,'W');
    cNomArchSql := 'CreaReporte_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.sql';
    fArchivoSql := UTL_FILE.FOPEN(cDirectorio,cNomArchSql,'W');
    UTL_FILE.PUT_LINE(fArchivoSql,cSetHeader);
    
    BEGIN
        SELECT Directory_Path
          INTO cPathLog
          FROM ALL_DIRECTORIES
         WHERE Directory_Name = cDirectorio;
    END;
    
    FOR X IN POLIZAS_Q LOOP
        cIndGeneraEdoCta := 'N';
        cDiaIniVig       := X.DiaIniVig;
        SELECT MIN(DP.IDetPol),MAX(DP.IDetPol),
               MIN(DP.Cod_Asegurado),MAX(DP.Cod_Asegurado)
          INTO nIDetPolIni,nIDetPolFin,
               nCodAsegIni,nCodAsegFin
          FROM DETALLE_POLIZA DP
         WHERE DP.CodCia    = nCodCia
           AND DP.CodEmpresa= nCodEmpresa
           AND DP.IdPoliza  = X.IdPoliza
           AND DP.IDetPol   = X.IDetPol
           AND DP.StsDetalle   = 'EMI';
           
        SELECT MIN(IdEndoso),MAX(IdEndoso)
          INTO nIdEndosoIni,nIdEndosoFin
          FROM ENDOSOS E
         WHERE E.CodCia    = nCodCia
           AND E.CodEmpresa= nCodEmpresa
           AND E.IdPoliza  = X.IdPoliza
           AND E.IDetPol   = X.IDetPol
           AND E.StsEndoso = 'EMI';
           
       SELECT DISTINCT CodAsegurado
         INTO nCodAsegurado
         FROM FAI_FONDOS_DETALLE_POLIZA
        WHERE CodCia    = nCodCia
          AND CodEmpresa= nCodEmpresa
          AND IdPoliza= X.IdPoliza
          AND IDetPol = X.IDetPol;
       
       FOR W IN 1..X.MesesVigencia LOOP
          dFecMesAniversario := TRUNC(ADD_MONTHS(X.FecIniVig,W));
          SELECT TO_CHAR(dFecMesAniversario,'MM'),TO_CHAR(dFecMesAniversario,'YYYY')
            INTO cMesEdoCta,cAnioEdoCta
            FROM DUAL;
          IF GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '002', cMesEdoCta, cAnioEdoCta) = 'N' AND (dFecMesAniversario + 1) <= TRUNC(SYSDATE) THEN
            dFecIni          := ADD_MONTHS(dFecMesAniversario,-1);
            dFecFin          := dFecMesAniversario;
            cIndGeneraEdoCta := 'S';
            EXIT;
          END IF;
       END LOOP;    
       
       IF cIndGeneraEdoCta = 'S' THEN NULL; END IF;
        FOR J IN REPORTES_Q LOOP
            nIdReporte  := J.IdReporte;
            cValorParam := NULL;
            cFormato    := GT_REPORTE_FORMATO.FORMATO_PRINCIPAL(nIdReporte);
            
            IF J.Reporte = 'POLIZAVF' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '002', cMesEdoCta, cAnioEdoCta) = 'N' THEN
                cTipoReporte:= '001';
                cNombrePdf  := TO_CHAR(X.CodCliente)||'_'||TO_CHAR(X.IdPoliza)||'_'||cTipoReporte||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.PDF';
                cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Es7e35elPr0duct1V0@PRODUCCI DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                --cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Nu3v0T35T@PRUEBAS DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                
                FOR W IN PARAMREP_Q LOOP
                    IF W.Nom_Param LIKE '%CODCIA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                    ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                    ELSIF W.Nom_Param LIKE '%CODASEGINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegIni)) ||' ';
                    ELSIF W.Nom_Param LIKE '%CODASEGFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegFin)) ||' ';
                    ELSIF W.Nom_Param LIKE '%ENDOSOINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIdEndosoIni))||' ';
                    ELSIF W.Nom_Param LIKE '%ENDOSOFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIdEndosoFin))||' ';
                    ELSE
                       cValorParam := '9999999';
                    END IF;
                END LOOP;
                cValorParam := cValorParam||'"';
                cCmd        := cCmd||cValorParam;
                cLineaSql   := 'host '||cCmd||';';
                UTL_FILE.PUT_LINE(fArchivoSql,cLineaSql);
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), NULL, NULL, cNombrePdf, cDirSFTPNas , cDirectorio);
            ELSIF J.Reporte = 'ESTCTAFO' AND cIndGeneraEdoCta = 'S' THEN
               cTipoReporte:= '002';
               cNombrePdf  := TO_CHAR(X.CodCliente)||'_'||TO_CHAR(X.IdPoliza)||'_'||cTipoReporte||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.PDF';
                cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Es7e35elPr0duct1V0@PRODUCCI DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                --cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Nu3v0T35T@PRUEBAS DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                
                FOR W IN PARAMREP_Q LOOP
                    IF W.Nom_Param LIKE '%CODCIA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                    ELSIF W.Nom_Param LIKE '%IDPOLIZA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOL%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IDetPol)) ||' ';
                    ELSIF W.Nom_Param LIKE '%CODEMPRESA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodEmpresa)) ||' ';
                    ELSIF W.Nom_Param LIKE '%CODASEGURADO%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegurado)) ||' ';
                    ELSIF W.Nom_Param LIKE '%FECINI%' THEN
                       --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR('TO_DATE('||''''||dFecIni||''''||','||''''||'DD/MM/YYYY'||''''||')'))||' ';
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(''''||TO_CHAR(dFecIni,'DD/MM/YYYY')||''''))||' ';
                    ELSIF W.Nom_Param LIKE '%FECFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(''''||TO_CHAR(dFecFin,'DD/MM/YYYY')||''''))||' ';
                       --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR('TO_DATE('||''''||dFecFin||''''||','||''''||'DD/MM/RRRR'||''''||')'))||' ';
                    ELSE
                       cValorParam := '9999999';
                    END IF;
                END LOOP;
                cValorParam := cValorParam||'"';
                cCmd        := cCmd||cValorParam;
                cLineaSql   := 'host '||cCmd||';';
                UTL_FILE.PUT_LINE(fArchivoSql,cLineaSql);
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
            
            ELSIF J.Reporte = 'APORTREG' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '009', NULL, NULL) = 'N' THEN
               cTipoReporte:= '009';
               cNombrePdf  := TO_CHAR(X.CodCliente)||'_'||TO_CHAR(X.IdPoliza)||'_'||cTipoReporte||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.PDF';
               cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Es7e35elPr0duct1V0@PRODUCCI DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                --cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Nu3v0T35T@PRUEBAS DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                
                FOR W IN PARAMREP_Q LOOP
                    IF W.Nom_Param LIKE '%CODCIA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                    ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                    ELSE
                       cValorParam := '9999999';
                    END IF;
                END LOOP;
                cValorParam := cValorParam||'"';
                cCmd        := cCmd||cValorParam;
                cLineaSql   := 'host '||cCmd||';';
                UTL_FILE.PUT_LINE(fArchivoSql,cLineaSql);
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
            ELSIF J.Reporte = 'APORTEXT' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '010', NULL, NULL) = 'N' THEN
               cTipoReporte:= '010';
               cNombrePdf  := TO_CHAR(X.CodCliente)||'_'||TO_CHAR(X.IdPoliza)||'_'||cTipoReporte||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.PDF';
               cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Es7e35elPr0duct1V0@PRODUCCI DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                --cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Nu3v0T35T@PRUEBAS DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                
                FOR W IN PARAMREP_Q LOOP
                    IF W.Nom_Param LIKE '%CODCIA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                    ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                    ELSE
                       cValorParam := '9999999';
                    END IF;
                END LOOP;
                cValorParam := cValorParam||'"';
                cCmd        := cCmd||cValorParam;
                cLineaSql   := 'host '||cCmd||';';
                UTL_FILE.PUT_LINE(fArchivoSql,cLineaSql);
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
            
            ELSIF J.Reporte = 'XXXXX' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '010', NULL, NULL) = 'N' THEN
               cTipoReporte:= '010';
               cNombrePdf  := TO_CHAR(X.CodCliente)||'_'||TO_CHAR(X.IdPoliza)||'_'||cTipoReporte||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.PDF';
               cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Es7e35elPr0duct1V0@PRODUCCI DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                --cCmd        := '"'||cRutaRepEjecutable||' '||cRutaReporte||J.Reporte||' userid=SICAS_OC/Nu3v0T35T@PRUEBAS DESTYPE=FILE DESNAME='||cPathLog||'\'||cNombrePdf||' DESFORMAT='||cFormato||' ';
                
                FOR W IN PARAMREP_Q LOOP
                    IF W.Nom_Param LIKE '%CODCIA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                    ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                    ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                       cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                    ELSE
                       cValorParam := '9999999';
                    END IF;
                END LOOP;
                cValorParam := cValorParam||'"';
                cCmd        := cCmd||cValorParam;
                cLineaSql   := 'host '||cCmd||';';
                UTL_FILE.PUT_LINE(fArchivoSql,cLineaSql);
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
            END IF;
        END LOOP;
    END LOOP;
    UTL_FILE.PUT_LINE(fArchivoSql,cFooter);
    UTL_FILE.FCLOSE (fArchivoSql);
    cCmd        := 'start /B /WAIT C:\app\SicasProd\product\11.2.0\dbhome_1\BIN\sqlplus SICAS_OC/Es7e35elPr0duct1V0@SICASPROD @'||cNomArchSql;
    --cCmd        := 'start /B /WAIT C:\app\oracle11g\product\11.2.0\dbhome_1\BIN\sqlplus SICAS_OC/Nu3v0T35T@PRUEBAS @'||cNomArchSql;
    UTL_FILE.PUT_LINE(fArchivoBat,cCmd);
    
    cNomFileLog  := 'TransferLog'||'_'||TO_CHAR(SYSDATE,'DDMMYYYY')||'_'||TO_CHAR(SYSDATE,'HHMISS')||'.log';
    cCmdFilesFtp := '"'||cClienteFTP||'" ^'                                                                                                                                                 ||CHR(10)||
                    '  /log="'||cPathLog||'\'||cNomFileLog||'" /ini=nul ^'                                                                                                                  ||CHR(10)||
                    '  /command ^'                                                                                                                                                          ||CHR(10)||
                    /*comando para prueas*/    
                    --'    "open sftp://SicasNube:S1cass*@'||cIpFTPNas||':21022/ -hostkey=""ssh-ed25519 256 nzRhe0e3oU5zb/3tTIL+36KJuRrseKpsv6r1LiTf0xA=""" ^'                                ||CHR(10)||                                                                                                                                                     
                    --'"open sftp://SicasNube:S1cass*@'||cIpFTPNas||':21022/ -hostkey=""ssh-ed25519 256 nzRhe0e3oU5zb/3tTIL+36KJuRrseKpsv6r1LiTf0xA=""" ^'                                    ||CHR(10)||
                    /*comando para produccion*/
                    '    "open sftp://SicasVF:VidaF2017%%2A@'||cIpFTPNas||':21022/ -hostkey=""ssh-ed25519 256 72:b2:9b:57:05:52:49:01:59:c3:3b:12:f0:c9:c1:7c""" ^'                         ||CHR(10)||
                    '    "lcd '||cPathLog||'" ^'                                                                                                                                            ||CHR(10)||
                    '    "cd /Doc_Polizas" ^'                                                                                                                                           ||CHR(10)||
                    '    "put *.PDF" ^'                                                                                                                                                     ||CHR(10)||
                    '    "exit"'                                                                                                                                                            ||CHR(10)||CHR(10)||
                    'set WINSCP_RESULT=%ERRORLEVEL%'                                                                                                                                        ||CHR(10)||
                    'if %WINSCP_RESULT% equ 0 ('                                                                                                                                            ||CHR(10)||
                    '  echo Success'                                                                                                                                                        ||CHR(10)||
                    ') else ('                                                                                                                                                              ||CHR(10)||
                    '  echo Error'                                                                                                                                                          ||CHR(10)||
                    ')'                                                                                                                                                                     ||CHR(10)||CHR(10)||
                    'exit /b %WINSCP_RESULT%';         
    UTL_FILE.PUT_LINE(fArchivoBat,cCmdFilesFtp);
    cCmd         := 'delete *.PDF'; 
    UTL_FILE.PUT_LINE(fArchivoBat,cCmd);
    UTL_FILE.FCLOSE (fArchivoBat);
EXCEPTION
    WHEN OTHERS THEN
        UTL_FILE.FCLOSE (fArchivoBat);
        UTL_FILE.FCLOSE (fArchivoSql);
END GENERA_REPORTERIA;

END GT_FAI_REPORTES_PORTAL_CTRL;
/

--
-- GT_FAI_REPORTES_PORTAL_CTRL  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_REPORTES_PORTAL_CTRL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_REPORTES_PORTAL_CTRL FOR SICAS_OC.GT_FAI_REPORTES_PORTAL_CTRL
/


GRANT EXECUTE ON SICAS_OC.GT_FAI_REPORTES_PORTAL_CTRL TO PUBLIC
/
