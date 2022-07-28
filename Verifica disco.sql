

--depois q apagar..tenta rodar o shrink
	DBCC SHRINKDATABASE ('nome_banco', 5)


--tabelas que podem ser apagadas no yc  "yc_tp_"

	select	s.name + '.' + o.name nome_tabela
			,create_date
    from	sys.schemas s
	join	sysobjects o on o.uid = s.schema_id
	join	sys.objects  x on  x.name  = o.name and  x.type ='U'
    
	where	o.type = 'u'  and   
			o.name like '%yc_tp_%'

	order by x.create_date