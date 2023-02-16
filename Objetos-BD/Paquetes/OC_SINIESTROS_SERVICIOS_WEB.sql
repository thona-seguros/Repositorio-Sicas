CREATE OR REPLACE PACKAGE          OC_SINIESTROS_SERVICIOS_WEB AS
    FUNCTION EXISTE_POLIZA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, /*nIdPoliza IN NUMBER,*/ cNumPolUnico IN VARCHAR2) RETURN VARCHAR2;    --> JALV (-) 03/02/2022
    FUNCTION EXISTE_AGENTE(nCodCia IN NUMBER, nCodAgente IN NUMBER, /*nIdPoliza IN NUMBER*/ cNumPolUnico IN VARCHAR) RETURN VARCHAR2;       --> JALV (-) 04/02/2022
    FUNCTION POLIZA_SINIESTRO (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, /*cNumPolUnico IN VARCHAR2,*/ nCodAgente IN VARCHAR2) RETURN XMLTYPE;   --> JALV (-) 09/02/2022
    FUNCTION LISTA_FLUJOS (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER) RETURN XMLTYPE;   --> JALV (+) 17/02/2022
    FUNCTION LISTA_TRAMITES (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER) RETURN XMLTYPE;   --> JALV (+) 15/02/2022
    FUNCTION OBTIENE_FOLIO (nCodCia  IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER, nIdTramite IN NUMBER) RETURN XMLTYPE;    --> JALV (+) 18/02/2022
    FUNCTION OBTIENE_ROL (nCodCia  IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER) RETURN XMLTYPE;    --> JALV (+) 22/03/2022
    FUNCTION OBTIENE_DICTAMEN (nCodCia  IN NUMBER, nIdSiniestro IN NUMBER) RETURN XMLTYPE;    --> JALV (+) 28/03/2022
    FUNCTION OBTIENE_DIAS_GARANTIA(PCODCIA NUMBER, PCODEMPRESA NUMBER, PIDPOLIZA NUMBER, PTIPO_SOL VARCHAR2, PTIPO_TRAMITE VARCHAR2, PAREA VARCHAR2) RETURN XMLTYPE;
END OC_SINIESTROS_SERVICIOS_WEB;

/

