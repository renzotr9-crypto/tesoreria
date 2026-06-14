#!/usr/bin/env bash
# ============================================================================
#  actualizar-datos.sh   (macOS / Linux)   ·  OPCIONAL
#  Sube una versión nueva del Excel al repositorio y publica los cambios.
#  Úsalo solo si trabajas con Git en tu equipo. La forma más simple de
#  actualizar es arrastrar el Excel en la web de GitHub (ver README).
#
#  Uso:
#    1) Coloca el Excel NUEVO (mismo nombre) en esta carpeta del proyecto.
#    2) Ejecuta:   bash scripts/actualizar-datos.sh
# ============================================================================
set -e
cd "$(dirname "$0")/.."          # raíz del proyecto

ARCHIVO="Flujo_Caja_Diario_Multiempresa.xlsx"
if [ ! -f "$ARCHIVO" ]; then
  echo "No se encontró $ARCHIVO en la carpeta del proyecto."
  exit 1
fi

FECHA="$(date '+%Y-%m-%d %H:%M')"
echo "Publicando datos actualizados ($FECHA)..."

git add "$ARCHIVO"
git commit -m "Actualización de datos $FECHA"
git push

echo ""
echo "Listo. En ~1-2 minutos el dashboard mostrará los nuevos datos."
echo "Comparte siempre el MISMO enlace; no necesitas reenviar nada."
