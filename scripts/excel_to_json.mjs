#!/usr/bin/env node
/* ============================================================================
   OPCIONAL · excel_to_json.mjs
   Convierte el Excel de tesorería a un data.json liviano.
   NO es necesario para que el dashboard funcione: por defecto el dashboard
   lee el .xlsx directamente. Este script es solo una utilidad por si en el
   futuro prefieres servir JSON (carga un poco más rápida en archivos grandes).

   Uso:
     1) Instala dependencias una sola vez:   npm install xlsx
     2) Ejecuta:                              node scripts/excel_to_json.mjs
     3) Genera:                               data.json  (junto al index.html)

   El JSON contiene exactamente las 3 hojas que el dashboard utiliza.
============================================================================ */
import * as XLSX from 'xlsx';
import fs from 'fs';
import path from 'path';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const XLSX_PATH = path.join(ROOT, 'Flujo_Caja_Diario_Multiempresa.xlsx');
const OUT_PATH  = path.join(ROOT, 'data.json');

if (!fs.existsSync(XLSX_PATH)) {
  console.error('No se encontró', XLSX_PATH);
  process.exit(1);
}

const wb = XLSX.read(fs.readFileSync(XLSX_PATH), { type: 'buffer' });

// Coincidencia flexible de nombres de hoja (tolera mayúsculas/espacios)
const norm = s => String(s).toLowerCase().replace(/\s+/g, '');
const findSheet = (...cands) => {
  for (const c of cands) {
    const hit = wb.SheetNames.find(n => norm(n) === norm(c) || norm(n).includes(norm(c)));
    if (hit) return wb.Sheets[hit];
  }
  return null;
};
const toRows = ws => (ws ? XLSX.utils.sheet_to_json(ws, { defval: null, raw: true }) : []);

const data = {
  generadoEl: new Date().toISOString(),
  movimientos: toRows(findSheet('Movimientos')),
  saldoBanco:  toRows(findSheet('SaldoBanco', 'SaldosBancos', 'Saldos Bancos')),
  listaDiaria: toRows(findSheet('Lista diaria', 'Lista Diaria')),
};

fs.writeFileSync(OUT_PATH, JSON.stringify(data));
console.log('OK ->', OUT_PATH);
console.log(`   movimientos: ${data.movimientos.length} | saldoBanco: ${data.saldoBanco.length} | listaDiaria: ${data.listaDiaria.length}`);
