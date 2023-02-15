CREATE OR REPLACE PACKAGE OC_FACT_ELECT_OBJETO_IMPUESTO AS
FUNCTION DESCRIPCION (nCodCia NUMBER, cCodObjetoImp VARCHAR2) RETURN VARCHAR;
FUNCTION LISTADO_WEB (nCodCia NUMBER, nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE;
END OC_FACT_ELECT_OBJETO_IMPUESTO; 

/

CREATE OR REPLACE PACKAGE BODY OC_FACT_ELECT_OBJETO_IMPUESTO AS
FUNCTION DESCRIPCION (nCodCia NUMBER, cCodObjetoImp VARCHAR2) RETURN VARCHAR IS
cDescObjetoImp    FACT_ELECT_OBJETO_IMPUESTO.DescObjetoImp%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DescObjetoImp,'NA')
        INTO cDescObjetoImp
        FROM FACT_ELECT_OBJETO_IMPUESTO
       WHERE CodCia        = nCodCia
         AND CodObjetoImp  = cCodObjetoImp;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         cDescObjetoImp := 'No Existe';
   END;
   RETURN cDescObjetoImp;
END DESCRIPCION;

FUNCTION LISTADO_WEB (nCodCia NUMBER, nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE IS
xListadoObjetoImp    XMLTYPE;
xPrevListadoObjImp   XMLTYPE;
BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("OBJETOIMPUESTO",  
                                                XMLELEMENT("CodObjetoImp", CodObjetoImp),
                                                XMLELEMENT("DescObjetoImp", DescObjetoImp),
                                                XMLELEMENT("FecIniVig", TO_CHAR(FecIniVig,'DD/MM/YYYY')),
                                                XMLELEMENT("FecFinVig", TO_CHAR(FecFinVig,'DD/MM/YYYY'))
                                            )
                                  )
                        )
         INTO xPrevListadoObjImp
         FROM (SELECT CodObjetoImp,
                      DescObjetoImp,
                      FecIniVig,
                      FecFinVig,
                      ROW_NUMBER() OVER (ORDER BY CodObjetoImp) Registro
                 FROM FACT_ELECT_OBJETO_IMPUESTO
                WHERE CodCia  = nCodCia
              ) 
        WHERE Registro BETWEEN nLimInferior AND nLimSuperior;

      SELECT NVL(COUNT(*),0)
        INTO nTotRegs
        FROM FACT_ELECT_OBJETO_IMPUESTO
       WHERE CodCia  = nCodCia;
   END;    

   SELECT XMLROOT (xPrevListadoObjImp, VERSION '1.0" encoding="UTF-8')
     INTO xListadoObjetoImp
     FROM DUAL;

   RETURN xListadoObjetoImp;    
END LISTADO_WEB;

END OC_FACT_ELECT_OBJETO_IMPUESTO; 
