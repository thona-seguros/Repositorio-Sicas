CREATE OR REPLACE PACKAGE OC_NOTAS_DE_CREDITO_POLIZA IS

  FUNCTION INSERTA_NOTA_CREDITO(nCodCia NUMBER, nIdPoliza NUMBER,nCodCliente NUMBER, dFecNcr DATE,nCodAgente NUMBER) RETURN NUMBER;

  PROCEDURE EMITIR(nIdNcrPol NUMBER, cNumNcr VARCHAR2);

PROCEDURE ACTUALIZA_NOTA(nIdNcrPol NUMBER);
END OC_NOTAS_DE_CREDITO_POLIZA;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_NOTAS_DE_CREDITO_POLIZA IS

FUNCTION INSERTA_NOTA_CREDITO(nCodCia NUMBER, nIdPoliza NUMBER,nCodCliente NUMBER, dFecNcr DATE,nCodAgente NUMBER) RETURN NUMBER IS
nIdNcrPol                     NOTAS_DE_CREDITO.IdNcr%TYPE;
cCodTipoDoc                   TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
BEGIN
   -- Inserta Notas de Crédito solamente con Prima
   SELECT NVL(MAX(IdNcrPol),0)+1
     INTO nIdNcrPol
     FROM NOTAS_DE_CREDITO_POLIZA;

   BEGIN
      SELECT CodTipoDoc
          INTO cCodTipoDoc
        FROM TIPO_DE_DOCUMENTO
       WHERE CodClase = 'NC'
         AND Sugerido = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          cCodTipoDoc := NULL;
   END;

   BEGIN
      INSERT INTO NOTAS_DE_CREDITO_POLIZA
             (IdNcrPol, IdPoliza,  CodCliente, NumNcr, FecDevol, StsNcr, FecSts,  CodTipoDoc,Cod_Agente,CodCia)
      VALUES (nIdNcrPol, nIdPoliza, nCodCliente, NULL, dFecNcr, 'XEM', TRUNC(SYSDATE),cCodTipoDoc, nCodAgente, nCodCia );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Nota de Credito No.: '||TRIM(TO_CHAR(nIdNcrPol))|| ' ' ||SQLERRM);
   END;
   RETURN(nIdNcrPol);
END INSERTA_NOTA_CREDITO;



PROCEDURE EMITIR(nIdNcrPol NUMBER, cNumNcr VARCHAR2) IS
BEGIN
   UPDATE NOTAS_DE_CREDITO_POLIZA
      SET StsNcr = 'EMI',
          NumNcr = cNumNcr,
          FecSts = TRUNC(SYSDATE)
    WHERE IdNcrPol  = nIdNcrPol;
END EMITIR;

PROCEDURE ACTUALIZA_NOTA(nIdNcrPol NUMBER) IS
nMtoTotal         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoTotalMoneda   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoComisi_Local   NOTAS_DE_CREDITO.MtoComisi_Local%TYPE;
nMtoComisi_Moneda  NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
BEGIN

   SELECT SUM(Monto_Ncr_Local),SUM(Monto_Ncr_Moneda),SUM(MtoComisi_Local),SUM(MtoComisi_Moneda)
     INTO nMtoTotal, nMtoTotalMoneda,nMtoComisi_Local,nMtoComisi_Moneda
     FROM NOTAS_DE_CREDITO
    WHERE IdNcrPol = nIdNcrPol;

   UPDATE NOTAS_DE_CREDITO_POLIZA
      SET Monto_Ncr_Local  = nMtoTotal,
          Monto_Ncr_Moneda = nMtoTotalMoneda,
          MtoComisi_Local  = nMtoComisi_Local,
          MtoComisi_Moneda = nMtoComisi_Moneda
    WHERE IdNcrPol = nIdNcrPol;

END ACTUALIZA_NOTA;



END OC_NOTAS_DE_CREDITO_POLIZA;
