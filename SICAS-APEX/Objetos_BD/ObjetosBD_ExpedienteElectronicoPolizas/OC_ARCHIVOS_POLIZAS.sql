--------------------------------------------------------------------------------
    --Paquete de Preocedimientos para la Tabla para ARCHIVOS_POLIZAS--
--------------------------------------------------------------------------------

DROP PUBLIC SYNONYM ARCHIVOS_POLIZAS;

CREATE OR REPLACE PACKAGE SICAS_OC.OC_ARCHIVOS_POLIZAS AS

  ------------------------------------------------------------------------------
  -- Tipo de dato que representa la estructura extraída desde el nombre del archivo
  ------------------------------------------------------------------------------
  TYPE t_info_archivo IS RECORD (
    idpoliza         NUMBER,
    clv_doc_grupo    VARCHAR2(50),
    clv_documento    VARCHAR2(50),
    nombre_archivo   VARCHAR2(255)
  );

  ------------------------------------------------------------------------------
  -- Elimina lógicamente múltiples archivos según IDs separados por ':'
  -- Ejemplo de entrada: '101:102:103'
  ------------------------------------------------------------------------------
  PROCEDURE ELIMINADO_MULTIPLE_ARCHIVOS_POLIZAS(p_ids IN VARCHAR2);

  ------------------------------------------------------------------------------
  -- Elimina lógicamente un solo archivo por su ID
  ------------------------------------------------------------------------------
  PROCEDURE ELIMINADO_LOGICO_ARCHIVO_POLIZA(p_id IN NUMBER);

  ------------------------------------------------------------------------------
  -- Inserta un nuevo archivo asociado a una póliza
  ------------------------------------------------------------------------------
  PROCEDURE INSERTAR_ARCHIVO_POLIZA(
    p_idpoliza       IN NUMBER,
    p_clv_doc_grupo  IN VARCHAR2,
    p_clv_doc        IN VARCHAR2,
    p_blob_content   IN BLOB,
    p_filename       IN VARCHAR2,
    p_mime_type      IN VARCHAR2,
    p_length         IN NUMBER,
    p_comentarios    IN VARCHAR2
  );

  ------------------------------------------------------------------------------
  -- Parsea el nombre del archivo y extrae sus componentes:
  -- [IDPOLIZA]_[CLVDOCUMENTO]_[NOMBREARCHIVO]
  ------------------------------------------------------------------------------
  FUNCTION PARSEAR_NOMBRE_ARCHIVO_POLIZA(
    p_filename IN VARCHAR2
  ) RETURN t_info_archivo;

  ------------------------------------------------------------------------------
  -- Muestra un archivo directamente 
  ------------------------------------------------------------------------------
  PROCEDURE MOSTRAR_ARCHIVO_POLIZA(p_id IN NUMBER);

  ------------------------------------------------------------------------------
  -- Descarga un archivo individual como attachment
  ------------------------------------------------------------------------------
  PROCEDURE DESCARGAR_ARCHIVO_POLIZA(p_id IN NUMBER);

  ------------------------------------------------------------------------------
  -- Descarga múltiples archivos como un ZIP
  -- p_ids debe ser una cadena de IDs separados por ':' (ej. '1:2:3')
  ------------------------------------------------------------------------------
  PROCEDURE DESCARGAR_ZIP_ARCHIVOS_POLIZA(p_ids IN VARCHAR2);

  ------------------------------------------------------------------------------
  -- Carga de archivos
  ------------------------------------------------------------------------------
  PROCEDURE CARGAR_ARCHIVOS(
    p_lista_nombres       IN VARCHAR2,
    p_usa_nombre_archivo  IN BOOLEAN,
    p_idpoliza            IN NUMBER DEFAULT NULL,
    p_clv_doc_grupo       IN VARCHAR2 DEFAULT NULL,
    p_clv_doc             IN VARCHAR2 DEFAULT NULL,
    p_comentarios         IN VARCHAR2,
    p_count_ok            OUT NUMBER,
    p_count_error         OUT NUMBER
  );

  ------------------------------------------------------------------------------
  -- Verifica si el usuario tiene permiso en la columna indicada
  ------------------------------------------------------------------------------
  FUNCTION VERIFICAR_PERMISO_USUARIO(
    p_nombre_columna IN VARCHAR2
  ) RETURN BOOLEAN;

  ------------------------------------------------------------------------------
  -- Generación de TOKEN para ingreso a la aplicación
  ------------------------------------------------------------------------------
  FUNCTION TOKEN_APEX(
    CUSER IN VARCHAR2
  ) RETURN VARCHAR2;

  ------------------------------------------------------------------------------
  -- Verificación de Token recibido para ingreso a la aplicación
  ------------------------------------------------------------------------------
  FUNCTION FORMS_TOKEN RETURN BOOLEAN;

  ------------------------------------------------------------------------------
  -- Ingreso a la aplicación por medio de login tradicional
  ------------------------------------------------------------------------------
  FUNCTION FORMS_LOGIN (
    P_USERNAME  IN VARCHAR2,
    P_PASSWORD  IN VARCHAR2
  ) RETURN BOOLEAN;

