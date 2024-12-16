WITH quantity AS (
SELECT p.productLine as categorie, monthname(o.orderDate) as mois, sum(quantityordered * priceeach) as ca,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) -2 THEN od.quantityOrdered  * priceeach
           ELSE 0
       END) as ca2022,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) -1 THEN od.quantityOrdered  * priceeach
           ELSE 0
       END) as ca2023,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) THEN od.quantityOrdered
           ELSE 0
       END) as ca2024
FROM orders o
LEFT JOIN orderdetails od on o.orderNumber = od.orderNumber
LEFT JOIN products p on od.productCode = p.productCode
GROUP BY categorie, mois)
SELECT * , (ca2022 - ca2023) / ca2023 * 100 as variation from quantity;
WITH quantity AS (
SELECT p.productLine as categorie, monthname(o.orderDate) as mois, sum(quantityordered * priceeach) as ca,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) -2 THEN od.quantityOrdered  * priceeach
           ELSE 0
       END) as en2022,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) -1 THEN od.quantityOrdered  * priceeach
           ELSE 0
       END) as en2023,
       SUM(case
           WHEN year(o.orderDate) >= year(now()) THEN od.quantityOrdered
           ELSE 0
       END) as en2024
FROM orders o
LEFT JOIN orderdetails od on o.orderNumber = od.orderNumber
LEFT JOIN products p on od.productCode = p.productCode
GROUP BY categorie, mois)
SELECT * , (en2023 - en2024) / en2024 * 100 as variation from quantity;
# Trouver les 2 meilleurs vendeurs sur 1 mois
SELECT TIMESTAMPDIFF(MONTH, '2022-01-01', '2022-06-01') AS MonthsDifference;
SELECT e.lastName, e.firstName, sum(priceEach*quantityOrdered) AS CA,
         max(o.orderDate) as last_order_date,
         min(o.orderDate) as first_order_date,
         TIMESTAMPDIFF(MONTH,  min(o.orderDate),  max(o.orderDate)) as MonthNumOrder
FROM employees e
INNER JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE  status = 'shipped' AND jobTitle = 'Sales Rep'
GROUP BY e.lastName, e.firstName
ORDER BY CA DESC;
SELECT SUM(od.quantityOrdered * od.priceEach) AS CA, year(orderdate)
	FROM orderdetails od
	RIGHT JOIN Orders o ON o.ordernumber = od.ordernumber
	RIGHT JOIN customers c on c.customerNumber = o.customerNumber
    GROUP BY year(orderdate);

    