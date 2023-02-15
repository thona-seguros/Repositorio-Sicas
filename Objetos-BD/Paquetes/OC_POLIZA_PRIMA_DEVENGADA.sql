CREATE OR REPLACE PACKAGE OC_POLIZA_PRIMA_DEVENGADA AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 24/03/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_POLIZA_PRIMA_DEVENGADA                                                                                        |
    | Objetivo   : Package obtiene informacion de las Primas devengadas de cada poliza en el transcurso del tiempo. Sera explotada  |
    |              por herramienta BI. Contiene carga inicial y procesos de actualizacion de la información.                        |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

PROCEDURE CARGA_PRIMA_DEVENGADA (nCodCia   NUMBER, nCodEmpresa   NUMBER, nIdPolizaG  NUMBER);

PROCEDURE PRIMA_DEVENGADA_GENERA (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER);

PROCEDURE PRIMA_DEVENGADA_CANCELAR (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER);

PROCEDURE PRIMA_DEVENGADA_REVERTIR (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER);


END OC_POLIZA_PRIMA_DEVENGADA;

/

CREATE OR REPLACE PACKAGE BODY OC_POLIZA_PRIMA_DEVENGADA AS

PROCEDURE CARGA_PRIMA_DEVENGADA (nCodCia   NUMBER, nCodEmpresa   NUMBER,   nIdPolizaG  NUMBER) IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 24/03/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CARGA_PRIMA_DEVENGADA                                                                                            |
    | Objetivo   : Procedimiento de Carga Inicial de datos de Primas Devengadas para aquellas Polizas que no esten como Solicitud   |
    |              ( stspoliza <> 'SOL')  y que tengan Prima Neta (Prima No Nula) hasta el momento de la ejecución en Tabla nueva.  |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
    |           nCodCia             Codigo de Compañia                  (Entrada)                                                   |
    |           nCodEmpresa         Codigo de Empresa                   (Salida)                                                    |
    |           nIdPolizaG          Numero de poliza a Cargar           (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/ 
nNumDia     NUMBER := 0;
nIdPoliza   NUMBER := 0;

CURSOR Cur_PolDev IS
    SELECT  IdPoliza,
            StsPoliza,
            FecIni,
            FecFin,
            FecAnula,
            fecha_termino,
            prima,
            diast,
            diasc,
            DECODE( diast, 0, 0, TRUNC(prima/DECODE(diast,0,1,diast),8))   PRIMA_DEVENGADA,
            CodCia,
            CodEmpresa
    FROM    (SELECT IdPoliza,
                    StsPoliza,
                    --TO_DATE(TO_CHAR(TRUNC(FecIniVig)), 'DD/MM/RRRR') FECINI,
                    --TO_DATE(TO_CHAR(TRUNC(FecFinVig)), 'DD/MM/RRRR') FECFIN,
                    --TO_DATE(TO_CHAR(TRUNC(FecAnul)), 'DD/MM/RRRR')   FECANULA,
                    FecIniVig       FECINI,
                    FecFinVig       FECFIN, 
                    FecAnul         FECANULA,
                    primaneta_local                                     PRIMA,
                    TO_DATE(TO_CHAR(TRUNC(NVL(FecAnul, FecFinVig))), 'DD/MM/YYYY')  FECHA_TERMINO,
                    CASE WHEN FecIniVig = FecFinVig AND FecAnul  = FecFinVig THEN 1
                         WHEN FecIniVig < FecFinVig AND FecAnul <= FecIniVig THEN 0 
                         WHEN FecIniVig = FecFinVig AND FecAnul IS NULL THEN 1
                         WHEN FecIniVig < FecFinVig AND FecIniVig = FecAnul THEN 0                         
                      ELSE TRUNC((NVL(TO_DATE(TO_CHAR(TRUNC(FecAnul)), 'DD/MM/YYYY'), TO_DATE(TO_CHAR(TRUNC(FecFinVig)), 'DD/MM/YYYY')) - TO_DATE(TO_CHAR(TRUNC(FecIniVig)), 'DD/MM/YYYY') ))+1
                    END  DIAST,
                    CASE WHEN FecIniVig = FecFinVig AND FecAnul  = FecFinVig THEN 1
                         WHEN FecIniVig < FecFinVig AND FecAnul <= FecIniVig THEN 0 
                         WHEN FecIniVig = FecFinVig AND FecAnul IS NULL THEN 1
                         WHEN FecIniVig < FecFinVig AND FecIniVig = FecAnul THEN 0
                         WHEN FecIniVig < FecFinVig AND FecAnul IS NULL AND SYSDATE < FecFinVig  THEN TRUNC(SYSDATE) - TRUNC(fecIniVig)
                      ELSE TRUNC((NVL(TO_DATE(TO_CHAR(TRUNC(FecAnul)), 'DD/MM/YYYY'), TO_DATE(TO_CHAR(TRUNC(FecFinVig)), 'DD/MM/YYYY')) - TO_DATE(TO_CHAR(TRUNC(FecIniVig)), 'DD/MM/YYYY') ))+1
                    END DIASC,
                    CodCia,
                    CodEmpresa
             FROM   POLIZAS
             WHERE  stspoliza <> 'SOL'
             AND    primaneta_local IS NOT NULL
             AND    CodCia     = nCodCia
             AND    CodEmpresa = nCodEmpresa
             AND    IdPoliza   = NVL(nIdPolizaG, IdPoliza)
            ORDER BY IdPoliza
            );
BEGIN
    FOR i IN Cur_PolDev LOOP
        FOR j IN (  --SELECT TO_DATE(TO_CHAR(TRUNC(i.FecIni)), 'DD/MM/RRRR') + rownum - 1 AS dia_mes
                    SELECT i.FecIni + rownum - 1 AS dia_mes
                    FROM DUAL
                    CONNECT BY LEVEL <= i.diast --> i.diasc
                  ) LOOP                                 
                        BEGIN
                                INSERT INTO POLIZA_PRIMA_DEVENGADA (idPoliza,
                                                                    FecDevenga,
                                                                    StsPolDev,
                                                                    FecIniVig,
                                                                    FecFinVig,
                                                                    FecAnula,                                                        
                                                                    DiaDevenga,
                                                                    PrimaDevenga,
                                                                    CodCia,
                                                                    CodEmpresa,
                                                                    FecRegistro,
                                                                    UserRegistro
                                                                    )
                                                            VALUES (i.IdPoliza,
                                                                    j.dia_mes,
                                                                    i.StsPoliza,
                                                                    i.FecIni,
                                                                    i.FecFin,
                                                                    i.FecAnula,                                                        
                                                                    nNumDia,
                                                                    DECODE(i.diast, 0, 0, i.prima_devengada),
                                                                    i.CodCia,
                                                                    i.CodEmpresa,
                                                                    SYSDATE,
                                                                    USER
                                                                    );
                                nNumDia := nNumDia + 1;
                                nIdPoliza := i.IdPoliza;

                        EXCEPTION
                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('Error en CARGA_PRIMA_DEVENGADA : '||SQLERRM);
                                DBMS_OUTPUT.PUT_LINE('Poliza        -> '||i.IdPoliza);
                                DBMS_OUTPUT.PUT_LINE('FecDevenga    -> '||j.dia_mes);
                                DBMS_OUTPUT.PUT_LINE('DiaDevenga    -> '||nNumDia-1);
                                DBMS_OUTPUT.PUT_LINE('PrimaDevenga  -> '||i.prima);
                                DBMS_OUTPUT.PUT_LINE('FecRegistro   -> '||SYSDATE);
                                DBMS_OUTPUT.PUT_LINE('UserRegistro  -> '||USER);
                        END;
                        --EXIT WHEN dia_mes = TRUNC(SYSDATE)-1; --> Evita registros igaules o superiores al dia de proceso.
        END LOOP;
        nNumDia := 0;        
    END LOOP;    

END CARGA_PRIMA_DEVENGADA;


PROCEDURE PRIMA_DEVENGADA_GENERA (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER) IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/03/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : PRIMA_DEVENGADA_GENERA                                                                                           |
    | Objetivo   : Procedimiento de Genera los datos de las Primas Devengadas para aquellas Polizas nuevas que No son 'SOL' y que   |
    |              No tienen Prima Neta Local en Cero.                                                                              |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
    |           nCodCia             Codigo de Compañia                  (Entrada)                                                   |
    |           nCodEmpresa         Codigo de Empresa                   (Entrada)                                                   |
    |           nIdPoliza           Numero de Poliza                    (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/ 
BEGIN    
    --> Genera Prima Nueva:
    OC_POLIZA_PRIMA_DEVENGADA.CARGA_PRIMA_DEVENGADA (nCodCia, nCodEmpresa, nIdPoliza);

    EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error en PRIMA_DEVENGADA_GENERA : '||SQLERRM);
                DBMS_OUTPUT.PUT_LINE('Poliza        -> '||nIdPoliza);
                DBMS_OUTPUT.PUT_LINE('Fecha Intento -> Igual o Mayor que '||TRUNC(SYSDATE));

END PRIMA_DEVENGADA_GENERA;

PROCEDURE PRIMA_DEVENGADA_CANCELAR (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER) IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/03/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : PRIMA_DEVENGADA_CANCELAR                                                                                         |
    | Objetivo   : Procedimiento de Cancela o Anula la Prima Devengada que coincida con el criterio.                                |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
    |           nCodCia             Codigo de Compañia                  (Entrada)                                                   |
    |           nCodEmpresa         Codigo de Empresa                   (Entrada)                                                   |
    |           nIdPoliza           Numero de Poliza                    (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/

cStsPoliza  POLIZAS.StsPoliza%TYPE;
dFecAnula   POLIZAS.FecAnul%TYPE;

BEGIN
    SELECT  StsPoliza, FecAnul
    INTO    cStsPoliza, dFecAnula
    FROM    POLIZAS
    WHERE   IdPoliza   = nIdPoliza
    AND     CodCia     = nCodCia
    AND     CodEmpresa = nCodEmpresa;

    --> Actualiza Status y Fecha de Anulacion
    UPDATE POLIZA_PRIMA_DEVENGADA
    SET     StsPolDev        = cStsPoliza,
            FecAnula         = dFecAnula,
            FecUltActualiza  = SYSDATE,
            UserUltActualiza = USER
    WHERE   IdPoliza   = nIdPoliza
    AND     TO_DATE(TO_CHAR(FecDevenga), 'DD/MM/RRRR') >= TRUNC(SYSDATE)
    AND     CodCia     = nCodCia
    AND     CodEmpresa = nCodEmpresa;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error en PRIMA_DEVENGADA_CANCELAR : '||SQLERRM);
                DBMS_OUTPUT.PUT_LINE('Poliza        -> '||nIdPoliza);
                DBMS_OUTPUT.PUT_LINE('StsPoliza     -> '||cStsPoliza);
                DBMS_OUTPUT.PUT_LINE('FecDevenga    -> Igual o Mayor que '||TRUNC(SYSDATE));
                DBMS_OUTPUT.PUT_LINE('FecAnul       -> '||TO_DATE(TO_CHAR(dFecAnula), 'DD/MM/RRRR'));
                DBMS_OUTPUT.PUT_LINE('UserRegistro  -> '||USER);

END PRIMA_DEVENGADA_CANCELAR;


PROCEDURE PRIMA_DEVENGADA_REVERTIR (nCodCia  NUMBER, nCodEmpresa NUMBER, nIdPoliza   NUMBER) IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/03/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : PRIMA_DEVENGADA_REVERTIR                                                                                         |
    | Objetivo   : Procedimiento de Revierte o Elimina los datos de las Primas Devengadas para aquellas Polizas que hayan sido      |
    |              Revertidas o Canceladas.                                                                                         |                                                                                                     |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
    |           nCodCia             Codigo de Compañia                  (Entrada)                                                   |
    |           nCodEmpresa         Codigo de Empresa                   (Entrada)                                                   |
    |           nIdPoliza           Numero de Poliza a Revertir          (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/ 
BEGIN
    DELETE  POLIZA_PRIMA_DEVENGADA
    WHERE   IdPoliza   = nIdPoliza
    AND     CodCia     = nCodCia
    AND     CodEmpresa = nCodEmpresa;

    EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error en PRIMA_DEVENGADA_REVERTIR : '||SQLERRM);
                DBMS_OUTPUT.PUT_LINE('Poliza        -> '||nIdPoliza);
                DBMS_OUTPUT.PUT_LINE('FecDevenga    -> '||TRUNC(SYSDATE));
                DBMS_OUTPUT.PUT_LINE('UserRegistro  -> '||USER);

END PRIMA_DEVENGADA_REVERTIR;


END OC_POLIZA_PRIMA_DEVENGADA;
