--
-- OC_MEDIOS_DE_COBRO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   MEDIOS_DE_COBRO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_MEDIOS_DE_COBRO IS

  PROCEDURE INSERTAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                     nIdFormaCobro NUMBER, cIndMedioPrincipal VARCHAR2, cCodFormaCobro VARCHAR2);

  FUNCTION EXISTE_MEDIO_DE_COBRO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                                 nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION FORMA_DE_COBRO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                          nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION ENTIDAD_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                            nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION CUENTA_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                           nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION CUENTA_CLABE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                        nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION NUMERO_DE_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                             nIdFormaCobro NUMBER) RETURN VARCHAR2;

  FUNCTION VENCIMIENTO_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdFormaCobro NUMBER) RETURN DATE;

  FUNCTION NOMBRE_TITULAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                          nIdFormaCobro NUMBER) RETURN DATE;

END OC_MEDIOS_DE_COBRO;
/

--
-- OC_MEDIOS_DE_COBRO  (Package Body) 
--
--  Dependencies: 
--   OC_MEDIOS_DE_COBRO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_MEDIOS_DE_COBRO IS

PROCEDURE INSERTAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                   nIdFormaCobro NUMBER, cIndMedioPrincipal VARCHAR2, cCodFormaCobro VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO MEDIOS_DE_COBRO
             (Tipo_Doc_Identificacion, Num_Doc_Identificacion, IdFormaCobro, IndMedioPrincipal,
              CodFormaCobro, CodEntidadFinan, NumCuentaBancaria, NumCuentaClabe, NumTarjeta,
              FechaVencTarjeta)
      VALUES (cTipo_Doc_Identificacion, cNum_Doc_Identificacion, nIdFormaCobro, cIndMedioPrincipal,
              cCodFormaCobro, NULL, NULL, NULL, NULL, NULL);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Medio de Cobro No. ' || nIdFormaCobro || ' Ya Existe');
   END;
END INSERTAR;

FUNCTION EXISTE_MEDIO_DE_COBRO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_MEDIO_DE_COBRO;

FUNCTION FORMA_DE_COBRO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                        nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cCodFormaCobro    MEDIOS_DE_COBRO.CodFormaCobro%TYPE;
BEGIN
   BEGIN
      SELECT CodFormaCobro
        INTO cCodFormaCobro
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodFormaCobro := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cCodFormaCobro);
END FORMA_DE_COBRO;

FUNCTION ENTIDAD_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                          nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cCodEntidadFinan    MEDIOS_DE_COBRO.CodEntidadFinan%TYPE;
BEGIN
   BEGIN
      SELECT CodEntidadFinan
        INTO cCodEntidadFinan
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodEntidadFinan := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cCodEntidadFinan);
END ENTIDAD_BANCARIA;

FUNCTION CUENTA_BANCARIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                         nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cNumCuentaBancaria    MEDIOS_DE_COBRO.NumCuentaBancaria%TYPE;
BEGIN
   BEGIN
      SELECT NumCuentaBancaria
        INTO cNumCuentaBancaria
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumCuentaBancaria := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cNumCuentaBancaria);
END CUENTA_BANCARIA;

FUNCTION CUENTA_CLABE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                      nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cNumCuentaClabe    MEDIOS_DE_COBRO.NumCuentaClabe%TYPE;
BEGIN
   BEGIN
      SELECT NumCuentaClabe
        INTO cNumCuentaClabe
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumCuentaClabe := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cNumCuentaClabe);
END CUENTA_CLABE;

FUNCTION NUMERO_DE_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                           nIdFormaCobro NUMBER) RETURN VARCHAR2 IS
cNumTarjeta    MEDIOS_DE_COBRO.NumTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT NumTarjeta
        INTO cNumTarjeta
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumTarjeta := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cNumTarjeta);
END NUMERO_DE_TARJETA;

FUNCTION VENCIMIENTO_TARJETA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                             nIdFormaCobro NUMBER) RETURN DATE IS
dFechaVencTarjeta    MEDIOS_DE_COBRO.FechaVencTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT FechaVencTarjeta
        INTO dFechaVencTarjeta
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFechaVencTarjeta := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(dFechaVencTarjeta);
END VENCIMIENTO_TARJETA;

FUNCTION NOMBRE_TITULAR(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                        nIdFormaCobro NUMBER) RETURN DATE IS
cNombreTitular    MEDIOS_DE_COBRO.NombreTitular%TYPE;
BEGIN
   BEGIN
      SELECT NombreTitular
        INTO cNombreTitular
        FROM MEDIOS_DE_COBRO
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND IdFormaCobro            = nIdFormaCobro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombreTitular := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe Varios Medios de Cobro Configurados con el Mismo No. de Registro '||nIdFormaCobro);
   END;
   RETURN(cNombreTitular);
END NOMBRE_TITULAR;

END OC_MEDIOS_DE_COBRO;
/
