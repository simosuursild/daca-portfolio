# Nädal 2: SQL Cleaning
## 1. Miks see projekt tehti?
Minu ülesanne see nädal oli uurida UrbanStyle tooteandmeid ning tuvastada probleemid nendes. Suurima leitud probleemid olid korduvad tootenimed, täitmata eco sertifikaatide väljad ja kahjumiga jaehinnad.

## 2. Minu tegevused ja panus
- Roll meeskonnas: roll C - tooteandmete puhastaja ja toote tabeli raporti koostaja
- Tööriistad: Supabase
- Kirjutasin järgnevad päringud / skriptid:
-   week-2/individual/week2_roll_C.sql
-   et analüüsida toote tabeli probleeme

## 3. Tulemused ja äriline mõju
- Tulemus 1: 12 korduvat tootenime; äriline mõju - andmesegadus
- Tulemus 2: 18 NULL väärtust eco sertifikaadi väljal; äriline mõju - puudu olev sertifikaat kui tegelikult on olemas või tähendada madalamat müügihinda ja seega saamata jäänud tulu
- Tulemus 3: 10 loogika viga, kus jaehind on väiksem ostuhind; äriline mõju - tooteid müüakse kahjumiga

## 4. AI kasutamine (ÕV5)
Kasutasin ChatGPT, et selgitada mõningate SQL päringute kasutamist ja 
NotebookLLM-i, et leida materjalidest vastust oma küsimustele programmi kohta kui ei tahtnud kõike materjale uuesti käistsi läbi lugeda

## 5. Kausta failid ja tiimi link
**Minu kirjutatud SQL-päringud:**
- [week-2/individual/week2_roll_C.sql](https://github.com/simosuursild/daca-portfolio/blob/main/week-2/individual/week2_roll_C.sql)

**Grupi ühise REPO link:** [urbanstyle-Marketing-Data](https://github.com/ylirem/urbanstyle-Marketing-Data)  
