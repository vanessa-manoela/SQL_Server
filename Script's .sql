--proc de importação geral recovery

proc_importacao_recovery_novo_webservice_robo


--Principais tbl's da recovery, consulta simples

SELECT top 3 * FROM dbo.tbl_devedor
SELECT top 3 * FROM dbo.tbl_contrato
SELECT top 3 * FROM dbo.tbl_contrato_complementar
SELECT top 3* FROM tbl_acordo
SELECT top 3* FROM dbo.tbl_importacao_recovery_retiradas
select top 3* from [dbo].[tbl_telefone]
SELECT top 3* FROM dbo.tbl_tipo_ocorrencia



-- Verifica status do lote ou log, consulta simples com filtro e data


SELECT * FROM dbo.tbl_robo_log_lote_carteira
WHERE id_lote = 3639388 


SELECT * FROM dbo.tbl_robo_lote_carteira
WHERE data_criacao >= '2021-04-19'



			
-- Verifica lote (alias, filtro com condição e função data, seleção de conjuto e condição negada)
SELECT  *
      FROM      SPO.RECOVERY.dbo.tbl_robo_lote_carteira a
      WHERE  id_campanha   = 288
	  and  year (data_criacao) >= '2021'
	  and cod_carteira  in (80,70)
	  and cod_status not in ('FIM_ANORMAL','FIM_ERRO','FIM_VAZIO','FIM_SOLICITADO')
	  
	 


-- Verifica log (filtro com faixa de busca, condição com string, busca por nome)
SELECT  *
      FROM      SPO.RECOVERY.dbo.tbl_robo_log_lote_carteira a 
      WHERE  data_log between '2021-04-19 01:00' and '2021-04-19 05:00'
	  and cod_tarefa > 'GERAR_ARQUIVO'
	  and cod_tarefa like '%acuerdos%'
	 

-- consulta com distinct/ verificando combinações

SELECT distinct carteira --, *
FROM dbo.tbl_atualizacao_divida
WHERE inicio_vigencia >= '2021-01-01'


-- Atualiza a tabela  BI fisico

EXEC dbo.proc_atualiza_bi_fisico_padrao


SELECT COUNT(0) FROM dbo.tbl_bi_fisico_lote 



--usado em procs para mostrar o andamento com uma mensagem de texto definida
select 'bloco x atualizado' 

--mostra mensagem de atualização do bloco apenas quando a proc termina. 
print 'processamento concluido'



--tabelas que rodam as cargas diarias terminam com o web_robo

select * from tbl_importacao_recovery_lista_segmento_web_robo


--tabelas que guardam as cargas diarias terminam temp_robo

select * from tbl_importacao_recovery_contatos_temp_robo -- receptivo

select * from tbl_importacao_recovery_contatos_novo_temp_robo -- ativo

-- procura as procs que executam uma detrminada tabela
SELECT DISTINCT name FROM sys.sysobjects 
INNER JOIN sys.syscomments ON syscomments.id = sysobjects.id
WHERE text LIKE '%tbl_acordo_online%'


SELECT name
FROM sys.procedures
WHERE OBJECT_DEFINITION(object_id) LIKE '%tbl_recovery_controle_retorno_batimento%'




SELECT * FROM dbo.tbl_acordo
WHERE ativo = 1
AND id_acordo = '272370'
AND id_acordo NOT IN (SELECT id_acordo 
FROM recovery.dbo.tbl_parcela WHERE id_acordo IS NOT NULL)



--Encontra tabelas ou procedures relacionadas

SELECT T.name AS Tabela , *
FROM sys.sysobjects AS T (NOLOCK)
WHERE t.NAME LIKE '%importacao_recovery_geral%'
AND T.XTYPE = 'P' --Type u tabelas, type = p procedures 




sp_who2 -- mostar todos os processos que estão rodando no nomomento

sp_depends tbl_ --mostra os dependentes daquela tabela

