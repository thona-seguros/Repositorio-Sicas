--
-- GT_BONOS_AGENTES_CONFIG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   GT_BONOS_AGENTES_NEGOCIOS (Package)
--   GT_BONOS_AGENTES_NIVELES (Package)
--   GT_BONOS_AGENTES_POLIZAS (Package)
--   GT_BONOS_AGENTES_RANGOS (Package)
--   GT_BONOS_AGENTES_RANGOS_CONV (Package)
--   GT_BONOS_AGENTES_TIPO_SEG (Package)
--   BONOS_AGENTES_CONFIG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_CONFIG AS

FUNCTION NUMERO_BONO RETURN NUMBER;

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodigoBonoDest VARCHAR2, 
                  cDescripBonoDest VARCHAR2, dFecIniBonoDest DATE, dFecFinBonoDest DATE);

PROCEDURE ACTIVAR_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

PROCEDURE CONFIGURAR_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

PROCEDURE SUSPENDER_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cIndicador VARCHAR2) RETURN VARCHAR2;

FUNCTION PORCENTAJE_SINIESTRALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PORCENTAJE_PROMOTORIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PORCENTAJE_ASEG_TITULARES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PRODUCCION_MINIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PROD_MINIMA_CONV_NAC(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PROD_MINIMA_CONV_INT(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION MINIMO_POLIZAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION RANGO_EDAD_ASEG_TITULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nEdad NUMBER) RETURN VARCHAR2;

FUNCTION CODIGO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION IDENTIFICADOR_DE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodigoBono VARCHAR2) RETURN VARCHAR2;

FUNCTION DESCRIPCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION CANT_AGENTES_PROD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION PROD_MINIMA_AGENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER;

FUNCTION CONCEPTO_BONO_ESTADO_CUENTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION RAMO_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION TIPO_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION FUNCIONARIO_FIRMA_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION URL_FIRMAFUNC_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

FUNCTION CARGO_FIRMAFUNC_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

END GT_BONOS_AGENTES_CONFIG;
/

--
-- GT_BONOS_AGENTES_CONFIG  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_CONFIG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_CONFIG AS

FUNCTION NUMERO_BONO RETURN NUMBER IS
nIdBonoVentas   BONOS_AGENTES_CONFIG.IdBonoVentas%TYPE;
BEGIN
   SELECT NVL(MAX(IdBonoVentas),0)+1
     INTO nIdBonoVentas
     FROM BONOS_AGENTES_CONFIG;

   RETURN(nIdBonoVentas);
END NUMERO_BONO;

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodigoBonoDest VARCHAR2, 
                  cDescripBonoDest VARCHAR2, dFecIniBonoDest DATE, dFecFinBonoDest DATE) IS
nIdBonoVentasDest   BONOS_AGENTES_CONFIG.IdBonoVentas%TYPE;
CURSOR BONO_Q IS
   SELECT TipoBonoConv, FrecuenciaBono, ReglaBono, IndAgteConvEsp, IndExcluConvEsp,
          IndPolEspecificas, IndIdTipoSegPlanes, IndEmisionNueva, IndRenovacion, 
          CodNivelBono, IndPromotoria, PorcenPromotoria, IndAsegTitulares, EdadIniAsegTit,
          EdadFinAsegTit, PorcenAsegTit, ProducMinimaBono, ProdMinimaConvNac,
          ProdMinimaConvInt, MinimoPolizas, CantAgentesProd, ProdMinAgentesProd, 
          CodUsuario, FecUltModif, CptoEstadoCuenta, CodTipoPlan, CodTipoBono, 
          IndEmisionRetro, NombFuncionarioFirma, RutaFirma, PuestoFuncionarioFirma
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN BONO_Q LOOP
      nIdBonoVentasDest := GT_BONOS_AGENTES_CONFIG.NUMERO_BONO;
      INSERT INTO BONOS_AGENTES_CONFIG
            (CodCia, CodEmpresa, IdBonoVentas, TipoBonoConv, CodigoBono, 
             DescripBono, FecIniBono, FecFinBono, StsBono, FecStatus, 
             FrecuenciaBono, ReglaBono,  ProducMinimaBono, ProdMinimaConvNac,
             ProdMinimaConvInt, MinimoPolizas, IndAgteConvEsp, IndExcluConvEsp,  
             IndPolEspecificas, IndIdTipoSegPlanes, IndEmisionNueva, IndRenovacion,  
             CodNivelBono, IndPromotoria, PorcenPromotoria, CantAgentesProd,  
             ProdMinAgentesProd, IndAsegTitulares, EdadIniAsegTit, EdadFinAsegTit, 
             PorcenAsegTit, CodUsuario, FecUltModif, CptoEstadoCuenta, CodTipoPlan, 
             CodTipoBono, IndEmisionRetro, NombFuncionarioFirma, RutaFirma, 
             PuestoFuncionarioFirma)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, W.TipoBonoConv, cCodigoBonoDest,
             cDescripBonoDest, dFecIniBonoDest, dFecFinBonoDest, 'CONFIG', TRUNC(SYSDATE), 
             W.FrecuenciaBono, W.ReglaBono,  W.ProducMinimaBono, W.ProdMinimaConvNac,
             W.ProdMinimaConvInt, W.MinimoPolizas, W.IndAgteConvEsp, W.IndExcluConvEsp,  
             W.IndPolEspecificas, W.IndIdTipoSegPlanes, W.IndEmisionNueva, W.IndRenovacion,  
             W.CodNivelBono, W.IndPromotoria, W.PorcenPromotoria, W.CantAgentesProd,  
             W.ProdMinAgentesProd, W.IndAsegTitulares, W.EdadIniAsegTit, W.EdadFinAsegTit, 
             W.PorcenAsegTit, USER, TRUNC(SYSDATE), W.CptoEstadoCuenta, W.CodTipoPlan, 
             W.CodTipoBono, W.IndEmisionRetro, W.NombFuncionarioFirma, W.RutaFirma, 
             W.PuestoFuncionarioFirma);

      GT_BONOS_AGENTES_RANGOS.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest, dFecIniBonoDest, dFecFinBonoDest);
      GT_BONOS_AGENTES_RANGOS_CONV.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest, dFecIniBonoDest, dFecFinBonoDest);
      GT_BONOS_AGENTES_NIVELES.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest);
      GT_BONOS_AGENTES_TIPO_SEG.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest);
      GT_BONOS_AGENTES_POLIZAS.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest);
      GT_BONOS_AGENTES_NEGOCIOS.COPIAR(nCodCia, nCodEmpresa, nIdBonoVentas, nIdBonoVentasDest);
   END LOOP;
