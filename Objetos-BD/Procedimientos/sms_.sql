--
-- SMS_  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   TABLA_SMS (Table)
--   SQ_TABLASMS (Sequence)
--   CLIENTES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC."SMS_" 
   ( dFecha DATE,
     nOpcion NUMBER ) IS

--  dFecha DATE := to_date('27/06/2010','dd/mm/yyyy');
--  nOpcion NUMBER := 5;
  c_Texto  VARCHAR(250);
  cNumero  VARCHAR2(8) := '44616360';
  --nOpcion 1  Facturas a Vencer agrupadas  por Factura
  --nOpcion 2  Facturas a Vencer agrupadas  por Cliente
  --nOpcion 3  Facturas vencidas agruapadas por factura
  --nOpcion 4  Facturas vencidas agrupadas  por Cliente
  CURSOR C_FACTURAS IS
     SELECT PNJ.APELLIDO  Nombre, FA.NumFact, FA.Monto_Fact_Moneda, POL.cod_moneda, PNJ.telmovil, PNJ.sexo
       FROM FACTURAS FA, POLIZAS POL, PERSONA_NATURAL_JURIDICA PNJ, CLIENTES CLI
      WHERE FA.FecVenc = dFecha
        AND FA.idpoliza = POL.idpoliza
        AND FA.StsFact = 'EMI'
        AND FA.codcliente = CLI.codcliente
        AND PNJ.tipo_doc_identificacion = CLI.tipo_doc_identificacion
        AND PNJ.num_doc_identificacion = CLI.num_doc_identificacion;
  CURSOR C_CLIENTE IS
     SELECT PNJ.APELLIDO Nombre , SUM(FA.Monto_Fact_Moneda) MtoFact, POL.cod_moneda, PNJ.telmovil, PNJ.SEXO, Count(*) NumFact
       FROM FACTURAS FA, POLIZAS POL, PERSONA_NATURAL_JURIDICA PNJ, CLIENTES CLI
      WHERE FA.FecVenc = dFecha
        AND FA.idpoliza = POL.idpoliza
        AND FA.StsFact = 'EMI'
        AND FA.codcliente = CLI.codcliente
        AND PNJ.tipo_doc_identificacion = CLI.tipo_doc_identificacion
        AND PNJ.num_doc_identificacion = CLI.num_doc_identificacion
      GROUP BY pnj.Apellido, POL.cod_moneda, PNJ.telmovil, pnj.sexo ;
  CURSOR C_FACTURAS_VENCIDAS IS
     SELECT PNJ.APELLIDO  Nombre , FA.NumFact, FA.Monto_Fact_Moneda, POL.cod_moneda, PNJ.telmovil, PNJ.sexo,
            dFecha - trunc(Fa.fecvenc) DiasVenc, Fa.FecVenc
       FROM FACTURAS FA, POLIZAS POL, PERSONA_NATURAL_JURIDICA PNJ, CLIENTES CLI
      WHERE FA.FecVenc < dFecha
        AND FA.idpoliza = POL.idpoliza
        AND FA.StsFact = 'EMI'
        AND FA.codcliente = CLI.codcliente
        AND PNJ.tipo_doc_identificacion = CLI.tipo_doc_identificacion
        AND PNJ.num_doc_identificacion = CLI.num_doc_identificacion;
  CURSOR C_CLIENTE_VENCIDAS IS
     SELECT PNJ.APELLIDO  Nombre, SUM(FA.Monto_Fact_Moneda) MtoFact, POL.cod_moneda, PNJ.telmovil, PNJ.sexo
       FROM FACTURAS FA, POLIZAS POL, PERSONA_NATURAL_JURIDICA PNJ, CLIENTES CLI
      WHERE FA.FecVenc < dFecha
        AND FA.idpoliza = POL.idpoliza
        AND FA.StsFact = 'EMI'
        AND FA.codcliente = CLI.codcliente
        AND PNJ.tipo_doc_identificacion = CLI.tipo_doc_identificacion
        AND PNJ.num_doc_identificacion = CLI.num_doc_identificacion
      GROUP BY pnj.Apellido, POL.cod_moneda, PNJ.telmovil,PNJ.sexo;
   CURSOR C_CLIENTES IS
     SELECT Trim(Pnj.nombre) ||' ' || Trim(Pnj.apellido) || ' ' || Decode(Pnj.apecasada,Null,' ', ' de ' ||Pnj.apecasada) Nombre, Pnj.sexo, Pnj.telmovil
       FROM PERSONA_NATURAL_JURIDICA Pnj
      WHERE TO_CHAR(dFecha,'dd') = TO_CHAR(Pnj.FecNacimiento,'dd')
        AND TO_CHAR(dFecha,'mm') = TO_CHAR(Pnj.FecNacimiento,'mm')
        AND Pnj.Sexo != 'N';
