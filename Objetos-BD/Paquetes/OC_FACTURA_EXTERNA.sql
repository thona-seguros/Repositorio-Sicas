CREATE OR REPLACE PACKAGE          OC_FACTURA_EXTERNA IS

FUNCTION ID_FACTURA_EXTERNA(nCodCia  NUMBER) RETURN NUMBER;

PROCEDURE ACTIVAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER);

PROCEDURE ANULAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER);

PROCEDURE PAGAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER);

PROCEDURE ANULA_FACTURA_NCR (nCodCia  NUMBER, nIdNcr NUMBER);

PROCEDURE PAGAR_FACTURA_NCR (nCodCia  NUMBER, nIdNcr NUMBER);

PROCEDURE GENERAR_REPORTE(nCodCia  NUMBER, cStsFactExt VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecDevol DATE);

FUNCTION INSERTAR_FACTURA(nCodCia NUMBER, cNumFactura VARCHAR2, dFecFact DATE, cTipo_Doc_Identificacion VARCHAR2, 
                          cNum_Doc_Identificacion VARCHAR2, nMontoFact NUMBER, cObservaciones VARCHAR2, nIdSiniestro NUMBER,
                          nNum_Aprobacion NUMBER, nIVA NUMBER, cUUID VARCHAR2 DEFAULT NULL,nCod_Agente NUMBER) RETURN NUMBER;

FUNCTION NUMERO_FACTURA(nCodCia NUMBER, nIdeFactExt NUMBER) RETURN VARCHAR2;

PROCEDURE ACTUALIZA_MONTOS(nCodCia NUMBER, nUUID VARCHAR2, nIdeFactExt NUMBER);

FUNCTION IDENTIFICADOR_FACT_EXT(nCodCia NUMBER, cNumFactura NUMBER) RETURN NUMBER;

END OC_FACTURA_EXTERNA;
/

CREATE OR REPLACE PACKAGE BODY          OC_FACTURA_EXTERNA IS

FUNCTION ID_FACTURA_EXTERNA(nCodCia  NUMBER) RETURN NUMBER IS
nIdeFactExt   FACTURA_EXTERNA.IdeFactExt%TYPE;
BEGIN
   SELECT NVL(MAX(IdeFactExt),1)+1
     INTO nIdeFactExt
     FROM FACTURA_EXTERNA
    WHERE CodCia = nCodCia;

   RETURN(nIdeFactExt);
END ID_FACTURA_EXTERNA;

PROCEDURE ACTIVAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER) IS
BEGIN
   UPDATE FACTURA_EXTERNA
      SET StsFactExt   = 'ACTIVA'
    WHERE IdeFactExt = nIdeFactExt
      AND CodCia     = nCodCia;
END ACTIVAR_FACTURA;

PROCEDURE ANULAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER) IS
BEGIN
   UPDATE FACTURA_EXTERNA
      SET StsFactExt   = 'ANULAD'
    WHERE IdeFactExt = nIdeFactExt
      AND CodCia     = nCodCia;
END ANULAR_FACTURA;

PROCEDURE PAGAR_FACTURA(nCodCia  NUMBER, nIdeFactExt NUMBER) IS
BEGIN
   UPDATE FACTURA_EXTERNA
      SET StsFactExt   = 'PAGADA'
    WHERE IdeFactExt = nIdeFactExt
      AND CodCia     = nCodCia;
END PAGAR_FACTURA;


PROCEDURE ANULA_FACTURA_NCR(nCodCia  NUMBER, nIdNcr NUMBER) IS
CURSOR FACT_Q IS
   SELECT IdeFactExt
     FROM FACTURA_EXTERNA
    WHERE IdNcr  = nIdNcr
      AND CodCia = nCodCia
    ORDER BY IdeFactExt;
BEGIN
   FOR X IN FACT_Q  LOOP OC_FACTURA_EXTERNA.ANULAR_FACTURA(nCodCia, X.IdeFactExt);
   END LOOP;
END ANULA_FACTURA_NCR;

PROCEDURE PAGAR_FACTURA_NCR(nCodCia  NUMBER, nIdNcr NUMBER) IS
CURSOR FACT_Q IS
   SELECT IdeFactExt
     FROM FACTURA_EXTERNA
    WHERE IdNcr  = nIdNcr
      AND CodCia = nCodCia
    ORDER BY IdeFactExt;
