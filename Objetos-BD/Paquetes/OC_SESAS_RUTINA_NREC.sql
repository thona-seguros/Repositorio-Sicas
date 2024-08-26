create or replace PACKAGE SICAS_OC.OC_SESAS_RUTINA_NREC AS 
/*
Proyecto :    018-0723-O-SESA's -Rutina Número de Reclamación
Autor :       Marco Andrés Vazquez mora 
Creacion :    30/FEB/2024
Modificacion :
Descripcion : Calcula Numero de reclamación de reporte de SESAS.

*/
/* TODO enter package declarations (types, exceptions, methods etc) here */
PROCEDURE INSERTA_SINIESTROS(p_mCode OUT number,p_mMessage out varchar);
PROCEDURE MODIFICA_SINIESTROS(p_mCode OUT number,p_mMessage out varchar);
END OC_SESAS_RUTINA_NREC;

/

create or replace PACKAGE BODY             SICAS_OC.OC_SESAS_RUTINA_NREC AS


 PROCEDURE INSERTA_SINIESTROS(p_mCode OUT number,p_mMessage out varchar) IS


 
        CURSOR SESAS_UNIFICADO IS
            SELECT
                ID_SESAS_SIN_APC
                ,CODCIA
                ,CODEMPRESA
                ,IDSINIESTRO
                ,MONTO
                ,RECL
                ,MAXIMO 
            FROM  SICAS_OC.SESAS_SIN_APC 
            ORDER BY IDSINIESTRO,COBERTURA,FEC_EST; 
       
       -- variables
       
          vl_proceso       varchar2(500);
          A                NUMBER := 0;  ----AQUI TENIA X COMO VARCHAR  PERO MI CAMPO DE ID SINIESTRO ES NUMBER.
          B                NUMBER := 1;
          nNumeroSec       NUMBER := 0;
          nSiniestroCtrl   NUMBER := 0;
          vl_maximo        SESAS_HISTORICO.NUM_REC%TYPE;
         
       


           
        --CURSOR PARA CALCULO DE R2 
         CURSOR CUR_CAL_R2 IS
              SELECT 
               ID_SESAS_SIN_APC
              ,CODCIA
              ,CODEMPRESA
              ,IDSINIESTRO
              ,FEC_EST
              ,FEC_OCU
              ,MONTO
              ,RECL
              ,R2
              FROM SICAS_OC.SESAS_SIN_APC  
              WHERE  TO_CHAR(FEC_OCU,'YYYY') = TO_CHAR(FEC_EST,'YYYY')
              ORDER BY IDSINIESTRO, FEC_EST DESC ;    ---  ,62294 ESTE ID EXISTE SOLO EN HISTORICO  LE TIENE QUE HACER  EN LA SEGUNDA VUELTA .EJEMPLOS SINIESTRO 315181, 356398 ESTE ID  NO ENTRA EN FECHAS  DE OCU  Y FECHA REP  IGUALES  ,357452 ESTE ID ES EL QUE NO TIENE MAXIMO Y SE VA CON 123,356573 ESTE MONTO SE  SUMAN Y SACA MONTO DIFERENTE POR EL CRUCE
            v_b           NUMBER := 0;
            v_c           NUMBER := 0;
            v_a           NUMBER := 0;
            VL_R2         NUMBER := 0;
            v_n           SESAS_SIN_APC.IDSINIESTRO%TYPE;
         
         ---CURSOR  R2 FECHA MENOR     
          CURSOR cur_R2_menor_fecha IS
                 SELECT 
           ID_SESAS_SIN_APC
              ,IDSINIESTRO
              ,CODCIA
              ,CODEMPRESA
              ,FEC_EST
              ,FEC_OCU
              ,MONTO
              ,MAXIMO
              ,RECL
              ,R2
          FROM SICAS_OC.SESAS_SIN_APC_FECM
         -- to_char(FEC_OCU,'YYYY') < to_char(FEC_EST,'YYYY')--WHERE IDSINIESTRO IN (351137 ,339508,318403,354468,356398)--WHERE IDSINIESTRO =  318403
          ORDER BY IDSINIESTRO,FEC_EST DESC;
            v_b1           NUMBER := 0;
            v_c1           NUMBER := 0;
            v_a1           NUMBER := 0;
            VL_R21         NUMBER := 0;
            v_n1           SESAS_SIN_APC_FECM.IDSINIESTRO%TYPE;
          
            
           ---VARIABLES PARA PROCEDIMIENTO NREC_OK 
            CURSOR cur_NREC_menor_fecha IS
   
           SELECT 
           ID_SESAS_SIN_APC
              ,IDSINIESTRO
              ,CODCIA
              ,CODEMPRESA
              ,FEC_EST
              ,FEC_OCU
              ,MONTO
              ,MAXIMO
              ,RECL
              ,R2
          FROM SICAS_OC.SESAS_SIN_APC_FECM
          --to_char(FEC_OCU,'YYYY') < to_char(FEC_EST,'YYYY')--WHERE IDSINIESTRO IN (351137 ,339508,318403,354468,356398)--WHERE IDSINIESTRO =  318403
          ORDER BY IDSINIESTRO,FEC_EST ASC;

            vl_a           NUMBER := 1;
            vl_b           NUMBER := 0;
            vl_c           NUMBER := 0;
            nNumeroRec     NUMBER := 0;
            Nrec           NUMBER := 0;
            vl_monto     NUMBER := 0;
            vl_maximo1   NUMBER := 0;
            ---SEGUNDAS VARIABLES NREC_OK
            
            vl_a1           NUMBER := 1;
            vl_b1           NUMBER := 0;
            vl_c1           NUMBER := 0;
            nNumeroRec1     NUMBER := 0;
            Nrec1           NUMBER := 0;

            ---cursor insert historico
                CURSOR InsertHistorico_fecm IS
                    SELECT 
                     A.NPOLIZA
                                        ,A.IDSINIESTRO
                                        ,A.FEC_OCU
                                        ,A.FEC_EST
                                        ,A.MONTO
                                        ,TO_NUMBER(TO_CHAR(B1.FEC_EST,'YYYY'))
                                        ,B1.NREC_OK
                                        ,A.RECL
                                        ,A.IDPOLIZA
                                        ,A.COBERTURA
                        FROM SICAS_OC.SESAS_SIN_APC A
                        ,SICAS_OC.SESAS_SIN_APC_FECM B1
                        WHERE 1 = 1
                       -- AND A.IDSINIESTRO = 351137
                        AND A.CODCIA = B1.CODCIA
                        AND A.CODEMPRESA = B1.CODEMPRESA
                        AND A.IDSINIESTRO = B1.IDSINIESTRO
                         AND A.FEC_EST = B1.FEC_EST
                        AND A.FEC_OCU = B1.FEC_OCU
                        AND A.ID_SESAS_SIN_APC = B1.ID_SESAS_SIN_APC
                        AND NOT EXISTS (SELECT SH.ID_SESAS_HIST

                    FROM SICAS_OC.SESAS_HISTORICO SH
                        WHERE 1 = 1
                        AND SH.IDSINIESTRO = B1.IDSINIESTRO--351137
                        AND SH.CODCIA = B1.CODCIA
                        AND SH.CODEMPRESA = B1.CODEMPRESA
                        AND SH.MONTO = B1.MONTO
                         AND SH.FECREP = B1.FEC_EST
                        AND SH.FECOCU = B1.FEC_OCU
                        --AND SH.ID_SESAS_HIST = A.ID_SESAS_SIN_APC
                    );
                           
