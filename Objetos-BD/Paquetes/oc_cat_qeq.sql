--
-- OC_CAT_QEQ  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   ADMON_RIESGO (Table)
--   SAI_CAT_GENERAL (Table)
--   CAT_QEQ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CAT_QEQ IS

FUNCTION ES_QEQ(cTipoDocIdentEmp VARCHAR2,cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2;
-- jmmd20181123
PROCEDURE ES_QEQ_NVO(P_TIPO_DOC_IDENTIFICACION        VARCHAR2,
           P_NUM_DOC_IDENTIFICACION         VARCHAR2, 
           P_NOMCOMPQEQ                     OUT VARCHAR2, 
           P_FECHA_NACIMIENTOQEQ            OUT DATE, 
           P_FECNACIMIENTOPNJ               OUT DATE,
           P_RFCQEQ                         OUT VARCHAR2, 
           P_LISTAQEQ                       OUT VARCHAR2, 
           P_VALORSCG                       OUT VARCHAR2, 
           P_REGRESOQEQ                     OUT VARCHAR2);
END OC_CAT_QEQ;
/

--
-- OC_CAT_QEQ  (Package Body) 
--
--  Dependencies: 
--   OC_CAT_QEQ (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CAT_QEQ IS
--
-- BITACORA DE CAMBIO
-- ALTA   JICO 20170518
-- MODIFICAR LOS CRITERIOS DE VALIDACION EN QEQ		JMMD20181120
FUNCTION ES_QEQ(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2 IS
cES_QEQ     VARCHAR2(1);
 W_NOMBRE         ADMON_RIESGO.NOMBRE%TYPE;
 W_FECNACIMIENTO  PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
BEGIN
   W_NOMBRE        := TRIM(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentEmp, cNumDocIdentEmp));
   W_FECNACIMIENTO := OC_PERSONA_NATURAL_JURIDICA.FECHA_NACIMIENTO(cTipoDocIdentEmp, cNumDocIdentEmp);
   --
   -- VALIDA POR NOMBRE
   --
   BEGIN
     SELECT 'S'
       INTO cES_QEQ
       FROM CAT_QEQ Q
      WHERE Q.NOMCOMP = W_NOMBRE;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          --
          -- VALIDA POR RFC Y FECHA DE NACIMIENTO
          --
          BEGIN
            SELECT 'S'
               INTO cES_QEQ
               FROM CAT_QEQ Q
              WHERE Q.RFC = cNumDocIdentEmp
                AND Q.FECHA_NACIMIENTO = W_FECNACIMIENTO;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 --
                 -- VALIDA POR RFC
                 --
                 BEGIN
                   SELECT 'S'
                     INTO cES_QEQ
                     FROM CAT_QEQ Q
                    WHERE Q.RFC = cNumDocIdentEmp;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        cES_QEQ := 'N';
                   WHEN TOO_MANY_ROWS THEN
                       cES_QEQ := 'S';
                 END;
                 --
            WHEN TOO_MANY_ROWS THEN
                 cES_QEQ := 'S';
          END;
        --
     WHEN TOO_MANY_ROWS THEN
           cES_QEQ := 'S';
   END;
   --
   RETURN(cES_QEQ);
END ES_QEQ;

PROCEDURE ES_QEQ_NVO(P_TIPO_DOC_IDENTIFICACION                   VARCHAR2,
                                P_NUM_DOC_IDENTIFICACION         VARCHAR2, 
                                P_NOMCOMPQEQ                     OUT VARCHAR2, 
                                P_FECHA_NACIMIENTOQEQ            OUT DATE, 
                                P_FECNACIMIENTOPNJ               OUT DATE,
                                P_RFCQEQ                         OUT VARCHAR2, 
                                P_LISTAQEQ                       OUT VARCHAR2, 
                                P_VALORSCG                       OUT VARCHAR2, 
                                P_REGRESOQEQ                     OUT VARCHAR2) IS
                                
 W_NOMBRE                       ADMON_RIESGO.NOMBRE%TYPE;
 W_FECNACIMIENTO                PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
 W_NOMCOMP                      CAT_QEQ.NOMCOMP%TYPE;
 W_FECHA_NACIMIENTO             CAT_QEQ.fecha_nacimiento%TYPE;
 W_RFC                          CAT_QEQ.RFC%TYPE;
 W_LISTA                        CAT_QEQ.LISTA%TYPE;
 W_VALOR_LARGO                  SAI_CAT_GENERAL.CAGE_VALOR_LARGO%TYPE;
 
BEGIN
   W_NOMBRE        := TRIM(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION));
   W_FECNACIMIENTO := OC_PERSONA_NATURAL_JURIDICA.FECHA_NACIMIENTO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);
   --
   -- NECESIDAD 1
   --                                
   BEGIN
