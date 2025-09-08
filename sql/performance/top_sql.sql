/* ===========================================================
   Script: top_sql.sql
   Descripción: Muestra las 10 sentencias SQL con mayor consumo de CPU.
   =========================================================== */

SELECT *
FROM (
    SELECT SQL_ID
         , EXECUTIONS
         , CPU_TIME
         , SQL_TEXT
    FROM V$SQL
    ORDER BY CPU_TIME DESC
)
WHERE ROWNUM <= 10;
