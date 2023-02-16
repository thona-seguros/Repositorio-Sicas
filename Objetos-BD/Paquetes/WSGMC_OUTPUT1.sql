CREATE OR REPLACE package WSGMC_OUTPUT1 is
  -- make sure we don't keep this around after a call
  pragma SERIALLY_REUSABLE;

  procedure Before (pRef in WSGOC.COMPONENT_REF, pDepth in number);
  procedure After (pRef in WSGOC.COMPONENT_REF, pDepth in number);
end;
 
 
 
 
 
/

CREATE OR REPLACE package body WSGMC_OUTPUT1 is
  -- make sure we don't keep this around after a call
  pragma SERIALLY_REUSABLE;

  -- This package is really only useful for debugging.  It dumps out
  -- the entire contents of the object cache!

procedure Before (pRef in WSGOC.COMPONENT_REF, pDepth in number) is
   l_branches  WSGOC.BRANCH_REF_LIST;
   l_comps     WSGOC.COMPONENT_REF_LIST;
   l_mods      WSGOC.MODULE_REF_LIST;
   l_max_depth binary_integer := 0;
   l_dumped    boolean;
begin
-- Now we wish to output this as if in HTML;
-- First get the maximum depth
   l_branches := WSGOC.GET_BRANCHS;
   for i in 1..l_branches.count loop
      if ( l_max_depth < WSGOC.GET_Depth(WSGOC.GET_Top_Component(l_branches(i))) ) then
         l_max_depth  := WSGOC.GET_Depth(WSGOC.GET_Top_Component(l_branches(i)));
      end if;
      WSGOC.dump_branch(l_branches(i));
   end loop;

   -- loop down through the components
   for lev in reverse 1..l_max_depth loop

      -- get comps at this level
      l_comps := WSGOC.GET_COMPONENTS(pDepth=>lev);
      for i in 0..l_comps.count() loop

         -- have we dumped this module yet
         l_dumped := FALSE;
         for d in 1..l_mods.count() loop
            if WSGOC.IS_SAME( l_mods(d), WSGOC.GET_Module( l_comps(i) ) ) then
               l_dumped := TRUE;
               exit;
            end if;
         end loop;
         if not l_dumped and not WSGOC.IS_NULL( WSGOC.GET_Module( l_comps(i) ) ) then
            WSGOC.dump_module(WSGOC.GET_Module(l_comps(i)));
            l_mods(l_mods.count() + 1) := WSGOC.GET_Module(l_comps(i));
         end if;

         -- dump the component
         WSGOC.dump_component(l_comps(i));
      end loop; -- thru comps at this level
   end loop;    -- thru levels
   htp.p('<p>');
   for i in 1..WSGOC.o.count loop
      htp.p(WSGOC.o(i).buff);
      if WSGOC.o(i).terminate then
         htp.p('<p>');
      end if;
   end loop;
end;

procedure After (pRef in WSGOC.COMPONENT_REF, pDepth in number) is
begin
   htp.p(WSGOC.Get_AfterText(pRef));
end;

end;
