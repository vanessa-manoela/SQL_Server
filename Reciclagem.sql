
--média
SELECT   (avg (valor_cobrado)) FROM tbl_importacao_recovery_acordo_cabecera_novo

--arrendondamento de média
SELECT  round (avg (valor_cobrado),3) FROM tbl_importacao_recovery_acordo_cabecera_novo

--retorno de mais dados usando média
select top 10 * from tbl_importacao_recovery_acordo_cabecera_novo
where valor_cobrado > (SELECT   (avg (valor_cobrado)) FROM tbl_importacao_recovery_acordo_cabecera_novo)

order by data_alta


select top 10 * from tbl_devedor