END COPIAR;

PROCEDURE ACTIVAR_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   UPDATE BONOS_AGENTES_CONFIG
      SET StsBono     = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE),
          FecUltModif = TRUNC(SYSDATE),
          CodUsuario  = USER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END ACTIVAR_BONO;

PROCEDURE CONFIGURAR_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   UPDATE BONOS_AGENTES_CONFIG
      SET StsBono     = 'CONFIG',
          FecStatus   = TRUNC(SYSDATE),
          FecUltModif = TRUNC(SYSDATE),
          CodUsuario  = USER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END CONFIGURAR_BONO;

PROCEDURE SUSPENDER_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   UPDATE BONOS_AGENTES_CONFIG
      SET StsBono     = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE),
          FecUltModif = TRUNC(SYSDATE),
          CodUsuario  = USER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END SUSPENDER_BONO;

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cIndicador VARCHAR2) RETURN VARCHAR2 IS
cIndAgteConvEsp           BONOS_AGENTES_CONFIG.IndAgteConvEsp%TYPE;
cIndExcluConvEsp          BONOS_AGENTES_CONFIG.IndExcluConvEsp%TYPE;
cIndPolEspecificas        BONOS_AGENTES_CONFIG.IndPolEspecificas%TYPE;
cIndIdTipoSegPlanes       BONOS_AGENTES_CONFIG.IndIdTipoSegPlanes%TYPE;
cIndEmisionNueva          BONOS_AGENTES_CONFIG.IndEmisionNueva%TYPE;
cIndRenovacion            BONOS_AGENTES_CONFIG.IndRenovacion%TYPE;
cIndPromotoria            BONOS_AGENTES_CONFIG.IndPromotoria%TYPE;
cIndAsegTitulares         BONOS_AGENTES_CONFIG.IndAsegTitulares%TYPE;
cIndEmisionRetro          BONOS_AGENTES_CONFIG.IndEmisionRetro%TYPE;

