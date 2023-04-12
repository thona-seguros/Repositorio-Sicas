CREATE OR REPLACE VIEW GET_POLIZAS_SI (CODCIA,	IDPOLIZA,	IDSINIESTRO,	NOMBRE_BENEFICIARIO,	NOMBRE_CONTRATANTE,	AseguradoSiniestradoSiniestro,
                           CURPAsegurado, FolioSiniestroPortal, NumPoliza, Fec_Ocurrencia, EstadoOcurrencia, CausaSiniestro, SubCausaSiniestro, CobertPolizaDesc, 
                            Fec_Notificacion, IDetPol, FecEmision, FecIniVig, FecFinVig, Desc_Siniestro, Agente, EjecutivoComercial, Nom_Medico_Certifica,
                            Hospital
                            ) AS 
   SELECT /*+ PARALLEL */
         SI.CODCIA
         ,SI.IDPOLIZA
         ,SI.IDSINIESTRO
         ,OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)           		NOMBRE_BENEFICIARIO
         ,OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)           		NOMBRE_CONTRATANTE
         ,OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CODCIA, PP.CODEMPRESA, SI.COD_ASEGURADO) AseguradoSiniestradoSiniestro
         ,OC_PERSONA_NATURAL_JURIDICA.CLAVE_CURP(A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion) CURPAsegurado
         ,SI.NumSiniRef FolioSiniestroPortal
         ,PP.NumPolUnico NumPoliza
         ,SI.Fec_Ocurrencia
         ,OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CodPaisOcurr, SI.CodProvOcurr) EstadoOcurrencia
         ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN', SI.Motivo_De_Siniestro) CausaSiniestro
         ,OC_SAI_CAT_GENERAL.DESCRIPCION (9, SI.Motivo_De_Siniestro, si.SubMotivo_Siniestro) SubCausaSiniestro
         ,PP.DescPoliza CobertPolizaDesc
         ,SI.Fec_Notificacion
         ,DP.IDetPol
         ,PP.FecEmision
         ,PP.FecIniVig
         ,PP.FecFinVig
         ,SI.Desc_Siniestro
         ,OC_AGENTES.NOMBRE_AGENTE(PP.CodCia, AP.Cod_Agente) Agente
         ,OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(PP.CodCia, OC_AGENTES.EJECUTIVO_COMERCIAL(PP.CodCia, AP.Cod_Agente)) EjecutivoComercial
         ,SI.Nom_Medico_Certifica   
         ,OC_PROVEEDORES.NOMBRE_PROVEEDOR(SI.CodCia, SI.CodProveedor) Hospital
      FROM SINIESTRO SI
         ,POLIZAS PP
         ,DETALLE_POLIZA DP
         ,AGENTE_POLIZA AP
         ,ASEGURADO A
      WHERE 1 = 1
           --**AND SI.IDSINIESTRO      = 56521--371235
           --AND PP.Idpoliza = 35425
      AND SI.Sts_Siniestro   != 'SOL'
      AND AP.Ind_Principal    = 'S'
      AND DP.IDPOLIZA		   = SI.idpoliza
      AND DP.CODCIA  			= SI.CODCIA
      AND DP.CODEMPRESA       = SI.CODEMPRESA
      AND DP.IDetPol          = SI.IDetPol
      AND PP.CodCia           = DP.CodCia
      AND PP.IdPoliza         = DP.IdPoliza
      AND PP.CodCia           = AP.CodCia
      AND PP.IdPoliza         = AP.IdPoliza
      AND SI.CodCia           = A.CodCia
      AND SI.CodEmpresa       = A.CodEmpresa
      AND SI.Cod_Asegurado    = A.Cod_Asegurado
         