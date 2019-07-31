--
-- WSGMC_OUTPUT2  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   HTP (Synonym)
--   PLITBLM (Synonym)
--   WSGOC (Package)
--   WSGOC (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.WSGMC_OUTPUT2 is
  -- make sure we don't keep this around after a call
  pragma SERIALLY_REUSABLE;

  procedure Before (pRef in WSGOC.COMPONENT_REF, pDepth in number);
  procedure After (pRef in WSGOC.COMPONENT_REF, pDepth in number);
end;
/

--
-- WSGMC_OUTPUT2  (Package Body) 
--
--  Dependencies: 
--   WSGMC_OUTPUT2 (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.WSGMC_OUTPUT2 is
  -- make sure we don't keep this around after a call
  pragma SERIALLY_REUSABLE;

  -- This package formats the context items from the object cache as
  -- an HTML table like;
  -- <component tile>|<1st context item value>
  --                 |<2nd context item value>
  --              '->|<component tile> |<1st context item value>
  --                 |       '->       |<2nd context item value>
  --
  -- titles are output in H1 style.

procedure Before (pRef in WSGOC.COMPONENT_REF, pDepth in number)
is
   l_comps        WSGOC.COMPONENT_REF_LIST;
   l_items        WSGOC.ITEM_REF_LIST;
   l_TableOpen    boolean := false;
   l_FirstValue   boolean;
   l_rows         integer := 0;
   l_value        varchar2(1000);
begin
-- Now we wish to output this as if in HTML;
-- First get the maximum depth

   -- loop down through the components
   for lev in reverse 0..pDepth loop

      -- get comps at this level
      l_comps := WSGOC.GET_COMPONENTS(pDepth=>lev);
      for c in 1..l_comps.count() loop

         -- if the table is not open then open it now
         if ( not l_TableOpen ) then

            htp.p('<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 >');
            l_TableOpen := true;

         end if;

         -- Open the table row
         htp.p('<TR VALIGN=BASELINE>');
         l_rows := l_rows + 1;

         -- output padding cells
         for p in 1..(l_rows-1) loop

            htp.p('<TD>');

            -- The last cell should have the image in it
            if p = (l_rows-1) then

               htp.p(  '<DIV ALIGN=right><IMG SRC="'
                    || WSGOC.Get_SystemImagePath(l_comps(c))
                    || 'cg_into.gif" HEIGHT=32 WIDTH=32></DIV>'
                    );
            end if;

            htp.p('</TD>');

         end loop;

         -- Output the component title
         htp.p('<TD><H1>'||WSGOC.Get_Title(l_comps(c))||'</H1></TD>');

         -- if component is current one then don't show values
         if ( not WSGOC.Is_Same(l_comps(c), pRef )) then

            -- Output the item values for context items
            htp.p('<TD COLSPAN="10">');
            l_FirstValue := true;
            l_Items    := WSGOC.Get_Items(l_comps(c));
            for i in 1..l_Items.Count() loop

               -- only look at context items
               if ( WSGOC.Get_IsContext(l_Items(i))) then

                  l_value := WSGOC.Get_Value(l_Items(i));
                  if (l_value is not null) then

                     -- finally surpress image call errors
                     if (    '<!-- ERROR' != substr(l_value,1,10)
                         and '<!-- NULL image source -->' != l_value )
                     then

                        if ( not l_FirstValue ) then
                           htp.br;
                        else
                           l_FirstValue := false;
                        end if;

                        htp.p('&nbsp;' || l_value );
                     end if;
                  end if;
               end if;
            end loop;

            -- close the cell
            htp.p('</TD>');

         end if;  -- master context component

         -- close the row
         htp.p('</TR>');

      end loop; -- thru comps at this level
   end loop;    -- thru levels

   -- close the table
   if l_TableOpen then
      htp.p('</TABLE>');
   end if;

   -- if there is any before text then show it
   htp.p(WSGOC.Get_BeforeText(pRef));
   htp.para;

end;

procedure After (pRef in WSGOC.COMPONENT_REF, pDepth in number)
is
begin
   htp.p(WSGOC.Get_AfterText(pRef));
end;

end;
/
