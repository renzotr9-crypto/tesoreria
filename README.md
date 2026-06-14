# Dashboard de Tesorería — Publicación web con enlace permanente

Solución de **producción** para publicar el dashboard de tesorería en una **única URL
permanente**. Cada vez que reemplaces el Excel de origen, **todos los usuarios verán
los datos más recientes al abrir el mismo enlace** — sin reenviar ningún archivo.

---

## 1. Arquitectura elegida (y por qué)

**GitHub Pages + lectura del Excel en vivo.**

El dashboard es un único `index.html` que, al abrirse, **descarga el Excel publicado
junto a él** (con un parámetro anti-caché) y lo procesa en el navegador. No hay servidor
que mantener, ni base de datos, ni proceso de compilación.

```
Tú reemplazas el Excel  ─►  GitHub Pages lo sirve  ─►  el dashboard lo lee al cargar
        (1 archivo)              (misma URL)                (siempre lo último)
```

**Por qué esta opción frente a las demás:**

| Alternativa | Veredicto |
|---|---|
| **GitHub Pages + Excel en vivo** ✅ | **Elegida.** Gratis, URL permanente, cero mantenimiento, sin compilación. Actualizas reemplazando **un solo archivo** desde el navegador. |
| GitHub Pages + JSON por GitHub Action | Válida, pero añade un paso de conversión y más piezas que mantener. Sólo aporta algo en volúmenes muy grandes. *(Incluyo el convertidor como opción avanzada.)* |
| Netlify / Vercel / Cloudflare Pages | Igual de buenas técnicamente; se prefirió GitHub Pages por su flujo "reemplazar un archivo en la web" sin build y por ser el más simple de mantener. |
| Firebase Hosting | Requiere CLI y despliegues; más pesado para un sitio estático. |
| Google Drive / Apps Script / Google Sheets | El hosting estático de Drive está descontinuado; usar Sheets como fuente añade API, permisos y cuotas. Menos robusto. |

Resultado: **lo más robusto y a la vez lo más sencillo** para este caso.

---

## 2. Estructura del proyecto

```
dashboard-tesoreria/
├── index.html                            ← el dashboard (no se vuelve a tocar)
├── Flujo_Caja_Diario_Multiempresa.xlsx   ← la FUENTE DE DATOS (esto es lo que reemplazas)
├── .nojekyll                             ← hace que GitHub Pages sirva los archivos tal cual
├── README.md                             ← este documento
└── scripts/                              ← utilidades OPCIONALES
    ├── actualizar-datos.ps1              ← (Windows) sube un Excel nuevo por Git
    ├── actualizar-datos.sh               ← (Mac/Linux) idem
    └── excel_to_json.mjs                 ← (avanzado) convierte el Excel a data.json
```

> El dashboard funciona **sin** los scripts. Son ayudas opcionales.

---

## 3. Publicar por primera vez (≈ 5 minutos, todo desde el navegador)

1. Crea una cuenta gratuita en **https://github.com** (si no tienes una).
2. Pulsa **New repository**. Nombre sugerido: `tesoreria` · visibilidad **Public** ·
   marca **Add a README** → **Create repository**.
3. Entra al repo → **Add file ▸ Upload files**. Arrastra **todo el contenido** de la
   carpeta `dashboard-tesoreria/` (el `index.html`, el `.xlsx`, el `.nojekyll`, el
   `README.md` y la carpeta `scripts/`). Pulsa **Commit changes**.
4. Ve a **Settings ▸ Pages**. En **Build and deployment ▸ Source** elige **Deploy from a
   branch**; en **Branch** selecciona **main** y carpeta **/ (root)** → **Save**.
5. Espera 1–2 minutos. GitHub mostrará en esa misma página tu enlace público.

### Tu URL final (para compartir con cualquiera)

```
https://<TU-USUARIO>.github.io/tesoreria/
```

Ejemplo: si tu usuario es `gianina`, el enlace sería
`https://gianina.github.io/tesoreria/`.

**Ese enlace es permanente.** Compártelo por correo, chat o intranet. No caduca y no
hay que volver a enviarlo nunca.

---

## 4. Actualizar los datos en el futuro (lo único que harás cada vez)

