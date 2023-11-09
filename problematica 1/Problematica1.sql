    /*Para tal fin se recomienda usar las sentencias CREATE, ALTER, INSERT y UPDATE*/

----------------------Crear en la base de datos: ().-----------------------------------------------------------------------------------

/*TIPO DE CLIENTE*/ -- DONE


CREATE TABLE  
    tipo_cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT, customer_type TEXT UNIQUE NOT NULL,

    limite_caja_ahorro INTEGER,
    limite_caja_ahorro_pesos INTEGER,
    limite_caja_ahorro_dolares INTEGER,
    limite_caja_ahorro_pesos_extra INTEGER,
    limite_caja_ahorro_dolares_extra INTEGER,
    limite_cuenta_corriente INTEGER,
    limite_cuenta_inversion INTEGER,
    limite_tarjetas_debito INTEGER,
    limite_tarjetas_credito INTEGER,
    limite_credito REAL,
    limite_cuota_credito REAL,
    limite_retiro_mensual INTEGER,
    limite_retiro_diario REAL,
    comisision_saliente REAL,
    comision_entrante REAL,
    limite_chequera INTEGER
    );

INSERT INTO 
    tipo_cliente (customer_type, 
     limite_caja_ahorro, limite_caja_ahorro_pesos, limite_caja_ahorro_dolares, limite_caja_ahorro_pesos_extra,
    limite_caja_ahorro_dolares_extra, limite_cuenta_corriente, limite_cuenta_inversion, limite_tarjetas_debito,
    limite_tarjetas_credito, limite_credito, limite_cuota_credito, limite_retiro_mensual, limite_retiro_diario,
    comisision_saliente, comision_entrante, limite_chequera) 

VALUES
     ('Classic', 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 5, 10000, 0.1, 0.005, 0),
     ('Gold', 2, 2, 0, NULL, 1, 1, 1, NULL, 5, 150000, 100000, NULL, 20000, 0.005, 0.001, 1),
     ('Black', 5, 5, NULL, NULL, 3, 1, 5, NULL, 10, 500000, 600000, NULL, 100000, 0, 0, 2);



/*TIPO DE CUENTA*/ --DONE                                   
--- Crear la tabla de Tipos de Cuenta - DONE
CREATE TABLE  
    tipo_cuenta (id INTEGER PRIMARY KEY AUTOINCREMENT, account_type TEXT UNIQUE NOT NULL);

INSERT INTO 
    tipo_cuenta (account_type) 
VALUES
    ('Caja de ahorro en pesos'),
    ('Caja de ahorro en dólares'),
    ('Cuenta Corriente en pesos'),
    ('Cuenta Corriente en dólares'),
    ('Cuenta Inversión');


/*MARCAS DE TARJETA*/ 

CREATE TABLE marca_tarjeta (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    card_type TEXT UNIQUE NOT NULL
);

INSERT INTO marca_tarjeta (card_type)
VALUES
    ('VISA'),
    ('MASTERCARD'),
    ('AMEX');


---Agregar la entidad tarjeta teniendo en cuenta los atributos necesarios para la operación del home banking (DONE).----------------------------------------

CREATE TABLE tarjeta (
    tarjeta_id INTEGER PRIMARY KEY AUTOINCREMENT,
    Numero TEXT NOT NULL UNIQUE CHECK (LENGTH(Numero) <= 20),
    CVV INTEGER,
    FechaOtorgamiento DATE,
    FechaExpiracion DATE,
    TipoTarjeta TEXT
  );


-------------Relacionar las tarjetas con la tabla donde se guardan las MARCAS DE TARJETA (DONE). ------------------------------------------------------------

/*Agregar la columna "MarcaTarjeta" en la tabla "tarjeta"*/ 
ALTER TABLE 
	tarjeta
ADD COLUMN 
	MarcaTarjeta INTEGER;

/*RELACIONAR LAS TARJETAS CON LAS MARCAS*/
--Sabiendo que las tarjetas con 13 dígitos corresponden a 'AMEX', relacionamos esas tarjetas directamente con la marca.
--El resto de las tarjetas se reparte en las marcas 'VISA' y 'MASTERCARD' que poseen 16 dígitos.

PRAGMA random_seed = 123; 

UPDATE 
    tarjeta
SET MarcaTarjeta = 
    CASE 
        WHEN LENGTH(Numero) = 13 THEN (SELECT id FROM marca_tarjeta WHERE card_type = 'AMEX')
        WHEN LENGTH(Numero) >= 13 AND LENGTH(Numero) <= 16 AND RANDOM() % 2 = 0 THEN (SELECT id FROM marca_tarjeta WHERE card_type = 'VISA')
        ELSE (SELECT id FROM marca_tarjeta WHERE card_type = 'MASTERCARD')
    END;

------------------------------Relacionar las tarjetas con el cliente al que pertenecen (DONE). -----------------------------------------------------------------

-- Agrega la columna 'owner' en tarjeta para asociarla con el titular de la misma.
ALTER TABLE 
    tarjeta
