DECLARE
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg %TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;

CURSOR TIPSEG_Q IS
   SELECT IdTipoSeg
     FROM TIPOS_DE_SEGUROS;

CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM PLAN_COBERTURAS
    WHERE IdTipoSeg = cIdTipoSeg;
    
BEGIN
   FOR X IN TIPSEG_Q LOOP
      cIdTipoSeg := X.IdTipoSeg;
      FOR Y IN PLAN_Q LOOP
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'A', 1);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'B', 1.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'C', 1.402597403);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'D', 1.701298701);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'E', 2.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'F', 2.701298701);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'G', 3.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'H', 4.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'I', 5.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'J', 6.202226345);
         
         INSERT INTO FACTORES_RIESGOS
                (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa, FactorRiesgo)
         VALUES (1, 1, cIdTipoSeg, Y.PlanCob, TO_DATE('01/01/2022','DD/MM/RRRR'), TO_DATE('31/12/2099','DD/MM/RRRR'), 'NA', 1);
         
      END LOOP;
   END LOOP;
COMMIT;
END;

