CREATE OR REPLACE PACKAGE          OC_OBSERVACION_SINIESTRO IS

PROCEDURE INSERTA_OBSERVACION(nIdSiniestro NUMBER, nIdPoliza NUMBER, cObservacion VARCHAR2);

END OC_OBSERVACION_SINIESTRO;
/

CREATE OR REPLACE PACKAGE BODY          OC_OBSERVACION_SINIESTRO IS

PROCEDURE INSERTA_OBSERVACION(nIdSiniestro NUMBER, nIdPoliza NUMBER, cObservacion VARCHAR2) IS
nIdObserva        OBSERVACION_SINIESTRO.IdObserva%TYPE;
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;
BEGIN
   SELECT NVL(MAX(IdObserva),0) + 1
     INTO nIdObserva
     FROM OBSERVACION_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro
      AND IdPoliza    = nIdPoliza;
      
    BEGIN
   select NVL(CODEMPRESA,1),NVL(CODCIA,1)
     into cCodEmpresa, cCodCia
     from siniestro
     where idsiniestro = nIdSiniestro
     and idpoliza     = nIdPoliza;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-202,'No existe compañia:'||SQLERRM);
  END;
      
  cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
  cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'SINOBS');
  dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
  dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);
   
  
   IF cIndFecEquivPro = 'S' THEN
    
      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;
      
    ELSE
    
     dFechaCamb := dFechaReal;
     
   end if;

   INSERT INTO OBSERVACION_SINIESTRO
          (IdSiniestro, IdPoliza, IdObserva, FecObserv, CodUsuario, Descripcion)
   VALUES (nIdSiniestro, nIdPoliza, nIdObserva, dFechaCamb, USER, cObservacion);
END INSERTA_OBSERVACION;

END OC_OBSERVACION_SINIESTRO;
