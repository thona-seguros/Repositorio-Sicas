CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_REPORTES_PORTAL_CTRL AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: N/A                                                                                                              |    
	| Nombre     : GT_FAI_REPORTES_PORTAL_CTRL                                                                                      |
    | Objetivo   : Package gestiona y/o controla la reporteria que es utilizada desde la Plataforma Digital.                        |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 13/08/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle [JALV ]                                                                                   |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Dependencias:                                                                                                                 |
    |       - STANDARD (Package)                                                                                                    |
    |       - XMLTYPE (Type)                                                                                                        |
    |       - UTL_FILE (Synonym)                                                                                                    |
    |       - DUAL (Synonym)                                                                                                        |
    |       - DBMS_LOB (Synonym)                                                                                                    |
    |       - ALL_DIRECTORIES (Synonym)                                                                                             |
    |       - XMLAGG (Synonym)                                                                                                      |
    |       - XMLTYPE (Synonym)                                                                                                     |
    |       - XMLTYPE (Synonym)                                                                                                     |
    |       - SYS_IXMLAGG (Function)                                                                                                |
    |       - VALORES_DE_LISTAS (Table)                                                                                             |
    |       - GT_REPORTE_FORMATO (Package)                                                                                          |
    |       - POLIZAS (Table)                                                                                                       |
    |       - FAI_FONDOS_DETALLE_POLIZA (Table)                                                                                     |
    |       - FAI_REPORTES_PORTAL_CTRL (Table)                                                                                      |
    |       - GT_FAI_FONDOS_DETALLE_POLIZA (Package)                                                                                |
    |       - OC_TIPOS_DE_SEGUROS (Package)                                                                                         |
    |       - PARAMETROS_GLOBALES (Table)                                                                                           |
    |       - REPORTE (Table)                                                                                                       |
    |       - REPORTE_FORMATO (Table)                                                                                               |
    |       - REPORTE_PARAMETRO (Table)                                                                                             |
    |       - OC_GENERALES (Package)                                                                                                |
    |       - DETALLE_POLIZA (Table)                                                                                                |
    |       - ENDOSOS (Table)                                                                                                       |
    |_______________________________________________________________________________________________________________________________|