BEGIN
   FOR X IN FACT_Q  LOOP
      OC_FACTURA_EXTERNA.PAGAR_FACTURA(nCodCia, X.IdeFactExt);
   END LOOP;
END PAGAR_FACTURA_NCR;

PROCEDURE GENERAR_REPORTE(nCodCia  NUMBER, cStsFactExt VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecDevol DATE) IS
cCadena        VARCHAR2(4000);
cSeparador     VARCHAR2(1) := '|';
nLinea         NUMBER;

CURSOR FACT_Q IS
   SELECT F.IdeFactExt, F.NumFactExt, F.StsFactExt, F.FecStsFactExt, F.IdNcr, F.FecFactExt,
          TRIM(PNJ.Nombre) || ' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) NomProveedor,
          F.MtoTotFactExt, F.FecRecepcion, F.Observaciones
     FROM FACTURA_EXTERNA F, PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Doc_Identificacion  = F.Tipo_Doc_Identificacion
      AND PNJ.Num_Doc_Identificacion   = F.Num_Doc_Identificacion
      AND F.StsFactExt                 = cStsFactExt
      AND F.FecStsFactExt             >= dFecDesde
      AND F.FecStsFactExt             <= dFecHasta
      AND CodCia                       = nCodCia
    UNION
   SELECT F.IdeFactExt, F.NumFactExt, F.StsFactExt, F.FecStsFactExt, F.IdNcr, F.FecFactExt,
          TRIM(PNJ.Nombre) || ' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) NomProveedor,
          F.MtoTotFactExt, F.FecRecepcion, F.Observaciones
     FROM FACTURA_EXTERNA F, PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Doc_Identificacion  = F.Tipo_Doc_Identificacion
      AND PNJ.Num_Doc_Identificacion   = F.Num_Doc_Identificacion
      AND F.StsFactExt                 = cStsFactExt
      AND F.FecStsFactExt             >= dFecDesde
      AND F.FecStsFactExt             <= dFecHasta
      AND F.IdNcr                     IN (SELECT IdNcr
                                            FROM NOTAS_DE_CREDITO
                                           WHERE IdNcr     = F.IdNcr
                                             AND FecDevol  = dFecDevol)
      AND CodCia                       = nCodCia
    ORDER BY IdeFactExt;
BEGIN
   -- Escribe Encabezado de Archivo Excel
   nLinea   := 1;
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
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
               '    -->'||chr(10)||
               ' </style><div id="libro">'||chr(10);
   OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
   nLinea   := 2;
   cCadena := '<table border = 1><tr><th align=center bgcolor = "#008000"><font color="#FFFFFF">Id. Factura</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">No. Factura</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Nombre Proveedor</font></th>'||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Fecha Factura</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Monto Factura</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Status</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Fecha Status</font></th>'||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">No. Nota Credito</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Fecha Recepcion</font></th>' ||
              '<th align=center bgcolor = "#008000"><font color="#FFFFFF">Observaciones</font></th></tr>';
   OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);

   FOR X IN FACT_Q LOOP
      nLinea  := NVL(nLinea,0) + 1;
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.IdeFactExt,'C')  ||
                        OC_ARCHIVO.CAMPO_HTML(X.NumFactExt,'C')     ||
                        OC_ARCHIVO.CAMPO_HTML(X.NomProveedor,'C')   ||
                        OC_ARCHIVO.CAMPO_HTML(X.FecFactExt,'D')     ||
                        OC_ARCHIVO.CAMPO_HTML(X.MtoTotFactExt,'N')  ||
                        OC_ARCHIVO.CAMPO_HTML(X.StsFactExt,'C')     ||
                        OC_ARCHIVO.CAMPO_HTML(X.FecStsFactExt,'D')  ||
                        OC_ARCHIVO.CAMPO_HTML(X.IdNcr,'N')       ||
                        OC_ARCHIVO.CAMPO_HTML(X.FecRecepcion,'D')   ||
                        OC_ARCHIVO.CAMPO_HTML(X.Observaciones,'C')  || '</tr>';

      OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', USER, 0);
END GENERAR_REPORTE;