sp_helptext 'proc_' -- abre o script da proc


-- conta e agrupa uma coluna
SELECT  COUNT(Relacion) AS qtd,Relacion 
FROM dbo.tbl_importacao_recovery_contatos_temp_robo
WHERE id_lote = 5388440
--AND Relacion <> 'titular'

GROUP BY Relacion




--quando a PROC da erro num INSERT into
--crie uma tabela temporaria com o mesmo nome e teste o INSERT nela, ao final DROP ela do banco.
--clicando em cima do nome da tabela depois em ctrl + espaço é possivel pegar o script do create, copie o insert da proc e altere a tabela original pela temp
CREATE TABLE [dbo].[tbl_blacklist_telefone_T]
(
[IdContacto] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[IdTelefono] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[BlackList] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[id_devedor] [int] NULL,
[data_inclusao] [datetime] NULL  ,
[telefone] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ddd] [varchar] (2) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
 INSERT INTO dbo.[tbl_blacklist_telefone_T]
(
    IdContacto,
    IdTelefono,
    BlackList,
    telefone,
    ddd
)
SELECT IdContacto,
       IdTelefono,
       BlackList,
       Telefono,
       SUBSTRING(
                    dbo.ajustaNumeros(REPLACE(
                                                 REPLACE(
                                                            REPLACE(REPLACE(CodArea, '356', '56'), '0064', '64'),
                                                            '0021',
                                                            '21'
                                                        ),
                                                 '241',
                                                 '41'
                                             )
                                     ),
                    1,
                    2
                )
FROM tbl_importacao_recovery_telefones_temp_robo a
WHERE LEN(a.Telefono) <= 9
      AND NOT EXISTS
(
    SELECT 1 FROM tbl_blacklist_telefone b WHERE a.IdTelefono = b.IdTelefono
)
      AND BlackList = '1';




-- executando proc com variavel de retorno de erro

DECLARE @OUTPUT INT  
 EXEC proc_importacao_recovery_webservice_robo @lote = 5483678, @erro_imp_web = @OUTPUT OUTPUT
 SELECT @OUTPUT

 
SELECT * FROM dbo.tbl_contrato AS A
WHERE A.carteira = 'BRADESCO NPL2'
AND A.ativo = 1
AND A.id_contrato NOT IN (SELECT id_contrato FROM dbo.tbl_contrato_ciclo
WHERE carteira = 'BRADESCO NPL2')


--alteração com replace, isnull
DELETE FROM dbo.tbl_importacao_recovery_telefones_web_robo_blacklist
WHERE LEN(RTRIM(LTRIM(telefone))) > 9;

DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist
WHERE ISNULL(telefone, '0') = '0';

UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist
SET cod_area = REPLACE(cod_area, '-', '')
WHERE cod_area LIKE '%-%';

UPPER	/ CHARINDEX / SUBSTRING / CAST / CONVERT / 


 -- tabela que mostra o andamento da execução da proc de acordo com a mensagem configurada 
 --Ajusta os campos da tabela 
 -- precisa  deletar os dados anterior no inico --DELETE FROM tbl_processo_importacao_atual                                      
 --fica na proc_importacao_recovery_batimento_novo
 INSERT INTO tbl_processo_importacao_atual( id_campanha,id_lote,descricao,data )                                      
 VALUES( 288,                                      
            @id_lote_log,                                      
            'AJUSTA OS CAMPOS DA TABELA',                                                                           
            CONVERT(DATETIME, GETDATE(), 121) ) 

--inserindo declaração de variavel
DECLARE @id_lote_log INT                                      
 SELECT @id_lote_log = ( SELECT DISTINCT ID_LOTE FROM dbo.tbl_importacao_recovery_operacoes_novo )


 --date fora do range
select * from tbl_importacao_recovery_contatos_buk_temp_novo a
where right(data_nascimento,4) > '2021'
			