*/ 
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
    FUNCTION GENERA_REPORTERIA_V2 (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cTipoReporte IN VARCHAR2,
                                    nIdPoliza IN NUMBER, nCodCliente IN VARCHAR2, cMes IN VARCHAR2,
                                    cAnio IN VARCHAR2) RETURN XMLTYPE;
    PROCEDURE CHECA_MESVERSARIO (nCodCia IN NUMBER, nCodEmpresa IN NUMBER);
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
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: N/A                                                                                                              |    
	| Nombre     : EXISTE_REPORTE	                                                                                                |
    | Objetivo   : Funcion que valida la existencia y/o disponibilidad del tipo de reportey demas criterios recibidos.              |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 13/08/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    |                                                                                                                               |
    | Obj. Modif.: Correccion de filtros de busqueda que omitian resultados cuando cMesReporte y cAnioReporte se reciben como Nulos |
    |              en combinacion con algunos cTipoReporte (p.e.'001').                                                             |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |
    |           nCodCliente         Codigo de Cliente               (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |           cTipoReporte        Tipo de Reporte                 (Entrada)                                                       |
    |           cMesReporte         Mes de interes del Reporte      (Entrada)                                                       |
    |           cAnioReporte        Año de interes del Reporte      (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
	
*/                             
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
         AND NVL(MesReporte,cMesReporte)  = NVL(cMesReporte,MesReporte)       --> JALV(-) 13/08/2021
         AND NVL(AnioReporte,cAnioReporte)= NVL(cAnioReporte,AnioReporte);    --> JALV(-) 13/08/2021
         --AND (NVL(MesReporte, cMesReporte)  = NVL(cMesReporte,MesReporte) OR NVL(MesReporte,'NULO') = NVL2(cMesReporte, MesReporte, 'NULO'))      --> JALV(+) 13/08/2021
         --AND (NVL(AnioReporte, cAnioReporte)= NVL(cAnioReporte,AnioReporte) OR  NVL(AnioReporte,'NULO') = NVL2(cAnioReporte, AnioReporte, 'NULO')); --> JALV(+) 13/08/2021
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

PROCEDURE GENERA_REPORTERIA (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFecEmision IN DATE, cNomReporte VARCHAR2) IS
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
       AND P.IdPoliza = 27670 -- Comentar
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
    -- No hacer esta validacion de archivo, pero validar existencia del registro en la tabla FAI_REPORTES_PORTAL_CTRL
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
    cCmd        := 'start /B /WAIT C:\app\SicasProd\product\11.2.0\dbhome_1\BIN\sqlplus SICAS_OC/Es7e35elPr0duct1V0@SICASPROD @'||cNomArchSql;  --> Producción
    --cCmd        := 'start /B /WAIT C:\app\oracle11g\product\11.2.0\dbhome_1\BIN\sqlplus SICAS_OC/Nu3v0T35T@PRUEBAS @'||cNomArchSql;             --> Pruebas
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

FUNCTION GENERA_REPORTERIA_V2 (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cTipoReporte IN VARCHAR2, nIdPoliza IN NUMBER, nCodCliente IN VARCHAR2, cMes IN VARCHAR2, cAnio IN VARCHAR2)
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 13/08/2021                                                                                                       |    
	| Nombre     : GENERA_REPORTERIA_V2                                                                                             |
    | Objetivo   : Funcion que obtiene y genera archivo XML con el nombre del reporte que corresponda al Tipo de Reporte            |
    |              proporcionado y los parametros necesarios para que sea ejecutado desde Plataforma Digital.                       |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |
    |           cTipoReporte        Tipo de Reporte                 (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |           nCodCliente         Codigo de Cliente               (Entrada)                                                       |      
    |           cMes                Mes de interes del Reporte      (Entrada)                                                       |
    |           cAnio               Año de interes del Reporte      (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
	
*/  
nIdReporte          REPORTE.IdReporte%TYPE;
cValorParam         VARCHAR2(1000);
cNomReporte         REPORTE.Reporte%TYPE;

nIDetPolIni         DETALLE_POLIZA.IDetPol%TYPE;
nIDetPolFin         DETALLE_POLIZA.IDetPol%TYPE;
nCodAsegIni         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nCodAsegFin         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nIdEndosoIni        ENDOSOS.IdEndoso%TYPE;
nIdEndosoFin        ENDOSOS.IdEndoso%TYPE;
nCodAsegurado       FAI_FONDOS_DETALLE_POLIZA.CodAsegurado%TYPE;
dFecIni             DATE; 
dFecFin             DATE;
cExisteReporte      VARCHAR2(1);

cValorParamSC       VARCHAR2(1000);
cSQLXML             VARCHAR2(1000) := '   SELECT XMLELEMENT("DATA",'||CHR(10)||'                       ';
xPrevReporte        XMLTYPE;
xReporte            XMLTYPE;

dFecMesAniversario  DATE;

CURSOR POLIZAS_Q IS
    SELECT  P.IdPoliza,
            DP.IDetPol,
            DP.Cod_Asegurado,
            DP.IdTipoSeg,
            P.CodCliente,
            P.FecIniVig,
            P.FecFinVig,
            TO_CHAR(P.FecIniVig,'DD')                       DIAINIVIG,
            ROUND(MONTHS_BETWEEN(P.FecFinVig,P.FecIniVig))  MESESVIGENCIA,
            ROUND(MONTHS_BETWEEN( TRUNC(SYSDATE), P.FecIniVig)) NUM_MES_VIG
    FROM    POLIZAS         P,
            DETALLE_POLIZA  DP
    WHERE   P.CodCia     = nCodCia
    AND     P.CodEmpresa = nCodEmpresa 
    --AND     P.FecEmision >= NVL(dFecEmision, P.FecEmision)
    AND     P.StsPoliza  = 'EMI' 
    AND     P.CodCia     = DP.CodCia
    AND     P.CodEmpresa = DP.CodEmpresa
    AND     P.IdPoliza   = DP.IdPoliza
    AND     OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(P.CodCia, P.CodEmpresa, DP.IdTipoSeg)                                         = 'S'  
    AND     GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(P.CodCia, P.CodEmpresa, P.IdPoliza, DP.IDetPol, DP.Cod_Asegurado)   = 'S'
    AND     P.IdPoliza   =  nIdPoliza
    /*AND     EXISTS (SELECT 'S'
                     FROM FAI_REPORTES_PORTAL_CTRL
                    WHERE CodCia        = nCodCia
                      AND CodEmpresa    = nCodEmpresa
                      AND CodCliente    = P.CodCliente
                      AND IdPoliza      = P.IdPoliza
                      AND EstadoReporte = 'GENERADO')*/
                          ;                          
CURSOR REPORTES_Q IS
    SELECT  IdReporte,
            Reporte
    FROM    REPORTE        
    WHERE   (REPORTE  = cNomReporte AND cNomReporte IS NOT NULL)
    OR      (REPORTE IN ('POLIZAVF','ESTCTAFO') AND cNomReporte IS NULL)
    ORDER BY IdReporte;
     
CURSOR PARAMREP_Q IS
    SELECT  UPPER(Nom_Param) NOM_PARAM,
            Tipo_Param
    FROM    REPORTE_PARAMETRO
    WHERE   IdReporte = nIdReporte
    ORDER BY NumOrden;
    
BEGIN
    -- Validar existencia del registro en la tabla FAI_REPORTES_PORTAL_CTRL
    cExisteReporte := GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, cTipoReporte, cMes, cAnio);
    
    --DBMS_OUTPUT.PUT_LINE('Se puede obtener el Reporte? = '||cExisteReporte);
    SELECT CASE cTipoReporte WHEN '001' THEN 'POLIZAVF'
                             WHEN '002' THEN 'ESTCTAFO'
                             WHEN '009' THEN 'APORTREG'
                             WHEN '010' THEN 'APORTEXT'
            ELSE cTipoReporte
            END
    INTO    cNomReporte
    FROM    DUAL;
    
    FOR X IN POLIZAS_Q LOOP      
        SELECT MIN(DP.IDetPol),
               MAX(DP.IDetPol),
               MIN(DP.Cod_Asegurado),
               MAX(DP.Cod_Asegurado)
          INTO nIDetPolIni, nIDetPolFin, nCodAsegIni, nCodAsegFin
          FROM DETALLE_POLIZA   DP
         WHERE DP.CodCia        = nCodCia
           AND DP.CodEmpresa    = nCodEmpresa
           AND DP.IdPoliza      = X.IdPoliza
           AND DP.IDetPol       = X.IDetPol
           AND DP.StsDetalle    = 'EMI';
           
        SELECT MIN(IdEndoso),
               MAX(IdEndoso)
          INTO nIdEndosoIni, nIdEndosoFin
          FROM ENDOSOS  E
         WHERE E.CodCia     = nCodCia
           AND E.CodEmpresa = nCodEmpresa
           AND E.IdPoliza   = X.IdPoliza
           AND E.IDetPol    = X.IDetPol
           AND E.StsEndoso  = 'EMI';
           
       SELECT DISTINCT CodAsegurado
         INTO nCodAsegurado
         FROM FAI_FONDOS_DETALLE_POLIZA
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdPoliza      = X.IdPoliza
          AND IDetPol       = X.IDetPol;
       
       -- Obtener Parametros segun el Tipo y/o Nombre del reporte
       IF cExisteReporte = 'S' THEN
            FOR J IN REPORTES_Q LOOP
                nIdReporte  := J.IdReporte;
                cValorParam := 'XMLAGG(XMLELEMENT("'||J.Reporte||'",' || CHR(10);                
                dFecMesAniversario := TRUNC(ADD_MONTHS(X.FecIniVig, X.num_mes_vig ));
                /*
                IF (dFecMesAniversario + 1) <= TRUNC(SYSDATE) THEN
                    dFecIni := ADD_MONTHS(dFecMesAniversario,-1);
                    dFecFin := dFecMesAniversario;
                END IF;*/
                dFecIni := TO_DATE(TO_CHAR(X.FecIniVig,'DD')||'/'||cMes||'/'||cAnio);
                dFecFin := TRUNC(ADD_MONTHS(dFecIni, 1));
                
                IF J.Reporte = 'POLIZAVF' /*AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '002', cMesEdoCta, cAnioEdoCta) = 'N'*/ THEN
                    --cTipoReporte:= '001';                    
                    FOR W IN PARAMREP_Q LOOP
                        IF W.Nom_Param LIKE '%CODCIA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodCia))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(X.IdPoliza))  ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                          --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolIni)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolFin)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%CODASEGINI%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegIni)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodAsegIni)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%CODASEGFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegFin)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodAsegFin)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%ENDOSOINI%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIdEndosoIni))||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIdEndosoIni)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%ENDOSOFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIdEndosoFin))||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIdEndosoFin)) ||'), '|| CHR(10);
                        ELSE
                           cValorParam := '9999999';
                        END IF;
                    END LOOP;
                    
                ELSIF J.Reporte = 'ESTCTAFO' /*AND cIndGeneraEdoCta = 'S'*/ THEN
                   --cTipoReporte:= '002';              
                    FOR W IN PARAMREP_Q LOOP
                        IF W.Nom_Param LIKE '%CODCIA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(nCodCia)) ),'|| CHR(10);
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||", TRIM(TO_CHAR(nCodCia)) '),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodCia))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDPOLIZA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(X.IdPoliza)) ),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(X.IdPoliza))  ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOL%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IDetPol)) ||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(X.IDetPol)) ),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(X.IDetPol)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%CODEMPRESA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodEmpresa)) ||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(nCodEmpresa)) ),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodEmpresa)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%CODASEGURADO%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodAsegurado)) ||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(nCodAsegurado)) ),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodAsegurado)) ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%FECINI%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR('TO_DATE('||''''||dFecIni||''''||','||''''||'DD/MM/YYYY'||''''||')'))||' ';
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(''''||TO_CHAR(dFecIni,'DD/MM/YYYY')||''''))||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(''''||TO_CHAR(dFecIni,''DD/MM/YYYY'')||'''')) ),'|| CHR(10);
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(''''||TO_CHAR(dFecIni,'DD/MM/YYYY')||''''))||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%FECFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(''''||TO_CHAR(dFecFin,'DD/MM/YYYY')||''''))||' ';
                           --cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", TRIM(TO_CHAR(''''||TO_CHAR(dFecFin,''DD/MM/YYYY'')||'''')) ),'|| CHR(10);
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR('TO_DATE('||''''||dFecFin||''''||','||''''||'DD/MM/RRRR'||''''||')'))||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(''''||TO_CHAR(dFecFin,'DD/MM/YYYY')||''''))||'), '|| CHR(10);
                        ELSE
                           cValorParam := '9999999';
                        END IF;
                    END LOOP;
                        
                ELSIF J.Reporte = 'APORTREG' /*AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '009', NULL, NULL) = 'N'*/ THEN
                   --cTipoReporte:= '009';                    
                    FOR W IN PARAMREP_Q LOOP
                        IF W.Nom_Param LIKE '%CODCIA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodCia))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(X.IdPoliza))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolIni))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolFin))     ||'), '|| CHR(10);
                        ELSE
                           cValorParam := '9999999';
                        END IF;
                    END LOOP;
                    
                ELSIF J.Reporte = 'APORTEXT' /*AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '010', NULL, NULL) = 'N'*/ THEN
                   --cTipoReporte:= '010';                    
                    FOR W IN PARAMREP_Q LOOP
                        IF W.Nom_Param LIKE '%CODCIA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nCodCia))     ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nCodCia))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%POLIZA%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(X.IdPoliza))  ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(X.IdPoliza))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLINI%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolIni)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolIni))     ||'), '|| CHR(10);
                        ELSIF W.Nom_Param LIKE '%IDETPOLFIN%' THEN
                           --cValorParam := cValorParam||W.Nom_Param||'='||TRIM(TO_CHAR(nIDetPolFin)) ||' ';
                           cValorParam := cValorParam||'                                           XMLELEMENT("'||W.Nom_Param||'", '||TRIM(TO_CHAR(nIDetPolFin))     ||'), '|| CHR(10);
                        ELSE
                           cValorParam := '9999999';
                        END IF;
                    END LOOP;
                
                END IF;
    
            END LOOP;
            --DBMS_OUTPUT.PUT_LINE(cValorParam);
    ELSE
        --cValorParam := 'XMLAGG(XMLELEMENT("'||cNomReporte||'",' || CHR(10);
        --cValorParam := cValorParam||'                                           XMLELEMENT("'||cTipoReporte||'", ''''Reporte NO disponible por el momento''''), '|| CHR(10);
        RAISE_APPLICATION_ERROR(-20200,'El Reporte '||cTipoReporte||'-"'||cNomReporte||'" no se encuentra disponible aún.');     
        
   END IF; --cExisteReporte
        -- Completar cadena:
        cValorParamSC :=  SUBSTR(cValorParam, 1, (LENGTH(cValorParam))-3);
        cSQLXML := cSQLXML||cValorParamSC;
        cSQLXML := cSQLXML||CHR(10)||'                                         )'||CHR(10)||'                               )'||CHR(10)||'                     )'||CHR(10)||
            '   FROM   DUAL'||CHR(10);
            
    -- Generar XML, con nombre del Reporte a invocar y los Parametros que necesita
    BEGIN
        EXECUTE IMMEDIATE cSQLXML INTO xPrevReporte;
        DBMS_OUTPUT.PUT_LINE('FecMesAniversario: '||dFecMesAniversario);
        DBMS_OUTPUT.PUT_LINE('FecIni: '||dFecIni);
        DBMS_OUTPUT.PUT_LINE('FecFin: '||dFecFin);
        EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20200,'No se encontraron Parametros para este Reporte.');
    END;
    
    SELECT  XMLROOT (xPrevReporte, VERSION '1.0" encoding="UTF-8')
    INTO    xReporte
    FROM    DUAL;
    END LOOP;    
    
    RETURN xReporte;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Problema detectado en la Poliza: '||nIdPoliza||' y Tipo de Reporte: '||cTipoReporte||'; Error: '||SQLERRM);
        --DBMS_OUTPUT.PUT_LINE(cSQLXML);
