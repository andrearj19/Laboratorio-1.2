-- ====================================================================
-- SCRIPT DE CREACIÓN Y VERIFICACIÓN DE VISTAS DE NEGOCIO
-- ====================================================================


-- VISTA 1: INTEGRANTE 1 - GESTIÓN DEL PROCESO DE COMPRAS

CREATE OR REPLACE VIEW v_gestion_compras AS
SELECT 
    c.id_compra         AS num_factura,         -- Renombra el ID de la compra para el usuario final.
    c.fecha             AS fecha_compra,        -- Muestra la fecha en la que se adquirió el insumo.
    p.nombre_company    AS proveedor,           -- Trae el nombre comercial o razón social del proveedor.
    p.ruc               AS ruc_proovedor,       -- Expone el Registro Único de Contribuyentes para control fiscal.
    mp.nombre           AS materia_prima,       -- Muestra qué ingrediente específico (orégano, comino, etc.) se compró.
    dc.cantidad         AS cantidad_kg,         -- Cantidad masiva adquirida reflejada en kilogramos.
    dc.precio_unitario  AS precio_por_kg,       -- Costo pactado por cada unidad de medida.
    dc.subtotal         AS subtotal_item,       -- Cálculo de cantidad multiplicada por el precio de esa línea.
    c.total             AS total_factura        -- El valor total general impreso en la cabecera de la factura.
FROM compra c
-- Combina las 4 tablas relacionales utilizando sus respectivas llaves primarias y foráneas:
JOIN proveedor p ON c.id_proveedor = p.id_proveedor
JOIN detalle_compra dc ON c.id_compra = dc.id_compra
JOIN materia_prima mp ON dc.id_materia = mp.id_materia;

-- Consulta de verificación para la Vista de Compras
SELECT * FROM v_gestion_compras;


-- VISTA 2: INTEGRANTE 2 - GESTIÓN DE VENTAS COMERCIAL

CREATE OR REPLACE VIEW v_gestion_ventas AS
SELECT 
    v.id_venta          AS num_venta,           -- Código único de la transacción de salida.
    v.fecha             AS fecha_venta,          -- Registra el momento exacto de la facturación comercial.
    cl.cedula           AS cedula_cliente,      -- Expone la identificación oficial del comprador.
    cl.nombres || ' ' || cl.apellidos AS nombre_cliente, -- Concatena los nombres y apellidos en una sola columna legible.
    prod.nombre         AS producto,            -- Muestra el nombre comercial del producto empaquetado (ej. Frasco 50g).
    dv.cantidad         AS unidades_vendidas,   -- Cuántos frascos o fundas se está llevando el consumidor.
    dv.precio_unitario  AS precio_cobrado,      -- Precio unitario de venta al público fijado en percha.
    dv.subtotal         AS subtotal_linea,      -- Costo total parcial acumulado por ese producto.
    v.total             AS total_venta          -- El valor neto que el cliente cancela en caja.
FROM venta v
-- Realiza las juntas lógicas ocultando datos sensibles del cliente como dirección o teléfono:
JOIN cliente cl ON v.id_cliente = cl.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN producto prod ON dv.id_producto = prod.id_producto;

-- Consulta de verificación para la Vista de Ventas
SELECT * FROM v_gestion_ventas;


-- VISTA 3: INTEGRANTE 3 - CONTROL DE PRODUCCIÓN Y EFICIENCIA

CREATE OR REPLACE VIEW v_control_produccion AS
SELECT 
    p.id_produccion     AS lote_produccion,     -- Código identificador del lote de procesamiento interno.
    p.fecha             AS fecha_proceso,       -- Día en que la materia prima se transformó en la planta.
    emp.nombre          AS empleado_responsable,-- Nombre del operador a cargo de la maquinaria.
    emp.cargo           AS cargo_empleado,      -- Puesto o rol laboral que desempeña el operario.
    prod.nombre         AS producto_terminado,  -- El artículo final obtenido listo para su distribución.
    p.cantidad_producida AS unidades_obtenidas,  -- Volumen total de frascos/sobres fabricados con éxito.
    mp.nombre           AS materia_prima_consumida, -- Qué ingrediente en bruto se sacó de los silos de almacenamiento.
    dp.cantidad_utilizada AS cantidad_mp_usada, -- Peso exacto de la materia prima consumida en el proceso.
    mp.unidad_medida    AS unidad_materia       -- Unidad métrica asociada para el balance de masa (ej. Kilogramos).
FROM produccion p
-- Conecta el flujo completo uniendo las tablas maestras, transaccionales y de consumo intermedio:
JOIN empleado emp ON p.id_empleado = emp.id_empleado
JOIN producto prod ON p.id_producto = prod.id_producto
JOIN detalle_produccion dp ON p.id_produccion = dp.id_produccion
JOIN materia_prima mp ON dp.id_materia = mp.id_materia;

-- Consulta de verificación para la Vista de Producción
SELECT * FROM v_control_produccion;