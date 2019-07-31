--
-- OC_INFO_SINIESTRO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   OC_DDL_OBJETOS (Package)
--   OC_PROCESOS_MASIVOS (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_INFO_SINIESTRO IS
--
PROCEDURE INSERTA(cLinea VARCHAR2, cTipoProceso VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, cNumRemesa VARCHAR2, cIdCredThona VARCHAR2);
--
END OC_INFO_SINIESTRO;
/

--
-- OC_INFO_SINIESTRO  (Package Body) 
--
--  Dependencies: 
--   OC_INFO_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_INFO_SINIESTRO IS
--
--
--
PROCEDURE INSERTA(cLinea VARCHAR2, cTipoProceso VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER, cNumRemesa VARCHAR2, cIdCredThona VARCHAR2) IS
--
--tInfo_Sini             INFO_SINIESTRO%ROWTYPE;
cCodPlantilla   CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'SINI_INFONACOT';
cInsert         VARCHAR2(4000);
cValores        VARCHAR2(4000);
cInsertCompl    VARCHAR2(4000) := 'NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,TO_DATE('''||TO_CHAR(SYSDATE,'DD/MM/YYYY')||''',''DD/MM/YYYY'')'||',''02'',''';  --JICO
--cInsertCompl    VARCHAR2(4000) := 'NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,TO_DATE('''||TO_CHAR(SYSDATE,'DD/MM/YYYY')||''',''DD/MM/YYYY'')'||',NULL,'''||USER;
--cInsertCompl    VARCHAR2(4000) := 'NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,TO_DATE('||TO_CHAR(SYSDATE,'DD/MM/YYYY')||'''||,NULL,'''||USER;
nOrden          NUMBER(10);
nOrdenInc       NUMBER(10);
W_USUARIO       VARCHAR2(15);
--
CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;
--
BEGIN
  --
  W_USUARIO := '';
  -- JICO  INICIO
  SELECT cInsertCompl||USER
    INTO cInsertCompl
    FROM DUAL;
  --  JICO FIN
  IF cTipoProceso = 'SINCER' THEN
     --
     cInsert  := NULL;
     cValores := NULL;
     nOrden   := 1;
     --
     FOR I IN C_CAMPOS_PART LOOP
--dbms_output.put_line('nOrden '||nOrden);
       nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION(cCodPlantilla, nCodCia, nCodEmpresa, I.OrdenProceso) + nOrden;
--dbms_output.put_line('nOrdenInc '||nOrdenInc);
       IF I.TipoCampo = 'NUMBER' THEN
          cValores   := cValores||','||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,nOrdenInc,','));
       ELSIF I.TipoCampo = 'VARCHAR2' THEN
             cValores   := cValores||','''||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,nOrdenInc,','))||'''';
       ELSIF I.TipoCampo = 'DATE' THEN
             IF I.NomCampo = 'FECHA NACIMIENTO' THEN
                cValores   := cValores||',TO_DATE('''||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,nOrdenInc,','))||''',''YYYYMMDD'')';
             ELSE
                cValores   := cValores||',TO_DATE('''||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,nOrdenInc,','))||''',''DD/MM/YYYY'')';
             END IF;
       END IF;
--dbms_output.put_line('nOrden '||nOrden);
       nOrden    := nOrden + 1;
     END LOOP;
     --
--dbms_output.put_line('cValores '||cValores);
     cInsert := 'INSERT INTO INFO_SINIESTRO (ID_CODCIA, NU_REMESA, ID_CREDITO_THONA, ID_POLIZA, ID_ENDOSO, ID_ASEGURADORA, ID_CREDITO, ID_TRABAJADOR, PATERNO, '||
                'MATERNO, NOMBRE, SEGUNDO_NOMBRE, FE_NACIMIENTO, SEXO, RFC_TRABAJADOR, IMPORTE, EMPRESA, DOMICILIO_CT, TEL_PRINCIPAL, TEL_CEL, TIPO_SEG_SOCIAL, '||
                'NUM_SEG_SOCIAL, SUCURSAL, PRODUCTO, COBERTURA, ID_ENVIO, REF_BANCA, FECHA_BAJA, SINIESTRO, FECHA_SINIESTRO, MENSUALIDAD, OBS_SINIESTRO, CVE_NO_PAGO, '||
                'ENVIO_ACTA_DEF, ENVIO_DICTAMEN_INV, REF_BANCA_PAGO, FECHA_PAGO, FE_CARGA, ST_REGISTRO, CODUSUARIO) ' ||
                'VALUES('||nCodCia||','''||cNumRemesa||''','''||cIdCredThona||''''||cValores||','||cInsertCompl||''')';
--dbms_output.put_line('cInsert '||cInsert);
     OC_DDL_OBJETOS.EJECUTAR_SQL(cInsert);
    --
  END IF;
  --
END INSERTA;
--
--
--
END OC_INFO_SINIESTRO;
/
