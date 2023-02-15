CREATE OR REPLACE PACKAGE OC_RESERVAS_TECNICAS_CONTAB IS
  PROCEDURE INSERTAR(nIdReserva NUMBER, cCodCptoResRva VARCHAR2, cCodCptoRva VARCHAR2,
                     nMtoCptoRva NUMBER, cDescCptoRva VARCHAR2);
  PROCEDURE ELIMINAR(nIdReserva NUMBER);

END OC_RESERVAS_TECNICAS_CONTAB;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_RESERVAS_TECNICAS_CONTAB IS

PROCEDURE INSERTAR(nIdReserva NUMBER, cCodCptoResRva VARCHAR2, cCodCptoRva VARCHAR2,
                   nMtoCptoRva NUMBER, cDescCptoRva VARCHAR2) IS
nIdContabRvas    RESERVAS_TECNICAS_CONTAB.IdContabRvas%TYPE;
BEGIN
   SELECT NVL(MAX(IdContabRvas),0) + 1
     INTO nIdContabRvas
     FROM RESERVAS_TECNICAS_CONTAB
    WHERE IdReserva = nIdReserva;

   BEGIN
      INSERT INTO RESERVAS_TECNICAS_CONTAB
             (IdReserva, IdContabRvas, CodCptoResRva, CodCptoRva,
              MtoCptoRva, DescCptoRva)
      VALUES (nIdReserva, nIdContabRvas, cCodCptoResRva, cCodCptoRva,
              nMtoCptoRva, cDescCptoRva);
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar INSERT en RESERVAS_TECNICAS_CONTAB '|| SQLERRM );
   END;
END INSERTAR;

PROCEDURE ELIMINAR(nIdReserva NUMBER) IS
BEGIN
   DELETE RESERVAS_TECNICAS_CONTAB
    WHERE IdReserva = nIdReserva;
END ELIMINAR;

END OC_RESERVAS_TECNICAS_CONTAB;
