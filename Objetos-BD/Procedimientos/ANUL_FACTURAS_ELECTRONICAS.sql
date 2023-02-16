PROCEDURE ANUL_FACTURAS_ELECTRONICAS IS
cCadena         VARCHAR2(32767);
cNomArch        VARCHAR2(32767);
Archivo         UTL_FILE.FILE_TYPE;
ArchivoLog      UTL_FILE.FILE_TYPE;
cFolioFactElec  FACTURAS.FolioFactElec%TYPE;
nIdFactura      FACTURAS.IdFactura%TYPE;
cLogFactElec    FACTURAS.LogProcesoFactElec%TYPE;
cExiste         VARCHAR2(1);

BEGIN
   Archivo := UTL_FILE.FOPEN('LOGANUFE','Procesados.TXT','R'); 
   LOOP
      BEGIN
         UTL_FILE.GET_LINE(Archivo, cNomArch);
         IF DBMS_LOB.FILEEXISTS(BFILENAME('LOGANUFE', cNomArch)) = 1 THEN
            IF INSTR(UPPER(cNomArch),'OK',1) != 0 THEN
               ArchivoLog  := UTL_FILE.FOPEN('LOGANUFE',cNomArch,'R');
               LOOP
                  BEGIN
                     UTL_FILE.GET_LINE(ArchivoLog, cCadena);
                     IF cCadena IS NOT NULL AND cCadena != ' ' THEN
                        cFolioFactElec := TRIM(SUBSTR(cCadena,1,INSTR(cCadena,'|',1)-1));
                        cLogFactElec   := SUBSTR(cCadena,INSTR(cCadena,'|',1,1)+1, LENGTH(cCadena) - INSTR(cCadena,'|',1,1));
                        
                        IF INSTR(UPPER(cNomArch),'FA',1) != 0 THEN
                           BEGIN
                              UPDATE FACTURAS
                                 SET LogProcesoFactElec = cLogFactElec
                               WHERE FolioFactElec  = cFolioFactElec;
                           END;
                        ELSE
                           BEGIN
                              UPDATE NOTAS_DE_CREDITO
                                 SET LogProcesoFactElec = cLogFactElec
                               WHERE FolioFactElec  = cFolioFactElec;
                           END;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        EXIT;
                     WHEN OTHERS THEN
                        EXIT;
                  END;
               END LOOP;
               UTL_FILE.FCLOSE (ArchivoLog);
               IF DBMS_LOB.FILEEXISTS(BFILENAME('OUTANUFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('OUTANUFE',cNomArch);
               END IF;
               UTL_FILE.FCOPY  ('LOGANUFE',cNomArch, 'OUTANUFE',cNomArch);
               IF DBMS_LOB.FILEEXISTS(BFILENAME('LOGANUFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('LOGANUFE',cNomArch);
               END IF;
            ELSIF INSTR(UPPER(cNomArch),'ERROR',1) != 0 THEN
               ArchivoLog  := UTL_FILE.FOPEN('LOGANUFE',cNomArch,'R');
               LOOP
                  BEGIN
                     UTL_FILE.GET_LINE(ArchivoLog, cCadena);
                     IF cCadena IS NOT NULL AND cCadena != ' ' THEN
                        cFolioFactElec := TRIM(SUBSTR(cCadena,1,INSTR(cCadena,'|',1)-1));
                        cLogFactElec   := SUBSTR(cCadena,INSTR(cCadena,'|',1,1)+1, LENGTH(cCadena) - INSTR(cCadena,'|',1,1));

                        IF INSTR(UPPER(cNomArch),'FA',1) != 0 THEN
                           BEGIN
                              UPDATE FACTURAS
                                 SET LogProcesoFactElec   = cLogFactElec,
                                     FecEnvFactElecAnu    = NULL,
                                     CodUsuarioEnvFactAnu = NULL
                               WHERE FolioFactElec  = cFolioFactElec;
                           END;
                        ELSE
                           BEGIN
                              UPDATE NOTAS_DE_CREDITO
                                 SET LogProcesoFactElec   = cLogFactElec,
                                     FecEnvFactElecAnu    = NULL,
                                     CodUsuarioEnvFactAnu = NULL
                               WHERE FolioFactElec  = cFolioFactElec;
                           END;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        EXIT;
                     WHEN OTHERS THEN
                        EXIT;
                  END;
               END LOOP;
               UTL_FILE.FCLOSE (ArchivoLog);
               IF DBMS_LOB.FILEEXISTS(BFILENAME('OUTANUFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('OUTANUFE',cNomArch);
               END IF;
               UTL_FILE.FCOPY  ('LOGANUFE',cNomArch, 'OUTANUFE',cNomArch);
               UTL_FILE.FREMOVE('LOGANUFE',cNomArch);
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            EXIT;
      END;
   END LOOP;
   UTL_FILE.FCLOSE(Archivo);
   COMMIT;
END ANUL_FACTURAS_ELECTRONICAS;
