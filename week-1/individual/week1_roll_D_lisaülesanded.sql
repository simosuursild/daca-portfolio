-- Lisaülesanne 1
-- Loe tehingud kokku iga kaupluse asukoha kohta.
SELECT COUNT(DISTINCT sale_id) AS tehingute_arv , store_location AS pood -- loen kokku unikaalsed tehingud ja valin lisaks ka veeru store_location ning nimetan mõlemad veerud ümber
FROM sales -- valin tabeli sales
WHERE store_location IS NOT NULL -- eemaldan valikust puudu oleva poe asukohaga read
GROUP BY store_location -- grupeerin tabeli poodide asukohtade järgi
ORDER BY tehingute_arv DESC; -- reastan tehingute arvu järgi kahanevalt

-- Lisaülesanne 2
-- Võrdle online vs pood tehingute arvu:
SELECT COUNT(DISTINCT sale_id) AS tehingute_arv , channel AS kanal -- loen kokku unikaalsed tehingud ja valin lisaks ka veeru channel ning nimetan mõlemad veerud ümber
FROM sales -- valin tabeli sales
GROUP BY channel -- grupeerin tabeli ostu kanali järgi
ORDER BY tehingute_arv DESC; -- reastan tehingute arvu järgi kahanevalt

-- Lisaülesanne 3
-- Kombineeri tingimused: Leia sularahamaksed Tartus:
SELECT DISTINCT sale_id, store_location, payment_method, total_price -- valin unikaalsed tehingud ja valin lisaks ka veeru store_location, payment_method ja total_price ning nimetan need ümber
FROM sales -- valin tabeli sales
WHERE store_location = 'Tartu' AND payment_method = 'sularaha' -- valin vaid read, kus on täidetud tingimused: poe asukoht on Tartu ja makseviis on sularaha
ORDER BY total_price DESC; -- reastan kogu müügisumma järgi kahanevalt