END GENERA_REPORTERIA_V2;

PROCEDURE CHECA_MESVERSARIO (nCodCia IN NUMBER, nCodEmpresa IN NUMBER) IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 13/08/2021                                                                                                       |    
	| Nombre     : CHECA_MESVERSARIO                                                                                                |
    | Objetivo   : Procedimiento que valida y genera el registro del reporte segun el tipo de reporte de que se trate, en el caso   |
    |              de los Estados de cuenta cuando sea la fecha de de corte (Mesversario). Esta informacion sera explotada desde    |
    |              Plataforma Digital. Este proceso se ejecutara diariamente.                                                       |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
	
*/  
nIdReporte          REPORTE.IdReporte%TYPE;
cTipoReporte        FAI_REPORTES_PORTAL_CTRL.TipoReporte%TYPE;
cNomReporte         VARCHAR2(100);
nIdPoliza           FAI_REPORTES_PORTAL_CTRL.IdPoliza%TYPE;
dFecIni             DATE; 
dFecFin             DATE;
cMesEdoCta          VARCHAR2(2);
cAnioEdoCta         VARCHAR2(4);
cIndGeneraEdoCta    VARCHAR2(1) := 'N';
cDiaIniVig          VARCHAR2(2);
dFecMesAniversario  DATE;
--dIniMesAniversario  DATE;

