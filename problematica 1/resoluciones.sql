Tipos de cliente
CREATE TABLE IF NOT EXISTS tipo_cliente ( id INTEGER PRIMARY KEY AUTOINCREMENT, nombre NOT NULL UNIQUE,
limite_cajas_ahorro INTEGER,
limite_cajas_ahorro_pesos INTEGER,
limite_cajas_ahorro_dolares INTEGER,
limite_cajas_ahorro_pesos_extra INTEGER,
limite_cajas_ahorro_dolares_extra INTEGER,
limite_cuentas_corriente INTEGER,
limite_cuentas_inversion INTEGER,
limite_tarjetas_debito INTEGER,
limite_tarjetas_credito INTEGER,
limite_extensiones INTEGER,
limite_credito REAL,
limite_cuota_credito REAL,
-- Nota: deberia usar campo para determinar las marcas 
master_disponible BOOLEAN,
visa_ disponible BOOLEAN, 
amex_disponible BOOLEAN,
limite_retiro_mensual INTEGER,
limite_retiro_diario REAL,
comision_saliente REAL,
comision_entrante REAL,
limite_chequeras INTEGER
);

INSERT INTO tipo_cliente (nombre, limite_cajas_ahorro,limite_cajas_ahorro_pesos,limite_cajas_ahorro_dolares,limite_cajas_ahorro_extra,limite_cajas_ahorro_dolares_extra,limite_cuentas_corriente,limite_cuentas_inversion,limite_tarjetas_debito,limite_tarjetas_credito,
                            limite_extensiones,limite_credito,limite_cuota_credito,master_disponible,amex_disponible,visa_disponible,
                            limite_retiro_mensual,limite_retiro_diario,comision_saliente