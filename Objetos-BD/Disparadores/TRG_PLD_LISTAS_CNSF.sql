
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_PLD_LISTAS_CNSF
  AFTER INSERT OR UPDATE ON PLD_LISTAS_CNSF
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
    csg_1   CONSTANT    NUMBER  :=  1;
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA PLD_LISTAS_CNSF
    FECHA CREACIN: 21/02/2025
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
    DESCRIPCIÓN: POR CADA PERSONA DADA DE ALTA COMO BENEFICIARIO EN BENESINI, SE DEBE AGREGAR EN PERSONA NATURAL JURIDICA
  */
    
    IF INSERTING THEN 
        BEGIN
			INSERT INTO SICAS_OC.HIS_LISTAS_CNSF VALUES (
                csg_1, --ID PROCESO. PARA TABLA TRG_PLD_LISTAS_CNSF SIEMPRE ES 1
                SICAS_OC.SEQ_HIS_LISTAS_CNSF.NEXTVAL,
                :NEW.NOMBRE_1,
                :NEW.TIPO_PERSONA_CNSF,
                :NEW.LISTA_ORIGEN,
                NVL(:NEW.OBSERVACIONES,'Cambio de estatus desde SICAS por carga de Layout.'),
                :NEW.TP_MOVIMIENTO,
                SYSDATE,
                USER,
                NULL,
                NULL);
            BEGIN
        
            INSERT INTO SICAS_OC.PLD_OBSERVACIONES (IDPROCESO,PROCESO_ACTIVI,IDCONSEC,TIPOPERSONA,LISTAORIGEN,NOMBRE,DESCRIPCION,FECHAINSERT,USRINSERT) 
            VALUES (5,1,SICAS_OC.SEQ_PLD_OBSERVACIONES.NEXTVAL,:NEW.TIPO_PERSONA_CNSF,
                :NEW.LISTA_ORIGEN,:NEW.NOMBRE_1,NVL(:NEW.OBSERVACIONES,'Cambio de estatus desde SICAS por carga de Layout.'),SYSDATE,USER);
                EXCEPTION
                    WHEN OTHERS THEN
                        vl_ErrorN := SQLCODE;
                          vl_ErrorC := 'Error con el disparador de PLD_LISTAS_CNSF, Contacte al administrador. '||SQLERRM;
                          --raise_application_error( -20000,vl_ErrorC);
                END;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
	END IF;  
    
	IF UPDATING THEN 
        BEGIN
            IF :OLD.TP_MOVIMIENTO <> :NEW.TP_MOVIMIENTO THEN
         
                    INSERT INTO SICAS_OC.HIS_LISTAS_CNSF VALUES (
                        csg_1, --ID PROCESO. PARA TABLA TRG_PLD_LISTAS_CNSF SIEMPRE ES 1
                        SICAS_OC.SEQ_HIS_LISTAS_CNSF.NEXTVAL,
                        :NEW.NOMBRE_1,
                        :NEW.TIPO_PERSONA_CNSF,
                        :NEW.LISTA_ORIGEN,
                        :NEW.OBSERVACIONES,
                        :NEW.TP_MOVIMIENTO,
                        SYSDATE,
                        USER,
                        NULL,
                        NULL);
         
            END IF;
                BEGIN
                    IF (:OLD.OBSERVACIONES <> :NEW.OBSERVACIONES) AND (:NEW.OBSERVACIONES IS NOT NULL) THEN
                        INSERT INTO SICAS_OC.PLD_OBSERVACIONES (IDPROCESO,PROCESO_ACTIVI,IDCONSEC,TIPOPERSONA,LISTAORIGEN,NOMBRE,DESCRIPCION,FECHAINSERT,USRINSERT) 
                        VALUES (5,1,SICAS_OC.SEQ_PLD_OBSERVACIONES.NEXTVAL,:OLD.TIPO_PERSONA_CNSF,
                            :OLD.LISTA_ORIGEN,:OLD.NOMBRE_1,NVL(:NEW.OBSERVACIONES,'Cambio de estatus desde SICAS por carga de Layout.'),SYSDATE,USER);
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        vl_ErrorN := SQLCODE;
                          vl_ErrorC := 'Error con el disparador de PLD_LISTAS_CNSF, Contacte al administrador. '||SQLERRM;
                          --raise_application_error( -20000,vl_ErrorC);
                END;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
		
	END IF;  

EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de PLD_LISTAS_CNSF, Contacte al administrador. '||SQLERRM;
      --raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_PLD_LISTAS_CNSF FOR SICAS_OC.TRG_PLD_LISTAS_CNSF;
/