--
-- OC_SOLICITUD_DETALLE_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_ARCHIVO (Package)
--   SOLICITUD_DETALLE_ASEG (Table)
--   OC_EMPRESAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUD_DETALLE_ASEG IS

FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION TIENE_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

FUNCTION VALIDA_ASEG_DUPLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

PROCEDURE REPORTE_ASEG_DUPLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, cIndElimina VARCHAR2);

END OC_SOLICITUD_DETALLE_ASEG;
/

--
-- OC_SOLICITUD_DETALLE_ASEG  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUD_DETALLE_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUD_DETALLE_ASEG IS

FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
nIdAsegurado     SOLICITUD_DETALLE_ASEG.IdAsegurado%TYPE;
BEGIN
   SELECT NVL(MAX(IdAsegurado),0) + 1
     INTO nIdAsegurado
     FROM SOLICITUD_DETALLE_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud;
    RETURN(nIdAsegurado);
END CORRELATIVO_ASEGURADO;

FUNCTION TIENE_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_DETALLE_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END TIENE_ASEGURADOS;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
nCantAseg     NUMBER(20);
BEGIN
   BEGIN
      SELECT COUNT(*)
        INTO nCantAseg
        FROM SOLICITUD_DETALLE_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol;
    END;
    RETURN(nCantAseg);
END CANTIDAD_ASEGURADOS;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_DETALLE_ASEG
         (CodCia, CodEmpresa, IdSolicitud, IDetSol, IdAsegurado, TipoDocIdentificacion,
          NumDocIdentificacion, NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg,
          FechaNacimiento, SexoAseg, DirecResAseg, CodigoPostalAseg)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, IDetSol, IdAsegurado, TipoDocIdentificacion,
          NumDocIdentificacion, NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg,
          FechaNacimiento, SexoAseg, DirecResAseg, CodigoPostalAseg
     FROM SOLICITUD_DETALLE_ASEG
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Lista de Asegurados en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

FUNCTION VALIDA_ASEG_DUPLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
--
nTotDuplicados          NUMBER;
cNumDocIdentificacion   SOLICITUD_DETALLE_ASEG.NumDocIdentificacion%TYPE := NULL;
--
CURSOR DUP_Q IS
   SELECT NVL(REPLACE(NumDocIdentificacion,' ','ESPACIOS'),'VACIO') NumDocIdentificacion, COUNT(*) 
     FROM SOLICITUD_DETALLE_ASEG 
    WHERE IdSolicitud = nIdSolicitud
      AND CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
    GROUP BY NumDocIdentificacion 
   HAVING COUNT(*) > 1;
--
BEGIN
   --
   nTotDuplicados := 0;
   --
   FOR Z IN DUP_Q LOOP
      cNumDocIdentificacion := Z.NumDocIdentificacion;
      nTotDuplicados        := nTotDuplicados + 1;
   END LOOP;   
   --
   IF nTotDuplicados = 0 THEN
      RETURN('X');
   ELSE
      RETURN('Tiene '||nTotDuplicados||' registros duplicados, uno de ellos es: '||cNumDocIdentificacion);
   END IF;
   --
END VALIDA_ASEG_DUPLICADOS;

PROCEDURE REPORTE_ASEG_DUPLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, cIndElimina VARCHAR2) IS
cCodUser                   VARCHAR2(30)   := USER;
nLinea                     NUMBER(15)     := 1;
cCadena                    VARCHAR2(4000);
cNumDocIdentificacion      SOLICITUD_DETALLE_ASEG.NumDocIdentificacion%TYPE;
nIDetSol                   SOLICITUD_DETALLE_ASEG.IDetSol%TYPE;

CURSOR DUP_Q IS
   SELECT NVL(REPLACE(NumDocIdentificacion,' ','ESPACIOS'),'VACIO') NumDocIdentificacion, 
          IDetSol, COUNT(*) 
     FROM SOLICITUD_DETALLE_ASEG
    WHERE IdSolicitud = nIdSolicitud
      AND CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
    GROUP BY NumDocIdentificacion, IDetSol
   HAVING COUNT(*) > 1
    ORDER BY IDetSol;

CURSOR ASEG_Q IS
   SELECT S.CodCia, S.CodEmpresa, S.IdSolicitud, S.IDetSol, S.IdAsegurado, S.TipoDocIdentificacion,
          S.NumDocIdentificacion, S.NombreAseg, S.ApellidoPaternoAseg, S.ApellidoMaternoAseg,
          S.FechaNacimiento, S.SexoAseg, S.DirecResAseg, S.CodigoPostalAseg
     FROM SOLICITUD_DETALLE_ASEG S
    WHERE S.CodCia               = nCodCia
      AND S.CodEmpresa           = nCodEmpresa
      AND S.IdSolicitud          = nIdSolicitud
      AND S.NumDocIdentificacion = cNumDocIdentificacion
      AND S.IDetSol              = nIDetSol
      AND S.IdAsegurado         IN (SELECT MIN(IdAsegurado)
                                      FROM SOLICITUD_DETALLE_ASEG
                                     WHERE CodCia               = S.CodCia
                                       AND CodEmpresa           = S.CodEmpresa
                                       AND IdSolicitud          = S.IdSolicitud
                                       AND NumDocIdentificacion = S.NumDocIdentificacion
                                       AND IDetSol              = S.IDetSol);
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
                    '          {mso-number-format:"dd\\-mm\\-yyyy";}'||chr(10)||
                    '    -->'||chr(10)||
                    ' </style><div id="libro">'||chr(10);

   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia) || '</th></tr>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>REPORTE DE ASEGURADOS DUPLICADOS EN SOLICITUD No. '|| TRIM(TO_CHAR(nIdSolicitud)) || '</th></tr>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>  </th></tr></table>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Solicitud</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle/Subgrupo</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Correlativo Asegurado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Doc. Identif.</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Num. Doc. Identif.</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Apellido Paterno</font></th>' || 
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Apellido Materno</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Nacimiento</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sexo</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dirección</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Postal</font></th>';
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   FOR W IN DUP_Q LOOP
      cNumDocIdentificacion := W.NumDocIdentificacion;
      nIDetSol              := W.IDetSol;
      FOR X IN ASEG_Q LOOP
         nLinea := nLinea + 1;
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(LPAD(TRIM(TO_CHAR(X.IdSolicitud)),14,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IDetSol,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IdAsegurado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.TipoDocIdentificacion,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumDocIdentificacion,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NombreAseg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.ApellidoPaternoAseg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.ApellidoMaternoAseg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaNacimiento,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.SexoAseg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DirecResAseg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodigoPostalAseg,'C') || '</tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         IF cIndElimina = 'S' THEN
            DELETE SOLICITUD_DETALLE_ASEG
             WHERE CodCia               = X.CodCia
               AND CodEmpresa           = X.CodEmpresa
               AND IdSolicitud          = X.IdSolicitud
               AND NumDocIdentificacion = X.NumDocIdentificacion
               AND IDetSol              = X.IDetSol
               AND IdAsegurado          > X.IdAsegurado;
         END IF;
      END LOOP;
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
END REPORTE_ASEG_DUPLICADOS;

END OC_SOLICITUD_DETALLE_ASEG;
/

--
-- OC_SOLICITUD_DETALLE_ASEG  (Synonym) 
--
--  Dependencies: 
--   OC_SOLICITUD_DETALLE_ASEG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SOLICITUD_DETALLE_ASEG FOR SICAS_OC.OC_SOLICITUD_DETALLE_ASEG
/


GRANT EXECUTE ON SICAS_OC.OC_SOLICITUD_DETALLE_ASEG TO PUBLIC
/
