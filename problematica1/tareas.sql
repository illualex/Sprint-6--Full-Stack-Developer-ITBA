-- Crear en la base de datos los tipos de cliente,
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

-- Crear en la base de datos los tipos de cuenta 
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


--Crear en la base de datos los tipos de marcas de tarjeta. Insertar los valores según la información provista en el Sprint 5.

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

-- Agregar la entidad tarjeta teniendo en cuenta los atributos necesarios para la operación del home banking. Se sugieren los siguientes campos:
        -- Número (único e irrepetible, con una restricción antes de cada inserción que no debe superar 20 números/espacios)
        -- CVV
        -- Fecha de otorgamiento
        -- Fecha de expiración. Almacenar si es una tarjeta de crédito o débito.

CREATE TABLE tarjeta (
    Numero TEXT NOT NULL,
    CVV INTEGER,
    FechaOtorgamiento DATE,
    FechaExpiracion DATE,
    TipoTarjeta TEXT,
    CONSTRAINT chk_numero_length CHECK (LENGTH(Numero) >= 16 AND LENGTH(Numero) <= 20)
);

-- Relacionar las tarjetas con la tabla donde se guardan las marcas de tarjeta.
-- Relacionar las tarjetas con el cliente al que pertenecen.

-- Insertar 500 tarjetas de crédito con sus respectivos datos (se puede utilizar www.generatedata.com) y asociarlas a los clientes de forma aleatoria.
 
 HECHO: SE ENCUENTRA EN AGREGATARJETAS.SQL// tarjetas-credito.py
la data esta en tarjetas.json

-- Agregar la entidad direcciones, que puede ser usada por los clientes, empleados y sucursales, con los campos utilizados en el SPRINT 5.

-- Insertar 500 direcciones, asignando del lote inicial a empleados, clientes o sucursales de forma aleatoria. Ten en cuenta que un cliente o empleado puede tener múltiples direcciones, pero la sucursal solo una.

-- Ampliar el alcance de la entidad cuenta para que identifique el tipo de la misma.

-- Asignar un tipo de cuenta a cada registro de cuenta de forma aleatoria.

-- Corregir el campo "employee_hire_date" de la tabla empleado con la fecha en formato YYYY-MM-DD.
UPDATE empleado
SET employee_hire_date = DATE(employee_hire_date);
