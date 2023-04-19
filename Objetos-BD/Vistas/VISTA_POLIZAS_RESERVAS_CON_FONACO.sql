CREATE OR REPLACE VIEW POLIZAS_RESERVAS_CON_FONACO(Ramo,Fec_Notificacion,Num_Siniestro,NumPoliza,IDPOLIZA,FecchaOcurrenciaSiniestro,EstadoOcurrenciaSiniestro,FolioSiniestroPortal,Nombre_Contratant,
Asegurado_Siniestrado,CausaSiniestro,CobertPolizaDesc,DireccionAsegurado,SumaAsegurada,DescripConceptoReserva, Monto_Reserva, Cobertura_Reserva) AS
  
 SELECT
         'VIDA COLECTIVO'                           Ramo
        ,PPSI.Fec_Notificacion                      Fec_Notificacion
       ,PPSI.IdSiniestro                           Num_Siniestro
       ,PPSI.NumPoliza                             NumPoliza
       ,PPSI.IDPOLIZA                              IDPOLIZA
       ,PPSI.Fec_Ocurrencia                        FecchaOcurrenciaSiniestro
       ,PPSI.EstadoOcurrencia                      EstadoOcurrenciaSiniestro
       ,PPSI.FolioSiniestroPortal                  FolioSiniestroPortal
       ,PPSI.Nombre_Contratante                    Nombre_Contratant
       ,PPSI.AseguradoSiniestradoSiniestro         Asegurado_Siniestrado
       ,PPSI.CausaSiniestro                        CausaSiniestro
       ,PPSI.CobertPolizaDesc                      CobertPolizaDesc
       ,OC_ASEGURADO.DIRECCION_ASEGURADO(PPSI.CodCia, DS.CodEmpresa, DS.Cod_Asegurado) DireccionAsegurado
       ,OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(PPSI.CodCia, PPSI.IdPoliza, PPSI.IDetPol, DS.Cod_Asegurado, CSA.CodCobert) SumaAsegurada
       ,CSA.DescripConcepto                        DescripConceptoReserva
       ,CSA.Monto_Reserva                          Monto_Reserva
        ,CSA.CodCobert                              Cobertura_Reserva
    FROM GET_POLIZAS_SI PPSI
    ,DETALLE_SINIESTRO DS
    ,TIPOS_DE_SEGUROS TS
    ,GET_MONTO_RESERVA CSA

  WHERE  
       PPSI.IDPOLIZA = DS.IDPOLIZA
   AND PPSI.IDSINIESTRO = DS.IDSINIESTRO 
   AND PPSI.IdPoliza    = DS.IdPoliza   
   AND DS.IdTipoSeg    in( 'FONACO')
   AND DS.IdTipoSeg     = TS.IdTipoSeg 
   AND DS.CodCia        = CSA.CodCia
   AND DS.CodEmpresa    = CSA.CodEmpresa     
   AND DS.IdPoliza      = CSA.IdPoliza        
   AND DS.IdSiniestro   = CSA.IdSiniestro     
   AND DS.IdDetSin		= CSA.IdDetSin 
   
   

/

CREATE OR REPLACE PUBLIC SYNONYM POLIZAS_RESERVAS_CON_FONACO FOR SICAS_OC.POLIZAS_RESERVAS_CON_FONACO

/
GRANT SELECT ON SICAS_OC.POLIZAS_RESERVAS_CON_FONACO TO PUBLIC
