create or replace PACKAGE SICAS_OC.REPORTE_SINIESTROS_CONT AS
/******************************************************************************
   NAME:       SICAS_OC.REPORTE_SINIESTROS_CONT
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/03/2023      Usuario       1. Created this package.
******************************************************************************/
PROCEDURE correporte(dFecFinal DATE,nIdReporte number);
PROCEDURE GENERA_IMPRESION  (cnombrearchivo varchar2,
                             dfechadesderep date,
                             dfechahastarep date,
                             nIdPolizaImp varchar2,
                             nIdSiniestroImp varchar2,
                             cUSUARIO_SOLICITANTEIMP VARCHAR2,
                             cFormato VARCHAR2,
                             nIdReporte NUMBER);
PROCEDURE GENERAR_SINIESTRALIDAD_UNAM (cNomArchivo VARCHAR2, 
                                       DFECDESTE_OCURRIDO DATE,    
                                       DFECHASTA_OCURRIDO DATE,
                                       DFECDESTE_NOTIFICACION DATE,    
                                       DFECHASTA_NOTIFICACION DATE,
                                       cFormato VARCHAR2,
                                       nIdReporte NUMBER);
PROCEDURE GENERAR_FONDOS_RETIRO(cNomArchivo VARCHAR2, 
                                DFECDESTE_PAGO DATE,    
                                DFECHASTA_PAGO DATE,
                                cFormato VARCHAR2,
                                nIdReporte NUMBER);
PROCEDURE GENERAR_SINIESTRALIDAD_CONALEP (cNomArchivo VARCHAR2, 
                                         DFECDESTE_OCURRIDO DATE,    
                                         DFECHASTA_OCURRIDO DATE,
                                         DFECDESTE_NOTIFICACION DATE,    
                                         DFECHASTA_NOTIFICACION DATE,
                                         cFormato VARCHAR2,
                                         nIdReporte     NUMBER);
PROCEDURE GENERA_POLIZAS_AP  (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2,
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte  NUMBER);

PROCEDURE REPORTE_SINIESTRALIDAD (dFecValFin DATE,nIdReporte NUMBER);
PROCEDURE REPORTE_OPC (CANIO VARCHAR2,CMES VARCHAR2,nIdReporte number,cregistros in out number);
FUNCTION VALIDA_SINIESTRO_EXISTE(nIDSINIESTRO NUMBER) RETURN NUMBER;
END REPORTE_SINIESTROS_CONT;

/

create or replace PACKAGE BODY SICAS_OC.REPORTE_SINIESTROS_CONT AS
PROCEDURE correporte(dFecFinal DATE,nIdReporte number) IS
	FE_INICIO          DATE                   ;
	FE_FIN             DATE                   ;
	W_CODCIA           NUMBER                 ;
	W_MES              VARCHAR2(20)           ;
    nLinea             		NUMBER;
    cCadena            		VARCHAR2(4000);
    cCodUser           		VARCHAR2(30);
LINEA_SALIDA       VARCHAR2(2000);
  WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
	muestralerta number;
	--
CURSOR POLIZAS IS 
SELECT POLIZA             ,
       SINIESTRO          ,
       REFERENCIA         ,
       TIPOSEG            , 
       MTO_PAGADO         ,
       MTO_RESERVADO      ,
       FECHA_MOVTO        ,
       STCOBERTURA        ,
       CONSECUTIVO        ,
       ID_CONCEP_TRANSAC  ,
       NOM_CONCEP_TRANSAC ,
       ID_TRANSACCION     ,
       ID_TRANSACCION_ANUL,
       FE_MOVTO2          ,
       SECUENCIA          ,
       SUBPROCESO         ,
       COBERTURA          ,
       MONTO_MOVTO        ,
       ESTREP             
FROM 
(
SELECT p.idpoliza                               POLIZA             ,
       S.IDSINIESTRO                            SINIESTRO          , 
       S.NUMSINIREF                             REFERENCIA         , 
       DECODE(TS.CODTIPOPLAN,'030','AP','VIDA') TIPOSEG            , 
       CSA.MONTO_PAGADO_LOCAL                   MTO_PAGADO         ,
       CSA.MONTO_RESERVADO_LOCAL                MTO_RESERVADO      ,
       CSA.FECRES                               FECHA_MOVTO        ,
       CSA.STSCOBERTURA                         STCOBERTURA        ,
       CSA.NUMMOD                               CONSECUTIVO        ,
       CSA.CODCPTOTRANSAC                       ID_CONCEP_TRANSAC  ,
       CTS.DESCTRANSAC                          NOM_CONCEP_TRANSAC ,
       CSA.IDTRANSACCION                        ID_TRANSACCION     ,
       CSA.IDTRANSACCIONANUL                    ID_TRANSACCION_ANUL,
       T.FECHATRANSACCION                       FE_MOVTO2          ,
       DT.CORRELATIVO                           SECUENCIA          ,
       DT.CODSUBPROCESO                         SUBPROCESO         ,
       DT.VALOR3                                COBERTURA          ,
       DT.MTOLOCAL                              MONTO_MOVTO        ,
       pr.codprovalterno                        ESTREP                                 
  FROM SINIESTRO                 S,
       DETALLE_POLIZA            P,
       TIPOS_DE_SEGUROS          TS,
       COBERTURA_SINIESTRO_ASEG  CSA,
       CONFIG_TRANSAC_SINIESTROS CTS,
       TRANSACCION               T,
       DETALLE_TRANSACCION       DT,
       provincia                 pr
 WHERE S.CODCIA      = 1
   AND S.IDSINIESTRO > 0
   --
   AND P.CODCIA(+) = S.CODCIA
   AND P.IDPOLIZA(+) = S.IDPOLIZA
   AND P.IDETPOL(+)  = S.IDETPOL
   --
   AND TS.IDTIPOSEG(+) = P.IDTIPOSEG
   --
   AND CSA.IDSINIESTRO = S.IDSINIESTRO
   AND CSA.FECRES      < dFecFinal
   --
   AND CTS.CODCIA(+)     = 1
   AND CTS.CODTRANSAC(+) = CSA.CODTRANSAC
   --
   AND (T.IDTRANSACCION = CSA.IDTRANSACCION
        OR
        T.IDTRANSACCION = CSA.IDTRANSACCIONANUL)
   --
   AND DT.IDTRANSACCION = T.IDTRANSACCION
   AND DT.CODSUBPROCESO != 'SIN'
   --
   AND pr.codpais       = s.codpaisocurr
   AND pr.codestado     = s.codprovocurr
--
UNION
--
SELECT P.IDPOLIZA                               POLIZA,
       S.IDSINIESTRO                            SINIESTRO,
       S.NUMSINIREF                             REFERENCIA,
       DECODE(TS.CODTIPOPLAN,'030','AP','VIDA') TIPOSEG, 
       CSA.MONTO_PAGADO_LOCAL                   MTO_PAGADO,
       CSA.MONTO_RESERVADO_LOCAL                MTO_RESERVADO,
       CSA.FECRES                               FECHA_MOVTO,
       CSA.STSCOBERTURA                         STCOBERTURA,
       CSA.NUMMOD                               CONSECUTIVO,
       CSA.CODCPTOTRANSAC                       ID_CONCEP_TRANSAC,
       CTS.DESCTRANSAC                          NOM_CONCEP_TRANSAC,
       CSA.IDTRANSACCION                        ID_TRANSACCION,
       CSA.IDTRANSACCIONANUL                    ID_TRANSACCION_ANUL,
       T.FECHATRANSACCION                       FE_MOVTO2,
       DT.CORRELATIVO                           SECUENCIA,
       DT.CODSUBPROCESO                         SUBPROCESO,
       DT.VALOR3                                COBERTURA,
       DT.MTOLOCAL                              MONTO_MOVTO     ,
       pr.codprovalterno                        estrep
  FROM SINIESTRO                 S,
       DETALLE_POLIZA            P,
       TIPOS_DE_SEGUROS          TS,
       COBERTURA_SINIESTRO       CSA,
       CONFIG_TRANSAC_SINIESTROS CTS,
       TRANSACCION               T,
       DETALLE_TRANSACCION       DT,
       provincia                 pr
 WHERE S.CODCIA      = 1
   AND S.IDSINIESTRO > 0
   --
   AND P.CODCIA(+) = S.CODCIA
   AND P.IDPOLIZA(+) = S.IDPOLIZA
   AND P.IDETPOL(+)  = S.IDETPOL
   --
   AND TS.IDTIPOSEG(+) = P.IDTIPOSEG
   --
   AND CSA.IDSINIESTRO = S.IDSINIESTRO
   AND CSA.FECRES      < dFecFinal
   --
   AND CTS.CODCIA(+)     = 1
   AND CTS.CODTRANSAC(+) = CSA.CODTRANSAC
   --
   AND T.IDTRANSACCION(+) = CSA.IDTRANSACCION
   --
   AND DT.IDTRANSACCION(+) = T.IDTRANSACCION
   --
   AND (T.IDTRANSACCION = CSA.IDTRANSACCION
        OR
        T.IDTRANSACCION = CSA.IDTRANSACCIONANUL)
   --
   AND DT.IDTRANSACCION = T.IDTRANSACCION
   AND DT.CODSUBPROCESO != 'SIN'
   --
   AND pr.codpais       = s.codpaisocurr
   AND pr.codestado     = s.codprovocurr
--          
)
ORDER BY SINIESTRO,
       CONSECUTIVO,
       SECUENCIA  ;
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
nLinea :=0;
  FOR x IN polizas LOOP
    nLinea := nLinea + 1;
      LINEA_SALIDA := x.POLIZA             ||'|'||
											x.SINIESTRO          ||'|'||
											x.REFERENCIA         ||'|'||
											x.TIPOSEG            ||'|'||
											x.MTO_PAGADO         ||'|'||
											x.MTO_RESERVADO      ||'|'||
											x.FECHA_MOVTO        ||'|'||
											x.STCOBERTURA        ||'|'||
											x.CONSECUTIVO        ||'|'||
											x.ID_CONCEP_TRANSAC  ||'|'||
											x.NOM_CONCEP_TRANSAC ||'|'||
											x.ID_TRANSACCION     ||'|'||
											x.ID_TRANSACCION_ANUL||'|'||
											x.FE_MOVTO2          ||'|'||
											x.SECUENCIA          ||'|'||
											x.SUBPROCESO         ||'|'||
											x.COBERTURA          ||'|'||
											x.MONTO_MOVTO        ||'|'||
											x.ESTREP             ;
        OC_ARCHIVO.Escribir_Linea(LINEA_SALIDA, cCodUser, nLinea);
  END LOOP;                    
  nlinea:=nlinea+1;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