BEGIN
  IF nOpcion = 1 THEN
    FOR X IN C_FACTURAS LOOP
      IF X.Sexo = 'M' THEN
         c_Texto := 'Estimado r';
      ELSIF X.Sexo = 'F' THEN
         c_Texto := 'Estimada r';
      ELSE
         c_Texto := 'R';
      END IF;
      c_Texto := c_Texto || x.Nombre || 'ecordandole que su Recibo Numero ' || x.NumFact ||', vence el dia '||
                    TO_CHAR(dFecha,'dd/mm/yyyy') || '. Por un Monto de '|| x.Cod_Moneda || ' '|| TRIM(TO_CHAR(x.Monto_Fact_Moneda,'999,999.99')) ||'.';
      BEGIN
         INSERT INTO TABLA_SMS (IdTabla_SMS, Para, Mensaje, Ennrec, De )
              VALUES ( SQ_TABLASMS.NEXTVAL, X.TelMovil, c_Texto, 'E', cNumero);
      END;
    END LOOP;
    ELSIF nOpcion = 2 THEN
    FOR X IN C_CLIENTE LOOP
      IF X.Sexo = 'M' THEN
         c_Texto := 'Estimado r';
      ELSIF X.Sexo = 'F' THEN
         c_Texto := 'Estimada r';
      ELSE
         c_Texto := 'R';
      END IF;
      c_Texto := c_Texto || x.Nombre || 'ecordandole que el Monto de los Recibos equivalen ' || x.Cod_Moneda || ' '|| TRIM( TO_CHAR(x.MtoFact,'999,999.99')) ||'.' ||
                   ' a vencer el dia '|| TO_CHAR(dFecha,'dd/mm/yyyy') || '.';
      DBMS_OUTPUT.Put_Line( c_Texto );
      DBMS_OUTPUT.Put_Line( Length(c_Texto) );
      BEGIN
         INSERT INTO TABLA_SMS (IdTabla_SMS, Para, Mensaje, Ennrec, De)
              VALUES ( SQ_TABLASMS.NEXTVAL, X.TelMovil, c_Texto, 'E', cNumero );
      END;
    END LOOP;
  ELSIF nOpcion = 3 THEN
    FOR X IN C_FACTURAS_VENCIDAS LOOP
      IF X.Sexo = 'M' THEN
         c_Texto := 'Estimado r';
      ELSIF X.Sexo = 'F' THEN
         c_Texto := 'Estimada r';
      ELSE
         c_Texto := 'R';
      END IF;
      c_Texto := c_Texto || x.Nombre || 'ecordandole que su Recibo Numero ' || x.NumFact ||', a la fecha '||
                    TO_CHAR(dFecha,'dd/mm/yyyy') || '. Presenta ' || x.DiasVenc ||' dias de atraso, por un Monto de '|| x.Cod_Moneda || ' '|| trim(TO_CHAR(x.Monto_Fact_Moneda,'999,999.99')) ||'.';
      DBMS_OUTPUT.Put_Line( c_Texto );
      DBMS_OUTPUT.Put_Line( Length(c_Texto) );
      BEGIN
         INSERT INTO TABLA_SMS (IdTabla_SMS, Para, Mensaje, Ennrec, De)
              VALUES ( SQ_TABLASMS.NEXTVAL, X.TelMovil, c_Texto, 'E', cNumero );
      END;
    END LOOP;
    ELSIF nOpcion = 4 THEN
    FOR X IN C_CLIENTE_VENCIDAS LOOP
      IF X.Sexo = 'M' THEN
         c_Texto := 'Estimado r';
      ELSIF X.Sexo = 'F' THEN
         c_Texto := 'Estimada r';
      ELSE
         c_Texto := 'R';
      END IF;
      c_Texto := c_Texto || x.Nombre || 'ecordandole  que el Monto de los Recibos equivalen ' || x.Cod_Moneda || ' '|| TRIM(TO_CHAR(x.MtoFact,'999,999.99')) ||
                   '. Saldo al dia '|| TO_CHAR(dFecha,'dd/mm/yyyy') || '.';
      BEGIN
         INSERT INTO TABLA_SMS (IdTabla_SMS, Para, Mensaje, Ennrec, De)
              VALUES ( SQ_TABLASMS.NEXTVAL, X.TelMovil, c_Texto, 'E', cNumero );
      END;
    END LOOP;
    ELSIF nOpcion = 5 THEN
       FOR X IN C_CLIENTES LOOP
          IF X.Sexo = 'M' THEN
            c_Texto := 'Estimado ';
          ELSIF X.Sexo = 'F' THEN
            c_Texto := 'Estimada ';
          END IF;
         c_Texto := c_Texto || x.Nombre ||  ' es para nosotros un gusto desearle un feliz cumplea?os, a la par de sus seres queridos';
      BEGIN
          DBMS_OUTPUT.Put_Line( c_Texto );
          DBMS_OUTPUT.Put_Line( Length(c_Texto) );
         INSERT INTO TABLA_SMS (IdTabla_SMS, Para, Mensaje, Ennrec, De)
              VALUES ( SQ_TABLASMS.NEXTVAL, X.TelMovil, c_Texto, 'E', cNumero );
      END;
      END LOOP;
    END IF;
END;
/
