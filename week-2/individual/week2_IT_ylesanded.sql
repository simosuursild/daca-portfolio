-- 1.3 - Ülesanne 1A
-- Leia kõik duplikaatsed sale_id väärtused ning nende kogused sales tabelis
SELECT
    sale_id,
    COUNT(*) AS koopiate_arv
FROM sales -- valin tabeli sales
GROUP BY sale_id -- grupeerin sales_id alusel tabelisse
HAVING COUNT(*) > 1 -- loen vaid read, mida on rohkem kui 1
ORDER BY koopiate_arv DESC; -- järjestan koopiate arvu järgi kahanevas järjekorras

-- Duplikaatide kogumõju vaatamine
SELECT
    COUNT(*) AS ridu_kokku, -- loen kogu ridade arvu ja nimetan veeru pealkirja ümber
    COUNT(DISTINCT sale_id) AS unikaalseid, -- loen kokku palju on unikaalseid sale_id'sid ja nimetan veeru pealkirja ümber
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate, -- arvutan duplikaatide arvu ja nimetan veeru pealkirja ümber
    SUM(total_price) AS summa_duplikaatidega, -- arvutan kõigi ridade summade summa
    (SELECT SUM(total_price) FROM (
        SELECT DISTINCT ON (sale_id) total_price -- valin ainult unikaalsete sale_id'dega read
        FROM sales
        ORDER BY sale_id, id -- valin duplikaatsetest ridadest vaid iga müügi väikseima id-ga rea
    ) unikaalsed) AS summa_ilma_duplikaatideta, -- leian summade summa ilma duplikaatsete ridadeta
    SUM(total_price) - (SELECT SUM(total_price) FROM (
        SELECT DISTINCT ON (sale_id) total_price
        FROM sales
        ORDER BY sale_id, id -- iga müügi väikseima id-ga rida = originaal
    ) unikaalsed) AS duplikaatide_mõju -- arvutan duplikaatide rahalise mõju
FROM sales; -- valin tabeli sales

-- 1.3 - Ülesanne 1B
-- Kirjuta päring, mis kasutab ROW_NUMBER() funktsiooni, et nummerdada customers tabeli read email veeru järgi. Nii leiad kliendid, kellel on sama e-mail mitu korda.
SELECT *
FROM (
    SELECT
        email, first_name, last_name,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn,
        COUNT(*) OVER (PARTITION BY email) AS email_count
    FROM customers
    WHERE email IS NOT NULL
)
WHERE email_count > 1;

SELECT
    email,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name)) AS last_name,
    TRIM(phone) AS phone,
    COUNT(*) AS kordade_arv
FROM customers
WHERE email IS NOT NULL
GROUP BY
    email,
    INITCAP(TRIM(first_name)),
    INITCAP(TRIM(last_name)),
    TRIM(phone)
HAVING COUNT(*) > 1
ORDER BY kordade_arv DESC;

-- 1.3 - Ülesanne 1C
-- Vali ise tabel (nt products või customers) ja kontrolli, kas seal on duplikaate. Otsusta ise, millise veeru järgi duplikaati defineerida.
-- Valisin products tabeli ning leian read, mis on duplikaadid ning palju neid on
SELECT
    product_name, -- valin toote nime
    COUNT(*) AS koopiate_arv -- loen kokku kõik read ja nimetan selle veeru ümber
FROM products -- valin tabeli products
GROUP BY product_name -- grupeerin toote nime alusel tabelisse
HAVING COUNT(*) > 1 -- loen vaid read, mida on rohkem kui 1 kord tabelis esindatud
ORDER BY koopiate_arv DESC; -- järjestan koopiate arvu järgi kahanevas järjekorras

-- Kuvan kõik duplikaatsed read ning reastan need toote nime alusel
SELECT * -- valin kõik veerud
FROM products -- valin tabeli products
-- filtreerin välja read, kus esinevad korduvad toote nimed:
WHERE product_name IN (
-- leian kõik toote nimed, mis esinevad tabelis rohkem kui korra:
    SELECT product_name 
    FROM products
    GROUP BY product_name
    HAVING COUNT(*) > 1
)
ORDER BY product_name; -- reastan toote nimede alusel, et duplikaatseid saaks võrrelda


-- 2.3 - Ülesanne 2A
-- Leia UrbanStyle'i andmetest NULL väärtused.
-- NULL-ide ülevaade customers tabelis:
SELECT * -- valin kõik veerud
FROM customers -- valin tabeli pcustomers
WHERE email IS NULL -- or loyalty_tier IS NULL -- valin read, kus kas email või lojaalsus taseme väli on puudu
ORDER BY customer_id DESC; -- järjestan klindikonto järgi kahanevas järjekorras

