--TIPO DE NEGOCIO
INSERT INTO TIPO_DE_LISTA VALUES ('TIPNEGO','FUENTE DE LOS RECURSOS','USR');
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPNEGO','PRIVAD','PRIVADO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPNEGO','GOBIER','GOBIERNO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPNEGO','SINDIC','SINDICATO');
/
COMMIT
/
--FUENTE DE LOS RECURSOS
INSERT INTO TIPO_DE_LISTA VALUES ('FUENTEREC','FUENTE DE LOS RECURSOS','USR');
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','PRIVAD','PRIVADO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','GOBFED','FEDERAL');
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','GOBEST','ESTATAL'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','GOBMUN','MUNICIPAL' );
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','FEDEST','FEDERAL/ESTATAL'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','FEDMUN','FEDERAL/MUNICIPAL' );
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','ESTMUN','ESTATAL/MUNICIPAL'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','FEDCON','FEDERAL/CONTRIBUTORIO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','ESTCON','ESTATAL/CONTRIBUTORIO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FUENTEREC','MUNCON','MUNICIPAL/CONTRIBUTORIO');
/
COMMIT
/
--FORMA DE VENTA O CANAL DE VENTA
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('FORMVENT','PTAFD','PLATAFORMA DIGITAL');
/
COMMIT
/
INSERT INTO PAQUETE_COMERCIAL  (CODCIA, CODEMPRESA, DESCPAQUETE, IDTIPOSEG, PLANCOB, CODPAQUETE, CODUSUARIO, FECHAMODIF)  
with data as (
Select 757 idcotizacion, 2159 idcotizacionp, 'LUCERO MAYOR OPCI�N 1' DESCRIP from dual union all 
Select 758 idcotizacion, 2160 idcotizacionp, 'LUCERO MAYOR OPCI�N 2' DESCRIP from dual union all 
Select 759 idcotizacion, 2161 idcotizacionp, 'LUCERO MAYOR OPCI�N 3' DESCRIP from dual union all 
Select 760 idcotizacion, 2163 idcotizacionp, 'LUCERO ESPECIAL OPCI�N 1' DESCRIP from dual union all 
Select 761 idcotizacion, 2164 idcotizacionp, 'LUCERO ESPECIAL OPCI�N 2' DESCRIP from dual union all 
Select 762 idcotizacion, 2165 idcotizacionp, 'LUCERO ESPECIAL OPCI�N 3' DESCRIP from dual union all 
Select 763 idcotizacion, 2166 idcotizacionp, 'LUCERO PREVISOR' DESCRIP from dual union all 
Select 764 idcotizacion, 2167 idcotizacionp, 'LUCERO FUNERARIOS OPCI�N 1' DESCRIP from dual union all 
Select 765 idcotizacion, 2168 idcotizacionp, 'LUCERO FUNERARIOS OPCI�N 2' DESCRIP from dual union all 
Select 766 idcotizacion, 2169 idcotizacionp, 'LUCERO FUNERARIOS OPCI�N 3' DESCRIP from dual union all 
Select 767 idcotizacion, 2184 idcotizacionp, 'TU ESTRELLA INFANTIL' DESCRIP from dual union all 
Select 768 idcotizacion, 2185 idcotizacionp, 'TU ESTRELLA SOCIAL' DESCRIP from dual union all 
Select 769 idcotizacion, 2186 idcotizacionp, 'TU ESTRELLA CONSTRUCTORA' DESCRIP from dual union all 
Select 770 idcotizacion, 2187 idcotizacionp, 'TU ESTRELLA MOTOCICLISTA' DESCRIP from dual union all 
Select 771 idcotizacion, 2188 idcotizacionp, 'TU ESTRELLA PROTECTORA OPCI�N 1' DESCRIP from dual union all 
Select 772 idcotizacion, 2189 idcotizacionp, 'TU ESTRELLA PROTECTORA OPCI�N 2' DESCRIP from dual union all 
Select 773 idcotizacion, 2190 idcotizacionp, 'TU ESTRELLA DOM�STICA' DESCRIP from dual union all 
Select 774 idcotizacion, 2191 idcotizacionp, 'TU ESTRELLA CICLISTA OPCI�N 1' DESCRIP from dual union all 
Select 775 idcotizacion, 2192 idcotizacionp, 'TU ESTRELLA CICLISTA OPCI�N 2' DESCRIP from dual union all 
Select 776 idcotizacion, 2193 idcotizacionp, 'TU ESTRELLA CICLISTA OPCI�N 3' DESCRIP from dual union all 
Select 777 idcotizacion, 2194 idcotizacionp, 'TU ESTRELLA INDEPENDIENTE' DESCRIP from dual union all 
Select 3822 idcotizacion, 2170 idcotizacionp, 'LUCERO QUIRURGICO OPCI�N 1' DESCRIP from dual union all 
Select 3823 idcotizacion, 2171 idcotizacionp, 'LUCERO QUIRURGICO OPCI�N 2' DESCRIP from dual union all 
Select 3824 idcotizacion, 2172 idcotizacionp, 'LUCERO QUIRURGICO OPCI�N 3' DESCRIP from dual union all 
Select 3825 idcotizacion, 2173 idcotizacionp, 'LUCERO GRAVE ENFERMEDAD OPCI�N 1' DESCRIP from dual union all 
Select 3826 idcotizacion, 2174 idcotizacionp, 'LUCERO GRAVE ENFERMEDAD OPCI�N 2' DESCRIP from dual union all 
Select 3827 idcotizacion, 2175 idcotizacionp, 'LUCERO GRAVE ENFERMEDAD OPCI�N 3' DESCRIP from dual union all 
Select 3828 idcotizacion, 2176 idcotizacionp, 'LUCERO PREVISOR PLUS OPCI�N 1' DESCRIP from dual union all 
Select 3829 idcotizacion, 2177 idcotizacionp, 'LUCERO PREVISOR PLUS OPCI�N 2' DESCRIP from dual)
select C.CODCIA, C.CODEMPRESA,  D.DESCRIP, C.IDTIPOSEG, C.PLANCOB, DECODE(G.GLOBAL_NAME, 'PRUEBAS', D.idcotizacion, D.idcotizacionP) CODPAQUETE, USER USUARIO, SYSDATE FECHA
from data d inner join cotizaciones c  on C.IDCOTIZACION = DECODE(G.GLOBAL_NAME, 'PRUEBAS', D.idcotizacion, D.idcotizacionP)
            INNER JOIN GLOBAL_NAME  G  ON 1 = 1;