END;
PROCEDURE GENERA_IMPRESION  (cnombrearchivo varchar2,
                             dfechadesderep date,
                             dfechahastarep date,
                             nIdPolizaImp varchar2,
                             nIdSiniestroImp varchar2,
                             cUSUARIO_SOLICITANTEIMP VARCHAR2,
                             cFormato VARCHAR2,
                             nIdReporte NUMBER) IS
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
WC_ASEGURADOS_EMI  		NUMBER;
WC_ASEGURADOS_END  		NUMBER;
nCodAgente         		AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nIdPoliza          		POLIZAS.IdPoliza%TYPE;
nCodCia            		POLIZAS.CodCia%TYPE;
nCodTipo           		AGENTES.CodTipo%TYPE;
cNomAgente         		VARCHAR2(300);
nCantAsegEmis      		NUMBER(20);
nCantAsegMov       		NUMBER(20);
WC_ULTIMOINGRESO   		VARCHAR2(30);
W_FECHA						 		VARCHAR2(10); 
W_HORA_FECHA			 		VARCHAR2(10);
cnombrearchivorep  		VARCHAR2(150);
dFechaterminoley   		DATE;
ndiasrestantes 		 		NUMBER;
ndiasTranscurridos 		NUMBER;
ndiasTranscurridosDOF NUMBER;
nMonto             		NUMBER(18,2);
CDESCMOTIVO 					VARCHAR2(100);
CDESCCAMPO						VARCHAR2(100);
--
CURSOR CAMBIOS IS 
SELECT CODCIA,             
       CODEMPRESA,
       IDPOLIZA, 
       IDSINIESTRO,
       IDCAMPO,
       IDTABLA,
       VALORANTERIOR,
       VALORNUEVO,
       USUARIO_SOLICITANTE, 
       USUARIO_REGISTRO,   
       TO_CHAR(FECHAREGISTRO,'DD/MM/YYYY') FECHAREGISTRO,  
       MOTIVO,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTCAM',MOTIVO) NOMMOTIVO
  FROM CONTROL_CAMBIO_DATOS
 WHERE FECHAREGISTRO       BETWEEN dFECHADESDEREP
                               AND dFECHAHASTAREP
   AND (IDPOLIZA           = DECODE(nIDPOLIZAIMP, '%', IDPOLIZA,nIDPOLIZAIMP) OR 
        IDPOLIZA           IS NULL)
   AND IDSINIESTRO         = DECODE(nIDSINIESTROIMP, '%', IDSINIESTRO,nIDSINIESTROIMP)
   AND USUARIO_SOLICITANTE = DECODE(cUSUARIO_SOLICITANTEIMP, '%',USUARIO_SOLICITANTE, cUSUARIO_SOLICITANTEIMP)                          
 ORDER BY FECHAREGISTRO       
  ;
