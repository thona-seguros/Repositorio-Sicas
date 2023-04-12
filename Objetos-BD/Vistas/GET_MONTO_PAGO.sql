 CREATE OR REPLACE VIEW GET_MONTO_PAGO (CODCIA,	CODEMPRESA,	IDPOLIZA,	IDSINIESTRO,	IDTRANSACCION,	NUM_APROBACION, BENEF,	IDDETSIN,	
                                       STSAPROBACION,	FECHA_TRANSACCION, USUARIO_GENERO, MONTO_PAGO, COD_PAGO, CodCptoTransac

) AS
 
 SELECT /*+ PARALLEL */
       A.CODCIA
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
       --,SUM(A.MONTO_MONEDA) MONTO_PAGO
       ,SUM(DA.MONTO_LOCAL) MONTO_PAGO
       ,DA.Cod_Pago
       ,DA.CodCptoTransac
  FROM TRANSACCION T
       ,APROBACIONES A
       ,DETALLE_APROBACION DA
       ,Config_Transac_Siniestros TS
       ,Cptos_Transac_Siniestros CTS
 WHERE T.IDPROCESO			= 6
   AND A.CODCIA            = T.CODCIA
   AND A.CODEMPRESA        = T.CODEMPRESA
   AND A.IDTRANSACCION     = T.IDTRANSACCION
   AND A.STSAPROBACION     = 'PAG'
   AND A.CODCIA   			= DA.CODCIA
   AND A.CODEMPRESA        = DA.CODEMPRESA
   AND A.IDSINIESTRO       = DA.IDSINIESTRO
   AND A.NUM_APROBACION    = DA.NUM_APROBACION
   AND DA.CodCia           = TS.CodCia
   AND DA.CodTransac       = TS.CodTransac
   AND DA.CodCia           = CTS.CodCia
   AND DA.CodTransac       = CTS.CodTransac
   AND DA.CodCptoTransac   = CTS.CodCptoTransac
   --AND CTS. IndDisminRva   = 'S'
   AND TS.StsTransac       = 'ACTIVA'
   AND TS.CodCia           = CTS.CodCia
   AND TS.CodTransac       = CTS.CodTransac
   --AND A.IDSINIESTRO       = 365085
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
       ,DA.Cod_Pago
       ,DA.CodCptoTransac
 --ORDER BY 3,4,8
 ;