-- CREACIÓN DE LA BASE DE DATOS
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'RetailPro')
BEGIN
    CREATE DATABASE RetailPro;
END
GO

USE RetailPro;
GO

-- ELIMINACIÓN DE TABLAS (reiniciar la estructura)
DROP TABLE IF EXISTS ventas_presencial;
DROP TABLE IF EXISTS ventas_online;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS territorios;
GO

-- CREACIÓN DE TABLAS (Estructura Relacional)

-- Tabla clientes
CREATE TABLE clientes (
    cliente_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    segmento VARCHAR(50)
);

-- Tabla productos
CREATE TABLE productos (
    producto_id INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- Tabla territorios
CREATE TABLE territorios (
    territorio_id INT PRIMARY KEY,
    region VARCHAR(50) NOT NULL
);

-- Tabla ventas_presencial
CREATE TABLE ventas_presencial (
    venta_id INT PRIMARY KEY,
    fecha DATE NOT NULL,
    cliente_id INT,
    producto_id INT,
    territorio_id INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id),
    FOREIGN KEY (territorio_id) REFERENCES territorios(territorio_id)
);

-- Tabla ventas_online
CREATE TABLE ventas_online (
    venta_id INT PRIMARY KEY,
    fecha DATE NOT NULL,
    cliente_id INT, -- Puede contener IDs no existentes para ejemplos de auditoría
    producto_id INT,
    monto_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);
GO

-- INSERCIÓN DE DATOS DE PRUEBA

-- Insertar Clientes
INSERT INTO clientes (cliente_id, nombre, email, segmento) VALUES
(1, 'María García', 'maria@email.com', 'Corporativo'),
(2, 'Juan Pérez', 'juan@email.com', 'Consumo'),
(3, 'Carlos López', 'carlos@email.com', 'PyME'),
(4, 'Ana Martínez', 'ana@email.com', 'Consumo');

-- Insertar Productos
INSERT INTO productos (producto_id, nombre_producto, categoria, precio) VALUES
(10, 'Notebook Pro 15', 'Tecnología', 1200.00),
(20, 'Monitor 27 Pulgadas', 'Tecnología', 550.00),
(30, 'Silla Ergonómica', 'Mobiliario', 220.00),
(40, 'Teclado Mecánico', 'Accesorios', 90.00);

-- Insertar Territorios
INSERT INTO territorios (territorio_id, region) VALUES
(100, 'Norte'),
(200, 'Sur'),
(300, 'Centro');

-- Insertar Ventas Presenciales
INSERT INTO ventas_presencial (venta_id, fecha, cliente_id, producto_id, territorio_id, cantidad, precio_unitario, monto_total) VALUES
(1, '2026-03-01', 1, 10, 100, 1, 1200.00, 1200.00),
(2, '2026-03-02', 2, 20, 200, 2, 300.00, 600.00),
(3, '2026-03-03', 3, 30, 300, 1, 250.00, 250.00),
(4, '2026-03-04', 1, 40, 100, 2, 50.00, 100.00);

-- Insertar Ventas Online
INSERT INTO ventas_online (venta_id, fecha, cliente_id, producto_id, monto_total) VALUES
(100, '2026-03-01', 1, 10, 250.00),
(101, '2026-03-02', 2, 20, 640.00),
(102, '2026-03-05', 99, 40, 100.00); -- Venta huérfana (cliente_id 99 no existe en clientes)
GO

USE RetailPro;
GO

-- Probar los tipos de JOIN con la base de datos real
SELECT c.nombre, v.venta_id, v.monto_total
FROM clientes c
INNER JOIN ventas_online v ON c.cliente_id = v.cliente_id;

SELECT c.nombre, v.venta_id, v.monto_total
FROM clientes c
LEFT JOIN ventas_online v ON c.cliente_id = v.cliente_id;

SELECT c.nombre, v.venta_id, v.monto_total
FROM clientes c
RIGHT JOIN ventas_online v ON c.cliente_id = v.cliente_id;

SELECT c.nombre, v.venta_id, v.monto_total
FROM clientes c
FULL OUTER JOIN ventas_online v ON c.cliente_id = v.cliente_id;

--Consulta 1 -- Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    v.monto_total,
    'Presencial' AS canal
FROM ventas_presencial v
INNER JOIN clientes c ON v.cliente_id = c.cliente_id
INNER JOIN productos p ON v.producto_id = p.producto_id
INNER JOIN territorios t ON v.territorio_id = t.territorio_id

-- Consulta 2 -- Clientes sin ventas (LEFT JOIN)
SELECT
    c.nombre,
    c.email
FROM clientes c
LEFT JOIN ventas_online vo ON c.cliente_id = vo.cliente_id
LEFT JOIN ventas_presencial vp ON c.cliente_id = vp.cliente_id
WHERE vo.venta_id IS NULL AND vp.venta_id IS NULL;

--Consulta 3 -- Productos sin ventas (LEFT JOIN)
SELECT
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos p
LEFT JOIN ventas_online vo ON p.producto_id =vo.producto_id
LEFT JOIN ventas_presencial vp ON p.producto_id = vp.producto_id
WHERE vo.venta_id IS NULL AND vp.venta_id IS NULL
   
--Consulta 4 -- Consolidado por canal (UNION ALL)
SELECT
    canal,
    SUM(monto_total) AS total_por_canal
FROM (
    SELECT monto_total,'Online' AS canal FROM ventas_online
    UNION ALL
    SELECT monto_total, 'Presencial' AS canal FROM ventas_presencial
) AS ventas_consolidadas
GROUP BY canal;
