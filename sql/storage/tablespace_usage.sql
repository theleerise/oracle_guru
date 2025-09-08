/* ===========================================================
   Script: tablespaces_usage.sql
   Descripción: Muestra el porcentaje de uso de los tablespaces.
   =========================================================== */

SELECT TABLESPACE_NAME
     , ROUND((USED_SPACE / TABLESPACE_SIZE) * 100, 2) AS PCT_USED
FROM DBA_TABLESPACE_USAGE_METRICS
ORDER BY PCT_USED DESC;
