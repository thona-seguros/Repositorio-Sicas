---------------------------------------------------------------
--  Actualización de la columna historial_siniestros         --
--  para siniestros con estado relevante (EMI, PGP, PGT),    --
--  registrados en los últimos 5 años.                       --
--                                                           --
--  La columna historial_siniestros almacena una lista       --
--  de IDs de siniestros anteriores del mismo asegurado      --
--  y póliza, concatenados en orden ascendente.              --
---------------------------------------------------------------

UPDATE siniestro s
SET historial_siniestros = (
    SELECT LISTAGG(TO_CHAR(s2.idsiniestro), ',') 
           WITHIN GROUP (ORDER BY s2.idsiniestro)
    FROM siniestro s2
    WHERE s2.idpoliza = s.idpoliza
      AND s2.cod_asegurado = s.cod_asegurado
      AND s2.sts_siniestro IN ('EMI', 'PGP', 'PGT')
      AND s2.idsiniestro < s.idsiniestro
      AND s2.fecregistro >= ADD_MONTHS(SYSDATE, -60)
)
WHERE s.sts_siniestro IN ('EMI', 'PGP', 'PGT')
  AND s.fecregistro >= ADD_MONTHS(SYSDATE, -60);

COMMIT;
