CREATE OR REPLACE VIEW POLIZAS_RESERVAS_ASEG(Ramo,Fec_Notificacion,Num_Siniestro,NumPoliza,FecchaOcurrenciaSiniestro,EstadoOcurrenciaSiniestro,FolioSiniestroPortal,Nombre_Contratant,
Asegurado_Siniestrado,CausaSiniestro,CobertPolizaDesc,DireccionAsegurado,SumaAsegurada,DescripConceptoReserva, Monto_Reserva, Cobertura_Reserva)
SELECT
        TS.CodTipoPlan                              Ramo
        ,PPSI.Fec_Notificacion                      Fec_Notificacion
       ,PPSI.IdSiniestro                           Num_Siniestro
       ,PPSI.NumPoliza                             NumPoliza
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
    ,DETALLE_SINIESTRO_ASEG DS
    ,TIPOS_DE_SEGUROS TS
    ,GET_MONTO_RESERVA_ASEG CSA

  WHERE 
    PPSI.IDPOLIZA = DS.IDPOLIZA
   AND PPSI.IDSINIESTRO = DS.IDSINIESTRO 
    AND DS.CodCia           = CSA.CodCia
  AND CSA.CodEmpresa      = DS.CodEmpresa
   AND CSA.IdPoliza        = DS.IdPoliza
   AND CSA.IdSiniestro     = DS.IdSiniestro
   AND CSA.IdDetSin        = DS.IdDetSin
