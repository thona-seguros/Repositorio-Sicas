 
CREATE VIEW GET_MONTO_PAGO_ASEG (CODCIA,	CODEMPRESA,	IDPOLIZA,	IDSINIESTRO,	IDTRANSACCION,	NUM_APROBACION,	BENEF,	IDDETSIN,	STSAPROBACION,	FECHA_TRANSACCION,	USUARIO_GENERO,	MONTO_PAGO
) AS

 GET_MONTO_PAGO_ASEG AS (SELECT A.CODCIA
                                ,A.CODEMPRESA
                                ,A.IDPOLIZA
                                ,A.IDSINIESTRO
                                ,A.IDTRANSACCION
                                ,A.NUM_APROBACION
                                ,A.BENEF
                                ,A.IDDETSIN
                                ,A.STSAPROBACION
                                ,TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY') FECHA_TRANSACCION
                                ,T.USUARIOGENERO USUARIO_GENERO
                                ,SUM(A.MONTO_MONEDA) MONTO_PAGO
                            FROM TRANSACCION T
                                ,(SELECT PAU.CODCIA, PAU.CODUSUARIO
                                FROM PROCESO_AUTORIZA_USUARIO PAU
                                WHERE 1 = 1
                                AND PAU.CODUSUARIO          IS NOT NULL
                                AND PAU.CODCIA      		= 1--T.CODCIA
                                AND PAU.CODPROCESO  		= 9040
                                AND PAU.idtiposeg   		= 'NOAPLI') GU
                                ,APROBACION_ASEG A
                                --??,DETALLE_APROBACION DA
                            WHERE 1 = 1
                            AND T.USUARIOGENERO		= GU.CODUSUARIO
                            AND T.CODCIA            = GU.CODCIA
                            AND T.IDPROCESO			= 6
                            AND A.CODCIA            = T.CODCIA
                            AND A.CODEMPRESA        = T.CODEMPRESA
                            AND A.IDTRANSACCION     = T.IDTRANSACCION
                            AND A.STSAPROBACION     = 'PAG'
                            --??AND A.CODCIA   			= DA.CODCIA
                            --??AND A.CODEMPRESA        = DA.CODEMPRESA
                            --??AND A.IDSINIESTRO       = DA.IDSINIESTRO
                            --??AND A.NUM_APROBACION    = DA.NUM_APROBACION
                            GROUP BY A.CODCIA
                                ,A.CODEMPRESA
                                ,A.IDTRANSACCION
                                ,A.IDPOLIZA
                                ,A.IDSINIESTRO
                                ,A.BENEF
                                ,A.IDDETSIN
                                ,A.NUM_APROBACION
                                ,A.STSAPROBACION
                                ,TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY')
                                ,T.USUARIOGENERO
                            ORDER BY 3,4,8
						)