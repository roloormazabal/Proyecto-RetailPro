# Proyecto RetailPro

Se trata de un trabajo para el curso de Data Analytics de CoderHouse, orientado a practicar el ciclo completo de trabajo con datos: diseño de una base relacional, carga de datos, consultas SQL de negocio, distintos tipos de JOIN para auditoría de integridad, y un pipeline ETL hacia Power BI para visualización.

El proyecto está construido sobre dos escenarios de datos de ventas: Ventas_Tech_DB (un comercio de tecnología, usado en las primeras etapas) y RetailPro (un modelo multicanal —presencial y online— con clientes, productos y territorios, usado para practicar joins e integridad referencial).

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `ventas_tech_db.sql` | Script de creación de la base **Ventas_Tech_DB**: tablas `categorias`, `clientes`, `productos` y `ventas` con sus claves foráneas, carga de datos de ejemplo y consultas de verificación. |
| `m4_consultas_negocio.sql` | Consultas de negocio sobre Ventas_Tech_DB: resumen ejecutivo mensual, ranking de productos por facturación, clientes recurrentes y comparación de meses contra el promedio. Incluye los hallazgos comerciales derivados de cada consulta. |
| `m5_consultas_joins.sql` | Script de creación de la base **RetailPro** (clientes, productos, territorios, `ventas_presencial` y `ventas_online`), con datos de ejemplo que incluyen un registro huérfano a propósito. Contiene ejemplos de `INNER`, `LEFT`, `RIGHT` y `FULL OUTER JOIN`, detección de clientes/productos sin ventas, y consolidación de ventas por canal con `UNION ALL`. |
| `M6_Pipeline_ETL_Apellido_Rolando_Ormazabal.pbix` | Archivo Power BI con el pipeline ETL armado en Power Query (M) a partir del dataset de Ventas_Tech_DB. |
| `M7_Ormazabal_Rolando_Checkpoint2.pbix` | Checkpoint de Power BI con el modelado y las visualizaciones construidas sobre los datos consolidados. |

## Herramientas usadas

- **SQL Server (T-SQL)** — modelado relacional, consultas de negocio, joins y validaciones de integridad.
- **Power BI Desktop / Power Query (M)** — transformación (ETL) y construcción del dashboard.
- **Git / GitHub** — control de versiones y publicación del proyecto.

## Cómo ejecutar los scripts SQL

1. Abrir SQL Server Management Studio (o Azure Data Studio) conectado a una instancia de SQL Server.
2. Ejecutar `ventas_tech_db.sql` primero. Este script crea la base **Ventas_Tech_DB**, sus tablas y carga los datos de ejemplo. Al final corre `SELECT * FROM ...` sobre cada tabla para verificar que la carga fue correcta.
3. Con la base ya creada, ejecutar `m4_consultas_negocio.sql` (empieza con `USE Ventas_Tech_DB;`) para correr las consultas de negocio y ver los hallazgos comentados al final del archivo.
4. Ejecutar `m5_consultas_joins.sql` de forma independiente. Este script crea su propia base, **RetailPro**, con un esquema distinto (multicanal), así que no depende de los pasos anteriores. Incluye un registro de venta online con `cliente_id` inexistente a propósito, para practicar la detección de registros huérfanos con `LEFT JOIN`.
5. Para los archivos `.pbix`, abrirlos con Power BI Desktop. `M6` documenta el pipeline de transformación (Power Query) y `M7` contiene el modelo y las visualizaciones finales; ambos apuntan a los datos de Ventas_Tech_DB generados en el paso 2.

> **Nota:** los scripts usan sintaxis T-SQL (`IF NOT EXISTS`, `GO`, `TOP`), por lo que están pensados para SQL Server. Para ejecutarlos en otro motor (PostgreSQL, MySQL) hay que adaptar esas construcciones.

Se utilizó Claude.ai para generar el presente Readme, con posterior análisis del texto generado y ajustado según contexto.