FUNCTION INSERTAR_FACTURA(nCodCia NUMBER, cNumFactura VARCHAR2, dFecFact DATE, cTipo_Doc_Identificacion VARCHAR2, 
                          cNum_Doc_Identificacion VARCHAR2, nMontoFact NUMBER, cObservaciones VARCHAR2, 
                          nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIVA NUMBER, cUUID VARCHAR2 DEFAULT NULL,nCod_Agente NUMBER) RETURN NUMBER IS
nIdeFactExt   FACTURA_EXTERNA.IdeFactExt%TYPE;
cExiste       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FACTURA_EXTERNA
       WHERE CodCia                  = nCodCia
         AND NumFactExt              = cNumFactura
         AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   IF cExiste = 'S' THEN
      RAISE_APPLICATION_ERROR(-20225,'Factura ya está Registrada en el Sistema para el Proveedor.');
   ELSE
      nIdeFactExt := OC_FACTURA_EXTERNA.ID_FACTURA_EXTERNA(nCodCia);
      INSERT INTO FACTURA_EXTERNA
             (CodCia, IdeFactExt, NumFactExt, IdNcr, FecFactExt, Tipo_Doc_Identificacion,
              Num_Doc_Identificacion, MtoTotFactExt, TipoFactExt, FecRecepcion, Observaciones,
              StsFactExt, FecStsFactExt, CodUsuario, IdSiniestro, Num_Aprobacion,IVA, UUID,
              Cod_Agente)
      VALUES (nCodCia, nIdeFactExt, cNumFactura, 0, dFecFact, cTipo_Doc_Identificacion,
              cNum_Doc_Identificacion, nMontoFact, 'N', TRUNC(SYSDATE), cObservaciones,
              'ACTIVA', TRUNC(SYSDATE), USER, nIdSiniestro, nNum_Aprobacion,nIVA, cUUID,
              nCod_Agente);
      RETURN(nIdeFactExt);
   END IF;
END INSERTAR_FACTURA;

FUNCTION NUMERO_FACTURA(nCodCia NUMBER, nIdeFactExt NUMBER) RETURN VARCHAR2 IS
cNumFactExt    FACTURA_EXTERNA.NumFactExt%TYPE;
BEGIN
   BEGIN
      SELECT NumFactExt
        INTO cNumFactExt
        FROM FACTURA_EXTERNA
       WHERE CodCia     = nCodCia
         AND IdeFactExt = nIdeFactExt;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumFactExt := NULL;
   END;
   RETURN(cNumFactExt);
END NUMERO_FACTURA;

PROCEDURE ACTUALIZA_MONTOS(nCodCia NUMBER, nUUID VARCHAR2, nIdeFactExt NUMBER) IS
    nMtoTotFactExt FACTURA_EXTERNA.MTOTOTFACTEXT%TYPE;
BEGIN
    SELECT NVL(SUM(DFE.MtoTotal),0)
      INTO nMtoTotFactExt
      FROM DETALLE_FACTURA_EXTERNA DFE,FACTURA_EXTERNA FE
     WHERE FE.UUID       = nUUID
       AND FE.IdeFactExt = nIdeFactExt
       AND FE.CodCia     = nCodCia
       AND FE.IdeFactExt = DFE.IdeFactExt;
       
    IF nMtoTotFactExt != 0 THEN 
        UPDATE FACTURA_EXTERNA
           SET MtoTotFactExt = nMtoTotFactExt
         WHERE UUID       = nUUID
           AND IdeFactExt = nIdeFactExt;
    ELSE 
        RAISE_APPLICATION_ERROR(-20225,'No Es Posible Actualizar La Factura, El Monto A Actualizar Es Cero, Por Favor Valide.');
    END IF;
END ACTUALIZA_MONTOS;

FUNCTION IDENTIFICADOR_FACT_EXT(nCodCia NUMBER, cNumFactura NUMBER) RETURN NUMBER IS
    nIdeFactExt FACTURA_EXTERNA.IdeFactExt%TYPE;
BEGIN
    BEGIN
        SELECT IdeFactExt
          INTO nIdeFactExt
          FROM FACTURA_EXTERNA
         WHERE CodCia     = nCodCia
           AND NumFactExt = cNumFactura;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            nIdeFactExt := 0;
    END;
    RETURN nIdeFactExt;
END IDENTIFICADOR_FACT_EXT;

END OC_FACTURA_EXTERNA;
