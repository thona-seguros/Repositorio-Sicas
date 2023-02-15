CREATE OR REPLACE PACKAGE OC_PROVEEDORES IS
  --
  PROCEDURE ACTIVAR_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER);
  PROCEDURE SUSPENDER_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER);
  FUNCTION NOMBRE_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) RETURN VARCHAR2;
  FUNCTION TIPO_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) RETURN VARCHAR2;
  FUNCTION OBTIENE_CODIGO_PROVEEDOR(cTipoDocIdentProv VARCHAR2, cNumDocIdentProv VARCHAR2,
                                    cTipoProveedor VARCHAR2, cClaseProveedor VARCHAR2) RETURN NUMBER;
  FUNCTION OBTIENE_TIPO_PROVEED(nCodCia NUMBER, nCodProveedor NUMBER) RETURN VARCHAR2;
  --
END OC_PROVEEDORES;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY oc_proveedores IS
--
--
--
PROCEDURE ACTIVAR_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) IS
--
BEGIN
  UPDATE PROVEEDORES
     SET StsProveedor = 'ACTIV',
         FecSts       = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodProveedor = cCodProveedor;
END ACTIVAR_PROVEEDOR;
--
--
--
PROCEDURE SUSPENDER_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) IS
--
BEGIN
  UPDATE PROVEEDORES
     SET StsProveedor = 'SUSPE',
         FecSts       = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodProveedor = cCodProveedor;
END SUSPENDER_PROVEEDOR;
--
--
--
FUNCTION NOMBRE_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) RETURN VARCHAR2 IS
--
cNombre       VARCHAR2(500);
--
BEGIN
  BEGIN
    SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
      INTO cNombre
      FROM PERSONA_NATURAL_JURIDICA
     WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
           (SELECT TipoDocIdentProv, NumDocIdentProv
              FROM PROVEEDORES
             WHERE CodCia        = nCodCia
               AND CodProveedor  = cCodProveedor);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      cNombre := 'Proveedor Código ' || cCodProveedor || ' NO Existe';
         --RAISE_APPLICATION_ERROR(-20225,'Proveedor Código ' || cCodProveedor || ' NO Existe');
  END;
  RETURN(cNombre);
END NOMBRE_PROVEEDOR;
--
--
--
FUNCTION TIPO_PROVEEDOR(nCodCia NUMBER, cCodProveedor NUMBER) RETURN VARCHAR2 IS
--
cTipoProveedor     PROVEEDORES.TipoProveedor%TYPE;
--
BEGIN
  BEGIN
    SELECT TipoProveedor
      INTO cTipoProveedor
      FROM PROVEEDORES
     WHERE CodCia       = nCodCia
       AND CodProveedor = cCodProveedor;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'Proveedor Código ' || cCodProveedor || ' NO Existe para Determinar su Tipo');
  END;
  RETURN(cTipoProveedor);
END TIPO_PROVEEDOR;
--
--
--
FUNCTION OBTIENE_CODIGO_PROVEEDOR(cTipoDocIdentProv VARCHAR2, cNumDocIdentProv VARCHAR2,
                                  cTipoProveedor VARCHAR2, cClaseProveedor VARCHAR2) RETURN NUMBER IS
--
cCodProveedor     PROVEEDORES.CodProveedor%TYPE;
--
BEGIN
  BEGIN
    SELECT CodProveedor
      INTO cCodProveedor
      FROM PROVEEDORES
     WHERE TipoDocIdentProv = cTipoDocIdentProv
       AND NumDocIdentProv  = cNumDocIdentProv
       AND TipoProveedor    = NVL(cTipoProveedor,TipoProveedor)
       AND ClaseProveedor   = NVL(cClaseProveedor,ClaseProveedor)
       AND StsProveedor     = 'ACTIV';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      cCodProveedor := NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al obtener el Código del Proveedor: '||SQLERRM);
  END;
  RETURN(cCodProveedor);
END OBTIENE_CODIGO_PROVEEDOR;
--
--
--
FUNCTION OBTIENE_TIPO_PROVEED(nCodCia NUMBER, nCodProveedor NUMBER) RETURN VARCHAR2 IS
--
cTipoProveedor     MEDICO.TipoProveedor%TYPE;
--
BEGIN
  BEGIN
    SELECT TipoProveedor
      INTO cTipoProveedor
      FROM PROVEEDORES
     WHERE CodCia        = nCodCia
       AND CodProveedor  = nCodProveedor
       AND StsProveedor  = 'ACTIV';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al obtener el Tipo de Proveedor: '|| SQLERRM);
  END;
  RETURN(cTipoProveedor);
END OBTIENE_TIPO_PROVEED;
--
--
--
END OC_PROVEEDORES;
