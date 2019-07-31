::compile_forms.bat
cls
Echo compiling Forms….
for %%f IN (*.fmb) do frmcmp userid=sicas_oc/s1cas2017Th0na@producci module=%%f batch=yes build=yes module_type=form compile_all=yes window_state=minimize
ECHO FINISHED COMPILING