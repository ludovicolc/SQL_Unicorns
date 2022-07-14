-- Dataset completo
SELECT * from UnicornsinJune2022

---------------------------------------------------------------------------------------------------------------------------------------
-- Data Cleaning


-- Colonna valuation_b_dollars rimozione simbolo $
UPDATE UnicornsinJune2022
set valuation_b_dollars = REPLACE(valuation_b_dollars, '$', '')


-- Colonna date_joined sostituzione / con ' '
UPDATE UnicornsinJune2022
set date_joined = REPLACE(date_joined, '/', ' ')

-- Estrazione anni
UPDATE UnicornsinJune2022
set date_joined = substr(date_joined, -4, 4)


-- Cambiare in minuscolo le colonne: country, city, industry, investors  
UPDATE UnicornsinJune2022
set country = lower(country)

UPDATE UnicornsinJune2022
set city  = lower(city )

UPDATE UnicornsinJune2022
set industry = lower(industry)

UPDATE UnicornsinJune2022
set investors = lower(investors)


-- Rinominare colonna city (è presente uno spazio al suo interno)
ALTER table UnicornsinJune2022
RENAME city  to city


---------------------------------------------------------------------------------------------------------------------------------------
-- Esplorazione dati


-- Numero totale unicorni
SELECT count(company) from UnicornsinJune2022


-- Valutazione più alta
SELECT company, max(valuation_b_dollars)
from UnicornsinJune2022

-- Valutazione più bassa
SELECT company, MIN(valuation_b_dollars)
from UnicornsinJune2022

-- Valore totale unicorns
SELECT round(SUM(valuation_b_dollars)) as valutazione_totale
from UnicornsinJune2022

-- Valore medio
SELECT round(avg(valuation_b_dollars), 2) as valutazione_media
from UnicornsinJune2022

-- Valore mediano
with cte_mediana as 
(SELECT valuation_b_dollars
from UnicornsinJune2022
ORDER by valuation_b_dollars DESC
limit (SELECT count(valuation_b_dollars) / 2 from UnicornsinJune2022))

SELECT MIN(valuation_b_dollars) as mediana
from cte_mediana


-- Unicorn più vecchia
SELECT company, MIN(date_joined)
from UnicornsinJune2022

-- Unicorn più giovane
SELECT company, max(date_joined)
from UnicornsinJune2022


-- View numero di unicorns per anno
create VIEW unicorns_annui AS
SELECT date_joined, count(date_joined) as unicorns_per_anno
from UnicornsinJune2022
group by date_joined

-- Massimo nuovi unicorni in 1 anno
SELECT date_joined, max(unicorns_per_anno)
from unicorns_annui

-- Minimo nuovi unicorni in 1 anno
SELECT date_joined, MIN(unicorns_per_anno)
from unicorns_annui

-- Media nuovi unicorn per anno
SELECT avg(unicorns_per_anno)
from unicorns_annui


-- View numero di unicorns per paese
create VIEW unicorns_paese AS
SELECT country, count(date_joined) as unicorns_per_paese
from UnicornsinJune2022
group by country

-- Distribuzione unicorns
SELECT country, round(cast(unicorns_per_paese as float)/1170, 3) as distribuzione_percentuale
from unicorns_paese
order by distribuzione_percentuale DESC

-- Paese con più unicorni
SELECT country, max(unicorns_per_paese)
from unicorns_paese

-- Paese con meno unicorni
SELECT country, MIN(unicorns_per_paese)
from unicorns_paese


-- View industria e valutazione
create VIEW industria AS
SELECT industry, count(industry) as unicorns_per_industria, round(sum(valuation_b_dollars), 2) as valutazione_tot_industria
from UnicornsinJune2022
group by industry

-- Industria con più unicorns
SELECT industry, max(unicorns_per_industria), valutazione_tot_industria
from industria

-- Industria con meno unicorns
SELECT industry, MIN(unicorns_per_industria), valutazione_tot_industria
from industria

-- Valutazione media per industria
SELECT industry, round(avg(valuation_b_dollars), 2) as valutazione_media_industria
from UnicornsinJune2022
group by industry
order by valutazione_media_industria DESC


---------------------------------------------------------------------------------------------------------------------------------------
-- Investimenti effettuati da: sequoia capital, softbank, tiger global management


-- Sequoia
with cte_sequoia as
(SELECT * from UnicornsinJune2022
where investors like '%sequoia%')

SELECT count(company) as numero_investimenti, round(sum(valuation_b_dollars)) as valore_totale,
round(sum(valuation_b_dollars)/count(company)) as valore_medio
from cte_sequoia

-- Industria preferita
SELECT y.industry, max(y.conteggio)
FROM (SELECT COUNT(industry) AS conteggio, industry
      FROM UnicornsinJune2022
      group by industry
      having investors like '%sequoia%') as y


-- Softbank
with cte_softbank as
(SELECT * from UnicornsinJune2022
where investors like '%softbank%')

SELECT count(company) as numero_investimenti, round(sum(valuation_b_dollars)) as valore_totale,
round(sum(valuation_b_dollars)/count(company)) as valore_medio
from cte_softbank

-- Industria preferita
SELECT y.industry, max(y.conteggio)
FROM (SELECT COUNT(industry) AS conteggio, industry
      FROM UnicornsinJune2022
      group by industry
      having investors like '%softbank%') as y


-- Tiger global
with cte_tiger_global as
(SELECT * from UnicornsinJune2022
where investors like '%tiger global%')

SELECT count(company) as numero_investimenti, round(sum(valuation_b_dollars)) as valore_totale,
round(sum(valuation_b_dollars)/count(company)) as valore_medio
from cte_tiger_global

-- Industria preferita
SELECT y.industry, max(y.conteggio)
FROM (SELECT COUNT(industry) AS conteggio, industry
      FROM UnicornsinJune2022
      group by industry
      having investors like '%tiger global%') as y