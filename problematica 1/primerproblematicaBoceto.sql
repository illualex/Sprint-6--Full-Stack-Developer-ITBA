-- -- Crear la tabla de Tipos de Cliente
-- CREATE TABLE TipoCliente (
--     ID INTEGER PRIMARY KEY,
--     Nombre TEXT NOT NULL
-- );

-- -- Insertar valores en la tabla de Tipos de Cliente
-- INSERT INTO TipoCliente (Nombre) VALUES ('Classic');
-- INSERT INTO TipoCliente (Nombre) VALUES ('Gold');
-- INSERT INTO TipoCliente (Nombre) VALUES ('Black');

-- -- Crear la tabla de Tipos de Cuenta
-- CREATE TABLE TipoCuenta (
--     ID INTEGER PRIMARY KEY,
--     Nombre TEXT NOT NULL
-- );

-- -- Insertar valores en la tabla de Tipos de Cuenta
-- INSERT INTO TipoCuenta (Nombre) VALUES ('Caja de ahorro en peso');
-- INSERT INTO TipoCuenta (Nombre) VALUES ('Caja de ahorro en dólares');
-- INSERT INTO TipoCuenta (Nombre) VALUES ('Cuenta Corriente en pesos');
-- INSERT INTO TipoCuenta (Nombre) VALUES ('Cuenta Corriente en dólares');
-- INSERT INTO TipoCuenta (Nombre) VALUES ('Cuenta Inversión');

-- -- Crear la tabla de Marcas de Tarjeta
-- CREATE TABLE MarcaTarjeta (
--     ID INTEGER PRIMARY KEY,
--     Nombre TEXT NOT NULL
-- );

-- -- Insertar valores en la tabla de Marcas de Tarjeta
-- INSERT INTO MarcaTarjeta (Nombre) VALUES ('Mastercard');
-- INSERT INTO MarcaTarjeta (Nombre) VALUES ('VISA');
-- INSERT INTO MarcaTarjeta (Nombre) VALUES ('American Express');

-- Tipos de cliente
-- - Classic
-- - Gold
-- - Black
-- Tipos de cuenta
-- - Caja de ahorro en peso
-- - Caja de ahorro en dólares
-- - Cuenta Corriente en pesos
-- - Cuenta Corriente en dólare
-- - Cuenta Inversión

-- tarjetas
-- MASTER
-- VISA
-- AMERICAN

CREATE TABLE tarjeta (
    Numero TEXT NOT NULL,
    CVV INTEGER,
    FechaOtorgamiento DATE,
    FechaExpiracion DATE,
    TipoTarjeta TEXT,
    CONSTRAINT chk_numero_length CHECK (LENGTH(Numero) >= 16 AND LENGTH(Numero) <= 20)
);

-- Agregar la columna "TipoCliente" en la tabla "cliente"
ALTER TABLE cliente
ADD COLUMN TipoCliente INTEGER;


-- Establecer las relaciones entre cliente y TipoCliente
UPDATE cliente
SET TipoCliente = (
    SELECT ID
    FROM TipoCliente
    WHERE Nombre = 'Classic'  
);

UPDATE cliente
SET TipoCliente = (
    SELECT ID
    FROM TipoCliente
    WHERE Nombre = 'Gold'
)
-- WHERE Nombre = ; aca falta la condicion bajo la cual cada cliente es el que es

-- Agregar la columna "TipoCuenta" en la tabla "cuenta"
ALTER TABLE cuenta
ADD COLUMN TipoCuenta INTEGER;

-- Establecer las relaciones entre cuenta y TipoCuenta
UPDATE cuenta
SET TipoCuenta = (
    SELECT ID
    FROM TipoCuenta
    WHERE Nombre = 'Caja de ahorro en peso' 
);

UPDATE cuenta
SET TipoCuenta = (
    SELECT ID
    FROM TipoCuenta
    WHERE Nombre = 'Caja de ahorro en dólares'
)
WHERE ...;  --  aca falta la condicion bajo la cual cada cliente es el que es

-- Agregar la columna "MarcaTarjeta" en la tabla "tarjeta"
ALTER TABLE tarjeta
ADD COLUMN MarcaTarjeta INTEGER;

ALTER TABLE Tarjeta
ADD FOREIGN KEY (TipoCuentaID) REFERENCES TipoCuenta(TipoCuentaID);

ALTER TABLE Tarjeta
ADD FOREIGN KEY (TipoClienteID) REFERENCES TipoCliente(TipoClienteID);

-- Establecer las relaciones entre tarjeta y MarcaTarjeta
UPDATE tarjeta
SET MarcaTarjeta = (
    SELECT ID
    FROM MarcaTarjeta
    WHERE Nombre = 'Mastercard'  
);


UPDATE tarjeta
SET MarcaTarjeta = (
    SELECT ID
    FROM MarcaTarjeta
    WHERE Nombre = 'VISA'
)
WHERE ...; -- aca falta la condicion bajo la cual cada cliente es el que es
