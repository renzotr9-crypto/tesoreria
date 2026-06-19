# ============================================================================
#  actualizar-datos.ps1   (Windows · PowerShell)   ·  OPCIONAL
#  Sube una versión nueva del Excel al repositorio y publica los cambios.
#  Úsalo solo si trabajas con Git instalado en tu PC. La forma más simple
#  de actualizar es arrastrar el Excel en la web de GitHub (ver README).
#
#  Uso:
#    1) Coloca el Excel NUEVO (mismo nombre) en esta carpeta del proyecto.
#    2) Clic derecho sobre este archivo  ->  "Ejecutar con PowerShell"
#       (o:  powershell -ExecutionPolicy Bypass -File .\scripts\actualizar-datos.ps1 )
# ============================================================================

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)   # raíz del proyecto

$archivo = "Flujo_Caja_Diario_Multiempresa.xlsx"
if (-not (Test-Path $archivo)) {
  Write-Host "No se encontró $archivo en la carpeta del proyecto." -ForegroundColor Red
  exit 1
}

$fecha = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host "Publicando datos actualizados ($fecha)..." -ForegroundColor Cyan

git add $archivo
git commit -m "Actualización de datos $fecha"
git push

Write-Host ""
Write-Host "Listo. En ~1-2 minutos el dashboard mostrará los nuevos datos." -ForegroundColor Green
Write-Host "Comparte siempre el MISMO enlace; no necesitas reenviar nada." -ForegroundColor Green