-- NULL-ide arv customers tabelis:
SELECT(
SELECT count(*) -- loen kokku kõik read 
FROM customers -- valin tabeli pcustomers
WHERE email IS NULL) AS puudu_emailid, -- valin read, kus email väli on puudu ja nimetan selle väärtuse kuvatavas tabelis ümber
(SELECT count(*) -- loen kokku kõik read
FROM customers -- valin tabeli pcustomers
WHERE loyalty_tier IS NULL) AS puudu_lojaalsus_tase; -- valin read, kus lojaalsus taseme väli on puudu ja nimetan selle väärtuse kuvatavas tabelis ümber

-- sama ülesanne materjalides nii:
SELECT
    COUNT(*) AS kliente_kokku, -- loen kokku kõik read ehk kliendid
    COUNT(first_name) AS eesnimi_olemas, -- loen kokku read, kus eesnimi on olemas
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub, -- lahutan kõikidest ridadest olemasolevate eesnimede arvu, et saada puuduvate eesnimede arv
    COUNT(email) AS email_olemas, -- loen kokku read, kus email on olemas
    COUNT(*) - COUNT(email) AS email_puudub, -- lahutan kõikidest ridadest olemasolevate emailide arvu, et saada puuduvate emailide arv
    COUNT(phone) AS telefon_olemas, -- loen kokku read, kus telefoninumber on olemas
    COUNT(*) - COUNT(phone) AS telefon_puudub, -- lahutan kõikidest ridadest olemasolevate telefoninumbrite arvu, et saada puuduvate telefoninumbrite arv
    COUNT(city) AS linn_olemas, -- loen kokku read, kus linn on olemas
    COUNT(*) - COUNT(city) AS linn_puudub, -- lahutan kõikidest ridadest olemasolevate linnade arvu, et saada puuduvate linnade arv
    COUNT(loyalty_tier) AS lojaalsus_tase_olemas, -- loen kokku read, kus lojaalsustase on olemas
    COUNT(*) - COUNT(loyalty_tier) AS lojaalsus_tase_puudub, -- lahutan kõikidest ridadest olemasolevate lojaalsustasemete arvu, et saada puuduvate lojaalsustasemete arv
    COUNT(birth_year) AS sünniaasta_olemas, -- loen kokku read, kus sünniaasta on olemas
    COUNT(*) - COUNT(birth_year) AS sünniaasta_puudub -- lahutan kõikidest ridadest olemasolevate sünniaastate arvu, et saada puuduvate sünniaastate arv
FROM customers; -- valin tabeli customers

-- 2.3 - Ülesanne 2B
 -- Liis Koppel tahab näha kõiki kliente, aga tühjade nimede asemel peaks kuvama "Tundmatu klient". Kirjuta päring, mis kasutab COALESCE funktsiooni.
SELECT customer_id, first_name, last_name, phone, city, -- valin veerud
 COALESCE(email, 'Puudub') AS email, -- asendan tühjad väljad tekstiga
 COALESCE(loyalty_tier, 'Puudub') AS lojaalsus_tase -- asendan tühjad väljad tekstiga
 FROM customers -- valin tabeli customers
 WHERE email IS NULL or loyalty_tier is NULL -- filtreeri ainult need kliendid, kellel vähemalt üks väli on NULL
ORDER BY customer_id DESC; -- järjestan customer_id alusel

-- 2.3 - Ülesanne 2C
-- Kontrolli, kas NULL-id mõjutavad sales tabeli arvutusi. Võrdle tulemusi.
-- Võrdlus: SUM kõigist vs SUM mitte-NULL väärtustest
-- arvutan kõigi müükide kogusumma (SUM jätab NULL väärtused automaatselt arvestusest välja):
SELECT SUM(total_price) AS kogu_summa, 
SUM(unit_price*quantity) AS kogu_summa_kontroll
     FROM sales; 


-- 3.3 - Ülesanne 3A
-- Vaata, kuidas kuupäeva formaadid töötavad.
-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

-- Nüüd vaata linnade kirjaviise
-- Linnade ühtlustamise diagnostika
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    INITCAP(trim(city))
FROM customers
ORDER BY customer_id DESC;

-- Materjalide järgi lahendus
SELECT
    city AS originaal,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY puhastatud;

-- 3.3 - Ülesanne 3B
-- Kirjuta päring, mis näitab customers tabeli linnade "puhastatud" versiooni koos statistikaga. Grupeeri puhastatud linnade kaupa.
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn,
    COUNT(*) AS kliente,
    COUNT(DISTINCT city) AS linna_kirjapilte
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

-- 3.3 - Ülesanne 3C
-- Kontrolli, kas products tabelis on kõik hinnad õiges formaadis. Kasuta CAST ja vaata, kas tekib vigu.
-- Kontrolli hinnaveeru tüüpi ja väärtusi
SELECT product_id, product_name,
CAST(cost_price AS NUMERIC) AS ostuhind,
CAST(retail_price AS NUMERIC) AS jaehind
FROM products;

