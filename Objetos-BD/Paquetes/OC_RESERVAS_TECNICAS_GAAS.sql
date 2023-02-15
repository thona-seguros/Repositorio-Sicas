CREATE OR REPLACE PACKAGE OC_RESERVAS_TECNICAS_GAAS AS
PROCEDURE INSERTAR_TRIMESTRE(nIdReserva NUMBER, nIdTrimestre NUMBER, nPrimaNetaTrim NUMBER);
PROCEDURE RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt NUMBER, nIdReserva NUMBER);
END OC_RESERVAS_TECNICAS_GAAS;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_RESERVAS_TECNICAS_GAAS AS

PROCEDURE INSERTAR_TRIMESTRE(nIdReserva NUMBER, nIdTrimestre NUMBER, nPrimaNetaTrim NUMBER) IS
BEGIN
   INSERT INTO RESERVAS_TECNICAS_GAAS
          (IdReserva, IdTrimestre, PrimaNetaTrim, ConstReserva,
           RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
           PrimaCedida, FactorCedida, RvaReasegCedido)
   VALUES (nIdReserva, nIdTrimestre, nPrimaNetaTrim, 0,
           0, 0, 0, 0, 0, 0, 0);
END INSERTAR_TRIMESTRE;

PROCEDURE RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt NUMBER, nIdReserva NUMBER) IS
CURSOR RVA_Q IS
   SELECT IdTrimestre, PrimaNetaTrim, ConstReserva,
          RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
          PrimaCedida, FactorCedida, RvaReasegCedido
     FROM RESERVAS_TECNICAS_GAAS
    WHERE IdReserva = nIdReservaAnt
         ORDER BY IdTrimestre;
BEGIN
   FOR X IN RVA_Q LOOP
      INSERT INTO RESERVAS_TECNICAS_GAAS
             (IdReserva, IdTrimestre, PrimaNetaTrim, ConstReserva,
              RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
              PrimaCedida, FactorCedida, RvaReasegCedido)
      VALUES (nIdReserva, X.IdTrimestre, X.PrimaNetaTrim, X.ConstReserva,
              X.RRCVidaInd, X.RvaAcumTrim, X.LimSupReserva, X.RvaTotTrimestre, 
              X.PrimaCedida, X.FactorCedida, X.RvaReasegCedido);
   END LOOP;
END RESERVA_TRIMESTRE_ANTERIOR;

END OC_RESERVAS_TECNICAS_GAAS;
