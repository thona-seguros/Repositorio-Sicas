REM INSERTING into ENTREGAS_CNSF_CONFIG
SET DEFINE OFF;

         
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATAPC','SESAS DE DATOS GENERALES PARA ACCIDENTES PERSONALES COLECTIVO' ,'SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA ACCIDENTES PERSONALES COLECTIVO' ,'PROC','OC_SESASCOLECTIVO.DATGEN_AP'     ,'SESASDATGENAPC.TXT'       ,'SESADATAPC','SEDATAPC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIAPC','SESAS DE EMISION PARA ACCIDENTES PERSONALES COLECTIVOS'        ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA ACCIDENTES PERSONALES COLECTIVOS'        ,'PROC','OC_SESASCOLECTIVO.EMISION_AP'    ,'SESASEMISIONAPC.TXT'      ,'SESAEMIAPC','SEEMIAPC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINAPC','SESAS DE SINIESTROS PARA ACCIDENTES PERSONALES COLECTIVOS'     ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA ACCIDENTES PERSONALES COLECTIVOS'     ,'PROC','OC_SESASCOLECTIVO.SINIESTROS_AP' ,'SESASSINIESTROSAPC.TXT'   ,'SESASINAPC','SESINAPC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATAPI','SESAS DE DATOS GENERALES PARA ACCIDENTES PERSONALES INDIVIDUAL','SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA ACCIDENTES PERSONALES INDIVIDUAL','PROC','OC_SESASINDIVIDUAL.DATGEN_AP'    ,'SESASDATGENAPI.TXT'       ,'SESADATAPI','SEDATAPI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIAPI','SESAS DE EMISION PARA ACCIDENTES PERSONALES INDIVIDUAL'        ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('28/01/13','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA ACCIDENTES PERSONALES INDIVIDUAL'        ,'PROC','OC_SESASINDIVIDUAL.EMISION_AP'   ,'SESASEMISIONAPI.TXT'      ,'SESAEMIAPI','SEEMIAPI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINAPI','SESAS DE SINIESTROS PARA ACCIDENTES PERSONALES INDIVIDUAL'     ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('28/01/13','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA ACCIDENTES PERSONALES INDIVIDUAL'     ,'PROC','OC_SESASINDIVIDUAL.SINIESTROS_AP','SESASSINIESTROSAPI.TXT'   ,'SESASINAPI','SESINAPI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATGMC','SESAS DE DATOS GENERALES PARA GASTOS MEDICOS COLECTIVO'        ,'SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA GASTOS MEDICOS COLECTIVO'        ,'PROC','OC_SESASCOLECTIVO.DATGEN_GM'     ,'SESASDATGENGMC.TXT'       ,'SESADATGMC','SEDATGMC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIGMC','SESAS DE EMISION PARA GASTOS MEDICOS COLECTIVO'                ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA GASTOS MEDICOS COLECTIVO'                ,'PROC','OC_SESASCOLECTIVO.EMISION_GM'    ,'SESASEMISIONGMC.TXT'      ,'SESAEMIGMC','SEEMIGMC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINGMC','SESAS DE SINIESTROS PARA GASTOS MEDICOS COLECTIVO'             ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA GASTOS MEDICOS COLECTIVO'             ,'PROC','OC_SESASCOLECTIVO.SINIESTROS_GM' ,'SESASSINIESTROSGMC.TXT'   ,'SESASINGMC','SESINGMC','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATGMI','SESAS DE DATOS GENERALES PARA GASTOS MEDICOS INDIVIDUAL'       ,'SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA GASTOS MEDICOS INDIVIDUAL'       ,'PROC','OC_SESASINDIVIDUAL.DATGEN_GM'    ,'SESASDATGENGMI.TXT'       ,'SESADATGMI','SEDATGMI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIGMI','SESAS DE EMISION PARA GASTOS MEDICOS INDIVIDUAL'               ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('28/01/13','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA GASTOS MEDICOS INDIVIDUAL'               ,'PROC','OC_SESASINDIVIDUAL.EMISION_GM'   ,'SESASEMISIONGMI.TXT'      ,'SESAEMIGMI','SEEMIGMI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINGMI','SESAS DE SINIESTROS PARA GASTOS MEDICOS INDIVIDUAL'            ,'SESAS','VI','CIE',to_date('31/01/13','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('28/01/13','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA GASTOS MEDICOS INDIVIDUAL'            ,'PROC','OC_SESASINDIVIDUAL.SINIESTROS_GM','SESASSINIESTROSGMI.TXT'   ,'SESASINGMI','SESINGMI','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATVIG','SESAS DE DATOS GENERALES PARA VIDA GRUPO'                      ,'SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA VIDA GRUPO'                      ,'PROC','OC_SESASCOLECTIVO.DATGEN_VI'     ,'SESASDATGENVIG.TXT'       ,'SESADATVIG','SEDATVIG','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIVIG','SESAS DE EMISION PARA VIDA GRUPO'                              ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA VIDA GRUPO'                              ,'PROC','OC_SESASCOLECTIVO.EMISION_VI'    ,'SESASEMISIONVIG.TXT'      ,'SESAEMIVIG','SEEMIVIG','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINVIG','SESAS DE SINIESTROS PARA VIDA GRUPO'                           ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA VIDA GRUPO'                           ,'PROC','OC_SESASCOLECTIVO.SINIESTROS_VI' ,'SESASSINIESTROSVIG.TXT'   ,'SESASINVIG','SESINVIG','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESADATVII','SESAS DE DATOS GENERALES PARA VIDA INDIVIDUAL'                 ,'SESAS','VI','CIE',to_date('08/07/21','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('08/07/21','DD/MM/RR'),'GENERACION DE SESAS DE DATOS GENERALES PARA VIDA INDIVIDUAL'                 ,'PROC','OC_SESASINDIVIDUAL.DATGEN_VI'    ,'SESASDATGENVII.TXT'       ,'SESADATVII','SEDATVII','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIVII','SESAS DE EMISION PARA VIDA INDIVIDUAL'                         ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE EMISION PARA VIDA INDIVIDUAL'                         ,'PROC','OC_SESASINDIVIDUAL.EMISION_VI'   ,'SESASEMISIONVII.TXT'      ,'SESAEMIVII','SEEMIVII','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESASINVII','SESAS DE SINIESTROS PARA VIDA INDIVIDUAL'                      ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE SINIESTROS PARA VIDA INDIVIDUAL'                      ,'PROC','OC_SESASINDIVIDUAL.SINIESTROS_VI','SESASSINIESTROSVII.TXT'   ,'SESASINVII','SESINVII','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));
--
Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAEMIVG-FONACOT','SESAS DE EMISION PARA VIDA GRUPO INFONACOT'             ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE EMISION VIDA GRUPO INFONACOT'                         ,'PROC','SESASEMISVG_INFONACOT'           ,'SESASEMISVG_INFONACOT.TXT','SESAEMIVGF','SEEMIVGF','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));

Insert into SICAS_OC.ENTREGAS_CNSF_CONFIG (CODCIA,CODEMPRESA,CODENTREGA,NOMENTREGA,TIPOENTREGA,AREAENTREGA,FRECENTREGA,FECLIMENTREGA,FECPRORROGA,TOTDIASENTREGA,FORMAENTREGA,STSENTREGA,FECSTS,DESCENTREGA,TIPOOBJETO,NOMREPPROC,NOMARCHIVO,CODPLANTILLA,CODLISTA,SEPARADOR,CODUSUARIO,FECULTCAMBIO) values (1,1,'SESAERROR','SESAS DE LOG DE ERRORES'             ,'SESAS','VI','CIE',to_date('17/05/14','DD/MM/RR'),null,31,'SEI','ACTIVA',to_date('17/05/14','DD/MM/RR'),'GENERACION DE SESAS DE LOG DE ERRORES'                         ,'PROC','  '           ,'SESASLOGERROR.TXT','SESAERROR','SESAERROR','|','SICAS_OC',to_date('08/07/21','DD/MM/RR'));


COMMIT;