ADD COLUMN 
    owner INTEGER;

UPDATE 
    tarjeta
SET owner = (
    SELECT cliente.customer_id
    FROM cliente
    WHERE tarjeta.tarjeta_id = cliente.customer_id
    LIMIT 1
);

SELECT * FROM tarjeta
----------Insertar 500 tarjetas con sus respectivos datos (DONE). -----------------------------------------------------------------------------------------------

-- INSERT REALIZADO EN ARCHIVO "AgregarTarjetas.SQL".

------------Agregar la entidad direcciones, que puede ser usada por los clientes, empleados y sucursales (DONE). -----------------------------------------------

CREATE TABLE direcciones (
	address_id INTEGER PRIMARY KEY AUTOINCREMENT,
    address TEXT NOT NULL,
    country TEXT NOT NULL,
    region TEXT NOT NULL,
    city TEXT NOT NULL,
    postalZip TEXT NOT NULL
);

--------------------Insertar 500 direcciones, asignando a empleados, clientes o sucursal de forma aleatoria (DONE).----------------------------
/* Teniendo en cuenta que un  cliente o empleado puede tener múltiples direcciones, pero la  sucursal, solo una.*/

-- INSERT REALIZADO EN ARCHIVO "DIRECCIONES.SQL".

/*CLIENTES*/

CREATE TABLE direccion_cliente (
    address_id INTEGER,
    customer_id INTEGER,
    FOREIGN KEY (address_id) REFERENCES direcciones(address_id) ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES cliente(customer_id) ON UPDATE CASCADE,
    PRIMARY KEY (address_id, customer_id)
);

PRAGMA random_seed = 0; 

INSERT INTO 
    direccion_cliente (address_id, customer_id)
SELECT
    ABS(RANDOM()) % 500 + 1, customer_id FROM cliente;

--DATOS PARA FACILITAR EL USO Y RECONOCIMIENTO DE LOS CLIENTES.
--Añade las columnas a la tabla direccion_cliente

ALTER TABLE 
    direccion_cliente
ADD COLUMN 
    customer_name TEXT;
ALTER TABLE
     direccion_cliente
ADD COLUMN 
    customer_surname TEXT;

-- Actualiza las columnas customer_name y customer_surname usando datos de la tabla cliente.

UPDATE 
    direccion_cliente
SET 
    customer_name = (SELECT customer_name FROM cliente WHERE cliente.customer_id = direccion_cliente.customer_id);
UPDATE 
    direccion_cliente
SET 
    customer_surname = (SELECT customer_surname FROM cliente WHERE cliente.customer_id = direccion_cliente.customer_id);

/*EMPLEADOS*/

CREATE TABLE direccion_empleado (
    address_id INTEGER,
    employee_id INTEGER,
    FOREIGN KEY (address_id) REFERENCES direcciones(address_id) ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES empleado(employee_id) ON UPDATE CASCADE,
    PRIMARY KEY (address_id, employee_id)
);

INSERT INTO 
    direccion_empleado (address_id, employee_id)
SELECT
    ABS(RANDOM()) % 500 + 1, employee_id FROM empleado;

--DATOS PARA FACILITAR EL USO Y RECONOCIMIENTO DE LOS EMPLEADOS.
--Añade las columnas a la tabla direccion_empleado.

ALTER TABLE 
    direccion_empleado
ADD COLUMN 
    employee_name TEXT;
ALTER TABLE 
    direccion_empleado
ADD COLUMN 
    employee_surname TEXT;

-- Actualiza las columnas employee_name y employee_surname usando datos de la tabla empleado.

UPDATE 
    direccion_empleado
SET 
    employee_name = (SELECT employee_name FROM empleado WHERE empleado.employee_id = direccion_empleado.employee_id);
UPDATE 
    direccion_empleado
SET 
    employee_surname = (SELECT employee_surname FROM empleado WHERE empleado.employee_id = direccion_empleado.employee_id);

/*SUCURSAL*/

UPDATE
    sucursal
SET
    branch_address_id = ABS(RANDOM()) % 500 + 1;

---------------------Ampliar el alcance de la entidad cuenta para que identifique el tipo de la misma (DONE). --------------------------------------------------

ALTER TABLE 
    cuenta
ADD COLUMN 
    account_type;

--------------------Asignar un tipo de cuenta a cada registro de cuenta de forma aleatoria (DONE).--------------------------------------------------------------

UPDATE 
    cuenta
SET 
    account_type = ABS(RANDOM()) % 5 + 1;

--------------------- Corregir el campo employee_hire_date de la tabla empleado con la fecha en formato YYYY-MM-DD (DONE).---------------------------------------

UPDATE 
    empleado
SET
     employee_hire_date = substr (employee_hire_date, 7, 4) ||'-'||
                          substr (employee_hire_date, 4, 2) ||'-'||
                          substr (employee_hire_date, 1, 2); 
---------------------------------------------------------------------------------------------------------------------------------------------------------------



