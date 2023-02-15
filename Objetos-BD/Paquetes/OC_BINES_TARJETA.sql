CREATE OR REPLACE PACKAGE OC_BINES_TARJETA IS
  --
  PROCEDURE INSERTA(nCodCia NUMBER, cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2, cCodEntidad VARCHAR2,
                    nPrefijo NUMBER, cProducto VARCHAR2, cTipoSistema VARCHAR2, cTipoTarjeta VARCHAR2);
  --
  FUNCTION VALIDAR_BIN(nCodCia NUMBER, cCodEntidad VARCHAR2, cNumTarjeta VARCHAR2) RETURN VARCHAR2;
  --
END OC_BINES_TARJETA;
/

CREATE OR REPLACE PACKAGE BODY OC_BINES_TARJETA IS
  --
  FUNCTION VALIDAR_BIN(nCodCia NUMBER, cCodEntidad VARCHAR2, cNumTarjeta VARCHAR2) RETURN VARCHAR2 IS
    --
    cValida   VARCHAR2(1);
    cPrefijo  VARCHAR2(6) := SUBSTR(cNumTarjeta,1,6);
	--
  BEGIN
    BEGIN
      SELECT 'S'
        INTO cValida
        FROM BINES_TARJETA
       WHERE CodCia                  = nCodCia
         AND CodEntidad              = cCodEntidad
         AND Prefijo                 = cPrefijo;
    EXCEPTION
      WHEN OTHERS THEN
        cValida := 'N';
    END;
    --
    RETURN(cValida);
    --
  END VALIDAR_BIN;
  --
  PROCEDURE INSERTA(nCodCia NUMBER, cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2, cCodEntidad VARCHAR2,
                    nPrefijo NUMBER, cProducto VARCHAR2, cTipoSistema VARCHAR2, cTipoTarjeta VARCHAR2) IS
    --
  BEGIN
    INSERT INTO BINES_TARJETA
          (CodCia, Tipo_Doc_Identificacion, Num_Doc_Identificacion, CodEntidad, Prefijo,
           Producto, TipoSistema, TipoTarjeta, FechaAlta, CodUsuario)
    VALUES(nCodCia, cTipo_Doc_Identificacion, cNum_Doc_Identificacion, cCodEntidad,
            nPrefijo, cProducto, cTipoSistema, cTipoTarjeta, SYSDATE, USER);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'INSERCION BEFEF_SIN_PAGOS - Ocurrió el siguiente error: '||SQLERRM);
  END INSERTA;
  --
END OC_BINES_TARJETA;
