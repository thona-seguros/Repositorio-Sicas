CREATE INDEX SICAS_OC.IDX_EAD_CTRL_ASEG_FECINIV ON SICAS_OC.EAD_CONTROL_ASEGURADOS
(FECINIVIG)
LOGGING
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;
/
CREATE PUBLIC SYNONYM SPLIT_TBL FOR SICAS_OC.SPLIT_TBL;
/
GRANT EXECUTE ON SICAS_OC.SPLIT_TBL TO "PUBLIC";
/
Insert into APLICACIONES (CODAPLICA, DESCAPLICA, TIPOAPLIC) values ('MANTDECL','Reporte hist�rico de declaraciones','F');
/
commit;
/