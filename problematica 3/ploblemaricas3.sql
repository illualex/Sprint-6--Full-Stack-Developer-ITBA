-- balance menor a 0
SELECT * FROM cuenta
    WHERE balance < 0

-- tengan en elapellido la letra Z
SELECT customer_name, customer_surname, dob FROM cliente
    WHERE customer_surname LIKE "%Z%";

-- personas cuyo nombre sea “Brendan”
SELECT customer_name, customer_surname, dob, branch_name 
FROM cliente, sucursal
WHERE customer_name = "Brendan"

--importe mayora $80.000
SELECT c.customer_name, c.customer_surname, c.dob, s.branch_name
FROM cliente c
JOIN sucursal s ON c.branch_id = s.branch_id
WHERE c.customer_name = 'Brendan'
ORDER BY s.branch_name;

--! falta uno

--prestamos cuyo importe sea mayor que el importe medio
SELECT *
FROM prestamo
WHERE loan_total > (SELECT AVG(loan_total) 
                    FROM prestamo);

-- cantidad de clientes menores a 50 años
SELECT COUNT(*) AS cantidad_clientes_menores_50
FROM cliente
WHERE strftime('%Y', 'now') - strftime('%Y', dob) - (strftime('%m-%d', 'now') < strftime('%m-%d', dob)) < 50;

--primeras 5 cuentas con saldo mayor a 8.000$

SELECT customer_id ,balance 
FROM cuenta
WHERE balance > 8000 
LIMIT 5

-- préstamos que tengan fecha en abril, junio y agosto,ordenándolos por importe
SELECT *
FROM prestamo
WHERE loan_date LIKE '%-04-%' OR loan_date LIKE '%-06-%' OR loan_date LIKE '%-08-%'
ORDER BY loan_total;

-- importe total de los prestamos agrupados por tipo de préstamos.Por cada tipo de préstamo

SELECT loan_type, SUM(loan_total) AS loan_total_accu
FROM prestamo
GROUP BY loan_type;