BEGIN
   SELECT IndAgteConvEsp, IndExcluConvEsp, IndPolEspecificas,
          IndIdTipoSegPlanes, IndEmisionNueva, IndRenovacion,
          IndPromotoria, IndAsegTitulares, IndEmisionRetro
     INTO cIndAgteConvEsp, cIndExcluConvEsp, cIndPolEspecificas,
          cIndIdTipoSegPlanes, cIndEmisionNueva, cIndRenovacion,
          cIndPromotoria, cIndAsegTitulares, cIndEmisionRetro
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;

    IF cIndicador = 'ACE' THEN --  Agentes con Convenio Especial 
       RETURN(cIndAgteConvEsp);
    ELSIF cIndicador = 'ECE' THEN -- Excluye Agentes con Convenio Especial
       RETURN(cIndExcluConvEsp);
    ELSIF cIndicador = 'BPE' THEN -- Bono por Pólizas Específicas
       RETURN(cIndPolEspecificas);
    ELSIF cIndicador = 'BPP' THEN -- Bono por Productos y Planes
       RETURN(cIndIdTipoSegPlanes);
    ELSIF cIndicador = 'PEN' THEN -- Sumariza Pólizas Nuevas
       RETURN(cIndEmisionNueva);
    ELSIF cIndicador = 'PRE' THEN -- Sumariza Renovaciones
       RETURN(cIndRenovacion);
    ELSIF cIndicador = 'PRO' THEN -- Si Agente Pertenece a Promotoría
       RETURN(cIndPromotoria);
    ELSIF cIndicador = 'AST' THEN -- Considerar Edades de Asegurados Titulares para Ponderación Adicional
       RETURN(cIndAsegTitulares);
    ELSIF cIndicador = 'RET' THEN -- Considerar Pólizas Emitidas Antes de la Fecha de Inicio del Cálculo
       RETURN(cIndEmisionRetro);
    ELSE
       RAISE_APPLICATION_ERROR(-20100,'Indicador NO Definido para Bonos');
    END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'Error en Indicadores BONOS_AGENTES_CONFIG');
END INDICADORES;

FUNCTION PORCENTAJE_SINIESTRALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nPorcSiniestralidad   BONOS_AGENTES_CONFIG.PorcSiniestralidad%TYPE;
BEGIN
   SELECT NVL(PorcSiniestralidad,0)
     INTO nPorcSiniestralidad
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nPorcSiniestralidad);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Porcentaje de Siniestralidad');
END PORCENTAJE_SINIESTRALIDAD;

FUNCTION PORCENTAJE_PROMOTORIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nPorcenPromotoria   BONOS_AGENTES_CONFIG.PorcenPromotoria%TYPE;
BEGIN
   SELECT NVL(PorcenPromotoria,0)
     INTO nPorcenPromotoria
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nPorcenPromotoria);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Porcentaje de Promotoría');
END PORCENTAJE_PROMOTORIA;

FUNCTION PORCENTAJE_ASEG_TITULARES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nPorcenAsegTit   BONOS_AGENTES_CONFIG.PorcenAsegTit%TYPE;
BEGIN
   SELECT NVL(PorcenAsegTit,0)
     INTO nPorcenAsegTit
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nPorcenAsegTit);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Porcentaje de Asegurados Titulares');
END PORCENTAJE_ASEG_TITULARES;

FUNCTION PRODUCCION_MINIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nProducMinimaBono   BONOS_AGENTES_CONFIG.ProducMinimaBono%TYPE;
BEGIN
   SELECT NVL(ProducMinimaBono,0)
     INTO nProducMinimaBono
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nProducMinimaBono);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Producción Mínima para Bono');
END PRODUCCION_MINIMA;

FUNCTION PROD_MINIMA_CONV_NAC(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nProdMinimaConvNac   BONOS_AGENTES_CONFIG.ProdMinimaConvNac%TYPE;
BEGIN
   SELECT NVL(ProdMinimaConvNac,0)
     INTO nProdMinimaConvNac
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nProdMinimaConvNac);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Producción Mínima para Convención Nacional');
END PROD_MINIMA_CONV_NAC;

FUNCTION PROD_MINIMA_CONV_INT(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nProdMinimaConvInt   BONOS_AGENTES_CONFIG.ProdMinimaConvInt%TYPE;
BEGIN
   SELECT NVL(ProdMinimaConvInt,0)
     INTO nProdMinimaConvInt
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nProdMinimaConvInt);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Producción Mínima para Convención Internacional');
END PROD_MINIMA_CONV_INT;

FUNCTION MINIMO_POLIZAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nMinimoPolizas   BONOS_AGENTES_CONFIG.MinimoPolizas%TYPE;
BEGIN
   SELECT NVL(MinimoPolizas,0)
     INTO nMinimoPolizas
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nMinimoPolizas);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Mínimo de Pólizas para Bono');
END MINIMO_POLIZAS;

FUNCTION RANGO_EDAD_ASEG_TITULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nEdad NUMBER) RETURN VARCHAR2 IS
cAceptado    VARCHAR2(1);
BEGIN
   SELECT 'S'
     INTO cAceptado
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdBonoVentas    = nIdBonoVentas
      AND EdadIniAsegTit >= nEdad
      AND EdadFinAsegTit <= nEdad;
   RETURN(cAceptado);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN('N');
   WHEN TOO_MANY_ROWS THEN
      RETURN('S');
END RANGO_EDAD_ASEG_TITULAR;

FUNCTION CODIGO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cCodigoBono    BONOS_AGENTES_CONFIG.CodigoBono%TYPE;
BEGIN
   SELECT CodigoBono
     INTO cCodigoBono
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(cCodigoBono);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
   WHEN TOO_MANY_ROWS THEN
      RETURN('ERROR');
END CODIGO_BONO;

