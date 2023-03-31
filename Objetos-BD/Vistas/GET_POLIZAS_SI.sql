CREATE OR REPLACE VIEW GET_POLIZAS_SI (CODCIA,	IDPOLIZA,	IDSINIESTRO,	NOMBRE_BENEFICIARIO,	NOMBRE_CONTRATANTE,	AseguradoSiniestradoSiniestro,
                            FolioSiniestroPortal, NumPoliza, Fec_Ocurrencia, EstadoOcurrencia, CausaSiniestro, CobertPolizaDesc
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
      FROM SINIESTRO SI
         ,POLIZAS PP
      WHERE 1 = 1
           --**AND SI.IDSINIESTRO      = 56521--371235
           --**AND SI.IDPOLIZA = 9746--48946
      AND PP.IDPOLIZA		    = SI.idpoliza
      AND PP.CODCIA  			= SI.CODCIA
      AND PP.CODEMPRESA       = SI.CODEMPRESA;
         