BEGIN 
  --
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --     
  IF cFormato = 'TEXTO' THEN
     cnombrearchivorep := cnombrearchivo||'.TXT';
     --
     nLinea  := 1;
     cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'Listado de Cambios en el periodo del '||to_char(dFECHADESDEREP,'dd/mm/yyyy')||' al '||to_char(dFECHAHASTAREP,'dd/mm/yyyy');
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --                                                               
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'No. Siniestro'      ||cLimitador|| 
                'No. Póliza'         ||cLimitador|| 
                'Campo'              ||cLimitador||                                           
                'Tabla'              ||cLimitador||
                'Valor Anterior'     ||cLimitador||
                'Valor Nuevo'        ||cLimitador||  
                'Usuario Solicitante'||cLimitador||
                'Usuario Registro'   ||cLimitador||                                                           
                'Motivo'             ||cLimitador||
                'Descripcion'        ||CHR(13);                                                                                                                         
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     cnombrearchivorep := cnombrearchivo||'.xls';
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\-mm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>LITADO DE CAMBIOS'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     -- 
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(dFECHADESDEREP,'DD/MM/YYYY')||' AL '||TO_CHAR(dFECHAHASTAREP,'DD/MM/YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Siniestro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Poliza</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Campo</font></th>' ||                                                                                                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tabla</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Valor Anterior</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Valor Nuevo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Usuario Solicitante</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Usuario Registro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Registro</font></th>' ||                                          
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Motivo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripcion</font></th>';                                                                                                                              
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  --
  FOR X IN CAMBIOS LOOP
      --      
      IF cFormato = 'TEXTO' THEN
         cCadena := X.idsiniestro         ||cLimitador||
                    X.idpoliza            ||cLimitador||
                    X.IDCAMPO             ||cLimitador||
                    X.idtabla             ||cLimitador||
                    X.valoranterior       ||cLimitador||
                    X.valornuevo          ||cLimitador||
                    X.usuario_solicitante ||cLimitador||
                    X.usuario_registro    ||cLimitador||
                    X.fecharegistro       ||cLimitador||
                    X.MOTIVO              ||cLimitador||
                    X.NOMMOTIVO           ||CHR(13);                                                                                                                                
      ELSE
         cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(X.idSiniestro,'C')         || 
                     OC_ARCHIVO.CAMPO_HTML(X.idpoliza,'C')            ||
                     OC_ARCHIVO.CAMPO_HTML(X.IDCAMPO,'C')             || 
                     OC_ARCHIVO.CAMPO_HTML(X.idtabla,'C')             || 
                     OC_ARCHIVO.CAMPO_HTML(X.valoranterior,'C')       ||
                     OC_ARCHIVO.CAMPO_HTML(X.valornuevo,'C')          ||
                     OC_ARCHIVO.CAMPO_HTML(X.usuario_solicitante,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.usuario_registro,'C')    ||
                     OC_ARCHIVO.CAMPO_HTML(X.fecharegistro,'C')       ||
                     OC_ARCHIVO.CAMPO_HTML(X.MOTIVO,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOMMOTIVO ,'C')          || '</tr>';
      END IF;
      --
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  --
  IF cFormato = 'EXCEL' THEN
     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
  END IF;
  --
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
  WHEN OTHERS THEN 
       OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
       raise_application_error(-20105,'Error en Generación de Listado de cambios ' ||SQLERRM); 

end;
PROCEDURE GENERAR_SINIESTRALIDAD_UNAM (cNomArchivo VARCHAR2, 
                                       DFECDESTE_OCURRIDO DATE,    
                                       DFECHASTA_OCURRIDO DATE,
                                       DFECDESTE_NOTIFICACION DATE,    
                                       DFECHASTA_NOTIFICACION DATE,
                                       cFormato VARCHAR2,
                                       nIdReporte NUMBER) IS
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
NSINIESTRO         		NUMBER;
CBENEF                VARCHAR2(1000);
CBENEF_GEN            VARCHAR2(1000);
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);
--
CURSOR SINUNAM IS 
SELECT S.IDPOLIZA                                           POLIZA,
       OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE)             NOM_CONTRATANTE,
       S.IDSINIESTRO                                        SINIESTRO,
       OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(S.CODCIA,S.CODEMPRESA,DP.IDTIPOSEG,DP.PLANCOB,CSA.CODCOBERT) NOM_COBERTURA,
       OC_ASEGURADO.NOMBRE_ASEGURADO(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO) NOM_TITULAR,
       OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO) RFC,
       S.FEC_OCURRENCIA                                     FECHA_FALLECIMIENTO,
       S.MOTIVO_DE_SINIESTRO                                CLAVE_CAUSA,
		   SCG.CAGE_VALOR_LARGO                                 CAUSA_FALLECIMIENTO,
       TRUNC((S.FEC_OCURRENCIA - PNJ.FECNACIMIENTO) / 365)  EDAD,
       DECODE(NVL(PNJ.SEXO,'M'),'F','FEMENINO','MASCULINO') SEXO,
       S.FEC_NOTIFICACION                                   FECHA_RECLAMACION,
       S.MONTO_RESERVA_MONEDA                               IMPTE_RECLAMADO,
       S.MONTO_PAGO_MONEDA                                  IMPTE_PAGADO,   
       S.MONTO_RESERVA_MONEDA - S.MONTO_PAGO_MONEDA         IMPTE_PENDIENTE,
       AC.CAMPO3                                            NUMERO_EMPLEADO     
  FROM SINIESTRO S,
       POLIZAS P,
       DETALLE_POLIZA DP,
       COBERTURA_SINIESTRO_ASEG CSA,
       SAI_CAT_GENERAL SCG,
       ASEGURADO A,
       PERSONA_NATURAL_JURIDICA PNJ,
       ASEGURADO_CERTIFICADO AC
 WHERE S.FEC_OCURRENCIA BETWEEN DFECDESTE_OCURRIDO
                            AND DFECHASTA_OCURRIDO
   AND S.FEC_NOTIFICACION BETWEEN DFECDESTE_NOTIFICACION
                              AND DFECHASTA_NOTIFICACION
   --
   AND P.IDPOLIZA = S.IDPOLIZA 
   --
   AND DP.IDPOLIZA  = S.IDPOLIZA
   AND DP.IDETPOL   = S.IDETPOL
   AND DP.IDTIPOSEG = 'VGUNAM'
   --
   AND CSA.IDSINIESTRO = S.IDSINIESTRO
   AND CSA.ROWID       = (SELECT MIN(CSA1.ROWID)
                            FROM COBERTURA_SINIESTRO_ASEG CSA1
                           WHERE CSA1.IDSINIESTRO = CSA.IDSINIESTRO)
   AND SCG.CAGE_CD_CATALOGO   = 1
   AND SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO 
   --
   AND A.COD_ASEGURADO = S.COD_ASEGURADO
   --
   AND PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
   AND PNJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION  
   --
   AND AC.CODCIA        = DP.CODCIA
   AND AC.IDPOLIZA      = DP.IDPOLIZA
   AND AC.IDETPOL       = DP.IDETPOL
   AND AC.COD_ASEGURADO = S.COD_ASEGURADO  
 ORDER BY S.IDPOLIZA;  
--
CURSOR BENEFICIARIOS IS 
SELECT BS.NOMBRE||' '||BS.APELLIDO_PATERNO||' '||BS.APELLIDO_MATERNO NOMBRE,
       TO_CHAR(AA.MONTO_MONEDA) MONTO_PAGADO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMPAGO',BS.IDTIPO_PAGO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMPAGO',BS.IDTIPO_PAGO)) FORMA_PAGO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT',BS.CODPARENT),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT',BS.CODPARENT)) PARENTESCO,
       TO_CHAR(BS.PORCEPART,'999.90') PORCENTAJE
  FROM APROBACION_ASEG AA,
       BENEF_SIN BS
 WHERE AA.IDSINIESTRO   = NSINIESTRO
   AND AA.STSAPROBACION ='PAG'
   --
   AND BS.IDSINIESTRO = AA.IDSINIESTRO
   AND BS.BENEF       = AA.BENEF
