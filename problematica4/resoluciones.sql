-- Listar la cantidad de clientes por nombre de sucursal, ordenando de mayor a menor.
-- SELECT branch_name AS NombreSucursal, COUNT(cliente.customer_id) AS CantidadDeClientes
-- FROM sucursal
-- LEFT JOIN cliente ON sucursal.branch_id = cliente.branch_id
-- GROUP BY NombreSucursal
-- ORDER BY CantidadDeClientes DESC;
SELECT s.branch_name AS sucursal, COUNT(c.customer_id) AS CantidadDeClientes
FROM sucursal s
LEFT JOIN cliente c ON s.branch_id = c.branch_id
GROUP BY sucursal
ORDER BY CantidadDeClientes DESC;


-- Obtener la cantidad de empleados por cliente por sucursal en un número real.
SELECT s.branch_name AS sucursal, CONCAT(c.customer_name, ' ', c.customer_surname) AS NombreCliente, COUNT(e.employee_id) AS CantidadEmpleados
FROM sucursal s
INNER JOIN cliente c ON s.branch_id = c.branch_id
LEFT JOIN empleado e ON c.customer_id = e.customer_id
GROUP BY sucursal, NombreCliente;


-- Obtener la cantidad de tarjetas de crédito por tipo por sucursal.
SELECT s.branch_name AS Sucursal, t.tipoTarjeta AS TipoTarjeta, COUNT(t.Numero) AS CantidadTarjetas
FROM sucursal s
INNER JOIN cliente c ON s.branch_id = c.branch_id
LEFT JOIN tarjeta t ON c.customer_id = t.customer_id
WHERE t.tipoTarjeta IN ('MASTER', 'VISA', 'AMERICAN')
GROUP BY Sucursal, TipoTarjeta;




-- Obtener el promedio de créditos otorgados por sucursal.
SELECT s.branch_name AS Sucursal, AVG(p.loan_total) AS PromedioCredito
FROM sucursal s
INNER JOIN cliente c ON s.branch_id = c.branch_id
LEFT JOIN prestamo p ON c.customer_id = p.customer_id
GROUP BY Sucursal;



-- Crear una tabla denominada "auditoria_cuenta" para guardar los datos de movimientos, con los siguientes campos: old_id, new_id, old_balance, new_balance, old_iban, new_iban, old_type, new_type, user_action, created_at.
CREATE TABLE auditoria_cuenta (
    auditoria_cuenta_id INTEGER PRIMARY KEY,
    old_id INTEGER,
    new_id INTEGER,
    old_balance REAL,
    new_balance REAL,
    old_iban TEXT,
    new_iban TEXT,
    old_type TEXT,
    new_type TEXT,
    user_action TEXT,
    created_at DATETIME
);

-- Crear un trigger que, después de actualizar en la tabla "cuentas" los campos balance, IBAN o tipo de cuenta, registre en la tabla "auditoria".
CREATE TRIGGER auditoria_cuenta_trigger_after_update
AFTER UPDATE ON cuenta
BEGIN
    INSERT INTO auditoria_cuenta (old_id, new_id, old_balance, new_balance, old_iban, new_iban, old_type, new_type, user_action, created_at)
    VALUES (OLD.account_id, NEW.account_id, OLD.balance, NEW.balance, OLD.iban, NEW.iban, OLD.type, NEW.type, 'Update', DATETIME('now'));
END;

-- Restar $100 a las cuentas 10, 11, 12, 13, 14.
UPDATE cuenta
SET balance = balance - 100
WHERE account_id IN (10, 11, 12, 13, 14);

-- Mediante índices, mejorar el rendimiento de la búsqueda de clientes por DNI.
CREATE INDEX idx_cliente_dni ON cliente (customer_dni);

-- Crear la tabla "movimientos" con los campos de identificación del movimiento, número de cuenta, monto, tipo de operación y hora.
CREATE TABLE movimientos (
    movimiento_id INTEGER PRIMARY KEY,
    numero_cuenta INTEGER,
    monto REAL,
    tipo_operacion TEXT,
    hora DATETIME
);

-- Mediante el uso de transacciones, hacer una transferencia de $1000 desde la cuenta 200 a la cuenta 400, registrar el movimiento en la tabla "movimientos" y, en caso de no poder realizar la operación de forma completa, realizar un ROLLBACK.
BEGIN;

INSERT INTO movimientos (numero_cuenta, monto, tipo_operacion, hora)
VALUES (200, -1000, 'Transferencia', DATETIME('now'));

UPDATE cuenta
SET balance = balance - 1000
WHERE account_id = 200;

INSERT INTO movimientos (numero_cuenta, monto, tipo_operacion, hora)
VALUES (400, 1000, 'Transferencia', DATETIME('now'));

UPDATE cuenta
SET balance = balance + 1000
WHERE account_id = 400;

COMMIT;
