--
-- GT_FAI_PRECIOS_DIARIOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--   FAI_PRECIOS_DIARIOS (Table)
--   OC_EMPRESAS (Package)
--   OC_MAIL (Package)
--   EMPRESAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_PRECIOS_DIARIOS AS

FUNCTION PRECIO (cTipoPrecio VARCHAR2, dFecPrecio DATE) RETURN NUMBER;

PROCEDURE REVISION_AUTOMATICA_EXISTENCIA;

END GT_FAI_PRECIOS_DIARIOS;
/

--
-- GT_FAI_PRECIOS_DIARIOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_PRECIOS_DIARIOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_PRECIOS_DIARIOS  AS

FUNCTION PRECIO (cTipoPrecio VARCHAR2, dFecPrecio DATE) RETURN NUMBER IS
nPrecioDiario    FAI_PRECIOS_DIARIOS.PrecioDiario%TYPE;
BEGIN
   BEGIN
      SELECT PrecioDiario
        INTO nPrecioDiario
        FROM FAI_PRECIOS_DIARIOS
       WHERE TipoPrecio       = cTipoPrecio
         AND TRUNC(FecPrecio) = TRUNC(dFecPrecio);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No Existe Precio  '||cTipoPrecio||
		                           ' para la Fecha: '||TO_DATE(dFecPrecio,'DD/MM/YYYY'));
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros para el Precio  '||cTipoPrecio||
		                           ' para la Fecha: '||TO_DATE(dFecPrecio,'DD/MM/YYYY'));
   END;
   RETURN(NVL(nPrecioDiario,0));
END PRECIO;

PROCEDURE REVISION_AUTOMATICA_EXISTENCIA IS
dFecha             DATE;
nRegs              NUMBER(10);
bFalta             BOOLEAN;
cReferencia        VARCHAR(2000);

CURSOR PRECIOS_Q IS
   SELECT DISTINCT TipoPrecio
     FROM FAI_PRECIOS_DIARIOS;
BEGIN
   dFecha := TRUNC(SYSDATE) -1;
   FOR X IN 1..5 LOOP   -- Verifica hasta 5 días atrás....
       bFalta        := FALSE;
       cReferencia   := '';
       FOR W IN PRECIOS_Q LOOP
           SELECT COUNT(*)
             INTO nRegs
             FROM FAI_PRECIOS_DIARIOS
            WHERE TipoPrecio       = W.TipoPrecio
              AND TRUNC(FecPrecio) = TRUNC(dFecha);
           
           IF nRegs = 0 THEN
              bFalta := TRUE; 
              IF LENGTH(cReferencia) = 0 THEN
                 cReferencia := W.TipoPrecio;
              ELSE   
                 cReferencia := cReferencia || ' - ' || W.TipoPrecio;
              END IF;
           END IF;
       END LOOP;
       
       IF bFalta = TRUE THEN         
          FOR Z IN (SELECT CodCia, Email
                      FROM USUARIOS
                     WHERE Email        IS NOT NULL
                       AND IndRevisaPrecios = 'S'
                     UNION
                    SELECT CodCia, Email
                      FROM EMPRESAS
                     WHERE CodCia   IN (SELECT DISTINCT CodCia
                                           FROM USUARIOS
                                          WHERE IndRevisaPrecios = 'S')) LOOP
              OC_MAIL.MAIL(OC_EMPRESAS.EMAIL_COMPANIA(Z.CodCia), Z.Email, NULL, NULL, 'Revisión de Precios Diarios de Unidades SICAS-OC',
                      'No existe el(los) Precio(s) Diario(s) ( ' || cReferencia || ' ); para el Día ' || 
                       TO_CHAR( dFecha, 'DD/MM/RRRR' ) || ', Por Favor Verificarlos y Actualizar los Precios');
          END LOOP;
       END IF;
       dFecha := TRUNC( SYSDATE ) - X;
   END LOOP;
END REVISION_AUTOMATICA_EXISTENCIA;

END GT_FAI_PRECIOS_DIARIOS;
/

--
-- GT_FAI_PRECIOS_DIARIOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_PRECIOS_DIARIOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_PRECIOS_DIARIOS FOR SICAS_OC.GT_FAI_PRECIOS_DIARIOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_PRECIOS_DIARIOS TO PUBLIC
/