BEGIN 
     
           vl_proceso :=  'insercion tabla SICAS_OC.SESAS_SINIESTROS_ATECNICA';
           
           INSERT INTO SICAS_OC.SESAS_SINIESTROS_ATECNICA
                      (
                      CODCIA
                      ,CODEMPRESA
                      ,LLAVE
                      ,CUENTA
                      ,SUBRAMO
                      ,IDPOLIZA
                      ,NPOLIZA
                      ,IDSINIESTRO
                      ,CVCOB
                      ,TIPOADIC
                      ,ADOMES
                      ,FEC_BZA
                      ,NUM_ASIST
                      ,INIVIGPOL
                      ,FINVIGPOL
                      ,FEC_EST
                      ,FEC_OCU
                      ,FEC_REP
                      ,FEC_NAC
                      ,CVESTIMADO
                      ,DESC_CIE10
                      ,NOM_ASEG
                      ,CAUSA
                      ,TIPOSEGURO
                      ,MONTO
                      ,ND_5401_05
                      ,SISTEMA
                      ,RAMSUBRAMO
                      ,RAMO
                      ,CTA_5411
                      ,CTA_5411_2
                      ,MES_STATUS
                      ,N_CONTRATO
                      ,REASEG
                      ,MONTO_AP
                      ,VIGENCIA
                      ,CONTRATANT
                      ,VAL1
                      ,VAL2
                      ,C_5401_03
                    )
                    SELECT 
                      1
                      ,1
                      ,LLAVE
                      ,CUENTA
                      ,SUBRAMO
                      ,CONSECUTIVO
                      ,NPOLIZA
                      ,SINIESTRO
                      ,CVCOB
                      ,TIPOADIC
                      ,ADOMES
                      ,FEC_BZA
                      ,NUM_ASIST
                      ,INIVIGPOL
                      ,FINVIGPOL
                      ,FEC_EST
                      ,FEC_OCU
                      ,FEC_REP
                      ,FEC_NAC
                      ,CVESTIMADO
                      ,DESC_CIE10
                      ,NOM_ASEG
                      ,CAUSA
                      ,TIPOSEGURO
                      ,MONTO
                      ,ND_5401_05
                      ,SISTEMA
                      ,RAMSUBRAMO
                      ,RAMO
                      ,CTA_5411
                      ,CTA_5411_2
                      ,MES_STATUS
                      ,N_CONTRATO
                      ,REASEG
                      ,MONTO_AP
                      ,VIGENCIA
                      ,CONTRATANT
                      ,VAL1
                      ,VAL2
                      ,C_5401_03
                      
                      
                      FROM SICAS_OC.SESAS_SIN_ATECNICA_EXT;
           
           
           vl_proceso :=  'insercion tabla SICAS_OC.SESAS_SIN_APC';
           INSERT INTO SICAS_OC.SESAS_SIN_APC(
                 NPOLIZA 
                ,IDPOLIZA 
                ,IDSINIESTRO 
                ,FEC_OCU
                ,FEC_EST
                ,MONTO
                ,COBERTURA
                ,MAXIMO
                ,RECL
                ,R2
                ,NREC_OK
               )
           SELECT 
              --ID_SESAS_SINIESTRO AS CONSECUTIVO  se mandaba al insert para validar pk
               NPOLIZA
              ,IDPOLIZA
              ,IDSINIESTRO AS SINIESTRO
              ,FEC_OCU AS FECHA_OCURRENCIA
              ,FEC_EST AS FECHA_REPORTE
              ,ROUND(SUM(MONTO + ND_5401_05),2) AS MONTO
              ,CVCOB
              ,00 AS MAXIMO
              ,00 AS RECL
              --,00 AS CON_SES
              ,00 AS R2
              ,00 AS NREC_OK
              
            --  ,NVL((SELECT MAX(NUM_REC) FROM SESAS_HISTORICO WHERE A.IDSINIESTRO = IDSINIESTRO  ),0)MAXIMO
           FROM SICAS_OC.SESAS_SINIESTROS_ATECNICA 
           WHERE SUBSTR(ramsubramo,1,2) IN('32','22','36','34') --AND  to_char(FEC_OCU,'YYYY') = to_char(FEC_EST,'YYYY')  
                   HAVING ROUND(SUM(MONTO + ND_5401_05),2) != 0
           GROUP BY 
               
               NPOLIZA
              ,IDPOLIZA
              ,IDSINIESTRO
              ,FEC_OCU
              ,FEC_EST
              ,CVCOB
              ,00
              ,00
              ,00
              ,00;
               
              COMMIT;
              
            
            
              
           -- EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
              --ROLLBACK;
          --DBMS_OUTPUT.PUT_LINE('Error al insertar Registros'||SQLERRM);
             -- raise_application_error(-20111,'Error al insertar Registros : '|| SQLERRM);
      --END;
          
     -- BEGIN 
            vl_proceso := 'Se abre el primer cursor  UPDATE CAMPO MAXIMO ';
           FOR I IN SESAS_UNIFICADO LOOP
                  
                    SELECT NVL(MAX(NUM_REC),0)
                    INTO vl_maximo
                    FROM SICAS_OC.SESAS_HISTORICO
                    WHERE IDSINIESTRO = I.IDSINIESTRO;
                    
                    UPDATE SICAS_OC.SESAS_SIN_APC
                    SET MAXIMO = vl_maximo
                    ,LAST_UPDATE_BY = USER
                    ,LAST_UPDATE_DATE = SYSDATE
                    WHERE IDSINIESTRO = I.IDSINIESTRO; -- CURRENT OF MI_CURSOR;
                    
                    --update  de sesas_sin_apc_fecm
       
                
           END LOOP;
                     COMMIT;
                     
      
         ---SE ABRE CURSOR LLENADO CAMPO RECL CONSECUTIVO
               vl_proceso :=  'Se abre segundo cursor UPDATE CAMPO RECL Consecutivo ';
                  FOR J IN SESAS_UNIFICADO LOOP
                          IF J.IDSINIESTRO = A THEN
           J.RECL := 1 + B;
        ELSE
            J.RECL := J.MAXIMO + 1;
        END IF;
                       
             -- Actualizamos el registro
                    UPDATE SICAS_OC.SESAS_SIN_APC
                    SET    RECL = J.RECL
                          ,LAST_UPDATE_BY = USER
                          ,LAST_UPDATE_DATE = SYSDATE
                    WHERE IDSINIESTRO = J.IDSINIESTRO 
                        AND ID_SESAS_SIN_APC = J.ID_SESAS_SIN_APC
                        AND CODCIA = J.CODCIA 
                        AND CODEMPRESA = J.CODEMPRESA;--WHERE CURRENT OF MI_CURSOR;
                        
                        A := J.IDSINIESTRO;
                    B := J.RECL;
                END LOOP;
            COMMIT;
            
             vl_proceso :=  'insercion tabla SICAS_OC.SESAS_SIN_APC_FECM'; 
             
           INSERT INTO SICAS_OC.SESAS_SIN_APC_FECM(
                 
                ID_SESAS_SIN_APC
                 ,CODCIA
             ,CODEMPRESA
                ,IDSINIESTRO 
               ,FEC_OCU
                ,FEC_EST
                 ,MONTO
                ,MAXIMO
                ,RECL
                )
          SELECT 
              ID_SESAS_SIN_APC 
             ,CODCIA
             ,CODEMPRESA
              ,IDSINIESTRO
               ,FEC_OCU
              ,FEC_EST FECHA
                ,MONTO
              ,MAXIMO
              ,RECL
              
          FROM SICAS_OC.SESAS_SIN_APC
          WHERE    TO_NUMBER(to_char(FEC_OCU,'YYYY')) < TO_NUMBER(to_char(FEC_EST,'YYYY'))
            UNION 
          SELECT
               ID_SESAS_HIST
             ,CODCIA
             ,CODEMPRESA
              ,IDSINIESTRO
                ,FECOCU
              ,FECREP FECHA
           
              ,MONTO
              ,00 AS MAXIMO
              ,NUM_REC AS RECL
            
          FROM SICAS_OC.SESAS_HISTORICO  ;  --order by IDSINIESTRO, FECHA DESC 
     COMMIT;
     
 
    
    ---SE ABRE CURSOR LLENADO CAMPO R2 DONDE FECHA OCURRENCIA SEA IGUAL A LA FECHA DE REPORTE
             vl_proceso :=  'Se abre tercer cursor UPDATE CAMPO R2 ';
             
                  FOR rec IN CUR_CAL_R2 LOOP 
                       v_n := rec.IDSINIESTRO;
                          --v_b := 0;

                       IF v_b > 0 AND v_b >= 0 THEN
                           VL_R2 := rec.RECL;
                           v_c := VL_R2-1;
                          
                      ELSE 
                            IF v_b + v_b > 0 THEN
                                VL_R2 := v_a;
                                v_a := 0;
                                v_b := 0;
                                v_c := VL_R2 - 1;
                             
                            ELSE
                                VL_R2 := CASE WHEN v_a = 0 AND v_c = 0 THEN rec.RECL ELSE GREATEST(v_a, v_c) END;    
                                v_b := rec.MONTO + rec.MONTO;
                                v_a := rec.R2 ;
                                v_c := 0;
                                
                            END IF;
                     END IF;
                                 v_a := CASE WHEN  v_n = rec.IDSINIESTRO THEN VL_R2 ELSE 0 END;
                               v_b := CASE WHEN v_n = rec.IDSINIESTRO  THEN rec.MONTO ELSE 0 END;
                               v_c := CASE WHEN v_n = rec.IDSINIESTRO  THEN VL_R2 - 1 ELSE 0 END;
                               
                                UPDATE SICAS_OC.SESAS_SIN_APC 
                                SET R2 = VL_R2
                                 ,LAST_UPDATE_BY = USER
                                  ,LAST_UPDATE_DATE = SYSDATE
                                  
                                WHERE IDSINIESTRO = rec.IDSINIESTRO 
                                AND ID_SESAS_SIN_APC = rec.ID_SESAS_SIN_APC
                                AND CODCIA = rec.CODCIA 
                                AND CODEMPRESA = rec.CODEMPRESA;
                                
                              
                            
                    END LOOP;
                     COMMIT;
                           
                  ---SE ABRE CURSOR LLENADO CAMPO R2 DONDE FECHA OCURRENCIA SEA MENOR A LA FECHA DE AÑO DE REPORTE 
                    vl_proceso := 'Se abre cuarto cursor UPDATE CAMPO R2 fecha menor al año ';
                     FOR rec2 IN cur_R2_menor_fecha LOOP
                        
                         
                           IF(v_n1 IS NULL)THEN

                                v_n1 := rec2.IDSINIESTRO;

                          ELSE

                                IF(rec2.IDSINIESTRO != v_n1)THEN

                                    v_a1 := 0;

                                    v_b1 := 0;

                                    v_c1 := 0;

                                    v_n1 := rec2.IDSINIESTRO;

                                END IF;

                          END IF;
                  
                           IF v_b1 > 0 AND v_b1 >= 0 THEN
                                 VL_R21 := rec2.RECL;
                                 v_c1 := VL_R21 -1;
                            
                              
                           ELSE 
                                IF v_b1 + v_b1 > 0 THEN
                                   VL_R21 := v_a1;
                                    v_a1 := 0;
                                    v_b1 := 0;
                                    v_c1 := VL_R21 - 1;
                                   
                                    
                                 ELSE
                                      VL_R21 := CASE WHEN v_a1 = 0 AND v_c1 = 0 THEN rec2.RECL ELSE GREATEST(v_a1, v_c1) END;    
                                      v_b1 := rec2.MONTO + rec2.MONTO;
                                     v_a1 := VL_R21;
                                      v_c1 := 0;
                              
                                    
                               END IF;
                          END IF;
                  ---SE DESCOMETA PARA VALIDAR ENTE 2 PROCESO
                         --v_a1 := CASE WHEN  v_n1 = rec2.IDSINIESTRO  THEN VL_R21 ELSE 0 END;
                        --v_b1 := CASE WHEN v_n1 = rec2.IDSINIESTRO   THEN rec2.MONTO ELSE 0 END;
                        -- v_c1 := CASE WHEN v_n1 = rec2.IDSINIESTRO  THEN VL_R21 -1 ELSE 0 END;
                         
                        -- DBMS_OUTPUT.PUT_LINE('%%%UPDATE %%%'||'SINIESTRO: '|| v_n1|| ' R2: '||VL_R21);
                         
                                UPDATE SICAS_OC.SESAS_SIN_APC_FECM
                                     SET R2 = VL_R21
                                    WHERE IDSINIESTRO = rec2.IDSINIESTRO 
                                     AND RECL = rec2.RECL
                                     AND CODCIA = rec2.CODCIA 
                                    AND CODEMPRESA = rec2.CODEMPRESA
                                    AND ID_SESAS_SIN_APC = rec2.ID_SESAS_SIN_APC;
                                   --AND MONTO = rec2.MONTO;
   
                  END LOOP;
                       
                    COMMIT;
               
                     
                  ---SE ABRE CURSOR LLENADO NREC_OK DONDE FECHA OCURRENCIA SEA IGUAL A LA FECHA DE REPORTE   
                 vl_proceso := 'Se abre quinto cursor UPDATE CAMPO NREC_OK';
                      FOR temp_rec IN (SELECT
                                           ID_SESAS_SIN_APC
                                          ,CODCIA
                                          ,CODEMPRESA
                                          ,IDSINIESTRO
                                          ,FEC_EST
                                          ,FEC_OCU
                                          ,MONTO
                                          ,RECL
                                          ,R2
                                       FROM SICAS_OC.SESAS_SIN_APC WHERE  to_char(FEC_OCU,'YYYY') = to_char(FEC_EST,'YYYY') ORDER BY IDSINIESTRO,FEC_EST, R2 ASC) 
                      LOOP
                              IF  vl_c1 != temp_rec.IDSINIESTRO THEN
                               vl_c1 := temp_rec.IDSINIESTRO;
                               vl_b1 := temp_rec.R2;
                               vl_a1 := 1;
                               Nrec1 :=1;
                                  
                        ELSE 

                              -- v_b := temp_rec.R2;
                            IF temp_rec.R2 = vl_a1 then
                                Nrec := vl_a1;
                                  
                            ELSE 
                                IF  temp_rec.R2 = vl_b1 then 
                                      Nrec1 := vl_a1;
                                      
                                ELSE 
                                      Nrec1 := vl_a1 + 1;
                                 END IF;
                
                            END IF;
                                      vl_a1 := Nrec1;
                                      vl_b1 := temp_rec.R2;
                                     -- v_c := temp_rec.IDSINIESTRO;
                           END IF;
                                  
                                    UPDATE SICAS_OC.SESAS_SIN_APC 
                                    SET NREC_OK = Nrec1 
                                     ,LAST_UPDATE_BY = USER
                                      ,LAST_UPDATE_DATE = SYSDATE
                                    WHERE IDSINIESTRO = temp_rec.IDSINIESTRO 
                                    AND ID_SESAS_SIN_APC = temp_rec.ID_SESAS_SIN_APC
                                   AND CODCIA = temp_rec.CODCIA 
                                    AND CODEMPRESA = temp_rec.CODEMPRESA;
                          
                      END LOOP;
                        COMMIT;
                        
                        ---SE ABRE CURSOR LLENADO NREC_OK DONDE FECHA OCURRENCIA SEA MENOR A LA FECHA DE AÑO DE REPORTE 
                            vl_proceso :=  'Se abre sexto cursor UPDATE CAMPO NREC_OK';
                              FOR temp_rec2 IN cur_NREC_menor_fecha LOOP
                              --DBMS_OUTPUT.PUT_LINE(temp_rec2.VL_R21);
                               
                           
                                Nrec := 0;
                                IF  vl_c != temp_rec2.IDSINIESTRO THEN
                                     vl_c := temp_rec2.IDSINIESTRO;
                                 
                                     --nNumeroSec := 0;
                                     vl_a := 1;
                                     vl_b := temp_rec2.R2;
                                     Nrec :=1;
                               
                               
                                ELSE 
                                     IF temp_rec2.R2 = vl_a then
                                              Nrec := vl_a;
                                     ELSE 
                                          IF  temp_rec2.R2 = vl_b then 
                                                Nrec := vl_a;
                                          ELSE 
                                                Nrec := vl_a + 1;
                                          END IF;
                                     END IF;
                                                vl_a := Nrec;
                                                 vl_b := temp_rec2.R2;
                                                  
                                END IF;
                                 UPDATE SICAS_OC.SESAS_SIN_APC_FECM 
                                        SET NREC_OK = Nrec
                                       WHERE IDSINIESTRO = temp_rec2.IDSINIESTRO
                                    AND RECL = temp_rec2.RECL
                                      AND CODCIA = temp_rec2.CODCIA 
                                    AND CODEMPRESA = temp_rec2.CODEMPRESA
                                   -- AND FEC_OCU = temp_rec2.FEC_OCU
                                    AND ID_SESAS_SIN_APC = temp_rec2.ID_SESAS_SIN_APC;
                
                               END LOOP;
                                  COMMIT;

                        vl_proceso :=  'Se abre septimo cursor insert historico fecha menor';

                        FOR K IN InsertHistorico_fecm LOOP

                                    BEGIN
                                        INSERT INTO SICAS_OC.SESAS_HISTORICO(
                                        NPOLIZA 
                                        ,IDSINIESTRO 
                                        ,FECOCU
                                        ,FECREP
                                        ,MONTO
                                        ,ANOREP
                                        ,NUM_REC
                                        ,ESTATUS
                                        ,RECL
                                        ,IDPOLIZA
                                        ,COBERTURA
                                        )
                                        VALUES
                                        (
                                        K.NPOLIZA
                                        ,K.IDSINIESTRO
                                        ,K.FEC_OCU
                                        ,K.FEC_EST
                                        ,K.MONTO
                                        ,TO_NUMBER(TO_CHAR(K.FEC_EST,'YYYY'))
                                        ,K.NREC_OK
                                        ,'INSERTADO'
                                        ,K.RECL
                                        ,K.IDPOLIZA
                                        ,K.COBERTURA
                                        );
                                    END;
                                    END LOOP;
                                    COMMIT;
  DELETE FROM SICAS_OC.SESAS_SIN_APC WHERE  TO_NUMBER(to_char(FEC_OCU,'YYYY')) < TO_NUMBER( to_char(FEC_EST,'YYYY'));
     COMMIT;
