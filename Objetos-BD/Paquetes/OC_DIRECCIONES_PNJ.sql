CREATE OR REPLACE PACKAGE OC_DIRECCIONES_PNJ IS

  FUNCTION DIRECCION_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                             nCorrelativo NUMBER) RETURN VARCHAR2;

END OC_DIRECCIONES_PNJ;
/

CREATE OR REPLACE PACKAGE BODY OC_DIRECCIONES_PNJ IS

FUNCTION DIRECCION_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                           nCorrelativo NUMBER) RETURN VARCHAR2 IS
cDireccion  VARCHAR2(2000);
BEGIN
   BEGIN
      SELECT  TRIM(Direccion)||' '||TRIM(NumExterior)||' ' ||DECODE(NumInterior, NULL, NULL, 'Interior') ||' '||TRIM(NumInterior)||' '
              || TRIM (OC_COLONIA.DESCRIPCION_COLONIA(CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Postal, CodAsentamiento))
              ||', '||TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(CodPais, CodEstado))
              ||', '||TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(CodPais, CodEstado, CodCiudad, CodMunicipio))
              ||', CP '|| TRIM(Codigo_Postal)
        INTO cDireccion
        FROM DIRECCIONES_PNJ D
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND Correlativo_Direccion   = nCorrelativo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDireccion  := 'NO EXISTE';
   END;
  RETURN UPPER(TRIM(cDireccion));
END DIRECCION_PERSONA;

END OC_DIRECCIONES_PNJ;
