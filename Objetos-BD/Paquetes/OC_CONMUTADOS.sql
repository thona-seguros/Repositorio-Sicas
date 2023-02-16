CREATE OR REPLACE PACKAGE OC_CONMUTADOS AS
PROCEDURE GENERAR(nCodCia NUMBER, cTipoTabla VARCHAR2, nInteres NUMBER, cSexo VARCHAR2, cFumador VARCHAR2);
END OC_CONMUTADOS;

--End of DDL script for OC_CONMUTADOS
/

CREATE OR REPLACE PACKAGE BODY OC_CONMUTADOS AS
PROCEDURE GENERAR(nCodCia NUMBER, cTipoTabla VARCHAR2, nInteres NUMBER ,cSexo VARCHAR2 ,cFumador VARCHAR2) IS
X                  TABLAS_MORTALIDAD.Edad%TYPE;
nEdadIni           TABLAS_MORTALIDAD.Edad%TYPE;
nEdad1             TABLAS_MORTALIDAD.Edad%TYPE;
nEdadFin           TABLAS_MORTALIDAD.Edad%TYPE;
nLx                TABLAS_MORTALIDAD.Lx%TYPE;
nLx1               TABLAS_MORTALIDAD.Lx%TYPE;
nDx                CONMUTADOS.Dx%TYPE;
nNx                CONMUTADOS.Nx%TYPE;
nQx                TABLAS_MORTALIDAD.Qx%TYPE;
nCx                CONMUTADOS.Cx%TYPE;
nMx                CONMUTADOS.Mx%TYPE;
nRx                CONMUTADOS.Rx%TYPE;
nSx                CONMUTADOS.Sx%TYPE;
nCxB               CONMUTADOS.CxB%TYPE;
nMxB               CONMUTADOS.MxB%TYPE;
nRxB               CONMUTADOS.RxB%TYPE;
nMxValgar          CONMUTADOS.MxValgar%TYPE; -- Conmutativo con recargo por gasto para
nTasaRiesgo        CONMUTADOS.TasaRiesgo%TYPE;
                                           -- Valores Garantizados / Prorrogas
