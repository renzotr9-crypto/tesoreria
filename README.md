# Dashboard de Tesorería · SSP Capital — Publicación web

Sitio estático (un solo `index.html`) para publicar el dashboard en **GitHub Pages**
y que cualquier persona con el enlace pueda verlo, sin instalar nada.

## Contenido del paquete
- `index.html` — el dashboard (autónomo; gráficos en SVG para verse en cualquier navegador/visor).
- `Flujo_Caja_Diario_Multiempresa.xlsx` — los datos. El dashboard lo lee automáticamente al abrir.
- `.nojekyll` — evita que GitHub procese el sitio y rompa rutas.
- `scripts/` — utilidades opcionales (conversión y subida de datos).

## Cómo se cargan los datos
Al abrir la página, el dashboard intenta **leer el Excel del mismo sitio** (`Flujo_Caja_Diario_Multiempresa.xlsx`)
con un parámetro anti-caché, para mostrar siempre la versión más reciente publicada.
Si no lo encuentra (por ejemplo al abrir el archivo localmente), usa una **copia incrustada** de respaldo.

## Publicar en GitHub Pages (una sola vez)
1. Crea un repositorio nuevo en GitHub (p. ej. `tesoreria`).
2. Sube los archivos de esta carpeta a la raíz del repositorio
   (`index.html`, el `.xlsx`, `.nojekyll` y la carpeta `scripts/`).
3. En el repositorio: **Settings ▸ Pages**.
4. En *Build and deployment ▸ Source* elige **Deploy from a branch**,
   rama **main** y carpeta **/(root)**. Guarda.
5. En 1–2 minutos tu sitio queda en:
   `https://<tu-usuario>.github.io/tesoreria/`
   Comparte ese enlace: cualquier persona lo abre y ve todo, sin SharePoint.

## Actualizar los datos (cada semana)
Solo reemplaza **un** archivo:
1. Sustituye `Flujo_Caja_Diario_Multiempresa.xlsx` por el nuevo (mismo nombre).
2. Súbelo al repositorio (web de GitHub: *Add file ▸ Upload files*, o `git push`).
3. Recarga la página (Ctrl + F5). El dashboard tomará los datos nuevos.

> Importante sobre el formato del Excel: el dashboard espera las hojas
> **Movimientos**, **SaldoBanco** y **Lista diaria**. La columna **Mes/Año** debe venir
> como `YYYY-MM` (no como fecha completa) y **Lista diaria** sin columnas basura a la derecha.
> Si tu Excel de origen trae esos detalles sin limpiar, pídeme que te lo compacte/normalice
> antes de subirlo (es lo mismo que se hizo con el archivo incluido).

## Notas
- Para ver el dashboard correctamente NO uses el visor previo de SharePoint/OneDrive:
  publícalo en GitHub Pages (o abre el archivo directamente en el navegador).
- Los gráficos usan renderizado **SVG**, por lo que se ven bien en navegadores, visores y correos.
