/*Süntees: Toomas Kaski Raport
Ülesanne 1 - Duplikaatide arv 
Küsimus: mitu duplikaati on? 5116 */
SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate
FROM sales;

/*Ülesanne 2 - NULL väärtused
Sinu päring NULL väärtuste kohta: */
SELECT 
COUNT(*) - COUNT(customer_id) AS puuduv_kliendi_id
FROM sales;

/*Ülesanne 3 - suurimad müügid
Sinu päring suurimate müükide kohta: */
SELECT sale_id, customer_id, total_price AS summa
FROM sales
ORDER BY summa DESC
LIMIT 10;

/*Ülesanne 4 - väikseimad ja kahtlased müügid
Sinu päring väikseimate ja kahtlaste müükide kohta: */
SELECT sale_id, customer_id, total_price AS summa
FROM sales
WHERE total_price <= 0
ORDER BY total_price DESC;

/* Teadmiste kontrolli ülesanne 10
Kirjuta SQL päring, mis vastab Toomase küsimusele: 
"Mitu tellimust on igas kanalis (channel) ja mitu unikaalset klienti igas kanalis?" Kasuta sales tabelit. */

--Leian unikaalsete müükide arvu poodides:
SELECT
COUNT(DISTINCT sale_id) AS pood
FROM sales
WHERE channel = 'pood';

--Leian unikaalsete müükide arvu e-poes
SELECT
COUNT(DISTINCT sale_id) AS online
FROM sales
WHERE channel = 'online';

--Leian unikaalsete klientide arvu poodides
SELECT
(COUNT(*) - COUNT(customer_id)) + COUNT(DISTINCT customer_id) AS kliendid_poodides
FROM sales
WHERE channel = 'pood';

--Leian unikaalsete klientide arvu e-poes
SELECT
(COUNT(*) - COUNT(customer_id)) + COUNT(DISTINCT customer_id) AS kliendid_e_poes
FROM sales
WHERE channel = 'online';
