--
-- CAMBIAASEGURADO  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   DETALLE_SINIESTRO_ASEG (Table)
--   APROBACION_ASEG (Table)
--   SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.CambiaAsegurado(vNumSini IN siniestro.idsiniestro%TYPE, 
                                            vSiniRef IN siniestro.numsiniref%TYPE, 
                                            vCodAseg IN siniestro.cod_asegurado%TYPE, 
                                            xCodAseg IN siniestro.cod_asegurado%TYPE) IS
      NoHaySiniestro EXCEPTION;
      xNumSini siniestro.idsiniestro%TYPE;
      x NUMBER(5) := 0;
BEGIN 
                x := 0;
                IF vNumSini > 0 THEN 
                   xNumSini := vNumSini;
                ELSE
                    BEGIN 
                          SELECT idsiniestro   
                            INTO xNumSini
                            FROM siniestro 
                           WHERE numsiniref = vSiniRef;
                    EXCEPTION 
                          WHEN no_data_found THEN 
                               RAISE NoHaySiniestro;
                          WHEN others THEN 
                               DBMS_OUTPUT.PUT_LINE('Buscando Siniestro: '||SQLERRM);           
                    END;
                 END IF;
                 DBMS_OUTPUT.PUT_LINE('El siniestro '||vSiniRef||' es: '||xNumSini);
                --idsiniestro = 26346
                UPDATE siniestro 
                   SET cod_asegurado = xCodAseg 
                 WHERE idsiniestro   = xNumSini;
                 
                 COMMIT;
           
                SELECT COUNT(*) 
                  INTO x 
                  FROM detalle_siniestro_aseg 
                 WHERE idsiniestro = xNumSini;
                --update detalle_siniestro_aseg SET cod_asegurado = 569392 where idsiniestro = 26346;
                INSERT INTO detalle_siniestro_aseg 
                SELECT idsiniestro            ,
                       idpoliza               ,
                       iddetsin               ,
                       xCodAseg               ,
                       monto_pagado_moneda    ,
                       monto_pagado_local     ,
                       monto_reservado_moneda ,
                       monto_reservado_local  ,
                       idtiposeg              
                  FROM detalle_siniestro_aseg 
                 WHERE idsiniestro   = xNumSini
                   AND cod_asegurado = vCodAseg; 
                COMMIT;

                  SELECT COUNT(*)
                    INTO x  
                    FROM cobertura_siniestro_aseg 
                   WHERE idsiniestro   = xNumSini
                     AND cod_asegurado = vCodAseg;
                   DBMS_OUTPUT.PUT_LINE('Cobertura_siniestro_aseg: '||x||' registros.') ;
                   IF x > 0 THEN 
                      UPDATE cobertura_siniestro_aseg  
                         SET cod_asegurado = xCodAseg
                       WHERE idsiniestro   = xNumSini
                         AND cod_asegurado = vCodAseg;
                       COMMIT;
                   END IF;

                  SELECT COUNT(*) 
                    INTO x 
                    FROM aprobacion_aseg 
                   WHERE idsiniestro   = vNumsini
                     AND cod_asegurado = vCodAseg;
                  DBMS_OUTPUT.PUT_LINE('Aprobacion_aseg: '||x||' registros.');
                  IF x > 0 THEN 
                      UPDATE aprobacion_aseg  
                         SET cod_asegurado = xCodAseg
                      WHERE idsiniestro    = xNumSini
                        AND cod_asegurado  = vCodAseg;
                      COMMIT;
                  END IF;
                  DBMS_OUTPUT.PUT_LINE('Elimino el detalle_siniestro_aseg...');
                  BEGIN 
                      DELETE FROM detalle_siniestro_aseg 
                       WHERE idsiniestro   = xNumSini 
                         AND cod_asegurado =  vCodAseg;
                      COMMIT;
                  END;
EXCEPTION 
     WHEN NoHaySiniestro THEN 
          DBMS_OUTPUT.PUT_LINE('El siniestro solicitado: '''||vsiniRef||''' NO EXISTE');
     WHEN others THEN 
          DBMS_OUTPUT.PUT_LINE('others: '||SQLERRM);
END CambiaAsegurado;
/
