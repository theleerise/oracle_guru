# Buenas Prácticas DBA Oracle

1. **Nunca ejecutes un script en producción sin probarlo en un entorno de pruebas.**
2. Usa **comentarios** en todos los scripts para documentar su propósito.
3. Aprovecha las **vistas dinámicas (`V$`)** para diagnósticos de rendimiento.
4. Implementa auditoría básica en tablas críticas mediante **triggers o paquetes**.
5. Realiza respaldos periódicos y verifica su validez.
6. Usa **roles** en lugar de otorgar permisos directos a los usuarios.
