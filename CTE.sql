;WITH CTE_EXTRATO AS (
					SELECT	ID_SEND
					FROM	banco_2.DBO.SF_DISPAROS
				  	WHERE 1=1
					and format(sent_time,'yyyyMM') = '202003'),
							cte_vendas as 
									(SELECT	a.numdbm,
									datediff(day,c.dat_cadastro,a.data_venda) as MES_DIFERENCA,
									count(num_ticket) as qtd_vendas,
									sum(valor_pago) as valor_pago
							
							FROM	banco.dbo.tbl_venda_abertura_email		a
									INNER JOIN CTE_EXTRATO B ON B.ID_SEND = A.ID_SEND
									inner join CalvinKlein_YC..DBM_YC c on a.numdbm = c.numdbm
									group by a.numdbm,dat_cadastro,data_venda),
									cte_meses as (
									SELECT	A.MES_DIFERENCA
									,sum(qtd_vendas) AS QTDADE
									,SUM(A.VALOR_PAGO) AS VALOR
									,CASE WHEN A.MES_DIFERENCA = 0 THEN 'PRIMEIRA COMPRA' ELSE
										CASE WHEN A.MES_DIFERENCA <= 30 THEN '< 1 MÊS' ELSE
											CASE WHEN A.MES_DIFERENCA BETWEEN 31 AND 59 THEN '1 - 2 MESES' ELSE
												CASE WHEN A.MES_DIFERENCA BETWEEN 60 AND 180 THEN '3 - 6 MESES' ELSE
													CASE WHEN A.MES_DIFERENCA BETWEEN 181 AND 365 THEN '6 - 12 MESES' ELSE
														CASE WHEN A.MES_DIFERENCA BETWEEN 366 AND 720 THEN '1 - 2 ANOS' ELSE '> 2 ANOS' END END END END END END AS MES_AGRUPADO
									,CASE WHEN A.MES_DIFERENCA = 0 THEN '1' ELSE
										CASE WHEN A.MES_DIFERENCA  <= 30 THEN '2' ELSE
											CASE WHEN A.MES_DIFERENCA BETWEEN 31 AND 59  THEN '3' ELSE
												CASE WHEN A.MES_DIFERENCA BETWEEN 60 AND 180  THEN '4' ELSE
													CASE WHEN A.MES_DIFERENCA BETWEEN 181 AND 365 THEN '5' ELSE
														CASE WHEN A.MES_DIFERENCA BETWEEN 366 AND 720 THEN '6' ELSE '7' END END END END END END AS ORD
										FROM	cte_vendas a
										GROUP BY A.MES_DIFERENCA)

							select mes_agrupado,
									 sum(qtdade) as qtdade,
									 sum(valor) as valor,
									 avg(cast(ord as int)) as ord 
							into #final 
							from cte_meses
							group by mes_agrupado
							order by avg(cast(ord as int))
							
						