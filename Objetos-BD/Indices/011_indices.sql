    create index SICAS_OC.IX_CHECK1 on SICAS_OC.PERSONA_NATURAL_JURIDICA(REPLACE(TRANSLATE(UPPER(NOMBRE),'�����','AEIOU'),' ',''),REPLACE(TRANSLATE(UPPER(APELLIDO_PATERNO),'�����','AEIOU'),' ',''),REPLACE(TRANSLATE(UPPER(APELLIDO_MATERNO),'�����','AEIOU'),' ',''));

    create index SICAS_OC.IX_CHECK2 on SICAS_OC.ASEGURADO(TIPO_DOC_IDENTIFICACION,NUM_DOC_IDENTIFICACION);
