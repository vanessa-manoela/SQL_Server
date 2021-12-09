
  --      SELECT  DISTINCT  
  --              nome_campanha ,  
  --            tipo_processo ,  
  --              --tipo_servico ,  
  --              id_processo ,  
  --  COUNT(DISTINCT LOTE.id_lote) AS 'QTD.'  
  --      FROM    tbl_robo_lote_carteira LOTE WITH ( NOLOCK )  
  --              INNER JOIN tbl_robo_log_lote_carteira LOG WITH ( NOLOCK )  
  --              ON LOTE.id_lote = LOG.id_lote  
  --              INNER JOIN acionamento_cobranca.dbo.tbl_campanha tbl_campanha WITH ( NOLOCK )  
  --              ON tbl_campanha.id_campanha = LOTE.id_campanha  
  --      WHERE   LOTE.cod_status = 'FIM_OK_SQL_OK'  
  --              AND data_criacao >= CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)  
  --      GROUP BY nome_campanha ,  
  --              tipo_processo ,  
  --              --tipo_servico ,  
  --              id_processo   
  --ORDER BY nome_campanha ASC  



select  Q1.id_campanha, Q1.id_processo, Q1.QTD
from (select 
id_campanha,
id_processo,
count ( DISTINCT id_lote) as QTD
from tbl_robo_lote_carteira
where cod_status = 'FIM_OK_SQL_OK'
and data_criacao >= CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)
group by id_campanha, id_processo) Q1


select 
count ( DISTINCT id_lote) as QTD
from tbl_robo_lote_carteira
where cod_status in ('VAI_EXECUTAR_WS','FIM_OK','FIM_OK_EXECUTAR_SQL','FIM_OK_SQL_OK','FIM_OK_SQL_ERRO')
and data_criacao >= CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103)
group by id_campanha, id_processo