;  
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
     nLinea  := 1;
     cCadena := OC_EMPRESAS.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := 'REPORTE DE SINIESTRALIDAD UNAM';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := TO_CHAR(DFECDESTE_OCURRIDO,'DD/MM/YYYY') || ' AL ' || TO_CHAR(DFECHASTA_OCURRIDO,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --  
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'No. de Póliza'           ||cLimitador||
                'Nombre del Contratante'  ||cLimitador||
                'No. de Siniestro'        ||cLimitador||
                'Cobertura'               ||cLimitador||
                'Nombre del Titular'      ||cLimitador||
                'RFC'                     ||cLimitador||
                'Nro. de Empleado'        ||cLimitador||
                'Fecha de Fallecieminto'  ||cLimitador||
                'Clave de causa'          ||cLimitador||
                'Causa del fallecimiento' ||cLimitador||
                'Edad'                    ||cLimitador||
                'Sexo'                    ||cLimitador||
                'Fecha de Reclamación'    ||cLimitador||
                'Importe Reclamado'       ||cLimitador||
                'Importe Pagado'          ||cLimitador||
                'Importe Pendiente'       ||cLimitador||
                'Definición beneficiarios'||cLimitador||
                'Nombre Beneficiario 1'   ||cLimitador||
                'Monto_pagado'            ||cLimitador||
                'Forma de pago'           ||cLimitador||
                'Parentesco'              ||cLimitador||
                'Porcentaje'              ||cLimitador||               
                'Nombre Beneficiario 2'   ||cLimitador||
                'Monto_pagado'            ||cLimitador||
                'Forma de pago'           ||cLimitador||
                'Parentesco'              ||cLimitador||
                'Porcentaje'              ||cLimitador||               
                'Nombre Beneficiario 3'   ||cLimitador||
                'Monto_pagado'            ||cLimitador||
                'Forma de pago'           ||cLimitador||
                'Parentesco'              ||cLimitador||
                'Porcentaje'              ||cLimitador||
                'Otors Beneficiaros'      ||CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE SINIESTRALIDAD UNAM'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     -- 
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(DFECDESTE_OCURRIDO,'DD/MM/YYYY')||' AL '||TO_CHAR(DFECHASTA_OCURRIDO,'DD/MM/YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>'||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Contratante</font></th>' 	||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' 			  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura</font></th>'               ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Titular</font></th>'     	||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC</font></th>'                   	||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nro. de Empleado</font></th>'       	||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Fallecieminto</font></th>'  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave de causa</font></th>'          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Causa del fallecimiento</font></th>'	||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Edad</font></th>'   	              	||   
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sexo</font></th>'   			            ||  
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Reclamación</font></th>'   	||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Reclamado</font></th>'   		||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pagado</font></th>'   		  	||                                                                                                     
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pendiente</font></th>'       ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Definición beneficiarios</font></th>'||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Beneficiario 1</font></th>'   ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto_pagado</font></th>'            ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de pago</font></th>'           ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Parentesco</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Porcentaje</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Beneficiario 2</font></th>'   ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto_pagado</font></th>'            ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de pago</font></th>'           ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Parentesco</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Porcentaje</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Beneficiario 3</font></th>'   ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto_pagado</font></th>'            ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de pago</font></th>'           ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Parentesco</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Porcentaje</font></th>'              ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OtrosBeneficiarios</font></th>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  --
  FOR X IN SINUNAM LOOP
      --
      IF cFormato = 'TEXTO' THEN  
          cCadena := X.POLIZA                                    ||cLimitador|| 
                     X.NOM_CONTRATANTE                           ||cLimitador|| 
                     X.SINIESTRO                                 ||cLimitador||
                     X.NOM_COBERTURA                             ||cLimitador||
                     X.NOM_TITULAR                               ||cLimitador||
                     X.RFC                                       ||cLimitador||
                     X.NUMERO_EMPLEADO                           ||cLimitador||
                     TO_CHAR(X.FECHA_FALLECIMIENTO,'dd/mm/yyyy') ||cLimitador||
          					 X.CLAVE_CAUSA												       ||cLimitador||   
                     X.CAUSA_FALLECIMIENTO                		   ||cLimitador||          
                     X.EDAD               						           ||cLimitador||
                     X.SEXO   									                 ||cLimitador||
										 TO_CHAR(X.FECHA_RECLAMACION,'dd/mm/yyyy')   ||cLimitador||         						 
                     X.IMPTE_RECLAMADO												   ||cLimitador||                     
                     X.IMPTE_PAGADO                              ||cLimitador||
                     X.IMPTE_PENDIENTE                           ||CHR(13); 
      ELSE
          NSINIESTRO := X.SINIESTRO;
          CBENEF_GEN := '';
          CBENEF     := '';           
          FOR B IN BENEFICIARIOS LOOP        
              CBENEF := OC_ARCHIVO.CAMPO_HTML(B.NOMBRE,'C')		         ||
                        OC_ARCHIVO.CAMPO_HTML(B.MONTO_PAGADO,'C')		   ||
                        OC_ARCHIVO.CAMPO_HTML(B.FORMA_PAGO,'C')		     ||
                        OC_ARCHIVO.CAMPO_HTML(B.PARENTESCO,'C')		     ||
                        OC_ARCHIVO.CAMPO_HTML(B.PORCENTAJE,'C');
              CBENEF_GEN := CBENEF_GEN||CBENEF;
          END LOOP;
         cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.POLIZA,'999999999999999990'),'C')	      ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_CONTRATANTE,'C')		                          ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.SINIESTRO,'9999999999990'),'C')   	      ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_COBERTURA,'C')																||                     
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_TITULAR,'C')               						    	||                                                                       
                     OC_ARCHIVO.CAMPO_HTML(X.RFC,'C')               					              	||
                     OC_ARCHIVO.CAMPO_HTML(X.NUMERO_EMPLEADO,'C')           	              	||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHA_FALLECIMIENTO,'dd/mm/yyyy'),'C') 	||  
                     OC_ARCHIVO.CAMPO_HTML(X.CLAVE_CAUSA ,'C')  									          	||
                     OC_ARCHIVO.CAMPO_HTML(X.CAUSA_FALLECIMIENTO ,'C')  						   				||
                     OC_ARCHIVO.CAMPO_HTML(X.EDAD ,'C')  							                   			||
                     OC_ARCHIVO.CAMPO_HTML(X.SEXO ,'C')  		                  								||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHA_RECLAMACION,'dd/mm/yyyy'),'C')			||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_RECLAMADO,'9999999999990.00'),'N')	||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_PAGADO,'9999999999990.00'),'N')    ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_PENDIENTE,'9999999999990.00'),'N') ||
                     OC_ARCHIVO.CAMPO_HTML(CBENEF_GEN ,'C')  		                  						||
                     '</tr>';
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      CBENEF_GEN := '';
      CBENEF     := '';   
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Reporte ' ||SQLERRM); 
END;
PROCEDURE GENERAR_FONDOS_RETIRO(cNomArchivo VARCHAR2, 
                                DFECDESTE_PAGO DATE,    
                                DFECHASTA_PAGO DATE,
                                cFormato VARCHAR2,
                                nIdReporte NUMBER)IS                         
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
NSINIESTRO         		NUMBER;
CBENEF                VARCHAR2(1000);
CBENEF_GEN            VARCHAR2(1000);
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);
--
CURSOR FONDOS IS 
SELECT NOM_JUBILADO,
       ID_RFC,
       ID_EMPLEADO,
       FEC_PAGO_FINIQUITO,
       FEC_NOTIFICACION,
       FEC_BAJA,
       IMPTE_PAGO
  FROM FONDOS_RETIRO F
 WHERE F.FEC_PAGO_FINIQUITO BETWEEN DFECDESTE_PAGO AND DFECHASTA_PAGO  
 ORDER BY F.ID_EMPLEADO;  
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
     nLinea  := 1;
     cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := 'REPORTE DE FONDOS DE RETIRO UNAM';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := TO_CHAR(DFECDESTE_PAGO,'DD/MM/YYYY') || ' AL ' || TO_CHAR(DFECHASTA_PAGO,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --  
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'Nombre del empleado'         ||cLimitador||
                'RFC del empleado'            ||cLimitador||
                'No. de empleado'             ||cLimitador||
                'Fecha de notificación'       ||cLimitador||
                'Fecha de pago del finiquito' ||cLimitador||
                'Fecha de baja'               ||cLimitador||
                'Monto_pagado'                ||CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FONDOS DE RETIRO UNAM'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     -- 
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(DFECDESTE_PAGO,'DD/MM/YYYY')||' AL '||TO_CHAR(DFECHASTA_PAGO,'DD/MM/YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del empleado</font></th>'||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC del empleado</font></th>'          	||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de empleado</font></th>' 			      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de notificación</font></th>'       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de pago del finiquito</font></th>' ||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de baja</font></th>'               ||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto_pagado</font></th>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  --
  FOR X IN FONDOS LOOP
      --
      IF cFormato = 'TEXTO' THEN  
          cCadena := X.NOM_JUBILADO         ||cLimitador|| 
                     X.ID_RFC               ||cLimitador|| 
                     X.ID_EMPLEADO          ||cLimitador||
                     X.FEC_PAGO_FINIQUITO   ||cLimitador||
                     X.FEC_NOTIFICACION     ||cLimitador||
                     X.FEC_BAJA             ||cLimitador||
                     X.IMPTE_PAGO           ||CHR(13); 
      ELSE
         cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_JUBILADO,'C')	                           ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_RFC,'C')		                               ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_EMPLEADO,'C')   	                         ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_FINIQUITO,'dd/mm/yyyy'),'C') ||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_NOTIFICACION,'dd/mm/yyyy'),'C')   ||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_BAJA,'dd/mm/yyyy'),'C') 	         ||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_PAGO,'9999999999990.00'),'N') ||
                     '</tr>';
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20104,'Error en Generación de Reporte ' ||SQLERRM); 
END;
PROCEDURE GENERAR_SINIESTRALIDAD_CONALEP (cNomArchivo VARCHAR2, 
                                         DFECDESTE_OCURRIDO DATE,    
                                         DFECHASTA_OCURRIDO DATE,
                                         DFECDESTE_NOTIFICACION DATE,    
                                         DFECHASTA_NOTIFICACION DATE,
                                         cFormato VARCHAR2,
                                         nIdReporte     NUMBER) IS
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
NSINIESTRO         		NUMBER;
CBENEF                VARCHAR2(1000);
CBENEF_GEN            VARCHAR2(1000);
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);
--
CURSOR SINCONALEP IS 
SELECT S.IDPOLIZA                                           POLIZA,
       OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE)             NOM_CONTRATANTE,
       S.IDSINIESTRO                                        SINIESTRO,
       OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(S.CODCIA,S.CODEMPRESA,DP.IDTIPOSEG,DP.PLANCOB,CSA.CODCOBERT) NOM_COBERTURA,
       OC_ASEGURADO.NOMBRE_ASEGURADO(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO) NOM_TITULAR,
       OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO) RFC,
       S.FEC_OCURRENCIA                                     FECHA_FALLECIMIENTO,
       S.MOTIVO_DE_SINIESTRO                                CLAVE_CAUSA,
       SCG.CAGE_VALOR_LARGO                                 CAUSA_FALLECIMIENTO,
       TRUNC((S.FEC_OCURRENCIA - PNJ.FECNACIMIENTO) / 365)  EDAD,
       DECODE(NVL(PNJ.SEXO,'M'),'F','FEMENINO','MASCULINO') SEXO,
       S.FEC_NOTIFICACION                                   FECHA_RECLAMACION,
       S.CODPROVOCURR                                       CVE_ESTADO,
       OC_PROVINCIA.NOMBRE_PROVINCIA(S.CODPAISOCURR, S.CODPROVOCURR) NOM_ESTADO,
       DECODE(NVL(DSN.CODPLANTEL,' '),' ',' ',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PLANTEL',DSN.CODPLANTEL))   PLANTEL, 
       S.MONTO_RESERVA_MONEDA                               IMPTE_RECLAMADO,
       S.MONTO_PAGO_MONEDA                                  IMPTE_PAGADO,   
       S.MONTO_RESERVA_MONEDA - S.MONTO_PAGO_MONEDA         IMPTE_PENDIENTE,    
       DECODE(NVL(DSN.ST_SINIESTRO_DOCTO,' '),' ',' ',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('STSINDOC',DSN.ST_SINIESTRO_DOCTO)) STSIN_X_RECHAZO,
       DECODE(NVL(DSN.ID_MOTIVO_RECHAZO,' '),' ',' ',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRECHA',DSN.ID_MOTIVO_RECHAZO)) MOTIVO_RECHAZO,
       DSN.MONTO_RECHAZO_NOCUM                              IMPTE_RECHA_NO_CUB
  FROM SINIESTRO S,
       POLIZAS P,
       DETALLE_POLIZA DP,
       COBERTURA_SINIESTRO_ASEG CSA,
       SAI_CAT_GENERAL SCG,
       ASEGURADO A,
       PERSONA_NATURAL_JURIDICA PNJ,
       DATOS_SINIESTRO_NEGOCIO DSN
 WHERE S.FEC_OCURRENCIA BETWEEN DFECDESTE_OCURRIDO
                            AND DFECHASTA_OCURRIDO
   AND S.FEC_NOTIFICACION BETWEEN DFECDESTE_NOTIFICACION
                              AND DFECHASTA_NOTIFICACION
   --
   AND P.IDPOLIZA     = S.IDPOLIZA 
   AND P.CODAGRUPADOR = '1053' -- CONALEP
   --
   AND DP.IDPOLIZA = S.IDPOLIZA
   AND DP.IDETPOL  = S.IDETPOL
   AND DP.CODCIA   = S.CODCIA
   --
   AND CSA.IDSINIESTRO = S.IDSINIESTRO
   AND CSA.ROWID       = (SELECT MIN(CSA1.ROWID)
                            FROM COBERTURA_SINIESTRO_ASEG CSA1
                           WHERE CSA1.IDSINIESTRO = CSA.IDSINIESTRO)
   --
   AND SCG.CAGE_CD_CATALOGO   = 1
   AND SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO 
   --
   AND A.COD_ASEGURADO = S.COD_ASEGURADO
   --
   AND PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
   AND PNJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION  
   --
   AND DSN.IDSINIESTRO(+) = S.IDSINIESTRO
   AND DSN.CODCIA(+)      = S.CODCIA
 ORDER BY S.IDPOLIZA;  

--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
     nLinea  := 1;
     cCadena := OC_EMPRESAS.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := 'REPORTE DE SINIESTRALIDAD CONALEP';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := TO_CHAR(DFECDESTE_OCURRIDO,'DD/MM/YYYY') || ' AL ' || TO_CHAR(DFECHASTA_OCURRIDO,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --  
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'No. de Póliza'           ||cLimitador||
                'Nombre del Contratante'  ||cLimitador||
                'No. de Siniestro'        ||cLimitador||
                'Cobertura'               ||cLimitador||
                'Nombre del Titular'      ||cLimitador||
                'RFC'                     ||cLimitador||
                'Fecha de Fallecimiento'  ||cLimitador||
                'Clave de Causa'          ||cLimitador||
                'Causa del Fallecimiento' ||cLimitador||
                'Edad'                    ||cLimitador||
                'Sexo'                    ||cLimitador||
                'Fecha de Reclamación'    ||cLimitador||
                'Clave de Estado'         ||cLimitador||
                'Estado'                  ||cLimitador||
                'Plantel'                 ||cLimitador||
                'Importe Reclamado'       ||cLimitador||
                'Importe Pagado'          ||cLimitador||
                'Importe Pendiente'       ||cLimitador||
                'Estatus del Rechazo'     ||cLimitador||
                'Motivo del Rechazo'       ||cLimitador||
                'Importe de Rechazo no cubierto' ||CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE SINIESTRALIDAD CONALEP'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     -- 
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(DFECDESTE_OCURRIDO,'DD/MM/YYYY')||' AL '||TO_CHAR(DFECHASTA_OCURRIDO,'DD/MM/YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>'||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Contratante</font></th>' 	||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' 			  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura</font></th>'               ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Titular</font></th>'     	||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC</font></th>'                   	||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Fallecimiento</font></th>'  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave de Causa</font></th>'          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Causa del Fallecimiento</font></th>'	||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Edad</font></th>'   	              	||   
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sexo</font></th>'   			            ||  
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Reclamación</font></th>'   	||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave de Estado</font></th>'   	||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estado</font></th>'   	||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plantel</font></th>'   	||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Reclamado</font></th>'   		||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pagado</font></th>'   		  	||                                                                                                     
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pendiente</font></th>'       ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus del Rechazo</font></th>'||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Motivo del Rechazo</font></th>'   ||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe de Rechazo no cubierto</font></th>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  --
  FOR X IN SINCONALEP LOOP
      IF cFormato = 'TEXTO' THEN  
         cCadena := X.POLIZA                                    ||cLimitador|| 
                     X.NOM_CONTRATANTE                           ||cLimitador|| 
                     X.SINIESTRO                                 ||cLimitador||
                     X.NOM_COBERTURA                             ||cLimitador||
                     X.NOM_TITULAR                               ||cLimitador||
                     X.RFC                                       ||cLimitador||
                     TO_CHAR(X.FECHA_FALLECIMIENTO,'dd/mm/yyyy') ||cLimitador||
          					 X.CLAVE_CAUSA												       ||cLimitador||   
                     X.CAUSA_FALLECIMIENTO                		   ||cLimitador||          
                     X.EDAD               						           ||cLimitador||
                     X.SEXO   									                 ||cLimitador||
										 TO_CHAR(X.FECHA_RECLAMACION,'dd/mm/yyyy')   ||cLimitador||         						 
                     X.CVE_ESTADO   						                 ||cLimitador||
                     X.NOM_ESTADO   						                 ||cLimitador||
                     X.PLANTEL   							                   ||cLimitador||
                     X.IMPTE_RECLAMADO												   ||cLimitador||                     
                     X.IMPTE_PAGADO                              ||cLimitador||
                     X.IMPTE_PENDIENTE                           ||cLimitador||
                     X.STSIN_X_RECHAZO   									       ||cLimitador||
                     X.MOTIVO_RECHAZO   									       ||cLimitador||
                     X.IMPTE_RECHA_NO_CUB   									   ||CHR(13);
      ELSE
         cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.POLIZA,'999999999999999990'),'C')	      ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_CONTRATANTE,'C')		                          ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.SINIESTRO,'9999999999990'),'C')   	      ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_COBERTURA,'C')																||                     
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_TITULAR,'C')               						    	||                                                                       
                     OC_ARCHIVO.CAMPO_HTML(X.RFC,'C')               					              	||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHA_FALLECIMIENTO,'dd/mm/yyyy'),'C') 	||  
                     OC_ARCHIVO.CAMPO_HTML(X.CLAVE_CAUSA ,'C')  									          	||
                     OC_ARCHIVO.CAMPO_HTML(X.CAUSA_FALLECIMIENTO ,'C')  						   				||
                     OC_ARCHIVO.CAMPO_HTML(X.EDAD ,'C')  							                   			||
                     OC_ARCHIVO.CAMPO_HTML(X.SEXO ,'C')  		                  								||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHA_RECLAMACION,'dd/mm/yyyy'),'C')			||  
                     OC_ARCHIVO.CAMPO_HTML(X.CVE_ESTADO ,'C')  		             								||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_ESTADO ,'C')  		             								||
                     OC_ARCHIVO.CAMPO_HTML(X.PLANTEL ,'C')  		               								||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_RECLAMADO,'9999999999990.00'),'N')	||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_PAGADO,'9999999999990.00'),'N')    ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IMPTE_PENDIENTE,'9999999999990.00'),'N') ||
                     OC_ARCHIVO.CAMPO_HTML(X.STSIN_X_RECHAZO ,'C')  	         								||
                     OC_ARCHIVO.CAMPO_HTML(X.MOTIVO_RECHAZO ,'C')  		         								||
                     OC_ARCHIVO.CAMPO_HTML(X.IMPTE_RECHA_NO_CUB ,'C')  		                    ||
                     '</tr>';
       END IF;
       --
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20104,'Error en Generación de Reporte ' ||SQLERRM); 
END;
PROCEDURE GENERA_POLIZAS_AP  (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2,
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte  NUMBER) IS
				cLimitador      VARCHAR2(1) :='|';
				nLinea          NUMBER;
				cCadena         VARCHAR2(4000);
				cCodUser        VARCHAR2(30);
				nDummy          NUMBER;
				cCopy           BOOLEAN;
        --
        LINEA_SALIDA       VARCHAR2(5000);           -- SPEEDFILE
        WI_ARCHIVO_SALIDA  VARCHAR2(2000);           -- SPEEDFILE 
	      muestralerta number;                         -- SPEEDFILE
        --
