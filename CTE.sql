
--## busca telefones repetidos e separa em uma tbl


select telefono, count(*) Qtd 
from tbl_importacao_recovery_telefones_novo_temp_robo
where id_lote = 11028998

group by telefono
having count(*) > 1

order BY telefono







;with cte_duplicados as (

select  telefono, 
count(*) Qtd,
max (IdTelefono) id_max
--min(IdTelefono) id_min,
from tbl_importacao_recovery_telefones_novo_temp_robo
where id_lote = 11375458

group by telefono
having count(*) > 1

) 

--select a.telefono, IdTelefono,* 
delete a
from tbl_importacao_recovery_telefones_novo_temp_robo a
join cte_duplicados on a.IdTelefono = cte_duplicados.id_max
where id_lote = 11375458








