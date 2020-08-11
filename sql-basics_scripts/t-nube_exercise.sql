/*Preguntas:
1.	¿Caal fue la evolución mensual de la base de clientes brasileños?
El output esperado es una tabla así:
		
month	#customers
01/2017	
02/2017	
….	

2.	¿Cual fue el churn de clientes de Diciembre 2017?
	El churn es el porcentaje de los clientes que abandonaron la plataforma durante el mes

3.	¿Cual fue la cantidad de clientes nuevos por mes?
	Un cliente nuevo es aquel que pagó por primera vez su mensualidad durante ese mes. */

-- ejercicio 1

SELECT
	DATE_FORMAT(date, '%m/%Y') 		AS 'month',
	COUNT(c.store_id) 				AS '#customers'
FROM CustomersBOM c
JOIN Store s ON c.store_id = s.id
WHERE s.country = 'Brasil'
GROUP BY 1
ORDER BY 1;

-- ejercicio 2

SELECT
	churn_customers / total_customers_prev_month*100 			AS 'churn_rate'
FROM
	(SELECT
	COUNT(c.store_id) 								AS 'churn_customers',
	(SELECT SUM(1)
	FROM CustomersBOM c
	WHERE DATE_FORMAT(date, '%m/%Y') = '11/2017') 	AS 'total_customers_prev_month'
	FROM CustomersBOM c 
	WHERE c.store_id
	NOT IN
	(SELECT c.store_id
        FROM CustomersBOM c
        WHERE DATE_FORMAT(date, '%m/%Y') = '12/2017')
	AND DATE_FORMAT(date, '%m/%Y') = '11/2017') churn;

-- ejercicio 3

SELECT
	DATE_FORMAT(s.created_at, '%Y-%m') 	AS 'month',
	COUNT(s.id) 						AS 'customers'
FROM Store s
JOIN customersbom c ON s.id = c.store_id
	AND
    (DATE_FORMAT(s.created_at, '%Y-%m') = DATE_FORMAT(c.date, '%Y-%m')
    OR
    DATE_FORMAT(s.created_at, '%Y-%m') = DATE_FORMAT(DATE_ADD(c.date, INTERVAL 1 MONTH), '%Y-%m'))
GROUP BY 1
ORDER BY 1;
