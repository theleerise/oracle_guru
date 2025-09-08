/* ===========================================================
   Procedimiento: p_generate_user_report.sql
   Descripción: Genera un reporte simple de usuarios activos.
   =========================================================== */

CREATE OR REPLACE PROCEDURE P_GENERAR_REPORTE IS
BEGIN
    FOR R IN (
        SELECT USERNAME, ACCOUNT_STATUS
        FROM DBA_USERS
        WHERE ACCOUNT_STATUS = 'OPEN'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('USER: ' || R.USERNAME || ' - STATE: ' || R.ACCOUNT_STATUS);
    END LOOP;
END P_GENERAR_REPORTE;
/