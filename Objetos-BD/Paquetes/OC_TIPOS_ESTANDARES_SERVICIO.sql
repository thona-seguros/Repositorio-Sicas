CREATE OR REPLACE PACKAGE          OC_TIPOS_ESTANDARES_SERVICIO AS
    --
    PROCEDURE ACTUALIZA_DIAS_ATENCION;
    --        
    PROCEDURE CONSULTA_POLIZA_DIAS_GARANTIA(PCODCIA NUMBER, PCODEMPRESA NUMBER, PIDPOLIZA NUMBER, PTIPO_SOL VARCHAR2, PTIPO_TRAMITE VARCHAR2, PAREA VARCHAR2, PNUMDIAS OUT NUMBER, PINDDIAS OUT VARCHAR2, SERVICIO OUT NUMBER, RESPUESTA OUT VARCHAR2);    
    -- 
END OC_TIPOS_ESTANDARES_SERVICIO;

/

CREATE OR REPLACE PACKAGE BODY          OC_TIPOS_ESTANDARES_SERVICIO AS
    PROCEDURE ACTUALIZA_DIAS_ATENCION IS
    BEGIN
        FOR ENT IN (        
                SELECT DISTINCT PL.CODCIA,
                       PL.CODEMPRESA,
                       'S' CODFLUJO,
                       T.IDTIPOSEG,
                       --T.DESCRIPCION,
                       PL.PLANCOB, 
                       --PL.DESC_PLAN,
                       --DECODE(NVL(TT.CODTRAMITE, NVL(CS.IdRamoReal, T.CODTIPOPLAN)), '030', 'AP', '010', 'VD', 'GM') CODTRAMITE,
                       TT.CODTRAMITE,
                       NVL(A.CODSOLICITUD, 'INICIAL') CODSOLICITUD, 
                       CASE WHEN NVL(MAX(TT.NUMDIASATN), 0) =  0 THEN
                            CASE WHEN nvl(MAX(A.NUMDIASATN), 0) =  0 THEN 
                                10 
                            ELSE
                                MAX(A.NUMDIASATN)
                            END
                       ELSE
                            CASE WHEN nvl(MAX(A.NUMDIASATN), 0) =  0 THEN
                                MAX(TT.NUMDIASATN)
                            ELSE
                                MAX(A.NUMDIASATN)
                            END
                       END NUMDIASATN, 
                       NVL(MAX(TT.INDDIAS), NVL(A.INDDIAS, 'H'))  INDDIAS
                       --NVL(T.INDMULTIRAMO, 'N') INDMULTIRAMO,
                       --OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(PL.CODCIA, PL.CODEMPRESA, PL.IDTIPOSEG) TIPOsEG,
                       --NVL(CS.IdRamoReal, T.CODTIPOPLAN) IdRamoReal, 
                       --LV.DescValLst              
                  FROM  DIAS_ATENCION_SINI A 
                                          INNER JOIN POLIZAS            P ON P.CODCIA = A.CODCIA AND P.CODEMPRESA = A.CODEMPRESA AND P.IDPOLIZA  = A.IDPOLIZA 
                                          INNER JOIN DETALLE_POLIZA     D ON D.CODCIA = P.CODCIA AND D.CODEMPRESA = P.CODEMPRESA AND D.IDPOLIZA  = P.IDPOLIZA
                                          RIGHT JOIN TIPOS_DE_SEGUROS   T ON T.CODCIA = A.CODCIA AND T.CODEMPRESA = A.CODEMPRESA AND T.IDTIPOSEG = D.IDTIPOSEG 
                                          INNER JOIN PLAN_COBERTURAS   PL ON PL.CODCIA = T.CODCIA AND PL.CODEMPRESA = T.CODEMPRESA AND PL.IDTIPOSEG = T.IDTIPOSEG
                                          LEFT  JOIN TIPOS_TRAMITE TT     ON TT.CODCIA = PL.CODCIA AND TT.CODEMPRESA = PL.CODEMPRESA AND TT.CODFLUJO = 'S' --AND TT.CODTRAMITE = DECODE(NVL(CS.IdRamoReal, T.CODTIPOPLAN), '030', 'AP', '010', 'VD', 'GM')                                                      
                                          INNER JOIN COBERTURAS_DE_SEGUROS CS ON  CS.CodCia       = PL.CodCia AND CS.CodEmpresa = PL.CodEmpresa AND CS.IdTipoSeg  = PL.IdTipoSeg AND CS.PlanCob    = PL.PlanCob --AND CS.IDRAMOREAL  = DECODE(NVL(TT.CODTRAMITE, NVL(CS.IdRamoReal, T.CODTIPOPLAN)),'AP', '030','VD', '010', 'MT', '099', 'GM', CS.IDRAMOREAL)  
                                          LEFT  JOIN VALORES_DE_LISTAS LV ON LV.CodLista = 'CODRAMOS' AND LV.CodValor = NVL(TT.CODTRAMITE, NVL(CS.IdRamoReal, T.CODTIPOPLAN))
                                          LEFT  JOIN TIPOS_SOLICITUD   TS ON TS.CODCIA = PL.CODCIA AND TS.CODEMPRESA = PL.CODEMPRESA AND TS.CODFLUJO = TT.CODFLUJO --AND TS.CODTRAMITE = DECODE(CS.IdRamoReal, '030', 'AP', '010', 'VD', 'GM')
/*
                  WHERE --(PL.IDTIPOSEG, PL.PLANCOB) IN (SELECT  DD.IDTIPOSEG, 
                        --                                       DD.PLANCOB
                        --                                 FROM POLIZAS PP INNER JOIN DETALLE_POLIZA DD ON DD.CODCIA = PP.CODCIA AND DD.CODEMPRESA = PP.CODEMPRESA AND DD.IDPOLIZA  = PP.IDPOLIZA
                        --                            WHERE PP.CODCIA = P.CODCIA AND PP.CODEMPRESA = P.CODEMPRESA AND PP.IDPOLIZA  = 41675) AND
                        NVL(CS.IdRamoReal, T.CODTIPOPLAN) IS NOT NULL AND          
                     NOT EXISTS (SELECT 1 
                                      FROM TIPOS_ESTANDARES_SERVICIO ES
                                      WHERE ES.CODCIA     = PL.CODCIA
                                        AND ES.CODEMPRESA = PL.CODEMPRESA
                                        AND ES.IDTIPOSEG  = PL.IDTIPOSEG
                                        AND ES.PLANCOB    = PL.PLANCOB   
                                        AND ES.CODTRAMITE = DECODE(NVL(CS.IdRamoReal, T.CODTIPOPLAN) , '030', 'AP', '010', 'VD', 'GM')
                                        AND ES.NUMDIASATN = CASE WHEN NVL(TT.NUMDIASATN, 0) =  0 THEN
                                                                    CASE WHEN nvl(A.NUMDIASATN, 0) =  0 THEN 
                                                                        10 
                                                                    ELSE
                                                                        (A.NUMDIASATN)
                                                                    END
                                                               ELSE
                                                                    (TT.NUMDIASATN)
                                                               END
                                        AND ES.INDDIAS    = NVL(TT.INDDIAS, NVL(A.INDDIAS, 'H'))   )
*/                                                                  
                GROUP BY T.IDTIPOSEG,
                         T.DESCRIPCION,
                         PL.CODCIA,
                         PL.CODEMPRESA,
                         PL.IDTIPOSEG,
                         PL.PLANCOB, 
                         PL.DESC_PLAN,
                         A.CODSOLICITUD,         
                         A.INDDIAS,
                         --T.INDMULTIRAMO,
                         --OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(PL.CODCIA, PL.CODEMPRESA, PL.IDTIPOSEG),
                         --T.CODTIPOPLAN,
                         --NVL(TT.CODTRAMITE, NVL(CS.IdRamoReal, T.CODTIPOPLAN))
                         --LV.DescValLst
                         TT.CODTRAMITE


                ) LOOP
            BEGIN
                INSERT INTO TIPOS_ESTANDARES_SERVICIO (CODCIA, CODEMPRESA, CODFLUJO, IDTIPOSEG, PLANCOB, CODTRAMITE, CODSOLICITUD, NUMDIASATN, INDDIAS)
                VALUES (ENT.CODCIA, ENT.CODEMPRESA, ENT.CODFLUJO, ENT.IDTIPOSEG, ENT.PLANCOB, ENT.CODTRAMITE, ENT.CODSOLICITUD, ENT.NUMDIASATN, ENT.INDDIAS);                       
            EXCEPTION WHEN OTHERS THEN
                UPDATE TIPOS_ESTANDARES_SERVICIO SET NUMDIASATN = ENT.NUMDIASATN, 
                                                     INDDIAS    =    ENT.INDDIAS
                WHERE CODCIA     = ENT.CODCIA
                  AND CODEMPRESA = ENT.CODEMPRESA
                  AND CODFLUJO   = ENT.CODFLUJO 
                  AND IDTIPOSEG  = ENT.IDTIPOSEG
                  AND PLANCOB    = ENT.PLANCOB
                  AND CODTRAMITE = ENT.CODTRAMITE
                  AND CODSOLICITUD   = ENT.CODSOLICITUD;
            END;         
        END LOOP;
        --        
    END ACTUALIZA_DIAS_ATENCION;
    --
    PROCEDURE CONSULTA_POLIZA_DIAS_GARANTIA (PCODCIA NUMBER, PCODEMPRESA NUMBER, PIDPOLIZA NUMBER, PTIPO_SOL VARCHAR2, PTIPO_TRAMITE VARCHAR2, PAREA VARCHAR2, PNUMDIAS OUT NUMBER, PINDDIAS OUT VARCHAR2, SERVICIO OUT NUMBER, RESPUESTA OUT VARCHAR2) IS 
