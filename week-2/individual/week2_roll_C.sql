- Ülesanne 1
-- Loo test tabeli
DROP TABLE IF EXISTS products_test; -- kustutan tabeli kui on juba olemas sessioonist 1
CREATE TABLE products_test AS SELECT * FROM products; -- tee uus tabel, mis on koopia originaalist

SELECT COUNT(*) AS ridade_arv FROM products; -- loe kokku ridade arv originaal tabelis - 362
SELECT COUNT(*) AS ridade_arv FROM products_test; -- loe kokku ridade arv uues tabelis - 362

-- Ülesanne 2
--Leia duplikaadid — kas on korduvaid tootenimesid? Jah, 12
SELECT
    product_name, -- valin toote nime veeru
    COUNT(*) AS koopiate_arv -- loen kokku kõik read ja nimetan selle veeru ümber
FROM products_test -- valin tabeli products_test
GROUP BY product_name -- grupeerin toote nime alusel tabelisse
HAVING COUNT(*) > 1 -- loen vaid read, mida on rohkem kui 1 kord tabelis esindatud
ORDER BY koopiate_arv DESC; -- järjestan koopiate arvu järgi kahanevas järjekorras

-- Ülesanne 3
-- Leia NULL väärtused kriitilistes väljades
SELECT * -- valin kõik veerud
FROM products_test -- valin tabeli sales
WHERE 
product_id is NULL or  -- leian tellimuse kus puudub tootekood
product_name is NULL or  -- leian tellimuse kus puudub toote nimi
category is NULL or  -- leian tellimuse kus puudub toote kategooria
subcategory is NULL or  -- leian tellimuse kus puudub alamkategooria
cost_price is NULL or  -- leian tellimuse kus puudub ostu hind
retail_price is NULL  -- leian tellimuse kus puudub jaehind
ORDER BY product_id DESC;

-- Ülesanne 4
-- Kontrolli loogilisi vigu — kas on ebareaalseid hindu? 10 hinda, kus jahind suurem kui ostu hind
SELECT * -- valin kõik veerud
FROM products_test -- valin tabeli products_test
WHERE cost_price > retail_price -- leian read, kus jaehind on väiksem ostu hinnast
or cost_price <=0 -- leian read, kus hind väiksem või võrdne 0-ga
or retail_price <=0 -- leian read, kus hind väiksem või võrdne 0-ga
or cost_price is NULL -- leian read, kus hind puudub
or retail_price is NULL -- leian read, kus hind puudub
ORDER BY product_id DESC; -- järjestan koopiate arvu järgi kahanevas järjekorras

-- Ülesanne 5
-- Kontrolli kategooriate järjekindlust. Kategooriad ei tundu korduvat
SELECT category, COUNT(*) AS arv -- valin veeru category ja loen read ning nimetan ümber veeruks arv
FROM products_test -- valin tabeli products_test
GROUP BY category -- grupeerin category nime alusel
ORDER BY category; -- reastan kategooria nime tähestikulises järjekorras

-- Ülesanne edasijõudnutele
-- Ühtlusta kategooriate nimed
-- Kontrollin kas vajavad ühtlustamist: (ei vaja)
SELECT COUNT(distinct category) AS puhastamata, -- loen kokku puhastamata unikaalsed kategooriad
       COUNT(distinct LOWER(TRIM(category))) AS puhastatud -- loen kokku puhastatud unikaalsed kategooriad
FROM products_test; -- valin tabeli products_test

-- Puhastan igaksjuhuks sellegipoolest
UPDATE products_test -- uuenda tabelit products_test
SET category = INITCAP(TRIM(category)) -- seadista kategooria nimi selliselt ...
WHERE category != INITCAP(TRIM(category)); -- ... kui juba ei ole selliselt seadistatud

-- Tulemuste kontroll
SELECT
    category, -- valin kategooria
    COUNT(*) AS arv -- loen kokku, mitu toodet igas kategoorias on
FROM products_test -- valin tabeli products_test
GROUP BY category -- grupeerin tooted kategooriate järgi
ORDER BY arv DESC; -- järjestan kategooriad toodete arvu järgi kahanevalt (suurim enne)
