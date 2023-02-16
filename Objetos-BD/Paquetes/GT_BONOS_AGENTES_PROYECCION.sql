CREATE OR REPLACE PACKAGE GT_BONOS_AGENTES_PROYECCION AS
FUNCTION  NUMERO_PROYECCION(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
PROCEDURE INSERTA_BONO_CALCULADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCalculoProy NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                                 cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, 
                                 nProdPrimaNeta NUMBER, nCantPolizas NUMBER, nMesesProd NUMBER, nCantAgentesProd NUMBER,
                                 nPorcenSiniest NUMBER, nPorcenBonoActual NUMBER);
PROCEDURE CALCULO_PROYECCIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCalculoProy NUMBER, nIdBonoVentas NUMBER);                                 
END GT_BONOS_AGENTES_PROYECCION;
/

CREATE OR REPLACE PACKAGE BODY GT_BONOS_AGENTES_PROYECCION AS
FUNCTION NUMERO_PROYECCION(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
    nIdCalculoProy BONOS_AGENTES_PROYECCION.IdCalculoProy%TYPE;
BEGIN
    SELECT NVL(MAX(IdCalculoProy),0) + 1
      INTO nIdCalculoProy
      FROM BONOS_AGENTES_PROYECCION
     WHERE CodCia     = nCodCia 
       AND CodEmpresa = nCodEmpresa;
    RETURN nIdCalculoProy;
END NUMERO_PROYECCION;

PROCEDURE INSERTA_BONO_CALCULADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCalculoProy NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                                 cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, 
                                 nProdPrimaNeta NUMBER, nCantPolizas NUMBER, nMesesProd NUMBER, nCantAgentesProd NUMBER,
                                 nPorcenSiniest NUMBER, nPorcenBonoActual NUMBER) IS
BEGIN
    BEGIN
      INSERT INTO BONOS_AGENTES_PROYECCION
            (CodCia, CodEmpresa, IdCalculoProy, IdBonoVentas, CodNivel, CodAgente, FecIniCalcBono, FecFinCalcBono,
             ProdPrimaNeta, CantPolizas, MesesProd, CantAgentesProd, PorcenSiniest, PorcenBonoActual, MontoNivel1, 
             PorcenNivel1, MontoNivel2, PorcenNivel2, MontoNivel3, PorcenNivel3, MontoNivel4, PorcenNivel4, 
             MontoNivelSup, PorcenNivelSup, FecCalculoProy, CodUsuario)
      VALUES(nCodCia, nCodEmpresa, nIdCalculoProy, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono, dFecFinCalcBono,
             nProdPrimaNeta, nCantPolizas, nMesesProd, nCantAgentesProd, nPorcenSiniest, nPorcenBonoActual, 0, 
             0, 0, 0, 0, 0, 0, 0,
             0, 0, TRUNC(SYSDATE), USER);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Bono Calculado para Nivel ' || nCodNivel || 
                                 ' y Código ' || cCodAgente || ' para Bono No. ' || nIdBonoVentas);
   END;
END INSERTA_BONO_CALCULADO;

PROCEDURE CALCULO_PROYECCIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCalculoProy NUMBER, nIdBonoVentas NUMBER) IS
    nMontoNivel1    BONOS_AGENTES_PROYECCION.MontoNivel1%TYPE := 0;
    nMontoNivel2    BONOS_AGENTES_PROYECCION.MontoNivel2%TYPE := 0;
    nMontoNivel3    BONOS_AGENTES_PROYECCION.MontoNivel3%TYPE := 0;
    nMontoNivel4    BONOS_AGENTES_PROYECCION.MontoNivel4%TYPE := 0;
    nMontoNivelSup  BONOS_AGENTES_PROYECCION.MontoNivelSup%TYPE := 0;
    nMontoAcumSup   BONOS_AGENTES_PROYECCION.MontoNivelSup%TYPE := 0;
    
    nPorcenNivel1    BONOS_AGENTES_PROYECCION.PorcenNivel1%TYPE := 0;
    nPorcenNivel2    BONOS_AGENTES_PROYECCION.PorcenNivel2%TYPE := 0;
    nPorcenNivel3    BONOS_AGENTES_PROYECCION.PorcenNivel3%TYPE := 0;
    nPorcenNivel4    BONOS_AGENTES_PROYECCION.PorcenNivel4%TYPE := 0;
    nPorcenNivelSup  BONOS_AGENTES_PROYECCION.PorcenNivelSup%TYPE := 0;

    CURSOR PROY_Q IS
        SELECT CodNivel, FecIniCalcBono, FecFinCalcBono,
               ProdPrimaNeta, PorcenBonoActual, CodAgente
          FROM BONOS_AGENTES_PROYECCION
         WHERE CodCia           = nCodCia
           AND CodEmpresa       = nCodEmpresa
           AND IdCalculoProy    = nIdCalculoProy
           AND IdBonoVentas     = nIdBonoVentas
           FOR UPDATE; 
           
    CURSOR RANGOS_Q IS 
        SELECT FecIniVig, FecFinVig, RangoInicial,
               RangoFinal, PorcenBono, ROWNUM Nivel
          FROM BONOS_AGENTES_RANGOS
         WHERE CodCia           = nCodCia
           AND CodEmpresa       = nCodEmpresa
           AND IdBonoVentas     = nIdBonoVentas;                  

