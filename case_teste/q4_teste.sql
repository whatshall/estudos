-- i) o volume de chamados por semana dos últimos três meses para cada cluster de clientes proposto na questão 3. 
WITH cases AS (
	SELECT DISTINCT 
		   DATE_TRUNC('week', CAST(date_ref AS DATE)) AS dt_chamado, 
		   assunto,
		   COUNT(accountid) AS qtd
	FROM dbadmin.tb_cases
	GROUP BY 1, 2
	ORDER BY 1 DESC)
-------------------------
SELECT dt_chamado, assunto, SUM(qtd)
FROM cases AS ca
WHERE TRUE
AND dt_chamado >= '2020-08-01'
GROUP BY dt_chamado, assunto
ORDER BY dt_chamado DESC
-------------------------
-- ii) uma série histórica dia a dia, que para cada dia retorne o número de chamados referentes aos últimos 30 dias
WITH cases AS (
	SELECT DISTINCT 
		   DATE_TRUNC('day', CAST(date_ref AS TIMESTAMP)) AS dt_chamado, 
		   COUNT(accountid) AS qtd
	FROM dbadmin.tb_cases
	GROUP BY 1
	ORDER BY 1 DESC)
-------------------------
SELECT dt_chamado, SUM(qtd), 
	   SUM(qtd) over (ORDER BY dt_chamado asc rows between unbounded preceding and current row)
	   --LAG(dt_chamado, 30) OVER (
		--	ORDER BY SUM(qtd)
		--	) soma30dias_previous--soma dos ultimos 30 dias
FROM cases AS ca
WHERE TRUE
AND dt_chamado--aqui seria CURRENTDATE
	>= '2020-10-01'
GROUP BY dt_chamado, qtd
ORDER BY dt_chamado DESC