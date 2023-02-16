CREATE OR REPLACE PACKAGE TH_FONDEO IS
--
-- BITACORA DE CAMBIO
-- 
PROCEDURE INSERTA(PCODCIA              NUMBER,
                  PCODEMPRESA          NUMBER,
                  PIDSINIESTRO         NUMBER,
                  PIDDETSIN            NUMBER,
                  PNUM_APROBACION      NUMBER,
                  PBENEF               NUMBER,
                  PFEC_PAGO_MOVTO      DATE,
                  PIDTIPO_PAGO         VARCHAR2,
                  PMONTO_MONEDA        NUMBER,                  
                  PMENSAJE             OUT VARCHAR2);

END TH_FONDEO;

/

CREATE OR REPLACE PACKAGE BODY TH_FONDEO IS
-- 
PROCEDURE INSERTA(PCODCIA              NUMBER,
                  PCODEMPRESA          NUMBER,
                  PIDSINIESTRO         NUMBER,
                  PIDDETSIN            NUMBER,
                  PNUM_APROBACION      NUMBER,
                  PBENEF               NUMBER,
                  PFEC_PAGO_MOVTO      DATE,
                  PIDTIPO_PAGO         VARCHAR2,
                  PMONTO_MONEDA        NUMBER,
                  PMENSAJE             OUT VARCHAR2) IS
--
NINSERTADOS NUMBER;
CIDRAMO     TIPOS_DE_SEGUROS.CODTIPOPLAN%TYPE;
--                         
BEGIN
	--
  NINSERTADOS := 0;
  PMENSAJE    := '';
  BEGIN 
    SELECT CODTIPOPLAN
      INTO CIDRAMO
      FROM (SELECT A.CODTIPOPLAN
              FROM DETALLE_SINIESTRO D,
                   TIPOS_DE_SEGUROS A
             WHERE D.IDSINIESTRO  = PIDSINIESTRO
               AND D.CODCIA       = PCODCIA
               --
               AND A.IDTIPOSEG  = D.IDTIPOSEG
               AND A.CODCIA     = D.CODCIA
               AND A.CODEMPRESA = D.CODEMPRESA
            --
            UNION
            --
            SELECT A.CODTIPOPLAN
              FROM DETALLE_SINIESTRO_ASEG DA,
                   TIPOS_DE_SEGUROS A
             WHERE DA.IDSINIESTRO  = PIDSINIESTRO
               AND DA.CODCIA       = PCODCIA
               --
               AND A.IDTIPOSEG  = DA.IDTIPOSEG
               AND A.CODCIA     = DA.CODCIA
               AND A.CODEMPRESA = DA.CODEMPRESA);     
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CIDRAMO := '000';
    WHEN OTHERS THEN
         CIDRAMO := '777';
  END;
  --
  INSERT INTO FONDEO
   (CODCIA,             CODEMPRESA,       IDSINIESTRO,         IDDETSIN,
    NUM_APROBACION,     BENEF,            NUM_CHEQUE,          NUM_REFERENCIA,
    IDTIPO_PAGO,        FEC_PAGO_MOVTO,   FEC_PAGO_REAL,       ID_GRUPO_FONDEO,
    ST_FONDEO,          FEC_FONDEO,       USUARIO_FONDEO,      MONTO_MONEDA,
    ST_FINIQUITO,       FEC_REGISTRO,     USUARIO_REGISTRO,    FEC_IMPRESION,
    USUARIO_IMPRESION,  MOTIVO_RECHAZO,   FEC_PAGO_PROGRAMADA, IDPROC,
    IDRAMO)
  VALUES
   (PCODCIA,            PCODEMPRESA,      PIDSINIESTRO,        PIDDETSIN,
    PNUM_APROBACION,    PBENEF,           '',                  '',
    PIDTIPO_PAGO,       PFEC_PAGO_MOVTO,  '',                  '',
    'PEN',              '',               '',                  PMONTO_MONEDA,
    'PEN',              '',               '',                   '',
    '',                 '',               '',                   '',
    CIDRAMO);
  --
  NINSERTADOS := SQL%ROWCOUNT;
  --
  IF NINSERTADOS = 0 THEN
     PMENSAJE := 'NO SE GRABARON REGISTROS EN CONTROL_CAMBIO_DATOS';
  END IF; 
END INSERTA;
--
--
END TH_FONDEO;