/
COMMIT;
/
UPDATE cotizaciones H SET H.CODPAQCOMERCIAL = (SELECT P.DESCPAQUETE FROM PAQUETE_COMERCIAL P WHERE H.IDCOTIZACION = P.CODPAQUETE)
WHERE EXISTS (SELECT 1 FROM PAQUETE_COMERCIAL P WHERE H.IDCOTIZACION = P.CODPAQUETE)
/
COMMIT;
/
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'PRIVAD',  'PRIVEMP', 'PRIVADO EMPRESARIAL', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'PRIVAD',  'PRIVDXN', 'AFFINITY/DXN/DOMICILIACI�N', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'PRIVAD',  'PRIVDIG', 'MARKETING DIGITAL', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'SINDIC','SINDSIN', 'SINDICATO', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'GOBIER', 'GOBMUN',  'MUNICIPIOS', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'GOBIER', 'GOBEST',  'ESTATALES', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'GOBIER', 'GOBFED',  'FEDERALES', USER, SYSDATE);
INSERT INTO SICAS_OC.CATEGORIAS VALUES (1,1, 'GOBIER', 'GOBOTR',  'OTRAS DEPENDENCIAS', USER, SYSDATE);
/
COMMIT;
/
INSERT INTO TIPO_DE_LISTA VALUES ('TIPOARCH','Tipo de documento cargado','USR');
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPOARCH','1','IDENTIFICACION'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPOARCH','2','COMPROBANTE DOMICILIO'); 
INSERT INTO VALORES_DE_LISTAS (CODLISTA, CODVALOR, DESCVALLST) VALUES ('TIPOARCH','3','OTRO'); 
/
COMMIT;
/
Insert into OFICINAS
   (CODOFICINA, DESCOFICINA, STSOFICINA, CODUSUARIO, FECALTA, 
    CODUSUARIOMOD, FECMODIF)
 Values
   ('09900010', 'THONA CENTRAL', 'ACTIVO', 'SICAS_OC', TO_DATE('10/24/2019 11:57:53', 'MM/DD/YYYY HH24:MI:SS'), 
    'SICAS_OC', TO_DATE('10/24/2019 11:57:53', 'MM/DD/YYYY HH24:MI:SS'));
Insert into OFICINAS
   (CODOFICINA, DESCOFICINA, STSOFICINA, CODUSUARIO, FECALTA, 
    CODUSUARIOMOD, FECMODIF)
 Values
   ('09900020', 'THONA OFICINA', 'ACTIVO', 'SICAS_OC', TO_DATE('10/24/2019 16:16:50', 'MM/DD/YYYY HH24:MI:SS'), 
    'SICAS_OC', TO_DATE('10/24/2019 16:16:50', 'MM/DD/YYYY HH24:MI:SS'));
/
COMMIT;
/

