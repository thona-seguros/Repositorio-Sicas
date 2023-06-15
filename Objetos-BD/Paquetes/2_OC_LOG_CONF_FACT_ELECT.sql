CREATE OR REPLACE PACKAGE SICAS_OC.OC_LOG_CONF_FACT_ELECT IS
/*	Fecha Modif: 14/06/2023
	Modificó: Luis Argenis Reynoso Alvarez
	modificación: Se agrega parametro de IndexUnique o PK al SP de inserción,
		con la finalidad de registrar el ID unico del evento desde el disparador,
		se coloca un DEFAULT NULLL, para no afectar los disparadores que ya están funcionando
*/
  PROCEDURE INSERTA(
                    nCodCia       IN  LOG_CONF_FACT_ELECT.CODCIA%TYPE,
                    cNombTabla    IN  LOG_CONF_FACT_ELECT.NOMBRETABLA%TYPE,
                    cNombCampo    IN  LOG_CONF_FACT_ELECT.NOMBRECAMPO%TYPE,
                    cValorOld     IN  LOG_CONF_FACT_ELECT.VALORCAMPOANT%TYPE,
                    cValorNew     IN  LOG_CONF_FACT_ELECT.VALORCAMPOUPD%TYPE,
                    cTipoAccion   IN  LOG_CONF_FACT_ELECT.ACCION%TYPE,
                    cIndexUnique  IN  LOG_CONF_FACT_ELECT.FCVALORUNIQ%TYPE DEFAULT NULL
                    );
END;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_LOG_CONF_FACT_ELECT IS

  PROCEDURE INSERTA(
                    nCodCia       IN  LOG_CONF_FACT_ELECT.CODCIA%TYPE,
                    cNombTabla    IN  LOG_CONF_FACT_ELECT.NOMBRETABLA%TYPE,
                    cNombCampo    IN  LOG_CONF_FACT_ELECT.NOMBRECAMPO%TYPE,
                    cValorOld     IN  LOG_CONF_FACT_ELECT.VALORCAMPOANT%TYPE,
                    cValorNew     IN  LOG_CONF_FACT_ELECT.VALORCAMPOUPD%TYPE,
                    cTipoAccion   IN  LOG_CONF_FACT_ELECT.ACCION%TYPE,
                    cIndexUnique  IN  LOG_CONF_FACT_ELECT.FCVALORUNIQ%TYPE DEFAULT NULL
                    ) IS

  BEGIN
    
    EXECUTE IMMEDIATE('ALTER SESSION SET NLS_DATE_FORMAT=''DD/MM/YYYY HH24:MI:SS''');
    
    INSERT INTO LOG_CONF_FACT_ELECT(
                                      IDCTRLOG, 
                                      CodCia, 
                                      NOMBRETABLA, 
                                      NOMBRECAMPO, 
                                      VALORCAMPOANT, 
                                      VALORCAMPOUPD, 
                                      ACCION, 
                                      USUARIOMOD, 
                                      FECMODIFICACION,
                                      FCVALORUNIQ)
                            VALUES(
                                      SICAS_OC.SQ_LOGCONFFACT.NEXTVAL, 
                                      nCodCia, 
                                      cNombTabla, 
                                      cNombCampo, 
                                      cValorOld, 
                                      cValorNew, 
                                      cTipoAccion, 
                                      USER, 
                                      SYSDATE,
                                      cIndexUnique);

  EXCEPTION 
    WHEN OTHERS THEN
      raise_application_error( -20000,SQLERRM);
  END INSERTA;
END OC_LOG_CONF_FACT_ELECT;
/

GRANT EXECUTE ON SICAS_OC.OC_LOG_CONF_FACT_ELECT TO SICAS_OC;
/