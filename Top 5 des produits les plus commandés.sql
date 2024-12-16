SELECT productName, SUM(quantityInStock), SUM(quantityordered)
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY SUM(quantityordered) DESC
LIMIT 5;
-- Quel est le stock des 5 produits les moins commandés :
SELECT productName, SUM(quantityInStock), SUM(quantityordered)
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY SUM(quantityordered) ASC
LIMIT 5;
