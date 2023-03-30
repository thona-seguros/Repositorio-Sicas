 CREATE VIEW GET_BENEF_SIN (CODCIA,	IDPOLIZA,	IDSINIESTRO,	IDDETSIN,	CODEMPRESA,	CODCOBERT,	MONTO_RESERVA

) AS



 
 
 GET_MONTO_RESERVA AS (SELECT CSA.CODCIA
                                ,CSA.IDPOLIZA
                                ,CSA.IDSINIESTRO
                                ,CSA.IDDETSIN
                                ,CSA.CODEMPRESA
                                ,CSA.CODCOBERT
                                ,SUM(CSA.MONTO_RESERVADO_MONEDA) MONTO_RESERVA
                            FROM COBERTURA_SINIESTRO CSA
                            WHERE 1 = 1
                            --**AND CSA.IDSINIESTRO      = 57252
                            GROUP BY CSA.CODCIA
                                    ,CSA.IDPOLIZA
                                    ,CSA.IDSINIESTRO
                                    ,CSA.IDDETSIN
                                    ,CSA.CODEMPRESA
                                    ,CSA.CODCOBERT
                    )