SELECT date_format(orderdate, '%Y-%m') as year2_month,
        concat(e.lastname,' ',e.firstName) as employee_name,
        e.jobTitle,
        e.reportsTo,
        offices.country,
        SUM(priceEach*quantityOrdered) as CA,
		RANK() OVER (partition by date_format(orderdate, '%Y-%m') ORDER BY SUM(priceEach*quantityOrdered) DESC) as Rang
FROM employees e
LEFT JOIN customers c ON   e.employeenumber =c.salesRepEmployeeNumber
LEFT JOIN orders o USING(customernumber)
LEFT JOIN orderdetails od USING(ordernumber)
LEFT JOIN offices ON e.officeCode = offices.officeCode
WHERE jobtitle like 'Sales Rep'  and status = 'shipped'
GROUP BY lastname,firstName,jobTitle,offices.country,year2_month, reportsTo;
-- 2
SELECT
        distinct (concat(e.lastname,' ',e.firstName)) as employee_name,employeeNumber,
        		date_format(orderdate, '%Y-%m') as year_months,
         max(o.orderDate) as last_order_date,
         min(o.orderDate) as first_order_date,
         TIMESTAMPDIFF(MONTH,  min(o.orderDate),  max(o.orderDate)) as MonthNumOrder,
         TIMESTAMPDIFF(MONTH,    max(o.orderDate), '2024-03-31') as last_periode_inactif,
         sum(
         CASE
           WHEN status != "shipped" THEN 1
           ELSE 0
         END
         ) as nbr_order_not_shipped,
          sum(
         CASE
           WHEN status = "shipped" THEN 1
           ELSE 0
         END
         ) as nbr_order_shipped
FROM employees e
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails od ON o.orderNumber = od.orderNumber
LEFT JOIN offices ON e.officeCode = offices.officeCode
WHERE  jobTitle = 'Sales Rep'
GROUP BY employee_name, year_months, employeeNumber,offices.country;
-- affiche nom et prénom du N+1
select employee.employeeNumber,employee.reportsTo,
concat(manager.lastname,' ',manager.firstname) As Manager
FROM employees as employee
join employees as manager
on employee.reportsTo = manager.employeeNumber;
-- Combinaison
WITH
-- on cherche les top2 meilleurs vendeurs
top2 AS (
SELECT date_format(orderdate, '%Y-%m') as year2_month,
        concat(e.lastname,' ',e.firstName) as employee_name,
        e.jobTitle,
        e.reportsTo,
        offices.country,
        SUM(priceEach*quantityOrdered) as CA,
		RANK() OVER (partition by date_format(orderdate, '%Y-%m') ORDER BY SUM(priceEach*quantityOrdered) DESC) as Rang
FROM employees e
LEFT JOIN customers c ON   e.employeenumber =c.salesRepEmployeeNumber
LEFT JOIN orders o USING(customernumber)
LEFT JOIN orderdetails od USING(ordernumber)
LEFT JOIN offices ON e.officeCode = offices.officeCode
WHERE jobtitle like 'Sales Rep'  and status = 'shipped'
GROUP BY lastname,firstName,jobTitle,offices.country,year2_month, reportsTo),
-- on récupére un max d'infos de l'utilisateur
employee_global_info as (
SELECT
        distinct (concat(e.lastname,' ',e.firstName)) as employee_name,employeeNumber,
        		date_format(orderdate, '%Y-%m') as year_months,
         max(o.orderDate) as last_order_date,
         min(o.orderDate) as first_order_date,
         TIMESTAMPDIFF(MONTH,  min(o.orderDate),  max(o.orderDate)) as MonthNumOrder,
         TIMESTAMPDIFF(MONTH,    max(o.orderDate), '2024-03-31') as last_periode_inactif,
         sum(
         CASE
           WHEN status != "shipped" THEN 1
           ELSE 0
         END
         ) as nbr_order_not_shipped,
          sum(
         CASE
           WHEN status = "shipped" THEN 1
           ELSE 0
         END
         ) as nbr_order_shipped
FROM employees e
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails od ON o.orderNumber = od.orderNumber
LEFT JOIN offices ON e.officeCode = offices.officeCode
WHERE  jobTitle = 'Sales Rep'
GROUP BY employee_name, year_months, employeeNumber,offices.country
),
-- on récupérer le nom du manager
NameN1 as (
-- affiche nom et prénom du N+1
select employee.employeeNumber,employee.reportsTo,
concat(manager.lastname,' ',manager.firstname) As Manager
FROM employees as employee
join employees as manager
on employee.reportsTo = manager.employeeNumber
)
SELECT *
	FROM top2
	JOIN employee_global_info using(employee_name)
	JOIN NameN1 using(employeeNumber)
    WHERE rang < 3
	ORDER BY year_months;