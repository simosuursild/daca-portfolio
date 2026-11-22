-- Leian arve ID-d, mis esinevad sales tabelis rohkem kui ühe korra, ja koondan nende esinemiste arvu tabelisse
SELECT
    invoice_id,
    COUNT(*) AS row_count
FROM sales
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- U1-2
-- Loen kokku kõik müügiread, unikaalsed arve ID-d ja nende põhjal arvutatud duplikaatide arvu sales tabelis
SELECT COUNT(*) AS ridu_kokku,
       COUNT(DISTINCT invoice_id) AS arveid,
       COUNT(*) - COUNT(DISTINCT invoice_id) AS duplikaate
FROM sales;

-- U1-4
-- Leian 10 kõige sagedamini korduvat arve ID-d sales tabelis ning nende esinemise arvud
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC
LIMIT 10;

-- U1-5
-- Kuvan korduvate arve ID-dega müügiread ja nummerdan iga arve read eraldi tabelis esinemise järjekorras
SELECT invoice_id, id, customer_id, total_price,
       ROW_NUMBER() OVER (PARTITION BY invoice_id ORDER BY id) AS rn
FROM sales
WHERE invoice_id IN (
  SELECT invoice_id FROM sales GROUP BY invoice_id HAVING COUNT(*) > 1
)
ORDER BY invoice_id, rn
LIMIT 20;

-- U1-6
-- Loen kokku kõik korduvad arve ID-dega read
WITH nummerdatud AS (
  SELECT ROW_NUMBER() OVER (PARTITION BY invoice_id ORDER BY id) AS rn
  FROM sales
)
SELECT COUNT(*) AS koopiaid
FROM nummerdatud
WHERE rn > 1;

-- Leian customers tabelist telefoninumbrid, mis esinevad rohkem kui ühe korra
SELECT phone, COUNT(*) FROM customers GROUP BY phone HAVING COUNT(*) > 1;

-- U2-1
-- Loen kokku klientide arvu customers tabelis ning puuduvate emailide ja telefoninumbrite väärtused
SELECT COUNT(*) AS kliente_kokku,
       COUNT(*) - COUNT(email) AS email_puudub,
       COUNT(*) - COUNT(phone) AS telefon_puudub
FROM customers;

-- U2-3
-- Kuvan 15 esimest klienti customers tabelist, kellel puudub email
SELECT customer_id, first_name, email, city
FROM customers
WHERE email IS NULL
ORDER BY customer_id
LIMIT 15;

-- U2-5
-- Kuvan 15 esimest klienti customers tabelist, kellel puudub email, asendades väljundis NULL väärtuse tekstiga 'puudub'
SELECT customer_id,
       first_name,
       COALESCE(email, 'puudub') AS email
FROM customers
WHERE email IS NULL
ORDER BY customer_id
LIMIT 15;

-- U2-6
-- Loen kokku müügid sales tabelist, millel puudub kliendi ID ehk on külalisostud
SELECT COUNT(*) AS kulalisoste
FROM sales
WHERE customer_id IS NULL;

-- U3-1
-- Kuvan linnade algsed kirjapildid customers tabelis, nende pikkused ja klientide arvu ning järjestan tulemused puhastatud nimede ja pikkuse järgi (kasvavas järjekorras)
SELECT city AS originaal, LENGTH(city) AS pikkus, COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY LOWER(TRIM(city)), pikkus;

-- U3-2
-- Leian kõik Tallinna erinevad algsed kirjapildid customers tabelis, nende pikkused ja klientide arvu ning reastan need pikkuse alusel kasvavalt
SELECT city AS originaal, LENGTH(city) AS pikkus, COUNT(*) AS kliente
FROM customers
WHERE LOWER(TRIM(city)) = 'tallinn'
GROUP BY city
ORDER BY pikkus;

-- U3-3
-- Grupeerin linnad customers tabelist puhastatud nimede järgi ning loen kokku klientide arvu ja erinevate algsete kirjapiltide arvu
SELECT INITCAP(TRIM(city)) AS linn,
       COUNT(*) AS kliente,
       COUNT(DISTINCT city) AS kirjaviise
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

-- U3-5
-- Kuvan 10 viimast müüki sales tabelist koos Eesti kuupäevaformaadi ning aasta ja kvartaliga
SELECT invoice_id,
       sale_date,
       TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
       TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal
FROM sales
ORDER BY sale_date DESC NULLS LAST
LIMIT 10;

-- U3-6
-- Teisendan tekstina esitatud kuupäeva kuupäeva andmetüübiks
SELECT TO_DATE('25/01/2023', 'DD/MM/YYYY');

-- U3-7
-- Proovin teisendada teksti numbriliseks andmetüübiks
SELECT CAST('pole number' AS NUMERIC);

-- U3-8
-- Loen kokku müügiread, mille müügikuupäev on hilisem kui 28.02.2025 (tegelik viimane müügikuupäev)
SELECT COUNT(*) AS vigaseid
FROM sales
WHERE sale_date > '2025-02-28';
