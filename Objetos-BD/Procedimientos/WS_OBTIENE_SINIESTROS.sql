create or replace PROCEDURE SICAS_OC.WS_OBTIENE_SINIESTROS (
    P_IDPOLIZA     IN  NUMBER,
    P_CODASEGURADO IN  NUMBER,   
    P_CODSUBGRUPO  IN  NUMBER, 
    P_CODCIA       IN  NUMBER DEFAULT NULL,
    P_CODEMPRESA   IN  NUMBER DEFAULT NULL, 
    p_resultado OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_resultado FOR
        SELECT S.IdSiniestro, 
               S.Fec_Ocurrencia, 
               S.Fec_Notificacion, 
               S.Sts_Siniestro, 
               S2.MONTO_RESERVADO_LOCAL AS Monto_Reserva_Local,
               S2.MONTO_RESERVADO_MONEDA AS Monto_Reserva_Moneda,
               S2.MONTO_PAGADO_LOCAL AS Monto_Pago_Local,
               S2.MONTO_PAGADO_MONEDA AS Monto_Pago_Moneda, 
               S.Cod_Asegurado,
               OC_ASEGURADO.NOMBRE_ASEGURADO(S.CodCia, S.CodEmpresa, S.Cod_Asegurado) AS cDescCodAsegurado,
               S.Motivo_de_Siniestro, 
               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN', S.Motivo_de_Siniestro) AS DescMotivo,
               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', S.Sts_Siniestro) AS DescStatus,
               S.NumSiniRef, 
               S.IDetPol, 
               S.IdPoliza,
               SYSDATE AS ultfecpago
        FROM SINIESTRO S
        JOIN DETALLE_SINIESTRO_ASEG S2 ON S2.IdSiniestro = S.IdSiniestro AND S2.IdPoliza = S.IdPoliza AND S2.IDDETSIN = 1
         JOIN DETALLE_POLIZA DP ON (S.IDPOLIZA = DP.IDPOLIZA)
        WHERE S.IdPoliza = P_IDPOLIZA
          AND S.CodCia = P_CODCIA
          AND S.CODEMPRESA = P_CODEMPRESA
          AND S2.COD_ASEGURADO = P_CODASEGURADO
          AND CODFILIAL = P_CODSUBGRUPO
          AND (S.IdPoliza, S.IDetPol, S.Cod_Asegurado) IN (
              SELECT DISTINCT AC.IdPoliza, AC.IDetPol, AC.Cod_Asegurado
              FROM ASEGURADO A
              JOIN ASEGURADO_CERTIFICADO AC ON AC.CodCia = A.CodCia
                                           AND AC.Cod_Asegurado = A.Cod_Asegurado
              WHERE A.Cod_Asegurado = P_CODASEGURADO
              UNION
              SELECT DISTINCT AC.IdPoliza, AC.IDetPol, AC.Cod_Asegurado
              FROM ASEGURADO A
              JOIN ASEGURADO_CERT AC ON AC.CodCia = A.CodCia
                                    AND AC.Cod_Asegurado = A.Cod_Asegurado
              WHERE A.Cod_Asegurado = P_CODASEGURADO
              UNION
              SELECT DISTINCT D.IdPoliza, D.IDetPol, D.Cod_Asegurado
              FROM ASEGURADO A
              JOIN DETALLE_POLIZA D ON D.CodCia = A.CodCia
                                   AND D.Cod_Asegurado = A.Cod_Asegurado
              WHERE A.Cod_Asegurado = P_CODASEGURADO
          );
END WS_OBTIENE_SINIESTROS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTIENE_SINIESTROS FOR SICAS_OC.WS_OBTIENE_SINIESTROS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTIENE_SINIESTROS TO PUBLIC
/