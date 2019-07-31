--
-- OC_SALARIO_MINIMO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SALARIO_MINIMO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SALARIO_MINIMO IS
  --
  FUNCTION CORRELATIVO RETURN NUMBER;
  --
  PROCEDURE INSERTA(cAreaGeografica  VARCHAR2, dFechaInicio  DATE, dFechaFinal DATE,
                    nSalarioMinimoDiario NUMBER, nSalarioMinimoMensual NUMBER);
  --
END OC_SALARIO_MINIMO;
/

--
-- OC_SALARIO_MINIMO  (Package Body) 
--
--  Dependencies: 
--   OC_SALARIO_MINIMO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SALARIO_MINIMO IS
  --
  FUNCTION CORRELATIVO RETURN NUMBER IS
    --
    nCorrelativo    SALARIO_MINIMO.IdSalarioMinimo%TYPE;
    --
  BEGIN
    --
    SELECT NVL(MAX(IdSalarioMinimo),0)+1
      INTO nCorrelativo
      FROM SALARIO_MINIMO;
    RETURN(nCorrelativo);
    --
  END;
  --
  --
  --
  PROCEDURE INSERTA(cAreaGeografica  VARCHAR2, dFechaInicio  DATE, dFechaFinal DATE,
                    nSalarioMinimoDiario NUMBER, nSalarioMinimoMensual NUMBER) IS
    --
    nCorrelativo    SALARIO_MINIMO.IdSalarioMinimo%TYPE := OC_SALARIO_MINIMO.Correlativo;
    --
  BEGIN
    INSERT INTO SALARIO_MINIMO
          (IdSalarioMinimo, AreaGeografica, FechaInicio, FechaFinal,
           SalarioMinimoDiario, SalarioMinimoMensual, UsuarioInserta, FechaInsercion)
    VALUES(nCorrelativo, cAreaGeografica, dFechaInicio, dFechaFinal,
            nSalarioMinimoDiario, nSalarioMinimoMensual, USER, SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'INSERCION BEFEF_SIN_PAGOS - Ocurrió el siguiente error: '||SQLERRM);
  END INSERTA;

END OC_SALARIO_MINIMO;
/
