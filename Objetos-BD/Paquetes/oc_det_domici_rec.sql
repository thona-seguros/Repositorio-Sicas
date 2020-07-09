--
-- OC_DET_DOMICI_REC  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NOTIFICACOBRANZADCL1 (Procedure)
--   POLIZAS (Table)
--   GT_DETALLE_DOMICI_REFERE (Package)
--   DETALLE_DOMICI_REFERE (Table)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_CONFIGURACION_DOMICILIACION (Package)
--   DETALLE_POLIZA (Table)
--   DET_DOMICI_REC (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DET_DOMICI_REC IS
    PROCEDURE ACTUA_DET_DOMI_REFE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, nIdProceso  IN NUMBER);
END OC_DET_DOMICI_REC;
/

--
-- OC_DET_DOMICI_REC  (Package Body) 
--
--  Dependencies: 
--   OC_DET_DOMICI_REC (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DET_DOMICI_REC IS
PROCEDURE ACTUA_DET_DOMI_REFE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, nIdProceso  IN NUMBER) IS
CURSOR C_DET_DOMI_REFE IS
   SELECT NumeroCuenta, TipAutorizacion, NumAutorizacion, NumRefContrato,
          CodResultado, RespDomiciliacion, DescRespDomiciliacion,
          Tipo_Configuracion
     FROM DET_DOMICI_REC
    WHERE NVL(Conciliado,'N') = 'N'
      AND NumRefContrato IN (SELECT IdFactura
                               FROM DETALLE_DOMICI_REFERE
                              WHERE CodCia         = nCodCia
                                AND IdProceso      = nIdProceso
                                AND Estado    NOT IN ('PAG','EXC'));
                                --AND Estado    NOT IN ('CNOR','PAG','EXC'));

