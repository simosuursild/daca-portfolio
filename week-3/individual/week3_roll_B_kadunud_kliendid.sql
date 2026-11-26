-- Roll B - "Kadunud klientide" tuvastamine
-- Ülesanne 2
-- Leia kliendid, kellel pole ühtegi ostu
-- Minu lahendus:
SELECT *
FROM customers
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (SELECT customer_id FROM sales WHERE customer_id IS NOT NULL);

-- Lahendus materjalides (JOIN'ga):
-- LEFT JOIN: kõik kliendid, ka need kellel pole oste    
SELECT c.first_name,       
       c.last_name,        
       c.email,        
       c.city,        
       c.registration_date,        
       s.sale_id    
FROM customers c   
LEFT JOIN sales s ON c.customer_id = s.customer_id  -- sidumistingimus  
WHERE s.sale_id IS NULL;    -- Kui sale_id on NULL, siis klient pole kunagi ostnud!

-- Ülesanne 3
-- Loe kokku, mitu "kadunud" klienti on
-- Minu lahendus:
SELECT COUNT(*) AS vaimkliendid
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales WHERE customer_id IS NOT NULL);

-- Lahendus materjalides (JOIN'ga):
SELECT COUNT(*) AS kadunud_kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id -- sidumistingimus   
WHERE s.sale_id IS NULL;

-- Ülesanne 4
-- Analüüsi kadunud kliente linnade kaupa
SELECT c.city AS linn, COUNT(*) AS kadunud_kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id -- sidumistingimus   
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;

-- Ülesanne 5
-- Uuri registreerimise kuupäeva
-- Millal kadunud kliendid registreerusid?
SELECT c.first_name,       
       c.last_name,        
       c.email,
       c.phone,        
       c.city,        
       c.registration_date,        
       s.sale_id    
FROM customers c   
LEFT JOIN sales s ON c.customer_id = s.customer_id -- sidumistingimus    
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;

-- Ülesanne 6
-- Võrdle kadunud vs aktiivsete klientide arvu
-- Minu lahendus:
SELECT
    COUNT(*) FILTER (WHERE s.sale_id IS NULL) AS kadunud_kliente,
    COUNT(DISTINCT c.customer_id) FILTER (WHERE s.sale_id IS NOT NULL) AS aktiivsed_kliendid
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id; -- sidumistingimus 

-- Lahendus materjalides:
SELECT        
       CASE           
       WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            
       ELSE 'Aktiivne (on ostnud)'        
       END AS staatus,        
COUNT(DISTINCT c.customer_id) AS kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
GROUP BY        
       CASE            
       WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            
       ELSE 'Aktiivne (on ostnud)'        
       END;


-- Edasijõudnute ülesanded
-- Lisa ajaline analüüs: grupeeri kadunud kliendid registreerimiskuu kaupa ja otsi mustreid
-- Minu lahendus:
SELECT
    TO_CHAR(c.registration_date, 'YYYY-MM') AS registreerimis_aasta_ja_kuu,
    COUNT(*) AS kogus
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id  -- sidumistingimus
WHERE s.sale_id IS NULL
GROUP BY TO_CHAR(c.registration_date, 'YYYY-MM')
ORDER BY kogus DESC;

-- Lahendus materjalides:
SELECT       
       DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu,       
       COUNT(*) AS kadunud_kliente   
FROM customers c   
LEFT JOIN sales s ON c.customer_id = s.customer_id   
WHERE s.sale_id IS NULL   
GROUP BY DATE_TRUNC('month', c.registration_date)   
ORDER BY registreerimis_kuu DESC;