create or replace PACKAGE BODY          OC_SINIESTROS_SERVICIOS_WEB AS

    FUNCTION EXISTE_POLIZA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, /*nIdPoliza IN NUMBER,*/ cNumPolUnico IN VARCHAR2) --> JALV (-) 03/02/2022
    RETURN VARCHAR2 IS
    cExiste  VARCHAR2(1);

    BEGIN
      BEGIN
        SELECT  'S'
        INTO    cExiste
        FROM    POLIZAS P
        WHERE   P.CodCia     = nCodCia
        AND     P.CodEmpresa = nCodEmpresa
        AND     P.StsPoliza  IN ('EMI', 'ANU')
        --AND     (P.IdPoliza    = NVL(nIdPoliza, P.IdPoliza) OR  P.NumPolUnico = NVL(cNumPolUnico, P.NumPolUnico));   -- 39904; --> JALV (-) 03/02/2022
        AND     P.NumPolUnico = NVL(cNumPolUnico, P.NumPolUnico);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
      END;
      RETURN(cExiste);
    END EXISTE_POLIZA;

    FUNCTION EXISTE_AGENTE (nCodCia IN NUMBER, nCodAgente IN NUMBER, /*nIdPoliza IN NUMBER*/ cNumPolUnico IN VARCHAR)   --> JALV (-) 03/02/2022
    RETURN VARCHAR2 IS
    /*   _______________________________________________________________________________________________________________________________    
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 18/01/2022                                                                                                       |    
        | Nombre     : EXISTE_AGENTE                                                                                                    |
        | Objetivo   : Funcion que valida que el agente que se recibe corresponda a la póliza solicitada.                               |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodAgente          Codigo de Agente                (Entrada)                                                       |
        |           nIdPoliza           ID de la Poliza                 (Entrada)                                                       |
        |_______________________________________________________________________________________________________________________________|
    */
    cExiste VARCHAR2(1); 

    BEGIN
       BEGIN
            SELECT  'S'
            INTO    cExiste
            FROM    POLIZAS         P,
                    AGENTE_POLIZA   A
            WHERE   P.CodCia      = A.CodCia
            AND     P.IdPoliza    = A.IdPoliza        
            AND     A.Cod_Agente  = nCodAgente    -- 538
            --AND     P.IdPoliza    = nIdPoliza    -- 39904
            AND     P.NumPolUnico = NVL(cNumPolUnico, P.NumPolUnico);

       EXCEPTION
          WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
          WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';            
       END;
       RETURN cExiste;
    END EXISTE_AGENTE;

    -- Agregar mas Componentes
    FUNCTION POLIZA_SINIESTRO (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, nCodAgente IN VARCHAR2) RETURN XMLTYPE IS

        xPolSini        XMLTYPE; 
        xPrevPolSini    XMLTYPE;
        xPrevPolSTR     XMLTYPE;
        wDescobert  VARCHAR2(500);
        WCodCobert  VARCHAR2(50);

    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("INFO_POLIZA",  
                                                    XMLELEMENT("NumPolUnico", Q.NumPolUnico),
                                                    XMLELEMENT("Consecutivo", Q.Poliza),
                                                    XMLELEMENT("ClaveContratante", Q.Clave_Contratante),
                                                    XMLELEMENT("NombreContratante", Q.Nombre_Contratante),
                                                    XMLELEMENT("TipoDePersonaContratante", Q.TipoDePersona_Contratante),
                                                    XMLELEMENT("CodigoAsegurado",Q.Codigo_Asegurado),
                                                    XMLELEMENT("CurpAsegurado", Q.Curp_Asegurado),
                                                    XMLELEMENT("RfcAsegurado", Q.RFC_Asegurado),
                                                    XMLELEMENT("NombreAsegurado", NVL(Q.NombreAsegurado,'NULL')),
                                                    XMLELEMENT("ApellidoPaternoAsegurado", NVL(Q.ApellidoPaterno,'NULL')),
                                                    XMLELEMENT("ApellidoMaternoAsegurado", NVL(Q.ApellidoMaterno,'NULL')),
                                                    XMLELEMENT("FechaDeNacimientoDeAsegurado", Q.FechaNacimiento),
                                                    XMLELEMENT("ClaveTipoDeSeguro", Q.TipoSeguro),
                                                    XMLELEMENT("DescripcionTipoDeSeguro", Q.DescTipoSeguro),
                                                    XMLELEMENT("ClaveTipoAdministracion", Q.TipoAdministracion),
                                                    XMLELEMENT("TipoAdministracion", Q.DescTipoAdministracion),
                                                    XMLELEMENT("InicioVigencia", Q.InicioVigencia),
                                                    --XMLELEMENT("HoraInicioVigencia", Q.HoraInicioVigencia),
                                                    XMLELEMENT("FinVigencia", Q.FinVigencia),
                                                    --XMLELEMENT("HoraFinVigencia", Q.HoraFinVigencia),
                                                    XMLELEMENT("FechaPagadoHasta", Q.FechaPagadoHasta),
                                                    --XMLELEMENT("StatusPoliza", Q.StatusPoliza),
                                                    --XMLELEMENT("DescEstatus", Q.DescEstatus),
                                                    XMLELEMENT("StatusPoliza", Q.DescEstatus),
                                                    XMLELEMENT("DiasDeGarantia",Q.Dias_Garantia),
                                                    XMLELEMENT("TiposDeDiasDeGarantia", Q.Tipos_Dias_Garantia),
                                                    XMLELEMENT("IdRolDictaminadorExterno", Q.Rol_Dictaminador),
                                                    (SELECT XMLAGG(XMLELEMENT("COBERTURAS",
                                                                                 XMLELEMENT("CodCobertura", CodCobert), 
                                                                                 XMLELEMENT("DescripcionCobertura", DescCobert)
                                                                              )
                                                                      )
                                                     FROM (SELECT C.CodCobert, 
                                                                  OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert) DESCCOBERT
                                                             FROM COBERT_ACT     C,
                                                                  DETALLE_POLIZA D
                                                            WHERE C.IdPoliza      = nIdPoliza -- 36091
                                                              AND C.CodCia        = nCodCia 
                                                              --AND C.StsCobertura  = 'EMI'
                                                              AND C.CodCia        = D.CodCia
                                                              AND C.CodEmpresa    = D.CodEmpresa
                                                              AND C.IdPoliza      = D.IdPoliza
                                                            GROUP BY nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert
                                                            UNION 
                                                           SELECT C.CodCobert, 
                                                                  OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert) DESCCOBERT
                                                             FROM COBERT_ACT_ASEG C, 
                                                                  DETALLE_POLIZA  D 
                                                            WHERE C.IdPoliza      = nIdPoliza --36091
                                                              AND C.CodCia        = nCodCia 
                                                              --AND C.StsCobertura  = 'EMI'
                                                              AND C.CodCia        = D.CodCia
                                                              AND C.CodEmpresa    = D.CodEmpresa
                                                              AND C.IdPoliza      = D.IdPoliza
                                                            GROUP BY nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert)
                                                    )                      
                                                )
                                     )
                              )
    INTO    xPrevPolSini
    FROM    (   SELECT  DISTINCT P.CODCIA, P.CODEMPRESA, 
                        P.NumPolUnico                                  NumPolUnico,
                        P.IdPoliza                                              Poliza,
                        P.CodCliente                                            Clave_Contratante,
                        OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                Nombre_Contratante,
                        PNJ.Tipo_Persona                                        TipoDePersona_Contratante,
                        A.Cod_Asegurado                                         Codigo_Asegurado,
                        NVL(PNJ.curp, 'NULL')                                   Curp_Asegurado,
                        DECODE(PNJ.Tipo_Doc_Identificacion, 'RFC', PNJ.Num_Tributario, 'NULL') RFC_Asegurado,
                        --DECODE(P.IndPolCol, 'N', 'Individual', 'Colectiva') Tipo_Poliza,
                        DECODE(P.IndPolCol, 'N', PNJ.Nombre, NULL)            NombreAsegurado,
                        DECODE(P.IndPolCol, 'N', PNJ.Apellido_Paterno, NULL)  ApellidoPaterno,
                        DECODE(P.IndPolCol, 'N', PNJ.Apellido_Materno, NULL)  ApellidoMaterno,
                        DECODE(P.IndPolCol, 'N', PNJ.FecNacimiento, NULL)     FechaNacimiento,
                        DP.IdTipoSeg                                            TipoSeguro,
                        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('UENXTIPSEG', DP.IdTipoSeg) DescTipoSeguro,
                        --OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPOSEG', DP.IdTipoSeg) DescTipoSeguro,
                        P.TipoAdministracion,
                        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', P.TipoAdministracion) DescTipoAdministracion,
                        -- Coberturas de la póliza (Clave y Descripción)
                        P.FecIniVig                                             InicioVigencia,
                        P.HoraVigIni                                            HoraInicioVigencia,
                        P.FecFinVig                                             FinVigencia,
                        P.HoraVigFin                                            HoraFinVigencia,
                        --F.FecFinVig                                             FechaPagadoHasta,
                        (SELECT  TO_CHAR(MAX(FC.FecFinVig),'YYYY-MM-DD')
                         FROM    FACTURAS  FC
                         WHERE   FC.StsFact  = 'PAG'
                         AND     FC.IdPoliza = nIdPoliza)                       FechaPagadoHasta,
                        P.StsPoliza                                             StatusPoliza,
                        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   DescEstatus,
                        NVL(D.NumDiasAtn, 0)                                   Dias_Garantia,       --> Días de garantía de atención a siniestros. (NULL cuando no tenga garantía)            --> Campo No existe !! -- Campo Nuevo en nueva tabla.
                        --NVL(D.IndDias, 'NULO')                                 Tipos_Dias_Garantia --> Tipo de días de garantía de atención a siniestros. (NULL cuando no tenga garantía)    --> Campo No existe !! -- Campo Nuevo en nueva tabla.
                        CASE D.IndDias WHEN 'H' THEN 'HABILES' WHEN 'N' THEN 'NATURALES' ELSE NVL(D.IndDias, 'N/A') END Tipos_Dias_Garantia,
                        -- ** ID de rol de dictaminador
                        OC_CRITERIOS_VAL_SINI.ROL_SINI(nCodCia, nCodEmpresa, nIdPoliza) Rol_Dictaminador,
                        IndProcFact,
                        AP.Cod_Agente
                FROM    POLIZAS   P INNER JOIN DETALLE_POLIZA               DP  ON P.CODCIA  = DP.CODCIA  AND P.CODEMPRESA = DP.CODEMPRESA  AND P.IdPoliza       = DP.IdPoliza --     AND P.StsPoliza     = 'EMI' solicitud de iván perez 20230103
                                    INNER JOIN AGENTE_POLIZA                AP  ON AP.CodCia =  P.CodCia  AND AP.IdPoliza  = P.IdPoliza     AND AP.Ind_Principal = 'S'
                                    INNER JOIN ASEGURADO                    A   ON A.CodCia  =  P.CodCia  AND A.CodEmpresa = P.CodEmpresa   AND A.Cod_Asegurado  = DP.Cod_Asegurado
                                    INNER JOIN PERSONA_NATURAL_JURIDICA     PNJ ON PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion  AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
                                    INNER JOIN FACTURAS                     F   ON F.CodCia  = A.CodCia   AND F.IdPoliza   = DP.IdPoliza   
                                    LEFT  JOIN DIAS_ATENCION_SINI           D   ON D.CodCia  =  P.CodCia  AND D.CodEmpresa = P.CodEmpresa   AND D.idpoliza       = P.idpoliza
                WHERE P.CodCia        = NCODCIA
                  AND P.CodEmpresa    = NCODEMPRESA
                  AND P.IdPoliza      = nIdPoliza     --> 36091 (INDIVIDUAL)  --> 3808 (COLECTIVA)
                  AND AP.Cod_Agente   = nCodAgente) Q; 

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SEVICIOS_WEB.POLIZA_SINIESTRO -> '||SQLERRM); 
       END;


       SELECT XMLROOT (xPrevPolSini, VERSION '1.0" encoding="UTF-8')
       INTO   xPolSini
       FROM   DUAL;
        --
       RETURN xPolSini;
        --
    END POLIZA_SINIESTRO;
    --
    FUNCTION LISTA_FLUJOS (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER)
    RETURN XMLTYPE IS
     /*  _______________________________________________________________________________________________________________________________    
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 17/02/2022                                                                                                       |    
        | Nombre     : LISTADO_FLUJOS                                                                                                   |
        | Objetivo   : Funcion que muestra el listado de los los diferentes Flujos disponibles en Siniestros para Plataforma Digital.   |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       | 
        |_______________________________________________________________________________________________________________________________|
    */
    xFlujo    XMLTYPE; 
    xPrevFlujo XMLTYPE;

    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("FLUJOS_DE_OPERACION",  
                                                    XMLELEMENT("IdFlujo", F.IdFlujo),
                                                    XMLELEMENT("CodigoFlujo", F.CodFlujo),
                                                    XMLELEMENT("NombreFlujo", F.NomFlujo)                    
                                                )
                                     )
                              )
    INTO    xPrevFlujo
    FROM    FLUJOS_OPERACION F
    WHERE   StsFlujo    = 'ACT'
    AND     CodCia      = nCodCia
    AND     CodEmpresa  = nCodEmpresa;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_FLUJOS_OPERACION_WEB.LISTA_FLUJOS'||SQLERRM); 
       END;

       SELECT   XMLROOT (xPrevFlujo, VERSION '1.0" encoding="UTF-8')
       INTO     xFlujo
       FROM     DUAL;

       RETURN xFlujo;

    END LISTA_FLUJOS;

    FUNCTION LISTA_TRAMITES (nCodCia  IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER)
    RETURN XMLTYPE IS
     /*  _______________________________________________________________________________________________________________________________    
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 15/02/2022                                                                                                       |    
        | Nombre     : LISTA_TRAMITES                                                                                                   |
        | Objetivo   : Funcion que muestra el listado de los los diferentes Trámites disponibles en Siniestros para Plataforma Digital. |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       | 
        |_______________________________________________________________________________________________________________________________|
    */
    xTipTramite     XMLTYPE; 
    xPrevTipTramite XMLTYPE;

    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("TIPOS_TRAMITE",  
                                                    XMLELEMENT("IdTramite", TT.IdTramite),
                                                    XMLELEMENT("CodigoRamo", TT.CodTramite),
                                                    XMLELEMENT("Ramo", TT.NomTramite)                    
                                                )
                                     )
                              )
            INTO    xPrevTipTramite
            FROM    TIPOS_TRAMITE TT
            WHERE   Ststiptram  = 'ACT'
            AND     CodCia      = nCodCia
            AND     CodEmpresa  = nCodEmpresa
            AND     IdFlujo     = nIdFlujo;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SERVICIOS_WEB.LISTA_TRAMITES'||SQLERRM); 
       END;

       SELECT   XMLROOT (xPrevTipTramite, VERSION '1.0" encoding="UTF-8')
       INTO     xTipTramite
       FROM     DUAL;

       RETURN xTipTramite;

    END LISTA_TRAMITES;

    FUNCTION OBTIENE_FOLIO (nCodCia  IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER, nIdTramite IN NUMBER)
    RETURN XMLTYPE IS
     /*  _______________________________________________________________________________________________________________________________
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 16/02/2022                                                                                                       |
        | Nombre     : OBTIENE_FOLIO_SINI                                                                                               |
        | Objetivo   : Funcion que obtiene el Folio obtenido que sera usado en la operación de Siniestros para Plataforma Digital.      |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       |
        |           nIdFlujo            Identificador del Flujo         (Entrada)                                                       |
        |           nIdTramite         Codigo de Tramite o Ramo         (Entrada)                                                       |
        |_______________________________________________________________________________________________________________________________|
    */
    xFolioTramite       XMLTYPE; 
    xPrevFolioTramite   XMLTYPE;

    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("TRAMITE",  
                                                    XMLELEMENT("Folio", OC_TIPOS_TRAMITE.GENERA_FOLIO (nCodCia, nCodEmpresa, nIdFlujo, nIdTramite))
                                                )
                                     )
                              )
    INTO    xPrevFolioTramite
    FROM    DUAL;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_FOLIO -> '||SQLERRM); 
       END;

       SELECT   XMLROOT (xPrevFolioTramite, VERSION '1.0" encoding="UTF-8')
       INTO     xFolioTramite
       FROM     DUAL;

       RETURN xFolioTramite;

    END OBTIENE_FOLIO;

    FUNCTION OBTIENE_ROL (nCodCia  IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER)
    RETURN XMLTYPE IS
     /*  _______________________________________________________________________________________________________________________________
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 22/03/2022                                                                                                       |
        | Nombre     : OBTIENE_ROL                                                                                                      |
        | Objetivo   : Funcion que obtiene el Rol del Dictaminador que corresponda a la Póliza Siniestrada para Plataforma Digital.     |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       |
        |           nIdPoliza           Número de Póliza                (Entrada)                                                       |
        |_______________________________________________________________________________________________________________________________|
    */
    xRolSini       XMLTYPE; 
    xPrevRolSini   XMLTYPE;

    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("ROL",  
                                                    XMLELEMENT("Rol", DECODE(OC_CRITERIOS_VAL_SINI.ROL_SINI(nCodCia, nCodEmpresa, nIdPoliza), 0, NULL, OC_CRITERIOS_VAL_SINI.ROL_SINI(nCodCia, nCodEmpresa, nIdPoliza))) 
                                                )
                                     )
                              )
    INTO    xPrevRolSini
    FROM    DUAL;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_ROL -> '||SQLERRM); 
       END;

       SELECT   XMLROOT (xPrevRolSini, VERSION '1.0" encoding="UTF-8')
       INTO     xRolSini
       FROM     DUAL;

       RETURN xRolSini;

    END OBTIENE_ROL;
    FUNCTION OBTIENE_DICTAMEN (nCodCia  IN NUMBER, nIdSiniestro IN NUMBER)
    RETURN XMLTYPE IS
     /*  _______________________________________________________________________________________________________________________________
        |                                                                                                                               |
        |                                                           HISTORIA                                                            |
        | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
        | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
        | Para       : THONA Seguros                                                                                                    |
        | Fecha Elab.: 28/03/2022                                                                                                       |
        | Nombre     : OBTIENE_DICTAMEN                                                                                                 |
        | Objetivo   : Funcion que obtiene el Reporte del Dictamen de la Póliza Siniestrada para Plataforma Digital.                    |
        | Modificado : No                                                                                                               |
        | Ult. modif.: N/A                                                                                                              |
        | Modifico   : N/A                                                                                                              |
        | Obj. Modif.: N/A                                                                                                              |
        |                                                                                                                               |
        | Parametros:                                                                                                                   |
        |           nCodCia             Codigo de la Compañia           (Entrada)                                                       |
        |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       |
        |           nIdPoliza           Número de Póliza                (Entrada)                                                       |
        |_______________________________________________________________________________________________________________________________|
    */
    nIdReporte      REPORTE.IdReporte%TYPE;
    cNomReporte     REPORTE.Reporte%TYPE;
    xReporte        XMLTYPE; 
    xPrevReporte    XMLTYPE;

    BEGIN
        -- Obtiene nombre del Reporte
        SELECT  IdReporte, Reporte
        INTO    nIdReporte, cNomReporte
        FROM    REPORTE        
        WHERE   descripcion = 'DICTAMEN SINIESTROS';

        BEGIN
            SELECT  XMLELEMENT("DATA",
                               XMLAGG(XMLELEMENT("REPORTE_DICTAMEN",  
                                                    (SELECT XMLAGG(XMLELEMENT("PARAMETROS",
                                                                                 XMLELEMENT("Parametro", NOM_PARAM) 
                                                                              )
                                                                      )
                                                     FROM (SELECT   UPPER(Nom_Param) NOM_PARAM
                                                            FROM    REPORTE_PARAMETRO P
                                                            WHERE   IdReporte = nIdReporte)
                                                    )
                                                )
                                     )
                              )
            INTO    xPrevReporte
            FROM    DUAL;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DICTAMEN -> '||SQLERRM); 
       END;

       SELECT   XMLROOT (xPrevReporte, VERSION '1.0" encoding="UTF-8')
       INTO     xReporte
       FROM     DUAL;

       RETURN xReporte;

    END OBTIENE_DICTAMEN;
    --
    FUNCTION OBTIENE_DIAS_GARANTIA(PCODCIA NUMBER, PCODEMPRESA NUMBER, PIDPOLIZA NUMBER, PTIPO_SOL VARCHAR2, PTIPO_TRAMITE VARCHAR2, PAREA VARCHAR2) RETURN XMLTYPE IS        
        RespuestaXML       XMLTYPE;         
        --
        PNUMDIAS    NUMBER;
        PINDDIAS    VARCHAR2(1); 
        SERVICIO    NUMBER;
        RESPUESTA   VARCHAR2(5000);
        --
    BEGIN
        --
        --DBMS_OUTPUT.PUT_LINE(PCODCIA || '-' || PCODEMPRESA || '-' || PIDPOLIZA || '-' || UPPER(PTIPO_SOL) || '-' || UPPER(PTIPO_TRAMITE)|| '-' || UPPER(PAREA));
        OC_TIPOS_ESTANDARES_SERVICIO.CONSULTA_POLIZA_DIAS_GARANTIA(PCODCIA, PCODEMPRESA, PIDPOLIZA, UPPER(PTIPO_SOL), UPPER(PTIPO_TRAMITE), UPPER(PAREA), PNUMDIAS, PINDDIAS, SERVICIO, RESPUESTA);
        --DBMS_OUTPUT.PUT_LINE(PNUMDIAS || '-' || UPPER(PINDDIAS) || '-' || UPPER(SERVICIO)|| '-' || UPPER(RESPUESTA));
        --
        SELECT  XMLELEMENT("DATA",
                           XMLAGG(XMLELEMENT("GARANTIA",  
                                                XMLELEMENT("DiasDeGarantia", PNUMDIAS),
                                                XMLELEMENT("TiposDeDiasDeGarantia",PINDDIAS))),
                           XMLAGG(XMLELEMENT("CONTROL",  
                                                XMLELEMENT("RespuestaServicio",  CASE WHEN SERVICIO = 1 THEN 'TRUE' ELSE 'FALSE' END),
                                                XMLELEMENT("TextoRespuestaServicio", RESPUESTA))))
          INTO RespuestaXML                                                    
          FROM DUAL;                              

       SELECT  XMLROOT (RespuestaXML, VERSION '1.0" encoding="UTF-8')
       INTO    RespuestaXML
       FROM    DUAL;

       RETURN RespuestaXML;
       --
    EXCEPTION WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20225,'Error detectado en OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DIAS_GARANTIA -> '||SQLERRM);
       RETURN NULL; 
    END OBTIENE_DIAS_GARANTIA;
    --
END OC_SINIESTROS_SERVICIOS_WEB;
