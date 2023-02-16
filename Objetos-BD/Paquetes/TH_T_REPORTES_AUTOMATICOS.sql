CREATE OR REPLACE PACKAGE TH_T_REPORTES_AUTOMATICOS IS


-- 
PROCEDURE INSERTA_REGISTROS(P_CODCIA                              NUMBER, 
                            P_CODEMPRESA                          NUMBER, 
                            P_NOMBRE_REPORTE                      VARCHAR2, 
                            P_FECHA_PROCESO                       DATE, 
                            P_NUMERO_REGISTRO                     NUMBER, 
                            P_CODPLANTILLA                        VARCHAR2,
                            P_NOMBRE_ARCHIVO_EXCEL                VARCHAR2,
                            P_CAMPO                               CLOB ) ;                                                     

--
PROCEDURE BORRA_MOVIMIENTO(P_CODCIA                              NUMBER, 
                           P_CODEMPRESA                          NUMBER, 
                           P_NOMBRE_REPORTE                      VARCHAR2, 
                           P_FECHA_PROCESO                       DATE  );

FUNCTION REPORTE(nCodCia NUMBER, nCodEmpresa NUMBER, cNombreReporte VARCHAR2, dFechaProceso DATE) RETURN XMLTYPE;                           
--                           

END TH_T_REPORTES_AUTOMATICOS;

/

CREATE OR REPLACE PACKAGE BODY TH_T_REPORTES_AUTOMATICOS IS
---
-- CREACION     21/01/2021                                        -- JMMDP
--
PROCEDURE INSERTA_REGISTROS(P_CODCIA                              NUMBER, 
                            P_CODEMPRESA                          NUMBER, 
                            P_NOMBRE_REPORTE                      VARCHAR2, 
                            P_FECHA_PROCESO                       DATE, 
                            P_NUMERO_REGISTRO                     NUMBER, 
                            P_CODPLANTILLA                        VARCHAR2,
                            P_NOMBRE_ARCHIVO_EXCEL                VARCHAR2,
                            P_CAMPO                               CLOB ) IS
BEGIN

       INSERT INTO T_REPORTES_AUTOMATICOS (CODCIA, CODEMPRESA, NOMBRE_REPORTE, FECHA_PROCESO, NUMERO_REGISTRO, 
                                           CODPLANTILLA, NOMBRE_ARCHIVO_EXCEL, CAMPO)
       VALUES(P_CODCIA, P_CODEMPRESA, P_NOMBRE_REPORTE, P_FECHA_PROCESO, P_NUMERO_REGISTRO, 
                                           P_CODPLANTILLA, P_NOMBRE_ARCHIVO_EXCEL, P_CAMPO);

       commit;  

END INSERTA_REGISTROS;
--
--
PROCEDURE BORRA_MOVIMIENTO(P_CODCIA                              NUMBER, 
                           P_CODEMPRESA                          NUMBER, 
                           P_NOMBRE_REPORTE                      VARCHAR2, 
                           P_FECHA_PROCESO                       DATE  ) IS
--
BEGIN
  --
  DELETE T_REPORTES_AUTOMATICOS 
    WHERE CODCIA    = P_CODCIA
      AND CODEMPRESA   = P_CODEMPRESA
      AND NOMBRE_REPORTE   = P_NOMBRE_REPORTE 
      AND FECHA_PROCESO   = P_FECHA_PROCESO ;      
  --
  COMMIT;   
  --  
END BORRA_MOVIMIENTO;
--
--

FUNCTION REPORTE(nCodCia NUMBER, nCodEmpresa NUMBER, cNombreReporte VARCHAR2, dFechaProceso DATE) RETURN XMLTYPE IS
xReporte XMLTYPE;
BEGIN 
   BEGIN
      SELECT XMLROOT(XMLELEMENT("DATA", 
                  XMLAGG(XMLELEMENT("REGISTRO",
                     XMLELEMENT("Nombre_Reporte",Nombre_Reporte),   
                     XMLELEMENT("Fecha_Proceso",TO_CHAR(Fecha_Proceso,'DD/MM/RRRR')),
                     XMLELEMENT("Numero_Registro",Numero_Registro),
                     XMLAGG(XMLELEMENT("INFORMACION", XMLFOREST(REPLACE(Campo,CHR(13)) "Datos")
                                       )
                           ) 
                                    )
                        )
                     )
                   , VERSION '1.0" encoding="UTF-8') XML
        INTO xReporte
        FROM T_REPORTES_AUTOMATICOS
       WHERE Nombre_Reporte   = cNombreReporte
         AND Fecha_Proceso    = dFechaProceso
       GROUP BY Nombre_Reporte, Fecha_Proceso, Numero_Registro
       ORDER BY Numero_Registro ASC;
   END;
   RETURN xReporte;
END REPORTE;
END TH_T_REPORTES_AUTOMATICOS;
