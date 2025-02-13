Este script ha sido creado para comprobar la integridad genuina de los archivos en un disco duro utilizando el algoritmo SHA-256.

Para ejecutar el script en Windows, es necesario permitir la ejecución de scripts en PowerShell. Esto se puede hacer estableciendo la política de ejecución para el usuario actual con el siguiente comando:

# Verificar la política de ejecución actual:
Get-ExecutionPolicy

# Permitir la ejecución de scripts locales (requiere permisos de usuario):
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Creado por LGM.