CURSOR POLIZAS_AP (dFechaDesde in DATE,dFecchaHasta in DATE )IS 
Select  p.Numpolunico        Poliza_Unica,
        DP.IdPoliza          Poliza_Consecutiva,
        DP.IdetPol           Certificado,
        P.Codcliente||' - '||OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE)      Contratante,
        DP.idtiposeg      Tipo_de_Seguro,
        DP.FECINIVIG      Inicio_de_Vigencia,
        DP.FECFINVIG      Fin_de_Vigencia 
        ,PC.Descripcion    Descrip_Plan---  PC.DESC_PLAN
FROM   Detalle_Poliza DP,
       Polizas        P,
       TIPOS_DE_SEGUROS PC
where DP.idtiposeg in ( Select TS.idtiposeg
		                    From  TIPOS_DE_SEGUROS TS
		                    Where (TS.IdTipoSeg  = DECODE(cIdTipoSeg,'%',TS.IdTipoSeg,cIdTipoSeg)) 
		                    And   TS.CodTipoPlan  = '030')
AND P.Idpoliza = DP.IdPoliza 
AND p.fecemision Between dFechaDesde And dFecchaHasta
AND (PC.IdTipoSeg  = DECODE(cIdTipoSeg,'%',PC.IdTipoSeg,cIdTipoSeg))
AND PC.IDTIPOSEG =    DP.idtiposeg
AND PC.CODEMPRESA = 1
AND PC.CODCIA = 1                
 ORder by 1,2,3,4                   
