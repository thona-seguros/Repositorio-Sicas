CREATE OR REPLACE PACKAGE OC_TICKET_POLIZA AS
FUNCTION POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, dFecRegistro DATE) RETURN NUMBER;
PROCEDURE INSERTAR( nCodCia      TICKET_POLIZA.CodCia%TYPE
                  , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                  , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                  , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                  , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE
                  , cIdTipoSeg   TICKET_POLIZA.IdTipoSeg%TYPE
                  , cStsPoliza   TICKET_POLIZA.StsPoliza%TYPE );
PROCEDURE EMITIR( nCodCia      TICKET_POLIZA.CodCia%TYPE
                , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE);
FUNCTION POLIZA_EMITIDA ( nCodCia      TICKET_POLIZA.CodCia%TYPE
                        , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                        , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                        , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                        , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE) RETURN VARCHAR2;

END OC_TICKET_POLIZA;

/

CREATE OR REPLACE PACKAGE BODY OC_TICKET_POLIZA AS
FUNCTION POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, dFecRegistro DATE) RETURN NUMBER IS
nIdPoliza TICKET_POLIZA.IdPoliza%TYPE;
BEGIN 
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   BEGIN 
      SELECT NVL(T.IdPoliza,0)
        INTO nIdPoliza
        FROM TICKET_POLIZA T, POLIZAS P
       WHERE T.CodCia                           = nCodCia
         AND T.CodEmpresa                       = nCodEmpresa
         AND T.CodCliente                       = nCodCliente
         AND TO_DATE(T.FecIniVig,'DD/MM/YYYY')  = TO_DATE(dFecRegistro,'DD/MM/YYYY')  + 1
         AND T.CodCia                           = P.CodCia
         AND T.CodEmpresa                       = P.CodEmpresa
         AND T.IdPoliza                         = P.IdPoliza
         AND TO_DATE(T.FecIniVig,'DD/MM/YYYY')  = TO_DATE(P.FecIniVig,'DD/MM/YYYY');
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         nIdPoliza := 0;
      WHEN TOO_MANY_ROWS THEN 
         RAISE_APPLICATION_ERROR(-20100,'Exsite más de una póliza configurada para la fecha '||dFecRegistro||' Por favor contacte con su administrador de sistemas');
   END;
   RETURN nIdPoliza;
END POLIZA;
--
PROCEDURE INSERTAR( nCodCia      TICKET_POLIZA.CodCia%TYPE
                  , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                  , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                  , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                  , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE
                  , cIdTipoSeg   TICKET_POLIZA.IdTipoSeg%TYPE
                  , cStsPoliza   TICKET_POLIZA.StsPoliza%TYPE ) IS
BEGIN
   INSERT INTO TICKET_POLIZA
        VALUES ( nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, dFecIniVig, cIdTipoSeg, cStsPoliza, USER, SYSDATE ); 
END INSERTAR;

PROCEDURE EMITIR( nCodCia      TICKET_POLIZA.CodCia%TYPE
                , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE) IS
BEGIN
   UPDATE TICKET_POLIZA
      SET StsPoliza = 'EMI'
    WHERE CodCia                          = nCodCia
      AND CodEmpresa                      = nCodEmpresa
      AND CodCliente                      = nCodCliente
      AND IdPoliza                        = nIdPoliza
      AND TO_DATE(FecIniVig,'DD/MM/YYYY') = TO_DATE(dFecIniVig,'DD/MM/YYYY');                
END EMITIR;

FUNCTION POLIZA_EMITIDA ( nCodCia      TICKET_POLIZA.CodCia%TYPE
                        , nCodEmpresa  TICKET_POLIZA.CodEmpresa%TYPE
                        , nCodCliente  TICKET_POLIZA.CodCliente%TYPE
                        , nIdPoliza    TICKET_POLIZA.IdPoliza%TYPE
                        , dFecIniVig   TICKET_POLIZA.FecIniVig%TYPE) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);                        
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TICKET_POLIZA
       WHERE CodCia                          = nCodCia
         AND CodEmpresa                      = nCodEmpresa
         AND CodCliente                      = nCodCliente
         AND IdPoliza                        = nIdPoliza
         AND TO_DATE(FecIniVig,'DD/MM/YYYY') = TO_DATE(dFecIniVig,'DD/MM/YYYY')
         AND StsPoliza                       = 'EMI';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
   END;
   RETURN cExiste;
END;

END OC_TICKET_POLIZA;