-- PROCESO MERGE  
                 vl_proceso :=  'MERGE';
                MERGE INTO SICAS_OC.SESAS_HISTORICO H
                    USING SICAS_OC.SESAS_SIN_APC APC
                    
                    ON (
                     H.IDSINIESTRO = APC.IDSINIESTRO
                    AND H.MONTO = APC.MONTO
                    AND H.FECOCU = APC.FEC_OCU
                    AND H.FECREP = APC.FEC_EST
                    AND APC.MAXIMO = (SELECT MAX(NUM_REC)FROM SICAS_OC.SESAS_HISTORICO WHERE IDSINIESTRO = APC.IDSINIESTRO)
                 
                        )
                        
                WHEN MATCHED 
                             THEN
                                  UPDATE 
                                  SET 
                                   H.ESTATUS = 'PROCESADO'
                                    ,H.LAST_UPDATE_BY = USER
                                    ,H.LAST_UPDATE_DATE = SYSDATE
                                   
                                  WHERE
                                    H.IDSINIESTRO = APC.IDSINIESTRO
                                    AND H.MONTO = APC.MONTO
                                    AND H.FECOCU = APC.FEC_OCU
                                    AND H.FECREP = APC.FEC_EST
                                    AND H.RECL = APC.RECL -1
                                    
                               WHEN NOT MATCHED 
                              THEN
                               INSERT ( H.NPOLIZA 
                                          ,H.IDSINIESTRO 
                                          ,H.FECOCU
                                          ,H.FECREP
                                          ,H.MONTO
                                          ,H.ANOREP
                                          ,H.NUM_REC
                                          ,H.ESTATUS
                                          ,H.RECL
                                          ,H.IDPOLIZA
                                          ,H.COBERTURA
                                          )  ---inserta registro completo
                                      VALUES (
                                          APC.NPOLIZA 
                                          ,APC.IDSINIESTRO 
                                          ,TO_DATE(TO_CHAR(APC.FEC_OCU,'DD/MM/YYYY'))
                                          ,TO_DATE(TO_CHAR(APC.FEC_EST,'DD/MM/YYYY'))
                                          ,APC.MONTO
                                          ,TO_NUMBER(TO_CHAR(APC.FEC_EST,'YYYY'))
                                          ,APC.NREC_OK
                                          ,'INSERTADO'
                                          ,APC.RECL
                                          ,APC.IDPOLIZA
                                          ,APC.COBERTURA
                                          );
                                       
                                      COMMIT;

                                      ---MERGE TABLA SESAS_SIN_APC_FECM
                                      
                                     
                                     --BORRADO DE LA TABLA  SESAS_SIN_APC 
                                   DELETE FROM SICAS_OC.SESAS_SIN_APC;
                                      --DBMS_OUTPUT.PUT_LINE('Registros eliminados SIN_APC '|| SQL%ROWCOUNT);
                                      --ELIMINA REGISTROS
                                   DELETE FROM SICAS_OC.SESAS_SIN_APC_FECM;   
                                       --DELETE SINIESTROS_ATECNICA
                                    DELETE FROM SICAS_OC.SESAS_SINIESTROS_ATECNICA;
                                      --DBMS_OUTPUT.PUT_LINE('Registros eliminados ATECNICA '|| SQL%ROWCOUNT);
                                      COMMIT;        
                                                            p_mCode := 1;        
                                                            p_mMessage :='Exito';
                               EXCEPTION 
                                    WHEN OTHERS THEN
                                    ROLLBACK;
                     
                                              p_mCode := SQLCODE;
                                              p_mMessage := 'Error al Proceso : '|| vl_proceso || ' Causa:'|| SQLERRM;
                        
       
      END INSERTA_SINIESTROS;
        ---MODIFICACION MERGE 
