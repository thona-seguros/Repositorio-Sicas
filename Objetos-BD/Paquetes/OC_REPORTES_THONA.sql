CREATE OR REPLACE PACKAGE          OC_REPORTES_THONA IS
   PROCEDURE GENERA_REPORTE( nCodCia      TEMP_REPORTES_THONA.CODCIA%TYPE
                           , nCodEmpresa  TEMP_REPORTES_THONA.CODEMPRESA%TYPE
                           , cCodReporte  TEMP_REPORTES_THONA.CODREPORTE%TYPE
                           , cCodUsuario  TEMP_REPORTES_THONA.CODUSUARIO%TYPE
                           , cNomArchivo  VARCHAR2 
                           , cNomArchZip  VARCHAR2 );

   PROCEDURE COPIA_ARCHIVO_BLOB( nCodCia         TEMP_ARCHIVOS_THONA.CODCIA%TYPE
                               , nCodEmpresa     TEMP_ARCHIVOS_THONA.CODEMPRESA%TYPE
                               , cCodReporte     TEMP_ARCHIVOS_THONA.CODREPORTE%TYPE
                               , cCodUsuario     TEMP_ARCHIVOS_THONA.CODUSUARIO%TYPE
                               , cNomArchZip     VARCHAR2 
                               , nId_Envio       NUMBER DEFAULT 0
                               , pEliminaArchivo VARCHAR2 DEFAULT 'N');

   FUNCTION EXISTE_ARCHIVO( cDirectorio  VARCHAR2
                          , cNomArchivo  VARCHAR2 ) RETURN BOOLEAN;

   PROCEDURE INSERTAR_REGISTRO( nCodCia      TEMP_REPORTES_THONA.CODCIA%TYPE
                              , nCodEmpresa  TEMP_REPORTES_THONA.CODEMPRESA%TYPE
                              , cCodReporte  TEMP_REPORTES_THONA.CODREPORTE%TYPE
                              , cCodUsuario  TEMP_REPORTES_THONA.CODUSUARIO%TYPE
                              , cCadena      TEMP_REPORTES_THONA.LINEA%TYPE );

END OC_REPORTES_THONA;

/

CREATE OR REPLACE PACKAGE BODY          OC_REPORTES_THONA IS
   PROCEDURE GENERA_REPORTE( nCodCia      TEMP_REPORTES_THONA.CODCIA%TYPE
                           , nCodEmpresa  TEMP_REPORTES_THONA.CODEMPRESA%TYPE
                           , cCodReporte  TEMP_REPORTES_THONA.CODREPORTE%TYPE
                           , cCodUsuario  TEMP_REPORTES_THONA.CODUSUARIO%TYPE
                           , cNomArchivo  VARCHAR2 
                           , cNomArchZip  VARCHAR2 )  IS
      cCtlArchivo     UTL_FILE.FILE_TYPE;
      cNomDirectorio  VARCHAR2(100);
      --
      CURSOR c_Reporte IS
             SELECT Linea
             FROM   TEMP_REPORTES_THONA
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  CodReporte = cCodReporte
               AND  CodUsuario = cCodUsuario
             ORDER BY IdSecuencia;
   BEGIN
      cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
      cCtlArchivo    := UTL_FILE.FOPEN(cNomDirectorio, cNomArchivo, 'W', 32767);
      --
      FOR x IN c_Reporte LOOP
          UTL_FILE.PUT_LINE(cCtlArchivo, x.Linea);
      END LOOP;
      --
      UTL_FILE.FCLOSE(cCtlArchivo);
      --
      IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
         dbms_output.put_line('OK');
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        UTL_FILE.FCLOSE(cCtlArchivo);
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20200, SQLCODE || ' Error al generar el archivo: ' || SQLERRM);
   END GENERA_REPORTE;

    PROCEDURE COPIA_ARCHIVO_BLOB( nCodCia         TEMP_ARCHIVOS_THONA.CODCIA%TYPE
                                , nCodEmpresa     TEMP_ARCHIVOS_THONA.CODEMPRESA%TYPE
                                , cCodReporte     TEMP_ARCHIVOS_THONA.CODREPORTE%TYPE
                                , cCodUsuario     TEMP_ARCHIVOS_THONA.CODUSUARIO%TYPE
                                , cNomArchZip     VARCHAR2
                                , nId_Envio       NUMBER DEFAULT 0
                                , pEliminaArchivo VARCHAR2 DEFAULT 'N')  IS
      cNomDirectorio  VARCHAR2(100) := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
      l_bfile         BFILE;
      l_blob          BLOB;
    BEGIN
      --Elimino los Archivos de ese CodCia/CodEmpresa/CodReporte/CodUsuario
      --
        DELETE TEMP_ARCHIVOS_THONA
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  CodReporte   = cCodReporte
           AND  CodUsuario   = cCodUsuario
           AND  trunc(Fecha)<= trunc(sysdate);
      --
      INSERT INTO TEMP_ARCHIVOS_THONA ( CODCIA, CODEMPRESA, CODREPORTE, CODUSUARIO, ID_ENVIO, ARCHIVO )
                               VALUES (nCodCia, nCodEmpresa, cCodReporte, cCodUsuario, nId_Envio, EMPTY_BLOB())
           RETURN Archivo INTO l_blob;
      --  
      l_bfile := BFILENAME(cNomDirectorio, cNomArchZip);
      --
      DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
      DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
      DBMS_LOB.fileclose(l_bfile);
      --      
      COMMIT;

      BEGIN
        IF UPPER(pEliminaArchivo) != 'N' THEN
           UTL_FILE.FREMOVE(cNomDirectorio, cNomArchZip);
        END IF;
      EXCEPTION WHEN OTHERS THEN
            NULL;            
      END;

    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20200, SQLCODE || ' Error al copiar el archivo BLOB: ' || SQLERRM);
    END COPIA_ARCHIVO_BLOB;

   FUNCTION EXISTE_ARCHIVO( cDirectorio  VARCHAR2
                          , cNomArchivo  VARCHAR2 ) RETURN BOOLEAN IS   
      bFileExists  BOOLEAN;
      nFileLen     NUMBER;
      bBlockSize   BINARY_INTEGER;
   BEGIN
      utl_file.fgetattr( location    => cDirectorio
                       , filename    => cNomArchivo
                       , fexists     => bFileExists
                       , file_length => nFileLen
                       , block_size  => bBlockSize );
      RETURN bFileExists;
   END EXISTE_ARCHIVO;

   PROCEDURE INSERTAR_REGISTRO( nCodCia      TEMP_REPORTES_THONA.CODCIA%TYPE
                              , nCodEmpresa  TEMP_REPORTES_THONA.CODEMPRESA%TYPE
                              , cCodReporte  TEMP_REPORTES_THONA.CODREPORTE%TYPE
                              , cCodUsuario  TEMP_REPORTES_THONA.CODUSUARIO%TYPE
                              , cCadena      TEMP_REPORTES_THONA.LINEA%TYPE ) IS
   BEGIN
      INSERT INTO TEMP_REPORTES_THONA( CodCia, CodEmpresa, CodReporte, CodUsuario, Linea )
      VALUES ( nCodCia, nCodEmpresa, cCodReporte, cCodUsuario, cCadena );
   EXCEPTION
   WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR( -20225, 'Error al insertar en TEMP_REPORTES_THONA: ' || SQLERRM );   
   END INSERTAR_REGISTRO;

END OC_REPORTES_THONA;
