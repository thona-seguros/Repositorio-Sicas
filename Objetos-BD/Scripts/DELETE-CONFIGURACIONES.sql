REM DELETE Configuraciones
SET DEFINE OFF;
DELETE SICAS_OC.ENTREGAS_CNSF_PLANTILLA;
DELETE SICAS_OC.CONFIG_PLANTILLAS_CAMPOS WHERE CODCIA = 1 AND CODEMPRESA = 1 AND CODPLANTILLA LIKE '%SESA%';
DELETE SICAS_OC.CONFIG_PLANTILLAS_TABLAS WHERE CODCIA = 1 AND CODEMPRESA = 1 AND CODPLANTILLA LIKE '%SESA%';
DELETE SICAS_OC.CONFIG_PLANTILLAS WHERE CODCIA = 1 AND CODEMPRESA = 1 AND CODPLANTILLA LIKE '%SESA%';
DELETE SICAS_OC.ENTREGAS_CNSF_CONFIG;
DELETE SICAS_OC.VALORES_DE_LISTAS WHERE CODLISTA IN ('SEDATAPC','SEEMIAPC','SESINAPC',
                                                     'SEDATAPI','SEEMIAPI','SESINAPI',
                                                     'SEDATGMC','SEEMIGMC','SESINGMC',
                                                     'SEDATGMI','SEEMIGMI','SESINGMI',
                                                     'SEDATVIG','SEEMIVIG','SESINVIG',
                                                     'SEDATVII','SEEMIVII','SESINVII',
                                                     'SEEMIGMI','SESINGM','SEEMIVGF',
                                                     'SEEQUCAM');
DELETE SICAS_OC.TIPO_DE_LISTA WHERE CODLISTA IN ('SEDATAPC','SEEMIAPC','SESINAPC',
                                                 'SEDATAPI','SEEMIAPI','SESINAPI',
                                                 'SEDATGMC','SEEMIGMC','SESINGMC',
                                                 'SEDATGMI','SEEMIGMI','SESINGMI',
                                                 'SEDATVIG','SEEMIVIG','SESINVIG',
                                                 'SEDATVII','SEEMIVII','SESINVII',
                                                 'SEEMIGMI','SESINGM','SEEMIVGF',
                                                 'SEEQUCAM');


COMMIT;
