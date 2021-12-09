--There is insufficient result space to convert a money value to int.

select  len(salario_bruto) tamanho_SL,*  FROM dbo.tbl_importacao_recovery_contatos_temp_robo a              
WHERE a.id_lote = 11497756
and len(salario_bruto) >= 10

order by salario_bruto




select * FROM dbo.tbl_importacao_recovery_contatos_temp_robo a              
WHERE a.id_lote = 11497756
and id_contacto = 31697827



