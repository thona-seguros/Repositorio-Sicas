CREATE VIEW GET_MONTO_RESERVA_ASEG (CODCIA,	IDPOLIZA,	IDSINIESTRO,	IDDETSIN,	CODEMPRESA,	CODCOBERT,	MONTO_RESERVA

) AS

 GET_MONTO_RESERVA_ASEG AS (SELECT CSA.CODCIA
                                    ,CSA.IDPOLIZA
                                    ,CSA.IDSINIESTRO
                                    ,CSA.IDDETSIN
                                    ,CSA.CODEMPRESA
                                    ,CSA.CODCOBERT
                                    ,SUM(CSA.MONTO_RESERVADO_MONEDA) MONTO_RESERVA
                                FROM COBERTURA_SINIESTRO_ASEG CSA
                                WHERE 1 = 1
                                GROUP BY CSA.CODCIA
                                    ,CSA.IDPOLIZA
                                    ,CSA.IDSINIESTRO
                                    ,CSA.IDDETSIN
                                    ,CSA.CODEMPRESA
                                    ,CSA.CODCOBERT
                    )