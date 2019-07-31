--
-- ASEGURADO_ASISTENCIA  (View) 
--
--  Dependencies: 
--   DETALLE_POLIZA (Table)
--   ASEGURADO (Table)
--   ASEGURADO_CERT (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   OC_ASEGURADO_CERTIFICADO (Package)
--
CREATE OR REPLACE FORCE VIEW SICAS_OC.ASEGURADO_ASISTENCIA
(IDPOLIZA, IDETPOL, TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION, CODCIA, 
 CODEMPRESA)
AS 
(SELECT DISTINCT AC.IdPoliza, AC.IDetPol,A.Tipo_Doc_Identificacion,A.Num_Doc_Identificacion,A.codcia,A.codempresa
    FROM ASEGURADO A, ASEGURADO_CERTIFICADO AC
      WHERE AC.CodCia = A.CodCia
        AND AC.Cod_Asegurado          = A.Cod_Asegurado
   UNION
   SELECT DISTINCT AC.IdPoliza, AC.IDetPol,A.Tipo_Doc_Identificacion,A.Num_Doc_Identificacion,A.codcia,A.codempresa
     FROM ASEGURADO A, ASEGURADO_CERT AC
       WHERE AC.CodCia = A.CodCia
         AND AC.Cod_Asegurado          = A.Cod_Asegurado
   UNION
   SELECT DISTINCT D.IdPoliza, D.IDetPol,A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion,A.codcia,A.codempresa
     FROM ASEGURADO A, DETALLE_POLIZA D
       WHERE OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(D.CodCia, D.IdPoliza, D.IDetPol, 0) = 'N'
         AND D.CodCia                  = A.CodCia
         AND D.Cod_Asegurado           = A.Cod_Asegurado )
/