PROCEDURE MODIFICA_SINIESTROS(p_mCode OUT number,p_mMessage out varchar) IS
      
    BEGIN
      
       MERGE INTO SICAS_OC.SESAS_HISTORICO H
                    USING SICAS_OC.SESAS_HISTORICO_EXT HE
                    
                    ON (
                     H.ID_SESAS_HIST = HE.ID_SESAS_HIST
                   
                 
                        )
                WHEN MATCHED 
                             THEN
                                  UPDATE 
                                  SET 
                                      H.NUM_REC = HE.NUM_REC
                                      ,H.FECOCU = TO_DATE(TO_CHAR(HE.FECOCU,'DD/MM/YYYY'))
                                      ,H.FECREP = TO_DATE(TO_CHAR(HE.FECREP,'DD/MM/YYYY'))
                                      ,H.FECCON = HE.FECCON
                                      ,H.FECPAG = HE.FECPAG
                                      ,H.EST_REC = HE.EST_REC
                                      ,H.ENTIDAD_OC = HE.ENTIDAD_OC
                                      ,H.COB_AFEC = HE.COB_AFEC
                                      ,H.FNACIM = HE.FNACIM
                                      ,H.SEXO = HE.SEXO
                                      ,H.CAUSA = HE.CAUSA
                                      ,H.TIP_MOV = HE.TIP_MOV
                                      ,H.MONTO = HE.MONTO
                                      ,H.MTO_DED = HE.MTO_DED
                                      ,H.MTO_COA = HE.MTO_COA
                                      ,H.MTO_PAG = HE.MTO_PAG
                                      ,H.MTO_CED = HE.MTO_CED
                                      ,H.PC = HE.PC
                                      ,H.LAST_UPDATE_BY = USER
                                      ,H.LAST_UPDATE_DATE = SYSDATE
                                      WHERE H.ID_SESAS_HIST = HE.ID_SESAS_HIST
                                  
                               WHEN NOT MATCHED 
                              THEN
                               INSERT ( H.ID_SESAS_HIST
                                        ,H.CODCIA
                                        ,H.CODEMPRESA
                                        ,H.NPOLIZA
                                        ,H.CERTIFICADO
                                        ,H.IDSINIESTRO
                                        ,H.NUM_REC
                                        ,H.FECOCU
                                        ,H.FECREP
                                        ,H.FECCON
                                        ,H.FECPAG
                                        ,H.EST_REC
                                        ,H.ENTIDAD_OC
                                        ,H.COB_AFEC
                                        ,H.FNACIM
                                        ,H.SEXO
                                        ,H.CAUSA
                                        ,H.TIP_MOV
                                       ,H.MONTO
                                        ,H.MTO_DED
                                        ,H.MTO_COA
                                        ,H.MTO_PAG
                                        ,H.MTO_CED
                                        ,H.PC
                                        ,H.ANOREP
                                        ,H.CREATION_BY
                                        ,H.CREATION_DATE
                                        ,H.LAST_UPDATE_BY
                                        ,H.LAST_UPDATE_DATE
                                        ,H.ESTATUS
                                        ,H.RECL
                                        ,H.EST_CIERRE
                                        ,H.IDPOLIZA
                                          )  ---inserta registro completo
                                      VALUES (
                                         HE.ID_SESAS_HIST
                                        ,1
                                        ,1
                                        ,HE.NPOLIZA
                                        ,HE.CERTIFICADO
                                        ,HE.IDSINIESTRO
                                        ,HE.NUM_REC
                                        ,HE.FECOCU
                                        ,HE.FECREP
                                        ,HE.FECCON
                                        ,HE.FECPAG
                                        ,HE.EST_REC
                                        ,HE.ENTIDAD_OC
                                        ,HE.COB_AFEC
                                        ,HE.FNACIM
                                        ,HE.SEXO
                                        ,HE.CAUSA
                                        ,HE.TIP_MOV
                                        ,HE.MONTO
                                        ,HE.MTO_DED
                                        ,HE.MTO_COA
                                        ,HE.MTO_PAG
                                        ,HE.MTO_CED
                                        ,HE.PC
                                        ,HE.ANOREP
                                        ,USER
                                        ,SYSDATE
                                        ,USER
                                        ,SYSDATE
                                        ,'99'
                                        ,'99'
                                        ,'99'
                                        ,HE.IDPOLIZA
                                          );
                                            COMMIT;
                                            p_mCode := 1;        
                                            p_mMessage :='Exito';
                               EXCEPTION 
                                    WHEN OTHERS THEN
                                    ROLLBACK;
                     
                                              p_mCode := SQLCODE;
                                              p_mMessage := 'Error al Proceso : '|| ' Causa:'|| SQLERRM;
                                       
                                    
      
      END MODIFICA_SINIESTROS;
      
    
END OC_SESAS_RUTINA_NREC;
/
-------PERMISOS 

GRANT EXECUTE ON SICAS_OC.OC_SESAS_RUTINA_NREC TO PUBLIC;
/
  --SINONIMO
  CREATE OR REPLACE PUBLIC SYNONYM OC_SESAS_RUTINA_NREC FOR SICAS_OC.OC_SESAS_RUTINA_NREC;
  /