PROCEDURE FACTURAS_ELECTRONICAS IS
cCadena         VARCHAR2(32767);
cNomArch        VARCHAR2(32767);
Archivo         UTL_FILE.FILE_TYPE;
ArchivoLog      UTL_FILE.FILE_TYPE;
cFolioFactElec  FACTURAS.FolioFactElec%TYPE;
nIdFacturaNcr   FACTURAS.IdFactura%TYPE;
cLogFactElec    FACTURAS.LogProcesoFactElec%TYPE;
cExiste         VARCHAR2(1);
BEGIN
   Archivo := UTL_FILE.FOPEN('LOGEMIFE','Procesados.TXT','R'); 
   LOOP
      BEGIN
         UTL_FILE.GET_LINE(Archivo, cNomArch);
         IF DBMS_LOB.FILEEXISTS(BFILENAME('LOGEMIFE', cNomArch)) = 1 THEN
            IF INSTR(UPPER(cNomArch),'OK',1) != 0 THEN
               ArchivoLog  := UTL_FILE.FOPEN('LOGEMIFE',cNomArch,'R');
               LOOP
                  BEGIN
                     UTL_FILE.GET_LINE(ArchivoLog, cCadena);
                     IF cCadena IS NOT NULL AND cCadena != ' ' THEN
                        nIdFacturaNcr  := TO_NUMBER(TRIM(SUBSTR(cCadena,1,INSTR(cCadena,'|',1)-1)));
                        cFolioFactElec := SUBSTR(cCadena,INSTR(cCadena,'|',1,3)+1, INSTR(cCadena,'|',1,4)-1 - INSTR(cCadena,'|',1,3));
                        cLogFactElec   := SUBSTR(cCadena,INSTR(cCadena,'|',1,4)+1, 4000);
                        IF INSTR(UPPER(cNomArch),'FA',1) != 0 THEN
                           BEGIN
                              UPDATE FACTURAS
                                 SET FolioFactElec      = cFolioFactElec,
                                     LogProcesoFactElec = cLogFactElec
                               WHERE IdFactura = nIdFacturaNcr;
                           END;
                        ELSE
                           BEGIN
                              UPDATE NOTAS_DE_CREDITO
                                 SET FolioFactElec      = cFolioFactElec,
                                     LogProcesoFactElec = cLogFactElec
                               WHERE IdNcr     = nIdFacturaNcr;
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
               IF DBMS_LOB.FILEEXISTS(BFILENAME('OUTEMIFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('OUTEMIFE',cNomArch);
               END IF;
               UTL_FILE.FCOPY  ('LOGEMIFE',cNomArch, 'OUTEMIFE',cNomArch);
               IF DBMS_LOB.FILEEXISTS(BFILENAME('LOGEMIFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('LOGEMIFE',cNomArch);
               END IF;
            ELSIF INSTR(UPPER(cNomArch),'ERROR',1) != 0 THEN
               ArchivoLog  := UTL_FILE.FOPEN('LOGEMIFE',cNomArch,'R');
               LOOP
                  BEGIN
                     UTL_FILE.GET_LINE(ArchivoLog, cCadena);
                     IF cCadena IS NOT NULL AND cCadena != ' ' THEN
                        nIdFacturaNcr  := TO_NUMBER(TRIM(SUBSTR(cCadena,1,INSTR(cCadena,'|',1)-1)));
                        cLogFactElec   := SUBSTR(cCadena,INSTR(cCadena,'|',1,4)+1, 4000);

                        IF INSTR(UPPER(cNomArch),'FA',1) != 0 THEN
                           BEGIN
                              UPDATE FACTURAS
                                 SET LogProcesoFactElec = cLogFactElec,
                                     FecEnvFactElec     = NULL,
                                     CodUsuarioEnvFact  = NULL
                               WHERE IdFactura = nIdFacturaNcr;
                           END;
                        ELSE
                           BEGIN
                              UPDATE NOTAS_DE_CREDITO
                                 SET LogProcesoFactElec = cLogFactElec,
                                     FecEnvFactElec     = NULL,
                                     CodUsuarioEnvFact  = NULL
                               WHERE IdNcr          = nIdFacturaNcr;
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
               IF DBMS_LOB.FILEEXISTS(BFILENAME('OUTEMIFE', cNomArch)) = 1 THEN
                  UTL_FILE.FREMOVE('OUTEMIFE',cNomArch);
               END IF;
               UTL_FILE.FCOPY  ('LOGEMIFE',cNomArch, 'OUTEMIFE',cNomArch);
               UTL_FILE.FREMOVE('LOGEMIFE',cNomArch);
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            EXIT;
      END;
   END LOOP;
   UTL_FILE.FCLOSE(Archivo);
   COMMIT;
END FACTURAS_ELECTRONICAS;
