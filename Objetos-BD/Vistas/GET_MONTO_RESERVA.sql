 CREATE VIEW GET_MONTO_RESERVA (CODCIA,	IDPOLIZA,	IDSINIESTRO,	IDDETSIN,	CODEMPRESA,	CODCOBERT,	
                                    CodCptoTransac, DescripConcepto, MONTO_RESERVA
) AS
SELECT CSA.CODCIA
      ,CSA.IDPOLIZA
      ,CSA.IDSINIESTRO
      ,CSA.IDDETSIN
      ,CSA.CODEMPRESA
      ,CSA.CODCOBERT
      ,CSA.CodCptoTransac
      ,CC.DescripConcepto
      ,CASE 
         WHEN CC.Signo_Concepto = '+' THEN 
            SUM(CSA.MONTO_RESERVADO_MONEDA)
         WHEN CC.Signo_Concepto = '-' THEN 
            SUM(CSA.MONTO_RESERVADO_MONEDA) * -1 
         ELSE 
            SUM(CSA.MONTO_RESERVADO_MONEDA) 
      END MONTO_RESERVA
  FROM COBERTURA_SINIESTRO CSA, CATALOGO_DE_CONCEPTOS CC
  WHERE CSA.CodCptoTransac =  CC.CodConcepto
    --and IDSINIESTRO      = 365085
  GROUP BY CSA.CODCIA
      ,CSA.IDPOLIZA
      ,CSA.IDSINIESTRO
      ,CSA.IDDETSIN
      ,CSA.CODEMPRESA
      ,CSA.CODCOBERT   
      ,CSA.CodCptoTransac
      ,CC.Signo_Concepto
      ,CC.DescripConcepto
                    