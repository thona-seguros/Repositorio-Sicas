CREATE OR REPLACE PACKAGE TH_CONTROL_CAMBIO_DATOS IS

PROCEDURE INSERTA_CAMBIO(PCODCIA              NUMBER,
                         PCODEMPRESA          NUMBER,
                         PIDPOLIZA            NUMBER,
                         PIDSINIESTRO         NUMBER,
                         PIDCAMPO             VARCHAR2,
                         PIDTABLA             VARCHAR2,
                         PVALORANTERIOR       VARCHAR2,
                         PVALORNUEVO          VARCHAR2,
                         PUSUARIO_SOLICITANTE VARCHAR2,
                         PMOTIVO              VARCHAR2,
                         PMENSAJE         OUT VARCHAR2);

END TH_CONTROL_CAMBIO_DATOS;

/

CREATE OR REPLACE PACKAGE BODY TH_CONTROL_CAMBIO_DATOS IS
--
-- BITACORA DE CAMBIO
-- 
-- 
PROCEDURE INSERTA_CAMBIO(PCODCIA              NUMBER,
                         PCODEMPRESA          NUMBER,
                         PIDPOLIZA            NUMBER,
                         PIDSINIESTRO         NUMBER,
                         PIDCAMPO             VARCHAR2,
                         PIDTABLA             VARCHAR2,
                         PVALORANTERIOR       VARCHAR2,
                         PVALORNUEVO          VARCHAR2,
                         PUSUARIO_SOLICITANTE VARCHAR2,
                         PMOTIVO              VARCHAR2,
                         PMENSAJE         OUT VARCHAR2) IS
--
NINSERTADOS    NUMBER;
--                         
BEGIN
	--
  NINSERTADOS := 0;
  PMENSAJE    := '';
  --
  INSERT INTO CONTROL_CAMBIO_DATOS
   (CODCIA,               CODEMPRESA,        IDPOLIZA,
    IDSINIESTRO,          IDCAMPO,           IDTABLA,
    VALORANTERIOR,        VALORNUEVO,        USUARIO_SOLICITANTE,
    USUARIO_REGISTRO,     FECHAREGISTRO,     MOTIVO)
  VALUES
   (PCODCIA,              PCODEMPRESA,       PIDPOLIZA,
    PIDSINIESTRO,         PIDCAMPO,          PIDTABLA,
    PVALORANTERIOR,       PVALORNUEVO,       PUSUARIO_SOLICITANTE,
    USER,                 TRUNC(SYSDATE),    PMOTIVO
   );
  --
  NINSERTADOS := SQL%ROWCOUNT;
  --
  IF NINSERTADOS = 0 THEN
     PMENSAJE := 'NO SE GRABARON REGISTROS EN CONTROL_CAMBIO_DATOS';
  END IF; 
END INSERTA_CAMBIO;
--
--
END TH_CONTROL_CAMBIO_DATOS;