nCantidad_Int_para   DETALLE_DOMICI_REFERE.Cantidad_Intentos%TYPE;
nCantidad_Int_Real   DETALLE_DOMICI_REFERE.Cantidad_Intentos%TYPE;
nIdPoliza            POLIZAS.IdPoliza%TYPE;        
--cCodEntidad          DOMICILIACION.CodEntidad%TYPE := OC_DOMICILIACION.CODIGO_ENTIDAD(nCodCia, nIdProceso);
nCodEmpresa          POLIZAS.CodEmpresa%TYPE;
nNumIntentosConf     POLIZAS.NumIntentosCobranza%TYPE;
nIDetPol             FACTURAS.IDetPol%TYPE;
nNumCuota            FACTURAS.NumCuota%TYPE;
cFormPago            FACTURAS.FormPago%TYPE;
cIdTipoSeg           DETALLE_POLIZA.IdTipoSeg%TYPE;
BEGIN
   nCantidad_Int_para  := OC_CONFIGURACION_DOMICILIACION.NUMERO_REINTENTOS(nCodCia, cCodEntidad, nCorrelativo);

   FOR D IN C_DET_DOMI_REFE LOOP
      BEGIN
         SELECT DISTINCT P.IdPoliza,P.CodEmpresa, F.IDetPol,F.NumCuota
           INTO nIdPoliza,nCodEmpresa,nIDetPol,nNumCuota
           FROM FACTURAS F,POLIZAS P
          WHERE F.CodCia     = nCodCia
            AND IdFactura    = D.NumRefContrato
            AND F.CodCia     = P.CodCia
            AND F.IdPoliza   = P.IdPoliza;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'Error al Obtener Poliza de Factura '|| D.NumRefContrato);
      END;
      
      SELECT NVL(MAX(Cantidad_Intentos),0)+1
        INTO nCantidad_Int_Real
        FROM DETALLE_DOMICI_REFERE
       WHERE IdFactura = D.NumRefContrato
         AND IdProceso = nIdProceso;
   
      IF GT_DETALLE_DOMICI_REFERE.EXISTE_FACTURA (nCodCia, nIdProceso, D.NumRefContrato) = 'S' AND D.TipAutorizacion = 1 THEN
         UPDATE DETALLE_DOMICI_REFERE
            SET TipoAutorizacion  = D.TipAutorizacion,
                NumAprob          = D.NumAutorizacion,
                Cantidad_Intentos = nCantidad_Int_Real
          WHERE IdFactura = D.NumRefContrato
            AND IdProceso = nIdProceso;
         
         UPDATE DET_DOMICI_REC
            SET Conciliado = 'S'
          WHERE NumRefContrato = D.NumRefContrato;
         
        -- NOTIFICACOBRANZAOK (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
      ELSE
         
         /*IF D.Tipo_Configuracion = 'D' THEN ---WEB TRANSFER
            nNumIntentosConf := OC_POLIZAS.NUMERO_INTENTOS_COBRANZA(nCodCia,nCodEmpresa,nIdPoliza);
            IF nNumIntentosConf = 0 THEN 
               nNumIntentosConf := nCantidad_Int_para;
            END IF;
            
            IF  GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_REENVIO (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'N' AND 
                GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_INTERVALOS (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'N' THEN 
               
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
               GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
               OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
               UPDATE FACTURAS
                  SET IndDomiciliado = NULL,
                      IdProceso      = NULL
                WHERE IdFactura  = D.NumRefContrato;
                     
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 1 THEN
                  NOTIFICACOBRANZADCL1 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               ELSIF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 2 THEN
                  NOTIFICACOBRANZADCL2 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               END IF;
                 
            ELSIF GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_REENVIO (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'S' AND   
                  GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_INTERVALOS (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'N' AND   
                  nNumIntentosConf > OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) THEN
                  
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);*/
               UPDATE DETALLE_DOMICI_REFERE
                  SET TipoAutorizacion  = D.TipAutorizacion,
                      Cantidad_Intentos = nCantidad_Int_Real
                WHERE IdFactura  = D.NumRefContrato
                  AND IdProceso  = nIdProceso;
				/**************************** ---- esto hay que quitarlo para reemplazarlo por todo lo que implica motivos de rechazo abajo comentado ************************************/  
				IF nCantidad_Int_Real >= nCantidad_Int_para THEN
					GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
		--            UPDATE DETALLE_DOMICI_REFERE
		--               SET Estado     = 'CNOR'
		--             WHERE IdFactura  = D.NumRefContrato
		--               AND IdProceso  = nIdProceso;

					UPDATE FACTURAS
					   SET IndDomiciliado = NULL,
						   IdProceso      = NULL
					 WHERE IdFactura  = D.NumRefContrato;
				 END IF;
            /************************************************************************************************************************************************************************/                                              
           /*    IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = nNumIntentosConf THEN
                   GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
                   OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
                   UPDATE FACTURAS
                      SET IndDomiciliado = NULL,
                          IdProceso      = NULL
                    WHERE IdFactura  = D.NumRefContrato;
               END IF;
                     
            ELSIF GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_REENVIO (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'S' AND   
                  GT_CAT_RESPUESTA_WEBTRANSFER.PERMITE_INTERVALOS (nCodCia, cCodEntidad, nCorrelativo, D.CodResultado, GT_CAT_RESPUESTA_WEBTRANSFER.TIPO_RESPUESTA(nCodCia,cCodEntidad,nCorrelativo, D.CodResultado)) = 'S' AND   
                  nNumIntentosConf > OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) THEN
                     
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato, nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
               UPDATE DETALLE_DOMICI_REFERE
                  SET TipoAutorizacion  = D.TipAutorizacion,
                      Cantidad_Intentos = nCantidad_Int_Real
                WHERE IdFactura  = D.NumRefContrato
                  AND IdProceso  = nIdProceso;
                                       
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = nNumIntentosConf THEN
                  GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
                  OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
                  UPDATE FACTURAS
                     SET IndDomiciliado = NULL,
                         IdProceso      = NULL
                   WHERE IdFactura  = D.NumRefContrato;
               END IF;
            ELSE
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
                                
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 1 THEN
                  NOTIFICACOBRANZADCL1 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               ELSIF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 2 THEN
                  NOTIFICACOBRANZADCL2 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               END IF;
            END IF;
         ELSIF D.Tipo_Configuracion = 'T' THEN ---DOMICILIACION
            nNumIntentosConf := nCantidad_Int_para;
            IF D.RespDomiciliacion = 'ENVIADO' AND nCantidad_Int_para > GT_DETALLE_DOMICI_REFERE.NUMERO_INTENTOS (nCodCia, nIdProceso, D.NumRefContrato) THEN
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
               UPDATE DETALLE_DOMICI_REFERE
                  SET Cantidad_Intentos = Cantidad_Intentos + 1
                WHERE CodCia     = nCodCia 
                  AND IdProceso  = nIdProceso
                  AND IdFactura  = D.NumRefContrato;
               IF nCantidad_Int_para = GT_DETALLE_DOMICI_REFERE.NUMERO_INTENTOS (nCodCia, nIdProceso, D.NumRefContrato) THEN
                  GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
                  OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
               END IF;
            ELSE
               IF GT_CAT_RESPUESTA_DOMICI.PERMITE_REINTENTOS (nCodCia, cCodEntidad, nCorrelativo, D.RespDomiciliacion, D.DescRespDomiciliacion) = 'N' THEN 
               
               GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
               OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
               UPDATE FACTURAS
                 SET IndDomiciliado = NULL,
                     IdProceso      = NULL
               WHERE IdFactura  = D.NumRefContrato;
                              
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 1 THEN
                  NOTIFICACOBRANZADCL1 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               ELSIF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 2 THEN
                  NOTIFICACOBRANZADCL2 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               END IF;
            ELSIF GT_CAT_RESPUESTA_DOMICI.PERMITE_REINTENTOS (nCodCia, cCodEntidad, nCorrelativo, D.RespDomiciliacion, D.RespDomiciliacion) = 'S' AND
                  nNumIntentosConf > GT_CAT_RESPUESTA_DOMICI.MAXIMO_REINTENTOS(nCodCia, cCodEntidad, nCorrelativo, D.RespDomiciliacion, D.RespDomiciliacion) THEN
                  
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
               UPDATE DETALLE_DOMICI_REFERE
                  SET TipoAutorizacion  = D.TipAutorizacion,
                      Cantidad_Intentos = nCantidad_Int_Real
                WHERE IdFactura  = D.NumRefContrato
                  AND IdProceso  = nIdProceso;
                                    
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = nNumIntentosConf THEN
                  GT_DETALLE_DOMICI_REFERE.MARCA_INTENTOS_CUMPLIDOS (nCodCia, nIdProceso, D.NumRefContrato);
                  OC_FACTURAS.MARCA_INTENTOS_CUMPLIDOS(D.NumRefContrato, nCodCia);
                  UPDATE FACTURAS
                     SET IndDomiciliado = NULL,
                         IdProceso      = NULL
                   WHERE IdFactura  = D.NumRefContrato;
               END IF;
            ELSE
               OC_FACTURAS.ACTUALIZA_NUMERO_INTENTOS(D.NumRefContrato,nCodCia, OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) + 1);
               IF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 1 THEN
                  NOTIFICACOBRANZADCL1 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               ELSIF OC_FACTURAS.NUM_INTENTOS_COBRA_REALIZADOS(D.NumRefContrato,nCodCia) = 2 THEN
                  NOTIFICACOBRANZADCL2 (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
               END IF;
            END IF;
            END IF;
         END IF;*/
         cFormPago := GT_DETALLE_DOMICI_REFERE.FORMA_PAGO(nCodCia, nIdProceso, D.NumRefContrato);
         IF cFormPago IN ('CLAB','CTC','DOMI','LIN') THEN
            IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN
               NOTIFICACOBRANZADCL1(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
            --ELSE
              --NOTIFICACOBRANZADCLSTD (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, D.NumRefContrato);
            END IF;
         END IF;
      END IF;
   END LOOP;
END ACTUA_DET_DOMI_REFE;

END OC_DET_DOMICI_REC;
/

--
-- OC_DET_DOMICI_REC  (Synonym) 
--
--  Dependencies: 
--   OC_DET_DOMICI_REC (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DET_DOMICI_REC FOR SICAS_OC.OC_DET_DOMICI_REC
/


GRANT EXECUTE ON SICAS_OC.OC_DET_DOMICI_REC TO PUBLIC
/
