--
-- OC_ARCHIVO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   UTL_RAW (Synonym)
--   DBMS_LOB (Synonym)
--   DBMS_STANDARD (Package)
--   TEMP_GEN_ARCHIVO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ARCHIVO IS
  cBinDataRow   BLob;
  PROCEDURE EJECUTAR_SQL(pSql IN VARCHAR2);
  PROCEDURE ESCRIBIR_LINEA(cCadena IN VARCHAR2, cIdGen IN VARCHAR2, nLinea IN VARCHAR2, cNomRep IN VARCHAR2 := 'N');
  PROCEDURE ELIMINAR_ARCHIVO (cIdGen IN VARCHAR2);
  FUNCTION CAMPO_HTML(p_cValor VARCHAR2, p_cTipo VARCHAR2) RETURN varchar2 ;
  PROCEDURE ENCABEZADO_HTML(p_DataClob IN OUT CLOB);
END OC_ARCHIVO;
/

--
-- OC_ARCHIVO  (Package Body) 
--
--  Dependencies: 
--   OC_ARCHIVO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ARCHIVO IS
PROCEDURE EJECUTAR_SQL( pSql IN varchar2) IS
BEGIN
   EXECUTE IMMEDIATE pSql;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20201,'ERROR  AL EJECUTAR SENTENCIA '||SQLERRM||'-->'||PSQL);
END EJECUTAR_SQL;

PROCEDURE ESCRIBIR_LINEA(cCadena IN VARCHAR2, cIdGen IN VARCHAR2, nLinea IN VARCHAR2, cNomRep IN VARCHAR2 := 'N') IS
BEGIN
    if nLinea = 1 THEN

      OC_ARCHIVO.cBinDataRow := UTL_RAW.cast_to_raw (dbms_lob.substr (cCadena || chr (10), 4000, 1));
    ELSIF  nLinea = 0 then
       IF  cNomRep != 'N' THEN
           NULL;
      ELSE
            INSERT INTO TEMP_GEN_ARCHIVO
                    (DATA, CodUser)
             VALUES (OC_ARCHIVO.cBinDataRow, cIdGen);
      END IF;
    ELSE
      dbms_lob.append (OC_ARCHIVO.cBinDataRow, UTL_RAW.cast_to_raw (dbms_lob.substr (cCadena || chr (10), 4000, 1)));
    END IF ;

END ESCRIBIR_LINEA;
PROCEDURE  Eliminar_Archivo (cIdGen IN VARCHAR2) is
  BEGIN
     DELETE TEMP_GEN_ARCHIVO
      WHERE CodUser = cIdGen;
  END Eliminar_Archivo;
/*------------------------------------------------------------------------------------------------
Nombre:    CAMPO_HTML
Objetivo:  Devuelve segun parametro el formato HTML que corresponde a Fecha,Numero o Texto
Parametros:
    p_cValor Valor del Dato.
    p_cTipo  Tipo de Dato (N=Numero, C=Texto y D=Fecha)
------------------------------------------------------------------------------------------------*/
FUNCTION CAMPO_HTML(p_cValor VARCHAR2, p_cTipo VARCHAR2) RETURN varchar2 IS
cCampoFormat varchar2(4000);
BEGIN
   if p_cTipo = 'C' then
      cCampoFormat := '<td class=texto>'||p_cValor||'</td>';
   elsif p_cTipo = 'N' then
      cCampoFormat := '<td class=numero>'||p_cValor||'</td>';
   elsif p_cTipo = 'D' then
      cCampoFormat := '<td class=fecha>'||p_cValor||'</td>';
   end if;
return cCampoFormat;
END;
/*------------------------------------------------------------------------------------------------
Nombre:    ENCABEZADO_HTML
Objetivo:  Graba en un campo clob el encabezado del archivo HTML que se grabara.
Parametros:
    p_DataClob Campo en el cual devolvera el encabezado para agregar el resto del archivo HTML
------------------------------------------------------------------------------------------------*/
PROCEDURE ENCABEZADO_HTML(p_DataClob IN OUT CLOB) is
BEGIN
            dbms_lob.append(p_DataClob,'  <html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10));
            dbms_lob.append(p_DataClob,'  xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10));
            dbms_lob.append(p_DataClob,'  xmlns="http://www.w3.org/TR/REC-html40">'||chr(10));
            dbms_lob.append(p_DataClob,'  <style id="libro">'||chr(10));
            dbms_lob.append(p_DataClob,'  <!--table'||chr(10));
            dbms_lob.append(p_DataClob,'    {mso-displayed-decimal-separator:"\.";'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-displayed-thousand-separator:"\,";}'||chr(10));
            dbms_lob.append(p_DataClob,'  .texto'||chr(10));
            dbms_lob.append(p_DataClob,'    {padding-top:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    padding-right:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    padding-left:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-ignore:padding;'||chr(10));
            dbms_lob.append(p_DataClob,'    color:windowtext;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-size:10.0pt;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-weight:400;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-style:normal;'||chr(10));
            dbms_lob.append(p_DataClob,'    text-decoration:none;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-family:Arial;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-generic-font-family:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-font-charset:0;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-number-format:"\@";'||chr(10));
            dbms_lob.append(p_DataClob,'    text-align:general;'||chr(10));
            dbms_lob.append(p_DataClob,'    vertical-align:bottom;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-background-source:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-pattern:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    white-space:nowrap;}'||chr(10));
            dbms_lob.append(p_DataClob,'    .numero'||chr(10));
            dbms_lob.append(p_DataClob,'    {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10));
            dbms_lob.append(p_DataClob,'  .fecha'||chr(10));
            dbms_lob.append(p_DataClob,'    {padding-top:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    padding-right:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    padding-left:1px;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-ignore:padding;'||chr(10));
            dbms_lob.append(p_DataClob,'    color:windowtext;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-size:10.0pt;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-weight:400;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-style:normal;'||chr(10));
            dbms_lob.append(p_DataClob,'    text-decoration:none;'||chr(10));
            dbms_lob.append(p_DataClob,'    font-family:Arial;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-generic-font-family:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-font-charset:0;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-number-format:"dd\\-mmm\\-yyyy";'||chr(10));
            dbms_lob.append(p_DataClob,'    text-align:general;'||chr(10));
            dbms_lob.append(p_DataClob,'    vertical-align:bottom;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-background-source:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    mso-pattern:auto;'||chr(10));
            dbms_lob.append(p_DataClob,'    white-space:nowrap;}'||chr(10));
            dbms_lob.append(p_DataClob,'  -->'||chr(10));
            dbms_lob.append(p_DataClob,'  </style><div id="libro">'||chr(10));
END ENCABEZADO_HTML;


end OC_archivo;
/

--
-- OC_ARCHIVO  (Synonym) 
--
--  Dependencies: 
--   OC_ARCHIVO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ARCHIVO FOR SICAS_OC.OC_ARCHIVO
/


GRANT EXECUTE ON SICAS_OC.OC_ARCHIVO TO PUBLIC
/