CURSOR POLIZAS_Q IS
    SELECT  P.IdPoliza,
            DP.IDetPol,
            DP.Cod_Asegurado,
            DP.IdTipoSeg,
            P.CodCliente,
            P.FecIniVig,
            P.FecFinVig,
            TO_CHAR(P.FecIniVig,'DD')                       DIAINIVIG,
            ROUND(MONTHS_BETWEEN(P.FecFinVig,P.FecIniVig))  MESESVIGENCIA
    FROM    POLIZAS         P,
            DETALLE_POLIZA  DP
    WHERE   P.CodCia     = nCodCia
    AND     P.CodEmpresa = nCodEmpresa 
    --AND     P.FecEmision >= NVL(dFecEmision, P.FecEmision)
    AND     P.StsPoliza  = 'EMI' 
    AND     P.CodCia     = DP.CodCia
    AND     P.CodEmpresa = DP.CodEmpresa
    AND     P.IdPoliza   = DP.IdPoliza
    AND     OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(P.CodCia, P.CodEmpresa, DP.IdTipoSeg)                                         = 'S'  
    AND     GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(P.CodCia, P.CodEmpresa, P.IdPoliza, DP.IDetPol, DP.Cod_Asegurado)   = 'S'
    --AND     P.IdPoliza   =  nIdPoliza
    AND NOT EXISTS (SELECT  'S'
                     FROM   FAI_REPORTES_PORTAL_CTRL
                    WHERE   CodCia        = nCodCia
                      AND   CodEmpresa    = nCodEmpresa
                      AND   CodCliente    = P.CodCliente
                      AND   IdPoliza      = P.IdPoliza
                      AND   EstadoReporte = 'GENERADO');
                          
