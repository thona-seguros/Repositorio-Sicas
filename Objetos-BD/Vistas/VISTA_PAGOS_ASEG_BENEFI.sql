CREATE OR REPLACE VIEW PAGOS_ASEG_BENEFI(FechaTransaccion,Monto_Pago,Num_Aprobacion,IdSiniestro,IdPoliza,IdDetSin,Codigo_Cobertura,USUARIO_GENERO,Nombre_Beneficiario,Tipo_Pago,Banco,Cuenta_Clabe,Cuenta_Bancaria,Telefono,Tipo_Identificacion,
Num_Identificacion,Cod_Convenio,EmailBeneficiario,Num_Doc_Tributario) AS
SELECT 
        TA.Fecha_Transaccion                       FechaTransaccion
        ,TA.Monto_Pago                              Monto_Pago
        ,TA.Num_Aprobacion                          Num_Aprobacion
       ,TA.IdSiniestro                             IdSiniestro
       ,TA.IdPoliza                                IdPoliza
       ,TA.IdDetSin                                IdDetSin
       ,TA.Cod_Pago                                Codigo_Cobertura
       ,TA.USUARIO_GENERO                           USUARIO_GENERO
        ,BES.Nombre_Beneficiario                    Nombre_Beneficiario
       ,BES.Tipo_Pago                              Tipo_Pago
       ,BES.Banco                                  Banco
       ,BES.Cuenta_Clave                           Cuenta_Clabe
       ,BES.Cuenta_Bancaria                        Cuenta_Bancaria
       ,BES.Telefono                               Telefono
       ,BES.Tipo_Identificacion                    Tipo_Identificacion
       ,BES.Num_Identificacion                     Num_Identificacion
       ,BES.Cod_Convenio                           Cod_Convenio
       ,BES.Email                                  EmailBeneficiario
       ,BES.Num_Doc_Tributario                     Num_Doc_Tributario 
   FROM 
   GET_MONTO_PAGO_ASEG TA
    , GET_BENEF_SIN BES
   WHERE     
        TA.IdPoliza             = BES.IdPoliza 
        AND TA.IdSiniestro      = BES.IdSiniestro
        AND TA.Benef            = BES.Benef

/

CREATE OR REPLACE PUBLIC SYNONYM PAGOS_ASEG_BENEFI FOR SICAS_OC.PAGOS_ASEG_BENEFI

/
GRANT SELECT ON SICAS_OC.PAGOS_ASEG_BENEFI TO PUBLIC

   