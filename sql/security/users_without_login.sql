/* ===========================================================
   Script: users_without_login.sql
   Descripción: Detecta usuarios bloqueados o que no pueden iniciar sesión.
   =========================================================== */

SELECT USERNAME
     , ACCOUNT_STATUS
     , LOCK_DATE
     , EXPIRY_DATE
FROM DBA_USERS
WHERE ACCOUNT_STATUS LIKE 'LOCKED%'
   OR ACCOUNT_STATUS LIKE 'EXPIRED%';