FUNCTION IDENTIFICADOR_DE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodigoBono VARCHAR2) RETURN VARCHAR2 IS
nIdBonoVentas   BONOS_AGENTES_CONFIG.IdBonoVentas%TYPE;
BEGIN
   SELECT IdBonoVentas
     INTO nIdBonoVentas
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodigoBono   = cCodigoBono;
   RETURN(nIdBonoVentas);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN TOO_MANY_ROWS THEN
      RETURN(0);
END IDENTIFICADOR_DE_BONO;

FUNCTION DESCRIPCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cDescripBono    BONOS_AGENTES_CONFIG.DescripBono%TYPE;
BEGIN
   SELECT DescripBono
     INTO cDescripBono
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(cDescripBono);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE BONO');
   WHEN TOO_MANY_ROWS THEN
      RETURN('ERROR EN CONFIGURACION DE BONO');
END DESCRIPCION_BONO;

FUNCTION CANT_AGENTES_PROD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nCantAgentesProd   BONOS_AGENTES_CONFIG.CantAgentesProd%TYPE;
BEGIN
   SELECT NVL(CantAgentesProd,0)
     INTO nCantAgentesProd
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nCantAgentesProd);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Cantidad de Agentes Productivos');
END CANT_AGENTES_PROD;

FUNCTION PROD_MINIMA_AGENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN NUMBER IS
nProdMinAgentesProd   BONOS_AGENTES_CONFIG.ProdMinAgentesProd%TYPE;
BEGIN
   SELECT NVL(ProdMinAgentesProd,0)
     INTO nProdMinAgentesProd
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(nProdMinAgentesProd);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20205,'Error en Producción Mínima de Agentes');
END PROD_MINIMA_AGENTES;

FUNCTION CONCEPTO_BONO_ESTADO_CUENTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cCptoEstadoCuenta    BONOS_AGENTES_CONFIG.CptoEstadoCuenta%TYPE;
BEGIN
   SELECT CptoEstadoCuenta
     INTO cCptoEstadoCuenta
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
   RETURN(cCptoEstadoCuenta);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
   WHEN TOO_MANY_ROWS THEN
      RETURN('ERROR');
END CONCEPTO_BONO_ESTADO_CUENTA;

FUNCTION RAMO_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cCodTipoPlan BONOS_AGENTES_CONFIG.CodTipoPlan%TYPE;
BEGIN
   BEGIN
      SELECT CodTipoPlan
        INTO cCodTipoPlan
        FROM BONOS_AGENTES_CONFIG
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoPlan := 'NA';
   END;
   RETURN cCodTipoPlan;
END RAMO_BONO;

FUNCTION TIPO_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cCodTipoBono BONOS_AGENTES_CONFIG.CodTipoBono%TYPE;
BEGIN
   BEGIN
      SELECT CodTipoBono
        INTO cCodTipoBono
        FROM BONOS_AGENTES_CONFIG
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoBono := 'NA';
   END;
   RETURN cCodTipoBono;
END TIPO_BONO;

FUNCTION FUNCIONARIO_FIRMA_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cNombFuncionarioFirma BONOS_AGENTES_CONFIG.NombFuncionarioFirma%TYPE;
BEGIN
   BEGIN
      SELECT NombFuncionarioFirma
        INTO cNombFuncionarioFirma
        FROM BONOS_AGENTES_CONFIG
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombFuncionarioFirma := 'NA';
   END;
   RETURN cNombFuncionarioFirma;
END FUNCIONARIO_FIRMA_BONO;

FUNCTION URL_FIRMAFUNC_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cRutaFirma BONOS_AGENTES_CONFIG.RutaFirma%TYPE;
BEGIN
   BEGIN
      SELECT RutaFirma
        INTO cRutaFirma
        FROM BONOS_AGENTES_CONFIG
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRutaFirma := 'NA';
   END;
   RETURN cRutaFirma;
END URL_FIRMAFUNC_BONO;

FUNCTION CARGO_FIRMAFUNC_BONO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
   cPuestoFuncionarioFirma BONOS_AGENTES_CONFIG.PuestoFuncionarioFirma%TYPE;
BEGIN
   BEGIN
      SELECT PuestoFuncionarioFirma
        INTO cPuestoFuncionarioFirma
        FROM BONOS_AGENTES_CONFIG
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPuestoFuncionarioFirma := 'NA';
   END;
   RETURN cPuestoFuncionarioFirma;
END CARGO_FIRMAFUNC_BONO;

END GT_BONOS_AGENTES_CONFIG;
/

--
-- GT_BONOS_AGENTES_CONFIG  (Synonym) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_CONFIG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_BONOS_AGENTES_CONFIG FOR SICAS_OC.GT_BONOS_AGENTES_CONFIG
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_BONOS_AGENTES_CONFIG TO PUBLIC
/
