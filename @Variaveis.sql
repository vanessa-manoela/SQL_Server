
-- variaveis =========================================

declare @nome varchar(10), @idade int, @DataNascimento date, @Custo float

set @nome = 'João'
set @idade = 10
set @DataNascimento = '10/01/2007'
set @Custo = 10.23


select @nome Nome, @idade Idade, @DataNascimento Dt_Nascimento, @Custo Custo

/*

Crie uma variável chamada NUMNOTAS e atribua a ela o número de notas fiscais do dia 01/01/2017. 
Mostre na saída do script o valor da variável.

*/

declare @numNotas int, @data date

set @data = '02/01/2017'
 
select @numNotas = count(*) from calvinklein.fct.transacao
where data_venda = @data

select @numNotas

-- controle de fluxo ============================================================

if OBJECT_ID ('tabela_teste', 'u') is not null drop table #tabela_teste


if OBJECT_ID ('tabela_teste', 'u') is not null
begin
drop table #tabela_teste
end
create table #tabela_teste (id int)


-- controle de fluxo em variaveis ================================================

select datename (weekday,  getdate())
select datename (weekday, dateadd(day, 5, getdate()))


declare @dia_semana varchar(20)
declare @numero_dias int
set @numero_dias = 6
set @dia_semana = datename(weekday, dateadd(day, @numero_dias, getdate()))
print @dia_semana
if @dia_semana = 'Saturday' or @dia_semana = 'Sunday'
	print 'Este dia é fim de semana'
else
	print 'Este dia é dia de semana'



-- contando qtd de notas baseado em uma data e informado a qtd =========================

declare @dt date, @qtdNotas int
set @dt = '2021-10-10'


select @qtdNotas = count(num_ticket) from CalvinKlein.fct.transacao
where data_venda = @dt
if @qtdNotas > 1000
	print 'Muitas notas'
else
	print 'Poucas notas'
	print @qtdNotas



--=======================================================

declare @dt date, @qtdNotas int, @numNotas int
set @dt = '2021-10-01'
set @numNotas = 1000

select @qtdNotas = count(num_ticket) from CalvinKlein.fct.transacao where data_venda = @dt
if (select count(num_ticket) from CalvinKlein.fct.transacao where data_venda = @dt) >= @numNotas
begin
	print 'Muitas notas'
	print @qtdNotas
end
else
begin
	print 'Poucas notas'
	print @qtdNotas
end