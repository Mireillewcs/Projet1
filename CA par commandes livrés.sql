SELECT month(orderDate) as Mois,
       sum(CASE
              WHEN year(orderdate) = year(now()) THEN  priceeach * quantityordered
              ELSE 0
		    END
            ) as ca_24,
		sum(CASE
              WHEN year(orderdate) = year(now()) - 1 THEN  priceeach * quantityordered
              ELSE 0
		    END
            ) as ca_23,
		sum(CASE
              WHEN year(orderdate) = year(now()) - 2 THEN  priceeach * quantityordered
              ELSE 0
		    END
            ) as ca_22
FROM orders
LEFT JOIN  orderdetails USING(ordernumber)
where status = 'Shipped'
Group By   month(orderDate)
ORDER BY month(orderDate) asc;