-- Materjalide järgi lahendus (ei kasuta CAST'i nagu oli ette nähtud)
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0 THEN 'NULL (0 = puudub?)'
        WHEN retail_price < 0 THEN 'NEGATIIVNE!'
        ELSE 'OK'
    END AS hinna_staatus
FROM products
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;



-- Süntees: Toomase Puhastamisraport
-- Ülesanne: Kirjuta kolm päringut, mis koos moodustavad tervikliku puhastamisraporti.
-- Duplikaatide ülevaade kõigis tabelites
-- Customers tabel
-- Palju on duplikaatseid linnanimesid eri vormides, mis tuleks ühtlustada? Alles peaks jääma 12
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn,
    COUNT(DISTINCT city) AS linna_kirjapilte
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY puhastatud_linn;

-- Kas on duplikaatseid kliente? Jah on 147 duplikaatset klienti
SELECT
    INITCAP(TRIM(first_name)) AS eesnimi,
    INITCAP(TRIM(last_name)) AS perekonnanimi,
    TRIM(phone) AS telefon,
    LOWER(TRIM(email)) AS email,
    COUNT(*) AS koopiate_arv
FROM customers
GROUP BY
    INITCAP(TRIM(first_name)),
    INITCAP(TRIM(last_name)),
    TRIM(phone),
    LOWER(TRIM(email))
HAVING COUNT(*) > 1
ORDER BY eesnimi;

-- products tabel
-- Kas on duplikaatseid tooteid? Jah, 12
SELECT
    product_name, -- valin toote nime veeru
    COUNT(*) AS koopiate_arv -- loen kokku kõik read ja nimetan selle veeru ümber
FROM products -- valin tabeli products
GROUP BY product_name -- grupeerin toote nime alusel tabelisse
HAVING COUNT(*) > 1 -- loen vaid read, mida on rohkem kui 1 kord tabelis esindatud
ORDER BY koopiate_arv DESC; -- järjestan koopiate arvu järgi kahanevas järjekorras

-- sales tabel
-- Kas on duplikaatseid müüke? Jah, 5116
SELECT
COUNT(sale_id) - COUNT(distinct sale_id) AS duplikaatseid_müüke
FROM sales;


-- Kirjuta päring, mis näitab iga tabeli kohta, mitu NULL väärtust on olulistes veergudes
-- customers tabel
-- Leian mitu NULLi on eri veergudes. 380 emaili puudu, 1260 lojaalsus taset puudu
SELECT
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub,
    COUNT(*) - COUNT(last_name) AS perekonnanimi_puudub,
    COUNT(*) - COUNT(email) AS email_puudub,
    COUNT(*) - COUNT(phone) AS telefon_puudub,
    COUNT(*) - COUNT(city) AS linn_puudub,
    COUNT(*) - COUNT(loyalty_tier) AS lojaalsustase_puudub,
    COUNT(*) - COUNT(birth_year) AS sunniaasta_puudub
FROM customers;

-- products tabel
-- Leian mitu NULLi on eri veergudes. 18 veerul eco sertifikaat puudu
SELECT
    COUNT(*) - COUNT(product_name) AS product_name_puudub,
    COUNT(*) - COUNT(category) AS category_puudub,
    COUNT(*) - COUNT(subcategory) AS subcategory_puudub,
    COUNT(*) - COUNT(supplier) AS supplier_puudub,
    COUNT(*) - COUNT(cost_price) AS cost_price_puudub,
    COUNT(*) - COUNT(retail_price) AS retail_price_puudub,
    COUNT(*) - COUNT(eco_certified) AS eco_certified_puudub
FROM products; 

-- sales tabel
-- Leian mitu NULLi on eri veergudes. 1487 kliendi konto nr puudu
SELECT
    COUNT(*) - COUNT(sale_id) AS sale_id_puudub,
    COUNT(*) - COUNT(invoice_id) AS invoice_id_puudub,
    COUNT(*) - COUNT(customer_id) AS customer_id_puudub,
    COUNT(*) - COUNT(product_id) AS product_id_puudub,
    COUNT(*) - COUNT(quantity) AS quantity_puudub,
    COUNT(*) - COUNT(unit_price) AS unit_price_puudub,
    COUNT(*) - COUNT(total_price) AS total_price_puudub,
    COUNT(*) - COUNT(channel) AS channel_puudub,
    COUNT(*) - COUNT(store_location) AS store_location_puudub,
    COUNT(*) - COUNT(payment_method) AS payment_method_puudub
FROM sales;


-- Kirjuta päring, mis näitab kõiki unikaalseid linnade kirjaviise koos puhastatud versioonidega.
SELECT
    distinct city AS originaal,
    INITCAP(TRIM(city)) AS puhastatud_linn
FROM customers
ORDER BY puhastatud_linn;



-- Kirjuta SQL päring, mis näitab iga linna kohta: klientide arvu, puuduvate e-mailide arvu ja protsentuaalselt, kui suur osa klientidest on puuduva e-mailiga. Kasuta customers tabelit ja grupeeri puhastatud linnanime järgi.
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn,
    COUNT(*) AS kliente,
    COUNT(*)-COUNT(email) AS emaile_puudu,
    ROUND(100.0 * (COUNT(*) - COUNT(email)) / COUNT(*), 1) AS puuduv_protsent
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY puhastatud_linn;