--25699
        wPIDPOLIZA      NUMBER;
        wPCODFLUJO      VARCHAR2(100);
        wPCODTRAMITE    VARCHAR2(100); 
        wPCODSOLICITUD  VARCHAR2(100);
        wCODTRAMITE    VARCHAR2(100); 
        wCODSOLICITUD  VARCHAR2(100);


        NumVeces        NUMBER := 0;

        --                             
        FUNCTION EXTRAE_REGISTRO(PCODCIA        NUMBER,
                                 PCODEMPRESA    NUMBER,
                                 PIDPOLIZA      NUMBER,
                                 PCODFLUJO      VARCHAR2,
                                 PCODTRAMITE    VARCHAR2, 
                                 PCODSOLICITUD  VARCHAR2,
                                 NumVeces       in out Number
                                 ) RETURN VARCHAR2 IS
        --                             
            NUMDIASATN  NUMBER;
            INDDIAS     VARCHAR2(10);                 
            PIDTIPOSEG  VARCHAR2(100); 
            PPLANCOB    VARCHAR2(100);   
            WIDPOLIZA   NUMBER;
        BEGIN
            --                
            IF PIDPOLIZA IS NOT NULL THEN
                BEGIN
                    SELECT P.IDPOLIZA, IDTIPOSEG, PLANCOB
                      INTO WIDPOLIZA, PIDTIPOSEG, PPLANCOB
                      FROM POLIZAS  P INNER JOIN DETALLE_POLIZA      D ON D.CODCIA   = P.CODCIA AND D.CODEMPRESA = P.CODEMPRESA AND D.IDPOLIZA  = P.IDPOLIZA AND D.IDETPOL = (SELECT MIN(DD.IDETPOL) FROM DETALLE_POLIZA DD WHERE DD.CODCIA   = P.CODCIA AND DD.CODEMPRESA = P.CODEMPRESA AND DD.IDPOLIZA  = P.IDPOLIZA)
                    WHERE P.CODCIA     = PCODCIA 
                      AND P.CODEMPRESA = PCODEMPRESA 
                      AND P.IDPOLIZA   = PIDPOLIZA;          
                EXCEPTION WHEN OTHERS THEN
                    WIDPOLIZA := NULL;
                END;
            END IF;
            --                                                                     
            --DBMS_OUTPUT.PUT_LINE('NumVeces: ' || NumVeces || '-->' || PCODCIA || '-' || PCODEMPRESA || '-' || PIDPOLIZA || '-' || PCODFLUJO || '-' || PCODTRAMITE || '-' || PCODSOLICITUD || '-' || PIDTIPOSEG || '-' || PPLANCOB);
            --
            FOR ENT IN (           
             SELECT * FROM (
                   SELECT DISTINCT QRY,
                           CODCIA,
                           CODEMPRESA,
                           IDPOLIZA,
                           CODFLUJO,
                           NOMFLUJO,
                           CODTRAMITE, 
                           NOMTRAMITE, 
                           CODSOLICITUD,
                           IDTIPOSEG, 
                           PLANCOB,        
                           NVL(NUMDIASATN, 5) NUMDIASATN,
                           NVL(INDDIAS, 'N')  INDDIAS
                      FROM (
                SELECT  1 QRY, A.CODCIA,
                                A.CODEMPRESA,
                                A.IDPOLIZA,
                                A.CODFLUJO,
                                O.NOMFLUJO,
                                A.CODTRAMITE, 
                                T.NOMTRAMITE, 
                                A.CODSOLICITUD,
                                D.IDTIPOSEG, 
                                D.PLANCOB,        
                                A.NUMDIASATN,
                                A.INDDIAS
                           FROM DIAS_ATENCION_SINI A INNER JOIN POLIZAS             P ON P.CODCIA   = A.CODCIA AND P.CODEMPRESA = A.CODEMPRESA AND P.IDPOLIZA  = A.IDPOLIZA 
                                                     INNER JOIN DETALLE_POLIZA      D ON D.CODCIA   = P.CODCIA AND D.CODEMPRESA = P.CODEMPRESA AND D.IDPOLIZA  = P.IDPOLIZA AND D.IDETPOL = (SELECT MIN(DD.IDETPOL) FROM DETALLE_POLIZA DD WHERE DD.CODCIA   = P.CODCIA AND DD.CODEMPRESA = P.CODEMPRESA AND DD.IDPOLIZA  = P.IDPOLIZA) 
                                                     INNER JOIN FLUJOS_OPERACION    O ON O.CODCIA   = P.CODCIA AND O.CODEMPRESA = P.CODEMPRESA AND O.CODFLUJO  = A.CODFLUJO
                                                     INNER JOIN TIPOS_TRAMITE       T ON T.CODCIA   = P.CODCIA AND T.CODEMPRESA = P.CODEMPRESA AND T.CODFLUJO  = A.CODFLUJO AND T.CODTRAMITE = A.CODTRAMITE 
                                                     INNER JOIN TIPOS_SOLICITUD     S ON S.CODCIA   = P.CODCIA AND S.CODEMPRESA = P.CODEMPRESA AND S.CODFLUJO  = A.CODFLUJO AND S.CODTRAMITE = A.CODTRAMITE AND S.CODSOLICITUD = A.CODSOLICITUD
                            WHERE P.IDPOLIZA =  NVL(WIDPOLIZA, 0)
                        UNION ALL                  
                    --
                        SELECT QRY,
                               CODCIA, 
                               CODEMPRESA,
                               IDPOLIZA,
                               CODFLUJO, 
                               NOMFLUJO,
                               CODTRAMITE, 
                               NOMTRAMITE, 
                               CODSOLICITUD,
                               IDTIPOSEG, 
                               PLANCOB,              
                               NUMDIASATN, 
                               INDDIAS
                      FROM (
                        SELECT 21 QRY,O.CODCIA, O.CODEMPRESA,
                               NULL IDPOLIZA,
                               O.CODFLUJO, 
                               O.NOMFLUJO,
                               NULL CODTRAMITE, 
                               NULL NOMTRAMITE, 
                               NULL CODSOLICITUD,
                               NULL IDTIPOSEG, 
                               NULL PLANCOB,              
                               5 NUMDIASATN, 
                               'N' INDDIAS
                          FROM FLUJOS_OPERACION O 
                    UNION ALL
                        SELECT 23 QRY,O.CODCIA, O.CODEMPRESA,
                               NULL IDPOLIZA,
                               O.CODFLUJO, 
                               O.NOMFLUJO,
                               T.CODTRAMITE, 
                               T.NOMTRAMITE, 
                               S.CODSOLICITUD,
                               E.IDTIPOSEG, 
                               E.PLANCOB,              
                               E.NUMDIASATN, 
                               E.INDDIAS
                          FROM FLUJOS_OPERACION O LEFT JOIN TIPOS_TRAMITE                T   ON T.CODCIA = O.CODCIA AND T.CODEMPRESA = O.CODEMPRESA AND T.CODFLUJO = O.CODFLUJO
                                                  LEFT JOIN TIPOS_SOLICITUD              S   ON S.CODCIA = O.CODCIA AND S.CODEMPRESA = O.CODEMPRESA AND S.CODFLUJO = O.CODFLUJO AND S.CODTRAMITE = T.CODTRAMITE                                
                                                  LEFT JOIN TIPOS_ESTANDARES_SERVICIO    E   ON E.CODCIA = O.CODCIA AND E.CODEMPRESA = O.CODEMPRESA AND E.CODFLUJO = O.CODFLUJO AND E.CODTRAMITE = T.CODTRAMITE AND E.CODSOLICITUD = S.CODSOLICITUD
                        --WHERE E.IDTIPOSEG = PIDTIPOSEG                
                            )            
                       WHERE NVL(WIDPOLIZA,1) <>  NVL(WIDPOLIZA,0)
                        )
                        --         
                    WHERE CODCIA        = PCODCIA
                      AND CODEMPRESA    = PCODEMPRESA
                      AND NVL(WIDPOLIZA, 0) = NVL(IDPOLIZA, 1) OR                       
                       ( CODFLUJO      = NVL(PCODFLUJO, CODFLUJO) 
                      AND CODTRAMITE    = NVL(PCODTRAMITE, CODTRAMITE)
                      AND CODSOLICITUD  = NVL(PCODSOLICITUD, CODSOLICITUD)
                      AND NVL(IDTIPOSEG, 1)     = NVL(PIDTIPOSEG, NVL(IDTIPOSEG, 1))
                      AND NVL(PLANCOB, 1)       = NVL(PPLANCOB,  NVL(PLANCOB, 1))    )                  
                    ORDER BY CODCIA, CODEMPRESA,CODFLUJO,  CODTRAMITE, CODSOLICITUD, NVL(IDTIPOSEG, 0) ASC, NVL(PLANCOB, 0) ASC)
                    WHERE  ROWNUM = 1) LOOP

                NUMDIASATN := ENT.NUMDIASATN;
                INDDIAS := ENT.INDDIAS;
                /*
                DBMS_OUTPUT.PUT_LINE('Qry: ' || ENT.QRY || ', ' || NUMDIASATN || '-' || INDDIAS);
                DBMS_OUTPUT.PUT_LINE('IDPOLIZA: ' || ENT.IDPOLIZA);
                DBMS_OUTPUT.PUT_LINE('CODFLUJO: ' || ENT.CODFLUJO);
                DBMS_OUTPUT.PUT_LINE('NOMFLUJO: ' || ENT.NOMFLUJO);
                DBMS_OUTPUT.PUT_LINE('CODTRAMITE: ' || ENT.CODTRAMITE); 
                DBMS_OUTPUT.PUT_LINE('NOMTRAMITE: ' || ENT.NOMTRAMITE); 
                DBMS_OUTPUT.PUT_LINE('CODSOLICITUD: ' || ENT.CODSOLICITUD);
                DBMS_OUTPUT.PUT_LINE('IDTIPOSEG: ' || ENT.IDTIPOSEG);
                DBMS_OUTPUT.PUT_LINE('PLANCOB: ' || ENT.PLANCOB);   
                DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
                */
            END LOOP;

            RETURN NUMDIASATN || CASE WHEN NUMDIASATN IS NULL THEN NULL ELSE ',' END || INDDIAS;
            --
        END EXTRAE_REGISTRO;    
        --
    BEGIN
    --25699

        wPIDPOLIZA      := PIDPOLIZA;
        wPCODFLUJO      := upper(substr(PAREA, 1,1));
        wPCODSOLICITUD  := PTIPO_SOL;  
        wPCODTRAMITE    := PTIPO_TRAMITE; 
        --    
        wCODTRAMITE    := wPCODTRAMITE;
        wCODSOLICITUD  := wPCODSOLICITUD; 

        WHILE RESPUESTA IS NULL and NumVeces <= 6 LOOP
            NumVeces := NumVeces + 1;        
            Respuesta := EXTRAE_REGISTRO(PCODCIA,PCODEMPRESA,WPIDPOLIZA,WPCODFLUJO,WPCODTRAMITE,WPCODSOLICITUD, NumVeces);
            IF Respuesta IS NULL AND NumVeces = 1 THEN
                wPIDPOLIZA      := wPIDPOLIZA;
                wPCODFLUJO      := wPCODFLUJO;
                wPCODTRAMITE    := wPCODTRAMITE;
                wPCODSOLICITUD  := NULL; 
            ELSIF Respuesta IS NULL AND NumVeces = 2 THEN
                wPIDPOLIZA      := wPIDPOLIZA;
                wPCODFLUJO      := wPCODFLUJO;
                wPCODTRAMITE    := NULL;
                wPCODSOLICITUD  := NULL;
            ELSIF Respuesta IS NULL AND NumVeces = 3 THEN
                wPIDPOLIZA      := NULL;
                wPCODFLUJO      := wPCODFLUJO;
                wPCODTRAMITE    := wCODTRAMITE;
                wPCODSOLICITUD  := wCODSOLICITUD;
            ELSIF Respuesta IS NULL AND NumVeces = 4 THEN
                wPIDPOLIZA      := NULL;
                wPCODFLUJO      := wPCODFLUJO;
                WPCODTRAMITE    := wCODTRAMITE;
                wPCODSOLICITUD  := NULL;
            ELSIF Respuesta IS NULL AND NumVeces = 5 THEN
                Respuesta := '5,H';                
            END IF;
        END LOOP;
        --
        --DBMS_OUTPUT.PUT_LINE('Respuesta: ' || Respuesta);
        --
        PNUMDIAS := SUBSTR(Respuesta, 1, INSTR(Respuesta, ',')-1);
        PINDDIAS := SUBSTR(Respuesta, INSTR(Respuesta, ',')+1);
        --     
        SERVICIO  := 1;
        RESPUESTA := 'El servicio se ejecuto correctamente.';
        --                              
    EXCEPTION WHEN OTHERS THEN
            PNUMDIAS    := 0;
            PINDDIAS    := NULL;
            SERVICIO    := 0;
            RESPUESTA   := sqlerrm;     
    END CONSULTA_POLIZA_DIAS_GARANTIA;   
    --
END OC_TIPOS_ESTANDARES_SERVICIO;
