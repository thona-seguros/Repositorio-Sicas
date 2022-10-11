--
-- OC_CRITERIOS_VAL_SINI  (Package) 
--
CREATE OR REPLACE PACKAGE OC_CRITERIOS_VAL_SINI AS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/Mar/2022                                                                                                      |    
    | Nombre     : OC_CRITERIOS_VAL_SINI                                                                                                |
    | Objetivo   : Paquete que realiza las diferentes acciones para el uso de los dis diferentes Criterios validos para Siniestros. |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    |_______________________________________________________________________________________________________________________________|
*/
FUNCTION EXISTE_VAL_CRITERIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER) RETURN VARCHAR2;
FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER, nIdCriterio NUMBER) RETURN VARCHAR2;
PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER, nIdCriterio NUMBER, cSts VARCHAR2);
FUNCTION ROL_SINI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

END OC_CRITERIOS_VAL_SINI;

/

--
-- OC_CRITERIOS_VAL_SINI  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CRITERIOS_VAL_SINI FOR OC_CRITERIOS_VAL_SINI
/


GRANT EXECUTE ON OC_CRITERIOS_VAL_SINI TO PUBLIC
/
DROP PACKAGE BODY OC_CRITERIOS_VAL_SINI
/

--
-- OC_CRITERIOS_VAL_SINI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY OC_CRITERIOS_VAL_SINI AS
FUNCTION EXISTE_VAL_CRITERIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/Mar/2022                                                                                                      |    
    | Nombre     : EXISTE_VAL_CRITERIO                                                                                              |
    | Objetivo   : Funcion que valida la existencia del Valor del Criterio dado en el catalogo de Criterios autorizados a la        |
    |              operacion del Siniestros que corresponda.                                                                        |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                Codigo de la Compañia        (Entrada)                                                           |
    |            nCodEmpresa            Codigo de la Empresa        (Entrada)                                                           |
    |           nIdValCriterio      Identificador del Criterio  (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
cExiste  VARCHAR2(1);
BEGIN
  BEGIN
        SELECT  'S'
        INTO    cExiste
        FROM    CRITERIOS_VAL_SINI
        WHERE   CodCia          = nCodCia
        AND     CodEmpresa      = nCodEmpresa
        AND     IdValCriterio   = nIdValCriterio;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
     WHEN TOO_MANY_ROWS THEN
        cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_VAL_CRITERIO;

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER, nIdCriterio NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/Mar/2022                                                                                                      |
    | Nombre     : DESCRIPCION                                                                                                      |
    | Objetivo   : Funcion que obtiene la descripcion del Criterio aplicable a la operacion de Siniestros que corresponda.          |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                Codigo de la Compañia                   (Entrada)                                               |
    |            nCodEmpresa            Codigo de la Empresa                    (Entrada)                                               |
    |           nIdValCriterio      Identificador del Valor del Criterio    (Entrada)                                               |
    |           nIdCriterio         Identificador del Criterio              (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/
cDescripcion    CRITERIOS_VAL_SINI.Descripcion%TYPE;
BEGIN
   BEGIN
        SELECT  NVL(Descripcion,'NO EXISTE')
        INTO    cDescripcion
        FROM    CRITERIOS_VAL_SINI
        WHERE   CodCia          = nCodCia
        AND     CodEmpresa      = nCodEmpresa
        AND     IdValCriterio   = nIdValCriterio
        AND     IdCriterio      = nIdCriterio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cDescripcion := 'NO EXISTE';
   END; 
   RETURN cDescripcion;
END DESCRIPCION;

PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdValCriterio NUMBER, nIdCriterio NUMBER, cSts VARCHAR2) IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/Mar/2022                                                                                                      |    
    | Nombre     : ACTUALIZA_ESTATUS                                                                                                |
    | Objetivo   : Procedimiento que actualiza el Estado del Criterio aplicable a la operacion de Siniestros que corresponda.       |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                Codigo de la Compañia                    (Entrada)                                               |
    |            nCodEmpresa            Codigo de la Empresa                    (Entrada)                                               |
    |           nIdValCriterio      Identificador del Valor del Criterio    (Entrada)                                               |
    |           nIdCriterio         Identificador del Criterio              (Entrada)                                               |
    |           cSts                Valor del Estado actual a Modificar     (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/
BEGIN
    UPDATE  CRITERIOS_VAL_SINI
    SET     StsValCriterio    = cSts,
            FecUltActualiza   = TRUNC(SYSDATE),
            userultactualiza  = USER
    WHERE   CodCia      = nCodCia
    AND     CodEmpresa  = nCodEmpresa
    AND     IdValCriterio   = nIdValCriterio
    AND     IdCriterio      = nIdCriterio;
END ACTUALIZA_ESTATUS;

FUNCTION ROL_SINI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER)
RETURN NUMBER IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 22/Mar/2022                                                                                                      |
    | Nombre     : ROL_SINI                                                                                                         |
    | Objetivo   : Funcion que obtiene el Rol de la poliza revisando por Orden de Criterios aplicable a la operacion de Siniestros  |
    |              que corresponda.                                                                                                 |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                Codigo de la Compañia                   (Entrada)                                               |
    |            nCodEmpresa            Codigo de la Empresa                    (Entrada)                                               |
    |           nIdPoliza           Número de Póliza                        (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/
nRol    CRITERIOS_VAL_SINI.IdRol%TYPE;
BEGIN
   BEGIN
        -- I) Agrupador
            BEGIN
                SELECT  V.IdRol
                INTO    nRol
                FROM    CRITERIOS_VAL_SINI  V,
                        CRITERIOS_SINI      C
                WHERE   V.IdCriterio = C.IdCriterio
                AND     V.CodCia     = C.CodCia
                AND     V.CodEmpresa = C.CodEmpresa
                AND     V.CodCia     = nCodCia
                AND     V.CodEmpresa = nCodEmpresa
                AND     C.orden = 1     --> Agrupador
                --AND     idCriterio = 1  
                AND     valor IN (SELECT  P.CodAgrupador
                                  FROM    POLIZAS P
                                  WHERE   P.CodCia     = nCodCia
                                  AND     P.CodEmpresa = nCodEmpresa
                                  AND     P.IdPoliza   = nIdPoliza   -- 34938
                                  );
            EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                     nRol := 0;
            END;
            IF nRol = 0 THEN 
            -- II) Contratante
                BEGIN
                    SELECT  V.IdRol
                    INTO    nRol
                    FROM    CRITERIOS_VAL_SINI  V,
                            CRITERIOS_SINI      C
                    WHERE   V.IdCriterio = C.IdCriterio
                    AND     V.CodCia     = C.CodCia
                    AND     V.CodEmpresa = C.CodEmpresa
                    AND     V.CodCia     = nCodCia
                    AND     V.CodEmpresa = nCodEmpresa
                    AND     C.orden = 2     --> Contratante: 8777776
                    --AND     idCriterio = 1  
                    AND     valor IN (SELECT  TO_CHAR(P.CodCliente)
                                      FROM    POLIZAS P
                                      WHERE   P.CodCia     = nCodCia
                                      AND     P.CodEmpresa = nCodEmpresa
                                      AND     P.IdPoliza   = nIdPoliza   -- 40433
                                      );
                    EXCEPTION
                          WHEN NO_DATA_FOUND THEN 
                             nRol := 0;
                END;
                IF nRol = 0 THEN                
                -- III) Poliza
                    BEGIN
                        SELECT  V.IdRol
                        INTO    nRol
                        FROM    CRITERIOS_VAL_SINI  V,
                                CRITERIOS_SINI      C
                        WHERE   V.IdCriterio = C.IdCriterio
                        AND     V.CodCia     = C.CodCia
                        AND     V.CodEmpresa = C.CodEmpresa
                        AND     V.CodCia     = nCodCia
                        AND     V.CodEmpresa = nCodEmpresa
                        AND     C.orden = 3     --> Poliza: 40749
                        --AND     idCriterio = 1  
                        AND     valor IN (SELECT  TO_CHAR(P.IdPoliza)
                                          FROM    POLIZAS P
                                          WHERE   P.CodCia     = nCodCia
                                          AND     P.CodEmpresa = nCodEmpresa
                                          AND     P.IdPoliza   = nIdPoliza   -- 40749
                                          );
                        EXCEPTION
                              WHEN NO_DATA_FOUND THEN 
                                 nRol := 0;
                    END;
                    IF nRol = 0 THEN
                    -- IV) Tipo de Seguro
                        BEGIN
                            SELECT  V.IdRol
                            INTO    nRol
                            FROM    CRITERIOS_VAL_SINI  V,
                                    CRITERIOS_SINI      C
                            WHERE   C.IdCriterio = V.IdCriterio
                            AND     V.CodCia     = C.CodCia
                            AND     V.CodEmpresa = C.CodEmpresa
                            AND     V.CodCia     = nCodCia
                            AND     V.CodEmpresa = nCodEmpresa
                            AND     C.orden = 5
                            --AND     idCriterio = 1  
                            AND     valor IN (SELECT  DP.IdTipoSeg
                                              FROM    DETALLE_POLIZA  DP
                                              WHERE   DP.CodCia     = nCodCia
                                              AND     DP.CodEmpresa = nCodEmpresa
                                              AND     DP.IdPoliza   = nIdPoliza    -- 41482
                                              );
                            EXCEPTION
                                  WHEN NO_DATA_FOUND THEN 
                                     nRol := 0;
                        END;
                        IF nRol = 0 THEN
                        -- V) Agente
                            BEGIN
                                SELECT  V.IdRol--, C.DescCriterio
                                INTO    nRol
                                FROM    CRITERIOS_VAL_SINI  V,
                                        CRITERIOS_SINI      C
                                WHERE   C.IdCriterio = V.IdCriterio
                                AND     V.CodCia     = C.CodCia
                                AND     V.CodEmpresa = C.CodEmpresa
                                AND     V.CodCia     = nCodCia
                                AND     V.CodEmpresa = nCodEmpresa
                                AND     C.orden      = 4
                                --AND     idCriterio = 1  
                                AND     valor IN (SELECT  TO_CHAR(AP.Cod_Agente)
                                                  FROM    AGENTE_POLIZA  AP
                                                  WHERE   AP.Ind_Principal = 'S'
                                                  AND     AP.CodCia        = nCodCia
                                                  AND     AP.IdPoliza      = nIdPoliza    -- 41482                       
                                                  );
                            EXCEPTION
                                  WHEN NO_DATA_FOUND THEN 
                                     nRol := 0;
                            END;
                        END IF; -- 4
                    END IF; --3
                END IF; --2
            END IF; --1
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         nRol := 0;
   END; 
   RETURN nRol;
END ROL_SINI;

END OC_CRITERIOS_VAL_SINI;

/

--
-- OC_CRITERIOS_VAL_SINI  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CRITERIOS_VAL_SINI FOR OC_CRITERIOS_VAL_SINI
/


GRANT EXECUTE ON OC_CRITERIOS_VAL_SINI TO PUBLIC
/
