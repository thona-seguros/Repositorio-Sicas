CREATE OR REPLACE PACKAGE          OC_DIAS_ATENCION_SINI AS
    FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
    PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cStsAtencion VARCHAR2);
END OC_DIAS_ATENCION_SINI;
/

CREATE OR REPLACE PACKAGE BODY          OC_DIAS_ATENCION_SINI AS

    FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER)  RETURN VARCHAR2 IS
        nNumDiasAtn DIAS_ATENCION_SINI.NumDiasAtn%TYPE;
    BEGIN
       BEGIN
          SELECT NVL(NumDiasAtn,'NO EXISTE')
            INTO nNumDiasAtn
            FROM DIAS_ATENCION_SINI
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             --AND CodCliente = nCodCliente
             AND IdPoliza   = nIdPoliza
             ;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
             nNumDiasAtn := 'NO EXISTE';
       END; 
       RETURN nNumDiasAtn;
    END DESCRIPCION;

    PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cStsAtencion VARCHAR2) IS
    BEGIN
       UPDATE DIAS_ATENCION_SINI
          SET StsAtencion       = cStsAtencion,
              FecUltActualiza   = TRUNC(SYSDATE),
              UserUltActualiza  = USER
        WHERE CodCia         = nCodCia
          AND CodEmpresa     = nCodEmpresa
          --AND CodCliente     = nCodCliente
          AND IdPoliza   = nIdPoliza
          ;
    END ACTUALIZA_ESTATUS;   
END OC_DIAS_ATENCION_SINI;