**Regla de oro:** el archivo nuevo debe llamarse **exactamente igual**
(`Flujo_Caja_Diario_Multiempresa.xlsx`) y conservar la **misma estructura de hojas**
(`Movimientos`, `SaldoBanco`, `Lista diaria`, `Control de Saldos`).

**Opción A — desde el navegador (recomendada, sin instalar nada):**
1. Abre tu repo en GitHub → **Add file ▸ Upload files**.
2. Arrastra el Excel **nuevo** (mismo nombre). GitHub detecta que reemplaza al anterior.
3. **Commit changes**.
4. En ~1–2 min el dashboard mostrará los datos nuevos. Los usuarios sólo refrescan la
   página (el dashboard ya pide la versión más reciente automáticamente).

**Opción B — con Git instalado (automatizada):**
1. Copia el Excel nuevo (mismo nombre) dentro de la carpeta del proyecto.
2. Ejecuta el script correspondiente:
   - Windows: `scripts/actualizar-datos.ps1`
   - Mac/Linux: `bash scripts/actualizar-datos.sh`

En ambos casos **solo reemplazas el Excel**; el dashboard se actualiza solo.

---

## 5. ¿Por qué los usuarios siempre ven lo más reciente?

Al cargar, el dashboard pide el Excel con `cache: no-store` **y** un parámetro
anti-caché (`?t=<momento>`). Eso evita que el navegador o la red sirvan una copia vieja:
**cada apertura trae la versión publicada más nueva.** En la barra de datos del
dashboard se muestra, además, la fecha/hora de la última actualización del archivo.

> Si algún usuario tuviera una copia muy cacheada, un **Ctrl + F5** fuerza la recarga.

---

## 6. Compatibilidad y funcionalidades

Se conserva **todo** lo actual: diseño y apariencia, KPIs (Saldo Consolidado dinámico,
Variación %, Ingresos, Egresos, Flujo Neto), gráficos (Evolución, Ranking de Bancos,
Tendencia, etc.), heatmap **Saldos por Compañía** con detalle de cuentas por banco,
tablas dinámicas, filtros (Periodo, Empresa, Tipo, Banco), exportaciones y el botón
**Compartir (HTML)**. El modo "hospedado" sólo cambia **de dónde** se leen los datos
(del Excel publicado en vez del incrustado).

Como respaldo, el `index.html` lleva los datos incrustados: si alguien abre el archivo
sin conexión o como `file://`, igual ve el dashboard (con los últimos datos incrustados).

---

## 7. Opcional / avanzado — servir JSON en lugar de Excel

No es necesario. Si en el futuro el Excel creciera mucho y quisieras una carga más
rápida, puedes generar un `data.json`:

```bash
npm install xlsx
node scripts/excel_to_json.mjs      # genera data.json junto al index.html
```

Súbelo al repo igual que el resto. *(Adoptar JSON como fuente del dashboard requiere un
pequeño ajuste en `index.html`; puedo dejarlo activado si decides tomar esta ruta.)*

---

## 8. Solución de problemas

| Síntoma | Causa probable | Solución |
|---|---|---|
| El dashboard no muestra los datos nuevos | El navegador cacheó la página | **Ctrl + F5**; verifica que el commit del Excel ya esté en el repo |
| Aparece "datos incrustados" en la barra | El Excel no se encontró por su nombre | El archivo debe llamarse `Flujo_Caja_Diario_Multiempresa.xlsx` y estar en la raíz del repo |
| Página en blanco / 404 | Pages aún no terminó de desplegar | Espera 1–2 min; revisa **Settings ▸ Pages** que la fuente sea **main / root** |
| Los gráficos no cargan | Bloqueo de CDN en la red del usuario | Las librerías se cargan por CDN; en redes muy restringidas, permitir `cdnjs.cloudflare.com` y `unpkg`/jsdelivr |
| Cambié el nombre del repo | La URL cambia | La URL incluye el nombre del repo: `https://usuario.github.io/<repo>/` |

---

### Resumen

- **Una sola URL** permanente para todos.
- **Actualizar = reemplazar un Excel** (mismo nombre) y commit.
- **Sin reenviar HTML**, sin servidores, sin costo.
