--
-- OC_MEDIOS_DE_PAGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   MEDIOS_DE_PAGO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_MEDIOS_DE_PAGO IS

  PROCEDURE INSERTAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                     nIdFormaPago NUMBER, cIndMedioPrincipal VARCHAR2, cCodFormaPago VARCHAR2);

  FUNCTION EXISTE_MEDIO_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                                 nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION FORMA_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                          nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION ENTIDAD_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                            nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION CUENTA_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                           nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION CUENTA_CLABE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                        nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION NUMERO_DE_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                             nIdFormaPago NUMBER) RETURN VARCHAR2;

  FUNCTION VENCIMIENTO_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdFormaPago NUMBER) RETURN DATE;

  FUNCTION MEDIO_PRINCIPAL_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER;

END OC_MEDIOS_DE_PAGO;
/

--
-- OC_MEDIOS_DE_PAGO  (Package Body) 
--
--  Dependencies: 
--   OC_MEDIOS_DE_PAGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_MEDIOS_DE_PAGO IS

PROCEDURE INSERTAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                   nIdFormaPago NUMBER, cIndMedioPrincipal VARCHAR2, cCodFormaPago VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO MEDIOS_DE_PAGO
             (Tipo_Doc_Identificacion, Num_Doc_Identificacion, IdFormaPago, IndMedioPrincipal,
              CodFormaPago, CodEntidadFinan, NumCuentaBancaria, NumCuentaClabe, NumTarjeta,
              FechaVencTarjeta, ABA_Swift, NombreBancoIntermediario, CuentaBancoIntermediario,
              ABA_Swift_Intermediario)
      VALUES (cTipo_Doc_Identificacion, cNum_Doc_Identificacion, nIdFormaPago, cIndMedioPrincipal,
              cCodFormaPago, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Medio de Pago No. ' || nIdFormaPago || ' Ya Existe');
   END;
END INSERTAR;

FUNCTION EXISTE_MEDIO_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_MEDIO_DE_PAGO;

FUNCTION FORMA_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                        nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cCodFormaPAGO    MEDIOS_DE_PAGO.CodFormaPAGO%TYPE;
BEGIN
   BEGIN
      SELECT CodFormaPAGO
        INTO cCodFormaPAGO
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodFormaPAGO := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(cCodFormaPAGO);
END FORMA_DE_PAGO;

FUNCTION ENTIDAD_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                          nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cCodEntidadFinan    MEDIOS_DE_PAGO.CodEntidadFinan%TYPE;
BEGIN
   BEGIN
      SELECT CodEntidadFinan
        INTO cCodEntidadFinan
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodEntidadFinan := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(cCodEntidadFinan);
END ENTIDAD_BANCARIA;

FUNCTION CUENTA_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                         nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cNumCuentaBancaria    MEDIOS_DE_PAGO.NumCuentaBancaria%TYPE;
BEGIN
   BEGIN
      SELECT NumCuentaBancaria
        INTO cNumCuentaBancaria
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumCuentaBancaria := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(cNumCuentaBancaria);
END CUENTA_BANCARIA;

FUNCTION CUENTA_CLABE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                      nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cNumCuentaClabe    MEDIOS_DE_PAGO.NumCuentaClabe%TYPE;
BEGIN
   BEGIN
      SELECT NumCuentaClabe
        INTO cNumCuentaClabe
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumCuentaClabe := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(cNumCuentaClabe);
END CUENTA_CLABE;

FUNCTION NUMERO_DE_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                           nIdFormaPago NUMBER) RETURN VARCHAR2 IS
cNumTarjeta    MEDIOS_DE_PAGO.NumTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT NumTarjeta
        INTO cNumTarjeta
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumTarjeta := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(cNumTarjeta);
END NUMERO_DE_TARJETA;

FUNCTION VENCIMIENTO_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                             nIdFormaPago NUMBER) RETURN DATE IS
dFechaVencTarjeta    MEDIOS_DE_PAGO.FechaVencTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT FechaVencTarjeta
        INTO dFechaVencTarjeta
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaPago             = nIdFormaPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFechaVencTarjeta := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Configurados con el Mismo No. de Registro '||nIdFormaPago);
   END;
   RETURN(dFechaVencTarjeta);
END VENCIMIENTO_TARJETA;

FUNCTION MEDIO_PRINCIPAL_DE_PAGO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
nIdFormaPago    MEDIOS_DE_PAGO.IdFormaPago%TYPE;
BEGIN
   BEGIN
      SELECT IdFormaPago
        INTO nIdFormaPago
        FROM MEDIOS_DE_PAGO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IndMedioPrincipal       = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdFormaPago := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de PAGO Principales Configurados');
   END;
   RETURN(nIdFormaPago);
END MEDIO_PRINCIPAL_DE_PAGO;

END OC_MEDIOS_DE_PAGO;
/
