import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor connect() {
  // Используем WebDatabase вместо WasmDatabase, чтобы не требовались файлы sqlite3.wasm и drift_worker.js
  // Это исправляет ошибку "Incorrect response MIME type" в Chrome
  return WebDatabase('recipes_db', logStatements: false);
}
