CREATE OR REPLACE PACKAGE OC_CTES_CERTIF_INDIV AS
FUNCTION NUMERO_CLIENTE (nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER, nCodCliente NUMBER);
PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER);
PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER);
FUNCTION EXISTE_CTE_CERT (nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER) RETURN VARCHAR2;
END OC_CTES_CERTIF_INDIV;
/

CREATE OR REPLACE PACKAGE BODY OC_CTES_CERTIF_INDIV AS
FUNCTION NUMERO_CLIENTE (nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdCertCte CTES_CERTIF_INDIV.IdCertCte%TYPE;
BEGIN
   SELECT CTES_CERTIF_INDIV_SEQ.NEXTVAL
     INTO nIdCertCte
     FROM DUAL;

   RETURN nIdCertCte;
END NUMERO_CLIENTE;

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER, nCodCliente NUMBER) IS
BEGIN
   INSERT INTO CTES_CERTIF_INDIV (IdCertCte, CodCia, CodEmpresa, CodCliente, StsCertCte, 
                                  FecRegistro, UserRegistro, FecUltActualiza, UserUltActualiza)
                          VALUES (nIdCertCte, nCodCia, nCodEmpresa, nCodCliente, 'SOL',
                                  SYSDATE, USER, SYSDATE, USER);
END INSERTAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER) IS
BEGIN
   UPDATE CTES_CERTIF_INDIV 
      SET StsCertCte       = 'ACT',
          FecUltActualiza  = SYSDATE,
          UserUltActualiza = USER
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa 
      AND IdCertCte  = nIdCertCte ;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCertCte NUMBER) IS
BEGIN
   UPDATE CTES_CERTIF_INDIV 
      SET StsCertCte       = 'SUS',
          FecUltActualiza  = SYSDATE,
          UserUltActualiza = USER
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa 
      AND IdCertCte  = nIdCertCte ;
END SUSPENDER;

FUNCTION EXISTE_CTE_CERT (nCodCia   NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : EXISTE_CTE_CERT                                                                                                  |
    | Objetivo   : Funcion verifica la existencia del Cliente del que forma parte el Asegurado en la tabla CTES_CERTIF_INDIV.       |
    |              Arroja "S" cuando si existe y "N" cuando no es asi.                                                              |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodCliente             Codigo del Cliente              (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
cExiste    VARCHAR2(1);
 BEGIN
    BEGIN
             SELECT 'S'
             INTO   cExiste
             FROM   CTES_CERTIF_INDIV
             WHERE  CodCliente  = nCodCliente
             AND    CodCia      = nCodCia
             AND    CodEmpresa  = nCodEmpresa;
        EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
    END;    
    RETURN cExiste;
END EXISTE_CTE_CERT;

END OC_CTES_CERTIF_INDIV;