;
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	

   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := 'THONA SEGUROS, S.A. de C.V.' ; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE POLIZAS ACCIDENTES PERSONALES  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY')||' Moneda sol '||cCodMoneda; --; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := ' ' ; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

---- // TITULOS //
      nLinea := nLinea + 1;
      cCadena     := 'POLIZA UNICA'       ||cLimitador||'POLIZA CONSECUTIVA'          ||cLimitador||'CERTIFICADO' ||cLimitador||'CONTRATANTE'       ||cLimitador||
                     'TIPO DE ASEGURADO'          ||cLimitador||'INICIO DE VIGENCIA'        ||cLimitador||'FIN DE VIGENCIA'||cLimitador||'DESCRIPCION DEL PLAN'          ; --||chr(13);--SPEEDFILE
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   ELSE
      nLinea := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'         ||chr(10)||
                       ' <style id="libro">'                               ||chr(10)||
                       '   <!--table'                                      ||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'     ||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'   ||chr(10)||
                       '        .texto'                                    ||chr(10)||
                       '          {mso-number-format:"\@";}'               ||chr(10)||
                       '        .numero'                                   ||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'                                    ||chr(10)||
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'  ||chr(10)||
                       '    -->'                                           ||chr(10)||
                       ' </style><div id="libro">'                         ||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE POLIZAS ACCIDENTES PERSONALES  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY')  ||' Moneda sol '||  cCodMoneda   || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;

      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA UNICA</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONSECUTIVA</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CERTIFICADO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONTRATANTE</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE ASEGURADO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">INICIO DE VIGENCIA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FIN DE VIGENCIA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION DEL PLAN</font></th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   END IF;
   FOR X IN POLIZAS_AP(dFecDesde,dFecHasta) LOOP
      IF cFormato = 'TEXTO' THEN
         cCadena :=  X.Poliza_Unica			  ||cLimitador||
                     X.Poliza_Consecutiva	||cLimitador||
                     X.Certificado				||cLimitador||
                     X.Contratante 			  ||cLimitador||   --- X.NPOLIZA						
                     X.Tipo_de_Seguro			||cLimitador||
                     X.Inicio_de_Vigencia	||cLimitador||
                     X.Fin_de_Vigencia		||cLimitador||
                     X.Descrip_Plan				; --||chr(13);
     ELSE
         cCadena := '<tr>' || 
         						OC_ARCHIVO.CAMPO_HTML(X.Poliza_Unica ,'C')       ||
         						OC_ARCHIVO.CAMPO_HTML(X.Poliza_Consecutiva ,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Certificado,'C')         ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante ,'C')        ||                      --- X.NPOLIZA
                    OC_ARCHIVO.CAMPO_HTML(X.Tipo_de_Seguro,'C')      ||      
                    OC_ARCHIVO.CAMPO_HTML(X.Inicio_de_Vigencia,'D')  ||        
                    OC_ARCHIVO.CAMPO_HTML(X.Fin_de_Vigencia,'D')     ||         
                    OC_ARCHIVO.CAMPO_HTML(X.Descrip_Plan,'C')                                        
                    || '</tr>';
     END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   END LOOP;
   IF cFormato = 'EXCEL' THEN
   	  cCadena := '</table></div></html>';      
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
         OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
          raise_application_error(-20105,'Error en Generación de Reporte del Area Medica: '|| ' ' ||SQLERRM);