/*   criterios originales
 --      SELECT Q.NOMCOMP,nvl(to_date(fecha_nacimiento,'dd/mm/yyyy'),to_date('01/01/1900','dd/mm/yyyy')), Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO 
       SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO
       INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
       FROM CAT_QEQ Q
           , PERSONA_NATURAL_JURIDICA PNJ
           , SAI_CAT_GENERAL SCG
      WHERE Q.NOMCOMP = W_NOMBRE
      AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
      AND ((TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
           AND PNJ.FECNACIMIENTO IS NOT NULL
           AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO)
      OR (PNJ.FECNACIMIENTO IS NOT NULL
          AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL
          AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION)
      OR (PNJ.FECNACIMIENTO IS NULL
          AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL
          AND Q.RFC IS NOT NULL
          AND PNJ.NUM_DOC_IDENTIFICACION IS NOT NULL
          AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION))
      AND SCG.CAGE_CD_CATALOGO = 5
      AND SCG.CAGE_NOM_CONCEP = Q.LISTA
      AND ROWNUM = 1;  */
-- PRECISIÓN DE CRITERIOS  19/02/2019 SOLICITADO POR vICTOR M. MIRANDA

       SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO
       INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
       FROM CAT_QEQ Q
           , PERSONA_NATURAL_JURIDICA PNJ
           , SAI_CAT_GENERAL SCG
      WHERE (Q.NOMCOMP = W_NOMBRE
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
      AND PNJ.FECNACIMIENTO IS NOT NULL)
      OR (Q.NOMCOMP = W_NOMBRE
      AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
      AND Q.RFC IS NOT NULL
      AND PNJ.NUM_DOC_IDENTIFICACION IS NOT NULL)
      OR (Q.NOMCOMP = W_NOMBRE
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO
      AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
      AND Q.RFC IS NOT NULL
      AND PNJ.NUM_DOC_IDENTIFICACION IS NOT NULL
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
      AND PNJ.FECNACIMIENTO IS NOT NULL)
      AND SCG.CAGE_CD_CATALOGO = 5
      AND SCG.CAGE_NOM_CONCEP = Q.LISTA
      AND ROWNUM = 1;  
--
      P_REGRESOQEQ            := 'N1';
      P_NOMCOMPQEQ            := W_NOMCOMP;
      P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
      P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
      P_RFCQEQ                := W_RFC;
      P_LISTAQEQ              := W_LISTA;
      P_VALORSCG              := W_VALOR_LARGO;
      DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 1');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
                 -- VALIDA NECESIDAD 2
        BEGIN   
/*   criterios originales     
--          SELECT Q.NOMCOMP,nvl(to_date(fecha_nacimiento,'dd/mm/yyyy'),to_date('01/01/1900','dd/mm/yyyy')), Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO 
         SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO          
            INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
            FROM CAT_QEQ Q
                 , PERSONA_NATURAL_JURIDICA PNJ
                 , SAI_CAT_GENERAL SCG
           WHERE Q.NOMCOMP = W_NOMBRE
             AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
             AND ((TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
             AND PNJ.FECNACIMIENTO IS NOT NULL
             AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO)
             OR (PNJ.FECNACIMIENTO IS NOT NULL
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL
                AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION)
             OR (PNJ.FECNACIMIENTO IS NULL
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL
                AND PNJ.NUM_DOC_IDENTIFICACION IS NOT NULL
                AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION))
             AND SCG.CAGE_CD_CATALOGO = 5
             AND SCG.CAGE_NOM_CONCEP = Q.LISTA
             AND ROWNUM = 1;        */  
