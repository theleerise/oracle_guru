# 🏛️ Oracle Guru

Colección de **consultas SQL, scripts PL/SQL y ejemplos prácticos** para facilitar el trabajo de administradores de bases de datos Oracle.  
El objetivo es ofrecer snippets reutilizables, buenas prácticas y ejemplos que puedan servir de apoyo en tareas de **rendimiento, seguridad, auditoría y administración diaria**.

---

## 📌 Contenido

- `sql/usuarios` → Consultas relacionadas con usuarios, roles y privilegios.
- `sql/rendimiento` → Scripts para monitorización de sesiones, planes de ejecución y SQL pesados.
- `sql/almacenamiento` → Análisis de tablespaces, datafiles y uso de disco.
- `sql/seguridad` → Detección de cuentas vulnerables, permisos excesivos, etc.
- `plsql/paquetes` → Paquetes PL/SQL listos para implementar.
- `plsql/funciones` → Funciones de utilidad para cálculos y reportes.
- `plsql/procedimientos` → Procedimientos comunes para tareas de mantenimiento.
- `docs/` → Guías, buenas prácticas y documentación complementaria.

---

## 🚀 Ejemplo rápido

```sql
-- Consultar tablespaces con más del 90% de uso
SELECT tablespace_name,
       ROUND((used_space/tablespace_size)*100,2) AS pct_used
  FROM dba_tablespace_usage_metrics
 WHERE (used_space/tablespace_size)*100 > 90;
