-- Ülesanne 2
-- Vaata kanalitega seotud veerge. Too välja esimesed 10 rida, keskendudes kanali, asukoha ja makseviisi veergudele:
-- Millised kanalid on olemas? Online ja Pood
-- Millised asukohad on olemas? Tallinn, Tartu ja Pärnu
-- Millised makseviisid on olemas? Kaart, sularaha ja järelmaks

SELECT channel AS kanal, store_location AS pood, payment_method AS makseviis -- valin veerud ja nimetan ümber sobivamaks
FROM sales -- valin tabeli sales
LIMIT 10; -- piiran välja toodud tulemusi 10ga

-- Ülesanne 3
-- Leia kõik müügikanalid. Milliseid müügikanaleid UrbanStyle kasutab?
-- Unikaalsed müügikanalid: Online ja pood
SELECT DISTINCT channel AS müügi_kanal -- valin tabelist veeru ning toon välja veeru unikaalsed sisendid
FROM sales; -- valin tabeli sales

-- Ülesanne 4
-- Leia kõik kaupluste asukohad. Kus UrbanStyle'i poed asuvad?
-- Unikaalsed kaupluste asukohad: Tallinn, Tartu ja Pärnu
--Mida tähendab NULL väärtus? Tühi väärtus kuna ost tehtud e-poes
SELECT DISTINCT store_location AS asukohad -- valin tabelist veeru ning toon välja veeru unikaalsed sisendid
FROM sales; -- valin tabeli sales

-- Ülesanne 5
-- Leia kõik makseviisid. Milliseid makseviise kliendid kasutavad?
-- Unikaalsed makseviisid: Järelmaks, kaart ja sularaha
SELECT DISTINCT payment_method AS makseviisid -- valin tabelist veeru ning toon välja veeru unikaalsed sisendid
FROM sales; -- valin tabeli sales

-- Ülesanne 6
-- Filtreeri online-müügid. Leia tehingud, mis on tehtud veebipoe (online) kaudu: 3462 müüki
SELECT DISTINCT sale_id, channel, store_location FROM sales -- valin kõik veerud tabelis sales, kus sale_id on unikaalne
WHERE channel = 'online'; -- filtreerin vaid müügid mis on toimunud veebipoes

-- Ülesanne 7
-- Leia tehingud ilma asukoha infota. Mitu tehingut on, kus kaupluse asukoht on puudu (NULL)? 3462
SELECT COUNT(DISTINCT sale_id) FROM sales -- loen kokku kõik veerud tabelis sales
WHERE store_location IS NULL; -- filtreerin vaid müügid millel puuduvad ostu füüsilised asukohad

-- Lisa ülesanne
-- Palju müüke protsentuaalselt toimub veebipoes? 3462 / 10118 * 100% = 34.2%
SELECT COUNT(DISTINCT sale_id) FROM sales;
SELECT COUNT(DISTINCT sale_id) FROM sales WHERE channel = 'online';


/* Kokkuvõte
Millised kanalid on olemas? Online ja pood
Millised asukohad? Tallinn, Tartu ja Pärnu
Millised makseviisid? Järelmaks, kaart ja sularaha
Mitu tehingut on ilma asukohata? 3462
kui suur osa müügist toimub veebis vs poodides? 34.2%
Mis oli üllatav? Et tabel oli suhteliselt korrapärane 
*/
