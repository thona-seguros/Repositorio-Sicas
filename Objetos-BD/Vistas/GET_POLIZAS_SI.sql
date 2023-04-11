CREATE OR REPLACE VIEW GET_POLIZAS_SI (CODCIA,	IDPOLIZA,	IDSINIESTRO,	NOMBRE_BENEFICIARIO,	NOMBRE_CONTRATANTE,	AseguradoSiniestradoSiniestro,
                            FolioSiniestroPortal, NumPoliza, Fec_Ocurrencia, EstadoOcurrencia, CausaSiniestro, CobertPolizaDesc, Fec_Notificacion,
                            IDetPol
                            ) AS 
   SELECT SI.CODCIA
         ,SI.IDPOLIZA
         ,SI.IDSINIESTRO
         ,OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)           		NOMBRE_BENEFICIARIO
         ,OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)           		NOMBRE_CONTRATANTE
         ,OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CODCIA, PP.CODEMPRESA, SI.COD_ASEGURADO) AseguradoSiniestradoSiniestro
         ,SI.NumSiniRef FolioSiniestroPortal
         ,PP.NumPolUnico NumPoliza
         ,SI.Fec_Ocurrencia
         ,OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CodPaisOcurr, SI.CodProvOcurr) EstadoOcurrencia
         ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN', SI.Motivo_De_Siniestro) CausaSiniestro
         ,PP.DescPoliza CobertPolizaDesc
         ,SI.Fec_Notificacion
         ,DP.IDetPol
      FROM SINIESTRO SI
         ,POLIZAS PP
         ,DETALLE_POLIZA DP
      WHERE 1 = 1
           --**AND SI.IDSINIESTRO      = 56521--371235
           --**AND SI.IDPOLIZA = 9746--48946
      AND SI.Sts_Siniestro   != 'SOL'
      AND DP.IDPOLIZA		   = SI.idpoliza
      AND DP.CODCIA  			= SI.CODCIA
      AND DP.CODEMPRESA       = SI.CODEMPRESA
      AND DP.IDetPol          = SI.IDetPol
      AND PP.CodCia           = DP.CodCia
      AND PP.IdPoliza         = DP.IdPoliza;
         