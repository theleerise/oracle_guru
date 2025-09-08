/* ===========================================================
   Script: active_sessions.sql
   Descripción: Lista sesiones activas en la base de datos.
   =========================================================== */

SELECT S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.STATUS
     , S.OSUSER
     , P.SPID   AS PROCESO_SO
     , S.MACHINE
FROM V$SESSION S
JOIN V$PROCESS P ON S.PADDR = P.ADDR
WHERE S.STATUS = 'ACTIVE';