END;
PROCEDURE REPORTE_SINIESTRALIDAD (dFecValFin DATE,nIdReporte NUMBER) IS

nLinea                NUMBER;
cCadena               VARCHAR2(4000);
cCadenaAux1           VARCHAR2(4000);
cCodUser              VARCHAR2(30);
nDummy                NUMBER;
cCopy                 BOOLEAN;
--
cLimitador            VARCHAR2(20) :='</td>';
cCampoFormatC         varchar2(4000):= '<td class=texto>';
cCampoFormatN         varchar2(4000):= '<td class=numero>';
cCampoFormatD         varchar2(4000):= '<td class=fecha>';
------
cFecIniVig            varchar2(14);---:= TO_CHAR(:BK_POLIZAS.FecIniVig,'DD/MM/YYYY');
cFecFinVig            varchar2(14);---:= TO_CHAR(:BK_POLIZAS.FecFinVig,'DD/MM/YYYY');
------
cESCONTRIBUTORIO      VARCHAR2(100);
cPORCENCONTRIBUTORIO  VARCHAR2(100);
cGIRONEGOCIO          VARCHAR2(100);
cTIPONEGOCIO          VARCHAR2(100);
cFUENTERECURSOS       VARCHAR2(100);
cCODPAQCOMERCIAL      VARCHAR2(100);
cCATEGORIA            VARCHAR2(100);
cCANALFORMAVENTA      VARCHAR2(100);
nIdPoliza             NUMBER;
--
BEGIN 
	--
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  nLinea := 1;
  cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                    ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                    ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                    ' <style id="libro">'||chr(10)||
                    '   <!--table'||chr(10)||
                    '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                    '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                    '        .texto'||chr(10)||
                    '          {mso-number-format:"\@";}'||chr(10)||
                    '        .numero'||chr(10)||
                    '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                    '        .fecha'||chr(10)||
                    '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                    '    -->'||chr(10)||
                    ' </style><div id="libro">'||chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  nLinea := nLinea + 1;
  cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  nLinea := nLinea + 1;
  cCadena     := '<tr><th>REPORTE DE SINIESTRALIDAR POR POLIZA AL '|| TO_CHAR(dFecValFin,'DD/MM/YYYY')||'('||NIDREPORTE||')' || '</th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  nLinea := nLinea + 1;
  cCadena     := '<tr><th>  </th></tr></table>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  nLinea := nLinea + 1;
  cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' || 
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Tipo Seguro</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan Coberturas</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Plan Coberturas</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Agente</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Promotor</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Promotor</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código DR</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre DR</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Total</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Anulada</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Pagada Hasta</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Pagada</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Reserva Siniestros</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Siniestros Pagados o Anulados</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Siniestros Pendientes</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cantidad Siniestros</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Siniestralidad</font></th>' || 
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ramo</font></th>';
  cCadenaAux1  := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>';

  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);
  --
  FOR X IN (SELECT P.STSPOLIZA,P.COD_MONEDA,T.* from tmp_sini T,POLIZAS P WHERE /*T.IDREPORTE = nIdReporte AND*/ T.IDPOLIZA = P.IDPOLIZA) LOOP
  cFecIniVig          := TO_CHAR(X.FecIniVig,'DD/MM/YYYY');
  cFecFinVig          := TO_CHAR(X.FecFinVig,'DD/MM/YYYY');
  nIdPoliza := x.idpoliza;
      --
      SELECT --
             DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
             NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
             UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
             DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
             DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
             P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
             CGO.DESCCATEGO                                            CATEGORIA,
             DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA  
        INTO CESCONTRIBUTORIO,
             CPORCENCONTRIBUTORIO,
             CGIRONEGOCIO,
             CTIPONEGOCIO,
             CFUENTERECURSOS,
             CCODPAQCOMERCIAL,
             CCATEGORIA,
             CCANALFORMAVENTA
        FROM POLIZAS         P, 
             POLIZAS_TEXTO_COTIZACION  TXT,
             CATEGORIAS                CGO       
       WHERE P.IDPOLIZA = x.IdPoliza
         --
         AND TXT.CODCIA(+)     = P.CODCIA    
         AND TXT.CODEMPRESA(+) = P.CODEMPRESA 
         AND TXT.IDPOLIZA(+)   = P.IDPOLIZA
         --
         AND CGO.CODCIA(+)         = P.CODCIA  
         AND CGO.CODEMPRESA(+)     = P.CODEMPRESA 
         AND CGO.CODTIPONEGOCIO(+) = P.CODTIPONEGOCIO 
         AND CGO.CODCATEGO(+)      = P.CODCATEGO;
      --    
      cCadena := '<tr>' || cCampoFormatC||x.NumPolUnico          ||cLimitador||
                           cCampoFormatC||TO_CHAR(x.IdPoliza,'9999999999990') ||cLimitador||
				                   cCampoFormatC||x.NOMBRE_CLIENTE             ||cLimitador||
					                 cCampoFormatC||cFecIniVig                       ||cLimitador||
					                 cCampoFormatC||cFecFinVig                       ||cLimitador||
					                 cCampoFormatC||x.StsPoliza            ||cLimitador||
					                 cCampoFormatC||x.Cod_Moneda           ||cLimitador||
					                 cCampoFormatC||x.IdTipoSeg            ||cLimitador||
					                 cCampoFormatC||x.DescIdTipoSeg        ||cLimitador||
					                 cCampoFormatC||x.PlanCob              ||cLimitador||
					                 cCampoFormatC||x.DescPlanCob          ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.Cod_Agente,'999990')||cLimitador||
					                 cCampoFormatC||x.NombreAgente        ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.CodPromotor,'999990')    ||cLimitador||
					                 cCampoFormatC||x.NomPromotor         ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.CodDireccion,'999990')    ||cLimitador||
					                 cCampoFormatC||x.NomDireccion        ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.MontoPrimaTotal,'999,999,999,999,990.00')   ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.PrimaAnulada,'999,999,999,999,990.00')      ||cLimitador||
					                 cCampoFormatC||x.FechaCobHasta        ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.MontoPrimaPagada,'999,999,999,999,990.00')  ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.MontoSiniestros,'999,999,999,999,990.00')   ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.MtoSiniPagados,'999,999,999,999,990.00')    ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.MtoSiniPendientes,'999,999,999,999,990.00') ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.CantSiniestros,'999,999,990')                ||cLimitador||
					                 cCampoFormatC||TO_CHAR(x.PORCSINI,'999,990.000000')  ||cLimitador||
					                 cCampoFormatC||x.Ramo               ||cLimitador||
					                 cCampoFormatC||CESCONTRIBUTORIO                ||cLimitador||
					                 cCampoFormatC||CPORCENCONTRIBUTORIO            ||cLimitador||
					                 cCampoFormatC||CGIRONEGOCIO                    ||cLimitador||
					                 cCampoFormatC||CTIPONEGOCIO                    ||cLimitador||
					                 cCampoFormatC||CFUENTERECURSOS                 ||cLimitador||
					                 cCampoFormatC||CCODPAQCOMERCIAL                ||cLimitador||
					                 cCampoFormatC||CCATEGORIA                      ||cLimitador||
					                 cCampoFormatC||CCANALFORMAVENTA                ||'</tr>';

      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);

INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLIcATION_ERROR(-20105,'Error en Generación de Reporte de Siniestralidad: '|| nIdPoliza || ' ' ||SQLERRM); 

