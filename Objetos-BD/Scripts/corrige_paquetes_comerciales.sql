

DECLARE
   CURSOR PAQ_COMERCIAL_Q IS
      SELECT CODPAQUETE, IDTIPOSEG, PLANCOB
        FROM PAQUETE_COMERCIAL
       WHERE CODPAQUETE < 100;

nIdCotizacion COTIZACIONES.IdCotizacion%TYPE;           
BEGIN
   FOR W IN PAQ_COMERCIAL_Q LOOP
      BEGIN
         SELECT NVL(IdCotizacion ,0)
           INTO nIdCotizacion
           FROM COTIZACIONES
          WHERE IdCotizacion = W.CODPAQUETE;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdCotizacion := 0;
      END;
      IF nIdCotizacion != 0 THEN
         DBMS_OUTPUT.PUT_LINE(nIdCotizacion);
         UPDATE COTIZACIONES 
            SET CODPAQCOMERCIAL = W.CODPAQUETE
          WHERE IdCotizacion = nIdCotizacion;
      END IF;
   END LOOP;
END;


DECLARE
CURSOR COT_ANT_Q IS
   SELECT IdCotizacion, NumCotizacionAnt
     FROM COTIZACIONES
    WHERE NumCotizacionAnt IN (SELECT CodPaquete
                                 FROM PAQUETE_COMERCIAL
                                WHERE CODPAQUETE < 100);
                                
cCodPaquete    PAQUETE_COMERCIAL.CodPaquete%TYPE; 
nCuenta        NUMBER := 0;
BEGIN
   FOR W IN COT_ANT_Q LOOP
      BEGIN
         SELECT NVL(CodPaquete,0)
           INTO cCodPaquete
           FROM PAQUETE_COMERCIAL 
          WHERE CodPaquete = W.NumCotizacionAnt;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN 
            cCodPaquete := 0;
      END;
      IF cCodPaquete != 0 THEN
         nCuenta := nCuenta + 1;
         DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO COTIZACION '||W.IdCotizacion||' nCuenta '||nCuenta);
         UPDATE COTIZACIONES
            SET CodPaqComercial  = cCodPaquete,
                CodPaquete       = cCodPaquete
          WHERE IdCotizacion = W.IdCotizacion;
      END IF;
   END LOOP;
END;



DECLARE
CURSOR POL_Q IS
   SELECT P.IdPoliza, P.Num_Cotizacion, C.NumCotizacionAnt, C.CodPaquete, C.CodPaqComercial 
     FROM POLIZAS P, COTIZACIONES C
    WHERE P.CodCia         = C.CodCia
      AND P.CodEmpresa     = C.CodEmpresa
      AND P.Num_Cotizacion = C.IdCotizacion
      AND C.CodPaqComercial  IS NOT NULL;

nCuenta        NUMBER := 0;      
BEGIN
   FOR W IN POL_Q LOOP
      nCuenta := nCuenta +1 ;
      UPDATE POLIZAS
         SET CodPaqComercial = W.CodPaquete
       WHERE IdPoliza   = W.IdPoliza;
       DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO POLIZA '||W.IdPoliza||' nCuenta '||nCuenta);
   END LOOP;
END;