END OC_ARCHIVOS_POLIZAS;
/





create or replace PACKAGE BODY OC_ARCHIVOS_POLIZAS AS

  ------------------------------------------------------------------------------
  -- Eliminación lógica de múltiples archivos por IDs separados por ':'
  ------------------------------------------------------------------------------
  PROCEDURE ELIMINADO_MULTIPLE_ARCHIVOS_POLIZAS(p_ids IN VARCHAR2) IS
  BEGIN
    FOR rec IN (
      SELECT TO_NUMBER(column_value) AS id
      FROM apex_string.split(p_ids, ':')
    ) LOOP
      UPDATE ARCHIVOS_POLIZAS
      SET 
        ESTATUS_BORRADO = 'S',
        DELETED         = SYSDATE,
        DELETED_BY      = NVL(V('APP_USER'), USER),
        UPDATED         = SYSDATE,
        UPDATED_BY      = NVL(V('APP_USER'), USER)
      WHERE ID = rec.id;
    END LOOP;
  END ELIMINADO_MULTIPLE_ARCHIVOS_POLIZAS;

  ------------------------------------------------------------------------------
  -- Eliminación lógica de un solo archivo por ID
  ------------------------------------------------------------------------------
  PROCEDURE ELIMINADO_LOGICO_ARCHIVO_POLIZA(p_id IN NUMBER) IS
  BEGIN
    UPDATE ARCHIVOS_POLIZAS
    SET 
      ESTATUS_BORRADO = 'S',
      DELETED         = SYSDATE,
      DELETED_BY      = NVL(V('APP_USER'), USER),
      UPDATED         = SYSDATE,
      UPDATED_BY      = NVL(V('APP_USER'), USER)
    WHERE ID = p_id;
  END ELIMINADO_LOGICO_ARCHIVO_POLIZA;

  ------------------------------------------------------------------------------
  -- Inserta un archivo asociado a una póliza
  ------------------------------------------------------------------------------
  PROCEDURE INSERTAR_ARCHIVO_POLIZA(
    p_idpoliza       IN NUMBER,
    p_clv_doc_grupo  IN VARCHAR2,
    p_clv_doc        IN VARCHAR2,
    p_blob_content   IN BLOB,
    p_filename       IN VARCHAR2,
    p_mime_type      IN VARCHAR2,
    p_length         IN NUMBER,
    p_comentarios    IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO ARCHIVOS_POLIZAS (
      IDPOLIZA,
      CODEMPRESA,
      CODCIA,
      ARCHIVO_BLOB,
      NOMBRE_ARCHIVO,
      FILE_MIME_TYPE,
      TAMANIO_BYTES,
      CLV_DOCUMENTO_GRUPO,
      CLV_DOCUMENTO,
      ESTATUS_BORRADO,
      COMENTARIOS,
      CREATED,
      CREATED_BY,
      UPDATED,
      UPDATED_BY,
      DELETED,
      DELETED_BY
    ) VALUES (
      p_idpoliza,
      1, -- CODEMPRESA por defecto
      1, -- CODCIA por defecto
      p_blob_content,
      p_filename,
      p_mime_type,
      p_length,
      p_clv_doc_grupo,
      p_clv_doc,
      'N',
      p_comentarios,
      SYSDATE,
      NVL(V('APP_USER'), USER),
      SYSDATE,
      NVL(V('APP_USER'), USER),
      NULL,
      NULL
    );
  END INSERTAR_ARCHIVO_POLIZA;

  ------------------------------------------------------------------------------
  -- Parsea el nombre del archivo y extrae:
  -- ID póliza, clave de grupo, clave de documento, y nombre real del archivo
  ------------------------------------------------------------------------------
  FUNCTION PARSEAR_NOMBRE_ARCHIVO_POLIZA(p_filename IN VARCHAR2) RETURN t_info_archivo IS
    v_parts   apex_t_varchar2;
    v_result  t_info_archivo;
  BEGIN
    v_parts := apex_string.split(p_filename, '_');

    IF v_parts.COUNT >= 3 AND REGEXP_LIKE(TRIM(v_parts(1)), '^\d+$') THEN
      v_result.idpoliza       := TO_NUMBER(TRIM(v_parts(1)));
      v_result.clv_documento  := UPPER(TRIM(v_parts(2)));
      v_result.nombre_archivo := SUBSTR(p_filename, INSTR(p_filename, '_', 1, 2) + 1);

      -- Obtener CLV_DOC_PARENT desde la base de datos
      BEGIN
        SELECT CLV_DOC_PARENT
        INTO v_result.clv_doc_grupo
        FROM TIPO_DOCUMENTOS_POLIZAS
        WHERE CLV_DOC = v_result.clv_documento;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          raise_application_error(-20101, 'CLV_DOC no encontrado en TIPO_DOCUMENTOS_POLIZAS: ' || v_result.clv_documento);
      END;

    ELSE
      raise_application_error(-20100, 'El nombre del archivo no cumple con el formato requerido: [poliza]_[CLV_DOC]_[nombre_archivo]');
    END IF;

    RETURN v_result;
  END PARSEAR_NOMBRE_ARCHIVO_POLIZA;

  ------------------------------------------------------------------------------
  -- Muestra un archivo en el navegador si es PDF o imagen compatible
  ------------------------------------------------------------------------------
  PROCEDURE MOSTRAR_ARCHIVO_POLIZA(p_id IN NUMBER) IS
    l_mime   VARCHAR2(255);
    l_nombre VARCHAR2(255);
    l_blob   BLOB;
  BEGIN
    SELECT FILE_MIME_TYPE, NOMBRE_ARCHIVO, ARCHIVO_BLOB
    INTO l_mime, l_nombre, l_blob
    FROM ARCHIVOS_POLIZAS
    WHERE ID = p_id;

    IF l_mime IN ('image/jpeg', 'image/png', 'image/gif', 'application/pdf') THEN
      owa_util.mime_header(l_mime, FALSE);
      htp.p('Content-Disposition: inline; filename="' || l_nombre || '"');
      owa_util.http_header_close;
      wpg_docload.download_file(l_blob);
      apex_application.stop_apex_engine;
    ELSE
      owa_util.mime_header('text/html', FALSE);
      owa_util.http_header_close;
      htp.p('<div class="col apex-col-auto col-end"><h2>Vista no disponible para este tipo de archivo.</h2></div>');
      apex_application.stop_apex_engine;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      owa_util.mime_header('text/html', FALSE);
      owa_util.http_header_close;
      htp.p('<div><p>Archivo no encontrado.</p></div>');
  END MOSTRAR_ARCHIVO_POLIZA;

  ------------------------------------------------------------------------------
  -- Descarga un archivo individual como attachment
  ------------------------------------------------------------------------------
  PROCEDURE DESCARGAR_ARCHIVO_POLIZA(p_id IN NUMBER) IS
    l_blob   BLOB;
    l_mime   VARCHAR2(255);
    l_nombre VARCHAR2(255);
  BEGIN
    SELECT ARCHIVO_BLOB, FILE_MIME_TYPE, NOMBRE_ARCHIVO
    INTO l_blob, l_mime, l_nombre
    FROM ARCHIVOS_POLIZAS
    WHERE ID = p_id;

    owa_util.mime_header(l_mime, FALSE);
    htp.p('Content-Disposition: attachment; filename="' || l_nombre || '"');
    owa_util.http_header_close;
    wpg_docload.download_file(l_blob);
    apex_application.stop_apex_engine;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      htp.p('Archivo no encontrado');
  END DESCARGAR_ARCHIVO_POLIZA;

  ------------------------------------------------------------------------------
  -- Descarga múltiples archivos como un ZIP
  ------------------------------------------------------------------------------
  PROCEDURE DESCARGAR_ZIP_ARCHIVOS_POLIZA(p_ids IN VARCHAR2) IS
    l_zip BLOB;
  BEGIN
    DBMS_LOB.createtemporary(l_zip, TRUE);

    FOR rec IN (
      SELECT NOMBRE_ARCHIVO, ARCHIVO_BLOB
      FROM ARCHIVOS_POLIZAS
      WHERE INSTR(':' || p_ids || ':', ':' || ID || ':') > 0
    ) LOOP
      APEX_ZIP.add_file(
        p_zipped_blob => l_zip,
        p_file_name   => rec.NOMBRE_ARCHIVO,
        p_content     => rec.ARCHIVO_BLOB
      );
    END LOOP;

    APEX_ZIP.finish(l_zip);

    owa_util.mime_header('application/zip', FALSE);
    htp.p('Content-Disposition: attachment; filename="archivos.zip"');
    owa_util.http_header_close;
    wpg_docload.download_file(l_zip);
    apex_application.stop_apex_engine;
  END DESCARGAR_ZIP_ARCHIVOS_POLIZA;

  ------------------------------------------------------------------------------
  -- Carga de archivos
  ------------------------------------------------------------------------------
  PROCEDURE CARGAR_ARCHIVOS(
    p_lista_nombres       IN VARCHAR2,
    p_usa_nombre_archivo  IN BOOLEAN,
    p_idpoliza            IN NUMBER DEFAULT NULL,
    p_clv_doc_grupo       IN VARCHAR2 DEFAULT NULL,
    p_clv_doc             IN VARCHAR2 DEFAULT NULL,
    p_comentarios         IN VARCHAR2,
    p_count_ok            OUT NUMBER,
    p_count_error         OUT NUMBER
  ) IS
    v_info OC_ARCHIVOS_POLIZAS.t_info_archivo;
  BEGIN
    p_count_ok := 0;
    p_count_error := 0;

    FOR rec IN (
      SELECT name, blob_content, mime_type, filename, dbms_lob.getlength(blob_content) AS length
      FROM apex_application_temp_files
      WHERE name IN (
        SELECT column_value FROM apex_string.split(p_lista_nombres, ':')
      )
    ) LOOP
      BEGIN
        IF p_usa_nombre_archivo THEN
          v_info := OC_ARCHIVOS_POLIZAS.PARSEAR_NOMBRE_ARCHIVO_POLIZA(rec.filename);
        ELSE
          v_info.idpoliza       := p_idpoliza;
          v_info.clv_doc_grupo  := p_clv_doc_grupo;
          v_info.clv_documento  := p_clv_doc;
          v_info.nombre_archivo := rec.filename;
        END IF;

        OC_ARCHIVOS_POLIZAS.INSERTAR_ARCHIVO_POLIZA(
          p_idpoliza      => v_info.idpoliza,
          p_clv_doc_grupo => v_info.clv_doc_grupo,
          p_clv_doc       => v_info.clv_documento,
          p_blob_content  => rec.blob_content,
          p_filename      => v_info.nombre_archivo,
          p_mime_type     => rec.mime_type,
          p_length        => rec.length,
          p_comentarios   => p_comentarios
        );

        DELETE FROM apex_application_temp_files
        WHERE name = rec.name;

        p_count_ok := p_count_ok + 1;

      EXCEPTION
        WHEN OTHERS THEN
          p_count_error := p_count_error + 1;
      END;
    END LOOP;
  END CARGAR_ARCHIVOS;

  FUNCTION VERIFICAR_PERMISO_USUARIO(
    p_nombre_columna IN VARCHAR2
  ) RETURN BOOLEAN IS
    v_sql       VARCHAR2(1000);
    v_resultado CHAR(1);
  BEGIN
    v_sql := '
      SELECT ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_nombre_columna) || '
      FROM USUARIOS_APPX u
      JOIN PERMISOS_ARCHIVOS_POLIZAS p ON u.CODGRUPO = p.CODGRUPO
      WHERE u.CODUSUARIO = :usuario';

    EXECUTE IMMEDIATE v_sql INTO v_resultado USING V('APP_USER');
    RETURN v_resultado = 'S';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;
    WHEN OTHERS THEN RETURN FALSE;
  END VERIFICAR_PERMISO_USUARIO;

    -----------------------------------------------------------------------------
    -- Generación de TOKEN para ingreso a la aplicación
    -----------------------------------------------------------------------------
    FUNCTION TOKEN_APEX(CUSER VARCHAR2) RETURN VARCHAR2 IS
        JWT_FORMS VARCHAR2(32767);
    BEGIN
        JWT_FORMS := APEX_JWT.ENCODE (
          P_ISS => 'TS_OC_SICAS',
          P_SUB => CUSER,
          P_AUD => 'Sicas',
          P_SIGNATURE_KEY => SYS.UTL_RAW.CAST_TO_RAW('Th0n4S3gUr05') );

        RETURN JWT_FORMS;
    END TOKEN_APEX;

    -----------------------------------------------------------------------------
    -- Verificación de Token recibido para ingreso a la aplicación
    -----------------------------------------------------------------------------
    FUNCTION FORMS_TOKEN RETURN BOOLEAN IS
        V_X01      VARCHAR2(32767);
        L_JWT      APEX_JWT.T_TOKEN;
        L_JWT_USER VARCHAR2(255);
        VUSER      NUMBER;
    BEGIN
        V_X01 := V('APP_AJAX_X01');

        IF V_X01 LIKE '%.%.%' THEN
            L_JWT := APEX_JWT.DECODE (
                P_VALUE         => V_X01,
                P_SIGNATURE_KEY => SYS.UTL_RAW.CAST_TO_RAW('Th0n4S3gUr05') );

            APEX_JWT.VALIDATE (
                P_TOKEN => L_JWT,
                P_ISS   => 'TS_OC_SICAS',
                P_AUD   => 'Sicas' );

            APEX_JSON.PARSE(P_SOURCE => L_JWT.PAYLOAD);
            L_JWT_USER := APEX_JSON.GET_VARCHAR2('sub');
        END IF;

        IF APEX_AUTHENTICATION.IS_PUBLIC_USER THEN
            IF L_JWT_USER IS NOT NULL THEN
                SELECT 1 INTO VUSER
                FROM USUARIOS
                WHERE CODUSUARIO = L_JWT_USER;

                APEX_AUTHENTICATION.POST_LOGIN(P_USERNAME => L_JWT_USER);
            ELSE
                RETURN FALSE;
            END IF;
        ELSIF APEX_APPLICATION.G_USER <> L_JWT_USER THEN
          RETURN FALSE;
        END IF;

        RETURN TRUE;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            APEX_ERROR.ADD_ERROR(
            P_MESSAGE => 'NO SE ENCONTRO USUARIO',
            P_DISPLAY_LOCATION => APEX_ERROR.C_INLINE_IN_NOTIFICATION );
            RETURN FALSE;

        WHEN OTHERS THEN
            APEX_ERROR.ADD_ERROR(
            P_MESSAGE => 'UN ERROR A OCURRIDO DURANTE LA AUTENTIFICACIÓN: ' || SQLERRM,
            P_DISPLAY_LOCATION => APEX_ERROR.C_INLINE_IN_NOTIFICATION );
            RETURN FALSE;
        END FORMS_TOKEN;

    -----------------------------------------------------------------------------
    -- Ingreso a la aplicación por medio de página de login tradicional
    -----------------------------------------------------------------------------
    FUNCTION FORMS_LOGIN (
        P_USERNAME  VARCHAR2,
        P_PASSWORD  VARCHAR2
    ) RETURN BOOLEAN IS
        VLOGIN  BOOLEAN;
        VCUSER  VARCHAR2(15);
        VUSER   NUMBER;
    BEGIN
        IF P_USERNAME IS NULL OR P_PASSWORD IS NULL THEN
            APEX_ERROR.ADD_ERROR(
                P_MESSAGE => 'USUARIO Y CONTRASEÑA SON REQUERIDOS.',
                P_DISPLAY_LOCATION => APEX_ERROR.C_INLINE_IN_NOTIFICATION );

            RETURN FALSE;
        ELSE
            IF APEX_AUTHENTICATION.IS_PUBLIC_USER THEN
                SELECT CODGRUPO 
                INTO VCUSER
                FROM USUARIOS
                WHERE CODUSUARIO = P_USERNAME;

                SELECT 1 
                INTO VUSER
                FROM PERMISOS_ARCHIVOS_POLIZAS
                WHERE CODGRUPO = VCUSER
                AND ACCESO_APLICATIVO = 'S';

                IF VUSER IS NOT NULL THEN
                    APEX_AUTHENTICATION.POST_LOGIN(
                    P_USERNAME  => P_USERNAME,
                    P_PASSWORD  => P_PASSWORD );
                END IF;
            END IF;
        END IF;

        RETURN TRUE;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            APEX_ERROR.ADD_ERROR(
                P_MESSAGE => 'NO SE ENCONTRO USUARIO',
                P_DISPLAY_LOCATION => APEX_ERROR.C_INLINE_IN_NOTIFICATION );
            
            RETURN FALSE;

        WHEN OTHERS THEN
            APEX_ERROR.ADD_ERROR(
                P_MESSAGE => 'UN ERROR A OCURRIDO DURANTE LA AUTENTIFICACIÓN: ' || SQLERRM,
                P_DISPLAY_LOCATION => APEX_ERROR.C_INLINE_IN_NOTIFICATION );

            RETURN FALSE;
    END FORMS_LOGIN;

END OC_ARCHIVOS_POLIZAS;
/
 
GRANT EXECUTE ON SICAS_OC.OC_ARCHIVOS_POLIZAS TO PUBLIC;
/
 
CREATE OR REPLACE PUBLIC SYNONYM OC_ARCHIVOS_POLIZAS FOR SICAS_OC.OC_ARCHIVOS_POLIZAS;
/