END;
PROCEDURE REPORTE_OPC (CANIO VARCHAR2,CMES VARCHAR2,nIdReporte number,cregistros in out number) IS
cLimitador        VARCHAR2(1) :='|';
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cCodUser          VARCHAR2(30);
nDummy            NUMBER;
cCopy             BOOLEAN;
CNOMARCHIVO       VARCHAR2(4000);
W_TI_PROCESADOS   NUMBER := 0;
cMotivoDeSiniestro SINIESTRO.MOTIVO_DE_SINIESTRO%TYPE;
cDescMotsiniestro  VARCHAR2(500);
cFechaMovto1       VARCHAR2(10);
cFechaMovto2       VARCHAR2(10);
cFecha             VARCHAR2(20);
--
CURSOR POL_Q IS 
SELECT ID_ORIGEN,
       ID_RAMO,
       ID_IND_O_COL,
       ID_MONEDA,
       ID_POLIZA,
       TO_CHAR(FE_INIVIG,'DD/MM/YYYY') FE_INIVIG,
       TO_CHAR(FE_FINVIG,'DD/MM/YYYY') FE_FINVIG,
       NUMPOLUNICO,
       OC_ASEGURADO.NOMBRE_ASEGURADO(R.CODCIA,R.CODCIA,R.COD_ASEGURADO) NOM_ASEGURADO,
       OC_CLIENTES.NOMBRE_CLIENTE(R.COD_CLIENTE) NOM_CLIENTE,
       TIPO_SEGURO,
       ID_SINIESTRO,
       NUMSINIREF,
       TO_CHAR(FE_NOTIFICACION,'DD/MM/YYYY') FE_NOTIFICACION,
       TO_CHAR(FE_OCURRIDO,'DD/MM/YYYY') FE_OCURRIDO,
       ID_COBERTURA,
       RESERVA_ANTERIOR,
       ESTIMACION_INICIAL,
       AJUSTES_MAS,
       AJUSTES_MENOS,
       PAGOS,
       DESPAGOS,
       RESERVA_FINAL
  FROM RESERVA R
 WHERE R.AÑO_MOVIMIENTO = cAnio
   AND R.MES_MOVIMIENTO = cMES
 ORDER BY ID_SINIESTRO
;
-- 
BEGIN
	-- 
	--:DATOS.TI_FE_INICIO := TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS');SYNCHRONIZE;
	--:DATOS.TI_PROCESO   := '                                P R O C E S A N D O ';SYNCHRONIZE;
	--
/*  SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
    INTO cCodUser
    FROM DUAL;*/
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
--MESSAGE('INICIO');SYNCHRONIZE;PAUSE;  
--  CNOMARCHIVO := :DATOS.TI_ARCHIVO;
  --
--MESSAGE('1');SYNCHRONIZE;PAUSE;  
  nLinea  := 1;
  cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('2');SYNCHRONIZE;PAUSE;  
  nLinea  := nLinea + 1;
  cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('3');SYNCHRONIZE;PAUSE;  
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>REPORTE DE OPC'|| '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('4');SYNCHRONIZE;PAUSE;  
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>'||TO_CHAR(TO_DATE('01/'||LPAD(TO_CHAR(cmes),2,'0')||'/'||TO_CHAR(cAnio),'DD/MM/YYYY'),'MONTH')
                 || ' DEL ' ||TO_CHAR(canio)|| '</th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('5');SYNCHRONIZE;PAUSE;  
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>  </th></tr></table>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('6');SYNCHRONIZE;PAUSE;  
  nLinea  := nLinea + 1;
  cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sistema</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ramo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Polizá</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Polizá</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Polizá Unico</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Asegurado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Siniestro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Referencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Notificacion</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ocurrido</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Causa de Siniestro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Desc Causa de Sinietro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primer Fec Movto Conta</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ultima Fec Movto Conta</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Reserva Anteror</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estimacion Inicial</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ajustes de Mas</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ajustes de Menos</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Pagos</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Despagos</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Reserva Final</font></th>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  --
--MESSAGE('7');SYNCHRONIZE;PAUSE;  
  FOR X IN POL_Q LOOP

  	--MLJS 18/11/2020 SE AGREGA CAUSA DE SINIESTRO
  	BEGIN
  	  SELECT MOTIVO_DE_SINIESTRO 
  	  INTO   cMotivoDeSiniestro
      FROM   SINIESTRO
      WHERE  IDSINIESTRO = X.ID_SINIESTRO;
  	EXCEPTION
  	 	WHEN OTHERS THEN
  	 	  cMotivoDeSiniestro := 99; 
  	END;

    --MLJS 25/11/2020 SE AGREGA LA PRIMER Y RULTIMA FECHA DEL MOVIMIENTO CONTABLE
    cFecha := '01/'||LPAD(cmes,2,0)||'/'||canio;
    BEGIN
  	   SELECT TO_CHAR(MIN(FE_MOVTO),'DD/MM/RRRR'), TO_CHAR(MAX(FE_MOVTO),'DD/MM/RRRR')
  	   INTO   cFechaMovto1, cFechaMovto2
       FROM   RESERVA_DET        
       WHERE  ID_SINIESTRO = X.ID_SINIESTRO; 
    EXCEPTION
    	WHEN OTHERS THEN
    	  cFechaMovto1 := NULL;
    	  cFechaMovto2 := NULL;
    END;
       --
        cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(X.ID_ORIGEN,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_RAMO,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_IND_O_COL,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_MONEDA,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Id_Poliza,'9999999999990'),'C')  ||
                     OC_ARCHIVO.CAMPO_HTML(X.FE_INIVIG,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.FE_FINVIG,'C')  ||
                     OC_ARCHIVO.CAMPO_HTML(X.NUMPOLUNICO,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEGURADO,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_CLIENTE,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(X.TIPO_SEGURO,'C')              ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.ID_SINIESTRO,'9999999999990'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')                        ||
                     OC_ARCHIVO.CAMPO_HTML(X.FE_NOTIFICACION,'C')                        ||
                     OC_ARCHIVO.CAMPO_HTML(X.FE_OCURRIDO,'C')            ||
                     OC_ARCHIVO.CAMPO_HTML(X.ID_COBERTURA,'C')           ||
                     OC_ARCHIVO.CAMPO_HTML(cMotivoDeSiniestro,'C')       ||
                     OC_ARCHIVO.CAMPO_HTML(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',cMotivoDeSiniestro),'C')             ||
                     OC_ARCHIVO.CAMPO_HTML(cFechaMovto1,'C')             ||
                     OC_ARCHIVO.CAMPO_HTML(cFechaMovto2,'C')             ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RESERVA_ANTERIOR,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.ESTIMACION_INICIAL,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.AJUSTES_MAS,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.AJUSTES_MENOS,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.PAGOS,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.DESPAGOS,'9,999,999,999,990.00'),'C')||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RESERVA_FINAL,'9,999,999,999,990.00'),'C')||
                   '</tr>';
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
       --
       W_TI_PROCESADOS := W_TI_PROCESADOS + 1; 
       --
       IF SUBSTR(W_TI_PROCESADOS,-3,3) = '000' THEN
       	 cregistros := W_TI_PROCESADOS;
       END IF;
       --
   END LOOP;
   --
--MESSAGE('8');SYNCHRONIZE;PAUSE;  
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   --
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
--MESSAGE('12');SYNCHRONIZE;PAUSE;  
  --
/*	:DATOS.TI_FE_FIN     := TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS');SYNCHRONIZE;
	:DATOS.TI_PROCESADOS := W_TI_PROCESADOS;SYNCHRONIZE;
	:DATOS.TI_PROCESO    := '                                  T E R M I N A D O ';SYNCHRONIZE;
*/	
	--
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Reporte de OPC ' ||SQLERRM); 

END;

FUNCTION VALIDA_SINIESTRO_EXISTE(nIDSINIESTRO NUMBER) RETURN NUMBER IS
NEX NUMBER;
BEGIN
    BEGIN
        SELECT 1
        INTO NEX
        FROM SINIESTRO
        WHERE IDSINIESTRO = nIDSINIESTRO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NEX:=0;
    END;
    RETURN NEX;
END;
END REPORTE_SINIESTROS_CONT;

/

GRANT EXECUTE ON SICAS_OC.REPORTE_SINIESTROS_CONT TO PUBLIC;

/

CREATE PUBLIC SYNONYM REPORTE_SINIESTROS_CONT FOR SICAS_OC.REPORTE_SINIESTROS_CONT;