BEGIN
   BEGIN
      SELECT MIN(Edad) ,MAX(Edad)
        INTO nEdadIni  ,nEdadFin
        FROM TABLAS_MORTALIDAD
       WHERE CodCia    = nCodCia
                   AND TipoTabla = cTipoTabla
         AND Sexo      = cSexo
         AND Fumador   = cFumador;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR( -20100, 'Error al Seleccionar Datos de Tabla de Mortalidad. ' || SQLErrM);
   END;
   X := nEdadIni;
   FOR X IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT Lx  ,Qx
           INTO nLx ,nQx
           FROM TABLAS_MORTALIDAD
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad      = X;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error, no se encontraron los datos para TABLAS_MORTALIDAD, Tabla: ' ||
                                    cTipoTabla ||', Sexo '||cSexo||', Fumador '||cFumador ||' y Edad: '||
                                    TO_CHAR(X)||'. '||SQLERRM);
         WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR( -20100, 'Datos de TABLAS_MORTALIDAD se encuentran duplicados para Tabla: ' ||
                                     cTipoTabla ||', Sexo '||cSexo||', Fumador '||cFumador ||
                                                         ' y Edad: '||TO_CHAR(X)||'. '||SQLERRM);
      END;
      nEdad1 := X + 1;
      BEGIN
         SELECT Lx
           INTO nLx1
           FROM TABLAS_MORTALIDAD
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad      = nEdad1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nLx1 := 0;
         WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR( -20100, 'Datos de TABLAS_MORTALIDAD se encuentran duplicados para Tabla: ' ||
                                     cTipoTabla ||', Sexo '||cSexo||', Fumador '||cFumador ||
                                                         ' y Edad: '||TO_CHAR(nEdad1)||'. '||SQLERRM);
      END;
      nDx         := ((1  + (nInteres/100))**(-x) ) * nLx;
      nCx         := ((1  + (nInteres/100))**(-(x+1))) * (nLx - nLx1);
      nCxB        := ((1  + (nInteres/100))**(-(x+0.5))) * (nLx - nLx1);
      nTasaRiesgo := nQx * ( 1 / ( 1 + nInteres ) ) * 1000;
      BEGIN
         INSERT INTO CONMUTADOS
               (CodCia, TipoTabla, Tasa, Sexo, Fumador, Edad,
                Lx, Dx, Cx, TasaRiesgo, CxB)
         VALUES(nCodCia, cTipoTabla, nInteres, cSexo, cFumador, X,
                nLx, nDx, nCx, nTasaRiesgo, nCxB);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al insertar datos CONMUTADOS. ' || SQLErrM);
      END;
   END LOOP;
   X := nEdadIni;
   FOR X IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT SUM(Dx),SUM(Cx)
           INTO nNx    ,nMx
           FROM CONMUTADOS
          WHERE CodCia    = nCodCia
                      AND TipoTabla  = cTipoTabla
            AND Tasa    = nInteres
            AND Sexo    = cSexo
            AND Fumador = cFumador
            AND Edad BETWEEN X AND nEdadFin;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al seleccionar datos CONMUTADOS ' || SQLErrM);
      END;
      nMxValgar := nMx + .003 * nNx;
      BEGIN
         UPDATE CONMUTADOS
            SET Nx  = nNx,
                Mx  = nMx,
                     MxValGar = nMxValgar
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Tasa      = nInteres
            AND Edad      = X;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al actualizar datos de CONMUTADOS ' || SQLErrM);
      END;
   END LOOP;

   X := nEdadIni;
   FOR X IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT SUM(Nx)
           INTO nSx
           FROM CONMUTADOS
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad BETWEEN X AND nEdadFin;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al seleccionar datos CONMUTADOS ' || SQLErrM);
      END;

      BEGIN
         UPDATE CONMUTADOS
            SET Sx  = nSx
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Tasa      = nInteres
            AND Edad      = X;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al actualizar datos de CONMUTADOS ' || SQLErrM);
      END;
   END LOOP;

   FOR x IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT SUM(Mx)
           INTO nRx
           FROM CONMUTADOS
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad BETWEEN X AND nEdadFin;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al seleccionar datos CONMUTADOS ' || SQLErrM);
      END;
      BEGIN
         UPDATE CONMUTADOS
            SET Rx = nRx
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad      = X;
      EXCEPTION
         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20100, 'Error al Actualizar datos CONMUTADOS ' || SQLErrM);
      END;
   END LOOP;

   X := nEdadIni;
   FOR X IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT SUM(CxB)
           INTO nMxB
           FROM CONMUTADOS
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad BETWEEN X AND nEdadFin;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al seleccionar datos CONMUTADOS ' || SQLErrM);
      END;
      BEGIN
         UPDATE CONMUTADOS
            SET MxB  = nMxB
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Tasa      = nInteres
            AND Edad      = X;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al actualizar datos de CONMUTADOS ' || SQLErrM);
      END;
   END LOOP;

   FOR X IN nEdadIni..nEdadFin LOOP
      BEGIN
         SELECT SUM(MxB)
           INTO nRxB
           FROM CONMUTADOS
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad BETWEEN X AND nEdadFin;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al seleccionar datos CONMUTADOS ' || SQLErrM);
      END;
      BEGIN
         UPDATE CONMUTADOS
            SET RxB = nRxB
          WHERE CodCia    = nCodCia
                      AND TipoTabla = cTipoTabla
            AND Tasa      = nInteres
            AND Sexo      = cSexo
            AND Fumador   = cFumador
            AND Edad      = X;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20100, 'Error al Actualizar datos CONMUTADOS ' || SQLErrM);
      END;
   END LOOP;

END GENERAR;

END OC_CONMUTADOS;
