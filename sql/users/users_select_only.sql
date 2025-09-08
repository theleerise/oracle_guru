/* ===========================================================
   Script: users_select_only.sql
   Descripción: Lista usuarios que solo tienen privilegios SELECT,
                sin permisos de INSERT, UPDATE o DELETE.
   =========================================================== */

SELECT DISTINCT GRANTEE AS USUARIO
FROM DBA_TAB_PRIVS PR
WHERE PR.PRIVILEGE = 'SELECT'
  AND NOT EXISTS (
        SELECT 1
        FROM DBA_TAB_PRIVS T1
        WHERE T1.GRANTEE = PR.GRANTEE
          AND T1.PRIVILEGE IN ('INSERT','UPDATE','DELETE')
     )
  AND NOT EXISTS (
        SELECT 1
        FROM DBA_SYS_PRIVS T2
        WHERE T2.GRANTEE = PR.GRANTEE
          AND T2.PRIVILEGE IN ('INSERT ANY TABLE','UPDATE ANY TABLE','DELETE ANY TABLE')
     )
ORDER BY USUARIO;