-- PRECISIÓN DE CRITERIOS  19/02/2019 SOLICITADO POR vICTOR M. MIRANDA

         SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO          
            INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
            FROM CAT_QEQ Q
                 , PERSONA_NATURAL_JURIDICA PNJ
                 , SAI_CAT_GENERAL SCG
           WHERE Q.NOMCOMP = W_NOMBRE
             AND (PNJ.NUM_DOC_IDENTIFICACION != P_NUM_DOC_IDENTIFICACION
             or TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO)
             AND SCG.CAGE_CD_CATALOGO = 5
             AND SCG.CAGE_NOM_CONCEP = Q.LISTA
             AND ROWNUM = 1;                           
--                
          P_REGRESOQEQ            := 'N2';
          P_NOMCOMPQEQ            := W_NOMCOMP;
          P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
          P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
          P_RFCQEQ                := W_RFC;
          P_LISTAQEQ              := W_LISTA;
          P_VALORSCG              := W_VALOR_LARGO;
          DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 2');
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
                 -- VALIDA NECESIDAD 3  
             BEGIN
/*   criterios originales              
--                SELECT Q.NOMCOMP,nvl(to_date(fecha_nacimiento,'dd/mm/yyyy'),to_date('01/01/1900','dd/mm/yyyy')), Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO 
                SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO                
                  INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
                  FROM CAT_QEQ Q
                       , PERSONA_NATURAL_JURIDICA PNJ
                       , SAI_CAT_GENERAL SCG
                WHERE Q.NOMCOMP = W_NOMBRE
                  AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
                  AND ((PNJ.NUM_DOC_IDENTIFICACION IS NOT NULL 
                  AND PNJ.FECNACIMIENTO IS NOT NULL
                  AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL
                  AND Q.RFC IS NULL)
                  OR (PNJ.FECNACIMIENTO IS NULL
                      AND PNJ.NUM_DOC_IDENTIFICACION IS NULL
                      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL
                      AND Q.RFC IS NOT NULL)
                  OR (PNJ.FECNACIMIENTO IS NULL
                      AND PNJ.NUM_DOC_IDENTIFICACION IS NULL
                      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL        
                      AND Q.RFC IS NULL))
                  AND SCG.CAGE_CD_CATALOGO = 5
                  AND SCG.CAGE_NOM_CONCEP = Q.LISTA
                  AND ROWNUM = 1;   */
                  
                SELECT Q.NOMCOMP,fecha_nacimiento, Q.RFC, Q.LISTA, SCG.CAGE_VALOR_LARGO                
                  INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC, W_LISTA, W_VALOR_LARGO
                  FROM CAT_QEQ Q
                       , PERSONA_NATURAL_JURIDICA PNJ
                       , SAI_CAT_GENERAL SCG
                WHERE Q.NOMCOMP = W_NOMBRE
                  AND (TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL
                  AND Q.RFC IS NULL)
                  OR (PNJ.FECNACIMIENTO IS NULL
                  AND PNJ.NUM_DOC_IDENTIFICACION IS NULL)
                  AND SCG.CAGE_CD_CATALOGO = 5
                  AND SCG.CAGE_NOM_CONCEP = Q.LISTA
                  AND ROWNUM = 1;   
                  
                P_REGRESOQEQ            := 'N3';
                P_NOMCOMPQEQ            := W_NOMCOMP;
                P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
                P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
                P_RFCQEQ                := W_RFC;
                P_LISTAQEQ              := W_LISTA;
                P_VALORSCG              := W_VALOR_LARGO;  
                
                DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 3');
             EXCEPTION
                WHEN OTHERS THEN
                 --                      
                P_REGRESOQEQ            := 'N4';
                P_NOMCOMPQEQ            := NULL;
                P_FECHA_NACIMIENTOQEQ   := NULL;
                P_FECNACIMIENTOPNJ      := NULL;
                P_RFCQEQ                := NULL;
                P_LISTAQEQ              := NULL;
                P_VALORSCG              := NULL;
                DBMS_OUTPUT.put_line('ME FUI POR DEFAULT A NECESIDAD 4');
             END;
        END;
--      
   END;   

END ES_QEQ_NVO;                              

END OC_CAT_QEQ;
/
