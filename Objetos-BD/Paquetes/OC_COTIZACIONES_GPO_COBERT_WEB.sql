create or replace PACKAGE          OC_COTIZACIONES_GPO_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia            IN  COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion      IN  COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                     , nCodGpoCobertWeb   IN  COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE );

   PROCEDURE ELIMINAR( nCodCia            IN  COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion      IN  COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                     , nCodGpoCobertWeb   IN  COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE );

   FUNCTION SERVICIO_XML( nCodCia          IN COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa      IN COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                        , nIdCotizacion    IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                        , nCodGpoCobertWeb IN COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) RETURN XMLTYPE;

   PROCEDURE COPIAR( nCodCia           IN COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                   , nCodEmpresa       IN COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                   , nIdCotizacionOrig IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                   , nIdCotizacion     IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE);                   

    PROCEDURE AGREGA_REGISTROS(nCODCIA NUMBER, nCODEMPRESA NUMBER, cCODCOTIZADOR VARCHAR2, cIDTIPOSEG VARCHAR2, cPLANCOB VARCHAR2, nIDCOTIZACION NUMBER, nIDETCOTIZACION NUMBER);
    
END OC_COTIZACIONES_GPO_COBERT_WEB;
/
create or replace PACKAGE BODY          OC_COTIZACIONES_GPO_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia            IN  COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion      IN  COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                     , nCodGpoCobertWeb   IN  COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) IS
   BEGIN
       INSERT INTO COTIZACIONES_GPO_COBERT_WEB
          ( CodCia, CodEmpresa, IdCotizacion, CodGpoCobertWeb )
       VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nCodGpoCobertWeb );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia            IN  COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion      IN  COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                     , nCodGpoCobertWeb   IN  COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) IS
   BEGIN
       DELETE COTIZACIONES_GPO_COBERT_WEB
       WHERE  CodCia          = nCodCia
         AND  CodEmpresa      = nCodEmpresa
         AND  IdCotizacion    = nIdCotizacion
         AND  CodGpoCobertWeb = nCodGpoCobertWeb;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia          IN COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa      IN COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                        , nIdCotizacion    IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                        , nCodGpoCobertWeb IN COTIZACIONES_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;   
   BEGIN
      SELECT XMLROOT (x.Resultado, VERSION '1.0" encoding="UTF-8')
      INTO   xResultado
      FROM ( SELECT XMLElement( "DATA",
                                XMLAGG(
                                        XMLCONCAT(
                                                   XMLElement( "COTIZACIONES_GPO_COBERT_WEB", 
                                                               XMLElement("CodCia", CodCia),
                                                               XMLElement("CodEmpresa",CodEmpresa),
                                                               XMLElement("IdCotizacion", IdCotizacion),
                                                               XMLElement("CodGpoCobertWeb", CodGpoCobertWeb)
--                                                               XMLElement("DescGpoCobertWeb", DescGpoCobertWeb)
                                                             )
                                                 )
                                      ) 
                              ) Resultado
             FROM   COTIZACIONES_GPO_COBERT_WEB
             WHERE  CodCia          = NVL( nCodCia         , CodCia)
               AND  CodEmpresa      = NVL( nCodEmpresa     , CodEmpresa)
               AND  IdCotizacion    = NVL( nIdCotizacion   , IdCotizacion)
               AND  CodGpoCobertWeb = NVL( nCodGpoCobertWeb, CodGpoCobertWeb)
           ) X;
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

    PROCEDURE COPIAR( nCodCia           IN COTIZACIONES_GPO_COBERT_WEB.CodCia%TYPE
                    , nCodEmpresa       IN COTIZACIONES_GPO_COBERT_WEB.CodEmpresa%TYPE
                    , nIdCotizacionOrig IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE
                    , nIdCotizacion     IN COTIZACIONES_GPO_COBERT_WEB.IdCotizacion%TYPE) IS
    CURSOR GPO_COBERT_Q IS
       SELECT CodGpoCobertWeb
         FROM COTIZACIONES_GPO_COBERT_WEB
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdCotizacion  = nIdCotizacionOrig;
    BEGIN
       FOR W IN GPO_COBERT_Q LOOP
           OC_COTIZACIONES_GPO_COBERT_WEB.INSERTAR( nCodCia, nCodEmpresa, nIdCotizacion, W.CodGpoCobertWeb);
       END LOOP;
    END COPIAR;

    --
    PROCEDURE AGREGA_REGISTROS(nCODCIA NUMBER, nCODEMPRESA NUMBER, cCODCOTIZADOR VARCHAR2, cIDTIPOSEG VARCHAR2, cPLANCOB VARCHAR2, nIDCOTIZACION NUMBER, nIDETCOTIZACION NUMBER) AS
    
    BEGIN
        FOR ENT IN (SELECT CODCIA, CODEMPRESA, CODCOTIZADOR, IDTIPOSEG, PLANCOB, CODGPOCOBERTWEB
                      FROM COTIZADOR_GPO_COBERT_WEB G
                     WHERE G.CODCIA        = nCODCIA
                       AND G.CODEMPRESA    = nCODEMPRESA
                       AND G.CODCOTIZADOR  = cCODCOTIZADOR
                       AND G.IDTIPOSEG     = cIDTIPOSEG
                       AND G.PLANCOB       = cPLANCOB) LOOP

            INSERT INTO COTIZACIONES_GPO_COBERT_WEB  (CODCIA, CODEMPRESA, IDCOTIZACION, CODGPOCOBERTWEB, ACTUALIZO_USUARIO, ACTUALIZO_FECHA) VALUES 
                                                    (ENT.CODCIA, ENT.CODEMPRESA, nIDCOTIZACION, ENT.CODGPOCOBERTWEB, USER, SYSDATE);
            --
            OC_COTIZACIONES_COBERT_WEB.AGREGA_REGISTROS (ENT.CODCIA, ENT.CODEMPRESA, ENT.CODCOTIZADOR, ENT.IDTIPOSEG, ENT.PLANCOB, ENT.CODGPOCOBERTWEB,  nIDCOTIZACION,  nIDETCOTIZACION);                                                                                           
            --                                       
        END LOOP;                  
                 
    END AGREGA_REGISTROS;
    --
END OC_COTIZACIONES_GPO_COBERT_WEB;
/
GRANT EXECUTE, DEBUG ON OC_COTIZACIONES_GPO_COBERT_WEB TO "PUBLIC";
/
CREATE OR REPLACE PUBLIC SYNONYM OC_COTIZACIONES_GPO_COBERT_WEB FOR OC_COTIZACIONES_GPO_COBERT_WEB;
/

