-- Crear una vista con las columnas id, numero sucursal, nombre, apellido, DNI y edad de la tabla cliente calculada a partir de la fecha de nacimiento.
-- Mostrar las columnas de los clientes, ordenadas por el DNI de menor a mayor y cuya edad sea superior a 40 años.

CREATE VIEW IF NOT EXISTS vista_clientes (id, nombre,apellido, DNI,edad,numero_sucursal) AS
SELECT customer_id, customer_name, customer_surname,customer_DNI,
    CASE  
        WHEN STRFTIME('%m-%d', DATE()) < STRFTIME('%m-%d',dob)
            then DATE()- dob - 1
        else DATE() - dob
    END,
    branch_id
FROM cliente;

SELECT *
FROM vista_clientes
WHERE edad > 40
ORDER BY DNI ASC;


-- Mostrar todos los clientes que se llaman "Anne" o "Tyler" ordenados por edad de menor a mayor.
SELECT customer_id, customer_name, customer_surname, customer_DNI,
STRFTIME('%Y', 'now') - STRFTIME('%Y', dob) - (STRFTIME('%m-%d', 'now') < STRFTIME('%m-%d', dob)) AS edad
FROM cliente
WHERE customer_name IN ('Anne', 'Tyler')
ORDER BY edad;



-- Dado el siguiente JSON, insertar 5 nuevos clientes en la base de datos y verificar que se haya realizado con éxito la inserción:
    -- [{"customer_name": "Lois", "customer_surname": "Stout", "customer_DNI": 47730534, "branch_id": 80, "customer_dob": "1984-07-07"},
    -- {"customer_name": "Hall", "customer_surname": "Mcconnell", "customer_DNI": 52055464, "branch_id": 45, "customer_dob": "1968-04-30"},
    -- {"customer_name": "Hilel", "customer_surname": "Mclean", "customer_DNI": 43625213, "branch_id": 77, "customer_dob": "1993-03-28"},
    -- {"customer_name": "Jin", "customer_surname": "Cooley", "customer_DNI": 21207908, "branch_id": 96, "customer_dob": "1959-08-24"},
    -- {"customer_name": "Gabriel", "customer_surname": "Harmon", "customer_DNI": 57063950, "branch_id": 27, "customer_dob": "1976-04-01"}
-- INSERT INTO cliente (customer_name, customer_surname, customer_DNI, branch_id, dob)
-- VALUES
--   ('Lois', 'Stout', 47730534, 80, '1984-07-07'),
--   ('Hall', 'Mcconnell', 52055464, 45, '1968-04-30'),
--   ('Hilel', 'Mclean', 43625213, 77, '1993-03-28'),
--   ('Jin', 'Cooley', 21207908, 96, '1959-08-24'),
--   ('Gabriel', 'Harmon', 57063950, 27, '1976-04-01');
-- -- SELECT * FROM cliente;
-- SELECT * FROM cliente ORDER BY customer_id DESC LIMIT 10;

INSERT INTO cliente (customer_name, customer_surname, customer_DNI, branch_id, dob)
SELECT
    json_extract(json_data, '$.customer_name'),
    json_extract(json_data, '$.customer_surname'),
    json_extract(json_data, '$.customer_DNI'),
    json_extract(json_data, '$.branch_id'),
    json_extract(json_data, '$.customer_dob')
FROM (
    SELECT '[
    {
        "customer_name": "Lois",
        "customer_surname": "Stout",
        "customer_DNI": 47730534,
        "branch_id": 80,
        "customer_dob": "1984-07-07"
    },
    {
        "customer_name": "Hall",
        "customer_surname": "Mcconnell",
        "customer_DNI": 52055464,
        "branch_id": 45,
        "customer_dob": "1968-04-30"
    },
    {
        "customer_name": "Hilel",
        "customer_surname": "Mclean",
        "customer_DNI": 43625213,
        "branch_id": 77,
        "customer_dob": "1993-03-28"
    },
    {
        "customer_name": "Jin",
        "customer_surname": "Cooley",
        "customer_DNI": 21207908,
        "branch_id": 96,
        "customer_dob": "1959-08-24"
    },
    {
        "customer_name": "Gabriel",
        "customer_surname": "Harmon",
        "customer_DNI": 57063950,
        "branch_id": 27,
        "customer_dob": "1976-04-01"
    }
]' AS json_data
);



 SELECT * FROM cliente ORDER BY customer_id DESC LIMIT 10;

-- Actualizar 5 clientes recientemente agregados en la base de datos dado que hubo un error en el JSON que traía la información; la sucursal de todos es la 10.
UPDATE cliente
SET branch_id = 10
WHERE customer_id BETWEEN 501 AND 505;
SELECT * FROM cliente ORDER BY customer_id DESC LIMIT 10;


-- Eliminar el registro correspondiente a "Noel David" realizando la selección por el nombre y apellido.
DELETE FROM cliente
WHERE customer_name = 'Noel' AND customer_surname = 'David';
 SELECT * FROM cliente;

-- Consultar cuál es el tipo de préstamo de mayor importe.
SELECT loan_type
-- SELECT *
FROM prestamo
ORDER BY loan_type DESC
LIMIT 1;
