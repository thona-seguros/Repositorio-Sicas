CREATE INDEX COMPROBANTES_DETALLE_IDX ON COMPROBANTES_DETALLE
(CODCIA, NUMCOMPROB)
LOGGING
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL
/