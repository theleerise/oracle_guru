# Guía de uso

Este repositorio contiene scripts SQL y PL/SQL para administración de Oracle.

## Requisitos
- Oracle Database 11g o superior.
- Usuario con permisos adecuados (`DBA_*`, `V$*`).

## Ejecución
Puedes ejecutar cualquier script desde **SQL*Plus** o **SQL Developer**:

```bash
sqlplus / as sysdba @sql/usuarios/usuarios_select_only.sql
```

## Categorías

- sql/usuarios → Administración de usuarios y privilegios.
- sql/rendimiento → Monitoreo y rendimiento.
- sql/almacenamiento → Gestión de tablespaces.
- sql/seguridad → Scripts de auditoría.
- plsql → Funciones, procedimientos y paquetes.