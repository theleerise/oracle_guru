/* ===========================================================
   SCRIPT: permissions_roles.SQL
   DESCRIPCIÓN: MUESTRA LOS ROLES Y PERMISOS ASIGNADOS A CADA USUARIO.
   =========================================================== */

SELECT U.USERNAME    AS USUARIO
     , R.GRANTED_ROLE AS ROL
     , P.PRIVILEGE    AS PRIVILEGIO
FROM DBA_USERS U
LEFT JOIN DBA_ROLE_PRIVS R
       ON U.USERNAME = R.GRANTEE
LEFT JOIN DBA_SYS_PRIVS P
       ON U.USERNAME = P.GRANTEE
ORDER BY USUARIO, ROL, PRIVILEGIO;