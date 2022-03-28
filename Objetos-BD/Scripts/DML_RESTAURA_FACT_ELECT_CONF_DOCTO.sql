select * from FACT_ELECT_CONF_DOCTO 
WHERE Proceso = 'EMI' 
  and CODIDENTIFICADOR IN ('CRELS', 'CREL')


/*RESTABLECE VALORES cancelacion TIMBRE 01 */
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='N', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='S'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = (SELECT 'EMI', 'CRELS', '3' FROM DUAL)
/  
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='S', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='N'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = (SELECT 'EMI', 'CREL', '4' FROM DUAL)
/

commit;


/*RESTABLECE VALORES ORIGINALES */
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='S', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='N'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = (SELECT 'EMI', 'CRELS', '3' FROM DUAL)
/  
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='S', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='S'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = (SELECT 'EMI', 'CREL', '4' FROM DUAL)
/
commit;