CURSOR REPORTES_Q IS
    SELECT  IdReporte,
            Reporte
    FROM    REPORTE        
    WHERE   (REPORTE  = cNomReporte AND cNomReporte IS NOT NULL)    -- IdReporte IN (94,93)
    OR      (REPORTE IN ('POLIZAVF','ESTCTAFO') AND cNomReporte IS NULL)
    ORDER BY IdReporte;
    
BEGIN    
    FOR x IN POLIZAS_Q LOOP
        cIndGeneraEdoCta := 'N';
        cDiaIniVig       := x.DiaIniVig;
        nIdPoliza        := x.IdPoliza;
        --DBMS_OUTPUT.PUT_LINE('cDiaIniVig = '||cDiaIniVig);        
       
       FOR W IN 1.. x.MesesVigencia LOOP
          dFecMesAniversario := TRUNC(ADD_MONTHS(X.FecIniVig,W));
          
          SELECT TO_CHAR(dFecMesAniversario,'MM'), TO_CHAR(dFecMesAniversario,'YYYY')
            INTO cMesEdoCta, cAnioEdoCta
            FROM DUAL;
            
            --DBMS_OUTPUT.PUT_LINE('cMesEdoCta = '||cMesEdoCta||', cAnioEdoCta= '||cAnioEdoCta);
            
          IF GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '002', cMesEdoCta, cAnioEdoCta) = 'N' AND (dFecMesAniversario + 1) <= TRUNC(SYSDATE) THEN
            dFecIni          := ADD_MONTHS(dFecMesAniversario,-1);
            dFecFin          := dFecMesAniversario;
            cIndGeneraEdoCta := 'S';
            --DBMS_OUTPUT.PUT_LINE('dFecIni = '||dFecIni||', dFecFin= '||dFecFin);
            EXIT;
          END IF;
          
       END LOOP;    
       
       IF cIndGeneraEdoCta = 'S' THEN
            NULL; 
       END IF;
       
        FOR J IN REPORTES_Q LOOP
            nIdReporte  := J.IdReporte;
            
            IF J.Reporte = 'POLIZAVF' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '002', cMesEdoCta, cAnioEdoCta) = 'N' THEN
                cTipoReporte:= '001';                
                --DBMS_OUTPUT.PUT_LINE('Insertar: GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR('||nCodCia||', '||nCodEmpresa||', '||X.CodCliente||', '||X.IdPoliza||', '||cTipoReporte||', '||TRUNC(SYSDATE)||', '||TO_CHAR(SYSDATE,'HH:MI:SS')||', NULL, NULL, cNombrePdf|, cDirSFTPNas, cDirectorio');
                -->> GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), NULL, NULL, cNombrePdf, cDirSFTPNas , cDirectorio);
                
                DBMS_OUTPUT.PUT_LINE('Insertar: GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR('||nCodCia||', '||nCodEmpresa||', '||X.CodCliente||', '||X.IdPoliza||', '||cTipoReporte||', '||TRUNC(SYSDATE)||', '||TO_CHAR(SYSDATE,'HH:MI:SS')||', NULL, NULL, ''POLIZAVF'', NULL, NULL');
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), NULL, NULL, J.Reporte, NULL , NULL);
                --DBMS_OUTPUT.PUT_LINE('Tipo Reporte 001, POLIZAVF; Tipo Reporte:'||cTipoReporte||', Reporte: '||J.Reporte||', Mesversario: '||dFecFin);
            
            ELSIF J.Reporte = 'ESTCTAFO' AND cIndGeneraEdoCta = 'S' AND TO_CHAR(TRUNC(SYSDATE),'DD') = cDiaIniVig THEN
               cTipoReporte:= '002';                
                -->> GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
                DBMS_OUTPUT.PUT_LINE('Insertar: GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR('||nCodCia||', '||nCodEmpresa||', '||X.CodCliente||', '||X.IdPoliza||', '||cTipoReporte||', '||TRUNC(SYSDATE)||', '||TO_CHAR(SYSDATE,'HH:MI:SS')||', '||cMesEdoCta||', '||cAnioEdoCta||', ''ESTCTAFO'', NULL, NULL');
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, J.Reporte, NULL, NULL);
                --DBMS_OUTPUT.PUT_LINE('Tipo Reporte 002, ESTCTAFO; Tipo Reporte:'||cTipoReporte||', Reporte: '||J.Reporte||', Mesversario: '||dFecFin);                    
            
            ELSIF J.Reporte = 'APORTREG' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '009', NULL, NULL) = 'N' THEN
               cTipoReporte:= '009';
                
                -->> GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
                DBMS_OUTPUT.PUT_LINE('Insertar: GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR('||nCodCia||', '||nCodEmpresa||', '||X.CodCliente||', '||X.IdPoliza||', '||cTipoReporte||', '||TRUNC(SYSDATE)||', '||TO_CHAR(SYSDATE,'HH:MI:SS')||', '||cMesEdoCta||', '||cAnioEdoCta||', ''APORTREG'', NULL, NULL);');
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, J.Reporte, NULL , NULL);
                DBMS_OUTPUT.PUT_LINE('Tipo Reporte 009, APORTREG; Tipo Reporte:'||cTipoReporte||', Reporte: '||J.Reporte||', Mesversario: '||dFecFin);
                
            ELSIF J.Reporte = 'APORTEXT' AND GT_FAI_REPORTES_PORTAL_CTRL.EXISTE_REPORTE(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, '010', NULL, NULL) = 'N' THEN
               cTipoReporte:= '010';
                
                -->> GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, cNombrePdf, cDirSFTPNas , cDirectorio);
                DBMS_OUTPUT.PUT_LINE('Insertar: GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR('||nCodCia||', '||nCodEmpresa||', '||X.CodCliente||', '||X.IdPoliza||', '||cTipoReporte||', '||TRUNC(SYSDATE)||', '||TO_CHAR(SYSDATE,'HH:MI:SS')||', '||cMesEdoCta||', '||cAnioEdoCta||', ''APORTEXT'', NULL, NULL);');
                GT_FAI_REPORTES_PORTAL_CTRL.INSERTAR(nCodCia, nCodEmpresa, X.CodCliente, X.IdPoliza, cTipoReporte, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH:MI:SS'), cMesEdoCta, cAnioEdoCta, J.Reporte, NULL , NULL);
                --DBMS_OUTPUT.PUT_LINE('Tipo Reporte 010, APORTEXT; Tipo Reporte:'||cTipoReporte||', Reporte: '||J.Reporte||', Mesversario: '||dFecFin);                
            END IF;
            
        END LOOP;

    END LOOP;        

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Problema detectado en la Poliza: '||nIdPoliza||' y reporte: '||nIdReporte||'; Error: '||SQLERRM);
END CHECA_MESVERSARIO;

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