BEGIN
    FOR X IN PROY_Q LOOP
        FOR W IN RANGOS_Q LOOP
            IF W.Nivel = 1 THEN 
                IF W.RangoFinal < X.ProdPrimaNeta THEN
                    nMontoNivel1 := 0;
                ELSIF W.RangoFinal > X.ProdPrimaNeta AND W.RangoInicial < X.ProdPrimaNeta THEN 
                    nMontoNivel1 := 0;
                ELSIF W.RangoInicial > X.ProdPrimaNeta THEN
                    nMontoNivel1 := W.RangoInicial - X.ProdPrimaNeta;
                END IF;
                nPorcenNivel1 := W.PorcenBono;
            ELSIF W.Nivel = 2 THEN 
                IF W.RangoFinal < X.ProdPrimaNeta THEN
                    nMontoNivel2 := 0;
                ELSIF W.RangoFinal > X.ProdPrimaNeta AND W.RangoInicial < X.ProdPrimaNeta THEN 
                    nMontoNivel2 := 0;
                ELSIF W.RangoInicial > X.ProdPrimaNeta THEN
                    nMontoNivel2 := W.RangoInicial - X.ProdPrimaNeta;
                END IF;
                nPorcenNivel2 := W.PorcenBono;
            ELSIF W.Nivel = 3 THEN 
                IF W.RangoFinal < X.ProdPrimaNeta THEN
                    nMontoNivel3 := 0;
                ELSIF W.RangoFinal > X.ProdPrimaNeta AND W.RangoInicial < X.ProdPrimaNeta THEN 
                    nMontoNivel3 := 0;
                ELSIF W.RangoInicial > X.ProdPrimaNeta THEN
                    nMontoNivel3 := W.RangoInicial - X.ProdPrimaNeta;
                END IF;
                nPorcenNivel3 := W.PorcenBono;
            ELSIF W.Nivel = 4 THEN
                IF W.RangoFinal < X.ProdPrimaNeta THEN
                    nMontoNivel4 := 0;
                ELSIF W.RangoFinal > X.ProdPrimaNeta AND W.RangoInicial < X.ProdPrimaNeta THEN 
                    nMontoNivel4 := 0;
                ELSIF W.RangoInicial > X.ProdPrimaNeta THEN
                    nMontoNivel4 := W.RangoInicial - X.ProdPrimaNeta;
                END IF;
                nPorcenNivel4 := W.PorcenBono;
            ELSIF W.Nivel > 4 THEN 
                IF nMontoAcumSup = 0 THEN
                    nMontoAcumSup := W.RangoInicial;
                    IF W.RangoFinal < X.ProdPrimaNeta THEN
                        nMontoNivelSup := 0;
                    ELSIF W.RangoFinal > X.ProdPrimaNeta AND W.RangoInicial < X.ProdPrimaNeta THEN 
                        nMontoNivelSup := 0;
                    ELSIF W.RangoInicial > X.ProdPrimaNeta THEN
                        nMontoNivelSup := nMontoAcumSup - X.ProdPrimaNeta;
                    END IF;
                    nPorcenNivelSup := W.PorcenBono;
                END IF;
            END IF;
        END LOOP;
        BEGIN
            UPDATE BONOS_AGENTES_PROYECCION
               SET MontoNivel1      = nMontoNivel1,
                   PorcenNivel1     = nPorcenNivel1,
                   MontoNivel2      = nMontoNivel2,
                   PorcenNivel2     = nPorcenNivel2,
                   MontoNivel3      = nMontoNivel3,
                   PorcenNivel3     = nPorcenNivel3,
                   MontoNivel4      = nMontoNivel4,
                   PorcenNivel4     = nPorcenNivel4,
                   MontoNivelSup    = nMontoNivelSup,
                   PorcenNivelSup   = nPorcenNivelSup
             WHERE CURRENT OF PROY_Q;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20100,'Error al Realizar Cálculo de Proyección de Bono Para Agente' || X.CodAgente || ' para Bono No. ' || nIdBonoVentas);
        END;
        nMontoAcumSup := 0;
    END LOOP;
END CALCULO_PROYECCIONES;

END GT_BONOS_AGENTES_PROYECCION;
