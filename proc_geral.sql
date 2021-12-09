CREATE   PROC [dbo].[proc_importacao_recovery_novo_webservice_robo]                                                                                
    @lote INT,                                                                                
    @erro_imp_web INT OUTPUT                                                                                
AS                                                                                
BEGIN                                                                                
                                                                                
    BEGIN TRY                                                                                
                                                                                
        BEGIN -- [ INICIO - Dropa TMPs / Ajusta campos ]                                                                                                   
                                                                                
            IF OBJECT_ID('tempdb..#novos_contratos_ocorrencia') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #novos_contratos_ocorrencia;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#tmp_recovery_operacoes_itau_renova') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #tmp_recovery_operacoes_itau_renova;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#tmp_recovery_contatos_itau_renova ') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #tmp_recovery_contatos_itau_renova;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#tmp_recovery_operacoes') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #tmp_recovery_operacoes;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#novos_contratos_ocorrencia') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #novos_contratos_ocorrencia;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#novos_contratos_ciclo') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #novos_contratos_ciclo;                                                                                
            END;                                                                                
            IF OBJECT_ID('tempdb..#ultima_data') IS NOT NULL                                                        
            BEGIN             
                DROP TABLE #ultima_data;                                                         
            END;                                                                          
IF OBJECT_ID('tempdb..#retirar_processo_email') IS NOT NULL                                                                
            BEGIN                                                                      
                DROP TABLE #retirar_processo_email;                            
            END;                        
            IF OBJECT_ID('tempdb..#temp_processo_inativacao') IS NOT NULL                                                                          
            BEGIN                                                              
                DROP TABLE #temp_processo_inativacao;                                                                                
            END;                                                               
            IF OBJECT_ID('tempdb..#maior_tel_ava') IS NOT NULL                                                                                
            BEGIN                                                           
                DROP TABLE #maior_tel_ava;                                                     
            END;                                                                                
            IF OBJECT_ID('tempdb..#telefone_inativo') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #telefone_inativo;                                                                    
            END;                                                                                
            IF OBJECT_ID('tempdb..#ultima_data') IS NOT NULL                                                                                
            BEGIN                                                             
                DROP TABLE #ultima_data;                                                                                
            END;                                                                           
            IF OBJECT_ID('tempdb..#retirar_processo_email') IS NOT NULL                                                                
            BEGIN                                                                                
                DROP TABLE #retirar_processo_email;                                                                           
            END;                                                                                
            IF OBJECT_ID('tempdb..#temp_processo_inativacao') IS NOT NULL                                                                                
            BEGIN                                                                                
                DROP TABLE #temp_processo_inativacao;                                                                                
            END;                                                                                
                                                                                
                                    DECLARE @id_lote_log INT;                                                                                
                                                                                
                                                                                
            SELECT @id_lote_log = @lote;                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
             'IMPORTACAO',         
                                               'Carteira - 288 importacao_recovery_novo_webservice_robo',                                                
           'Iniciando a Execução da Carga',                                                                                
     'FALSE';                                                                                
                      
            -- ==========================                                                                                                  
            -- AJUSTA OS CAMPOS DA TABELA                                                                                                  
            -- ==========================                                                                                                  
            EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_contatos_novo_web_robo';                                                                                
            EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_emails_novo_web_robo';                                                                                
        EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_enderecos_novo_web_robo';                                                           
            EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_operacoes_novo_web_robo';                                                  
            EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_saldo_novo_web_robo';                                           
            EXEC dbo.proc_ajusta_campos 'tbl_importacao_recovery_telefones_novo_web_robo';                                                                                
                                                                        
            --===============================================================                                                                          
            -- Importar da carteira BV-Renova  os casos que é do tipo cartão                                              
            -- Pois estes casos  é para ser importado no massificado                                                                                                         
            --==============================================================                                                                                                  
                                                                   
            DECLARE @carteira VARCHAR(50);                                                                                
                                                                                
            SELECT TOP 1                                                                                
                @carteira = descricao_produto                                                                                
           FROM tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo                                                                    
    JOIN dbo.tbl_tipo_produto_cliente ON IdCartera_Compra  =  cod_carteira                                                                              
                                                         
                                                                     
        END; -- [ FIM ]                                                                                    
                                                                                
        BEGIN -- [ INICIO - if Itau Renova ]                                                                                            
                                                                                
            IF (@carteira = 'Itau Renova')                                                                                
            BEGIN                                                                          
                                         
                UPDATE dbo.tbl_importacao_recovery_operacoes_novo_web_robo              
                SET segmento = SUBSTRING(RPW.segmento, CHARINDEX('|', RPW.segmento, 0) + 1, 1000)                                                                            
               FROM tbl_importacao_recovery_operacoes_novo_web_robo RPW;                                     
                                                                             
                SELECT idoperacao_SIR                                                              
                INTO #tmp_recovery_operacoes_itau_renova                                                                                
                FROM dbo.tbl_importacao_recovery_operacoes_novo_web_robo                                                                                
                WHERE segmento IN ( 'Premium Leves', 'Padrão Leves', 'Saldos Menores', 'Padrão Pesados',                                                                                
      'Padrão Motos', 'PADRÃ£O LEVES', 'PADRÃ£O MOTOS', 'PADRÃ£O PESADOS'                                                                                
                    )                                                                                
                    --  AND carteira = 'Itau Renova';                                                                
                                                      
                                                                      
                                                                    
                                                                    
     SELECT id_contato                                                                                
                INTO #tmp_recovery_contatos_itau_renova                                                   
                FROM tbl_importacao_recovery_contatos_novo_web_robo a                                                                    
       JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdContacto = a.id_contato                                                                                
                WHERE b.IdOperacion_SIR IN (                                                                                
                                SELECT * FROM #tmp_recovery_operacoes_itau_renova                                                                                
                                          );                                                                                
                                                                   
                                                                                 
       DELETE FROM dbo.tbl_importacao_recovery_operacoes_novo_web_robo                                   
                WHERE segmento IN ( 'Premium Leves', 'Padrão Leves', 'Saldos Menores', 'Padrão Pesados',                                                                                
                                    'Padrão Motos', 'PADRÃ£O LEVES', 'PADRÃ£O MOTOS', 'PADRÃ£O PESADOS'                                                                                
                                  )                                                                                
                    --  AND carteira = 'Itau Renova';                                                                          
                                                                                
                                                                             
                                                                    
       DELETE a FROM tbl_importacao_recovery_contatos_novo_web_robo a                                                                    
     JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdContacto = a.id_contato                                  
                WHERE b.IdOperacion_SIR IN (                                                                                
       SELECT * FROM #tmp_recovery_operacoes_itau_renova                                                                                
                                          );                                                                                
                                                                                
                                                    
       DELETE a FROM tbl_importacao_recovery_saldo_novo_web_robo   a                                                                             
               JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdOperacion_SIR = a.id_operacion_SIR                                                                   
                WHERE b.IdOperacion_SIR IN (                                                                                
                                              SELECT * FROM #tmp_recovery_operacoes_itau_renova                                                                                
                                          );                                                                            
                                                                                
                DELETE a FROM tbl_importacao_recovery_emails_novo_web_robo a                                                                               
                JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdContacto = a.id_contato                              
                WHERE b.IdOperacion_SIR IN (                                                                                
                                        SELECT * FROM #tmp_recovery_contatos_itau_renova                              
                                    );                                                                     
                                                                    
                                                                    
                                                                           
                                                                           
                DELETE FROM tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
                WHERE id_contato IN (                                                   
                                        SELECT * FROM #tmp_recovery_contatos_itau_renova                                                                                
                                    );                                                                             
                                                                          
                DELETE FROM tbl_importacao_recovery_telefones_novo_web_robo                                                                                
              WHERE id_contato IN (                                                                                
                                        SELECT * FROM #tmp_recovery_contatos_itau_renova                                                                                
                                    );                                                                                
                                                                                
            END;                                                        
                                                                                
        END; -- [ FIM ]                                                                                                  
                                                                                
        BEGIN -- [ INICIO - if BV-Renova ]                                          
                                                                                
            IF (@carteira = 'BV-Renova')               
            BEGIN                                                                                
                                                                              
                SELECT idoperacao_SIR                                                
               INTO #tmp_recovery_operacoes                                                                                
               FROM dbo.tbl_importacao_recovery_operacoes_novo_web_robo                                            
                WHERE tipo_carteira <> 'CARTÃO'                                                                                
                                                                         
                                                                                
                SELECT id_contato                                                                    
                INTO #tmp_recovery_contatos                                                                  
                FROM tbl_importacao_recovery_contatos_novo_web_robo a                                                                        
     JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdContacto = a.id_contato                                                              
               WHERE b.IdOperacion_SIR IN (                                                                                
                             SELECT * FROM #tmp_recovery_operacoes                                                                                
 );                                                                                
                                                                                
                                                                    
                DELETE a FROM dbo.tbl_importacao_recovery_operacoes_novo_web_robo a                           
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdOperacion_SIR = a.idoperacao_SIR                                                                                
                WHERE tipo_carteira <> 'CARTÃO'                                                                                
                                                                                               
                                                     
              DELETE a FROM tbl_importacao_recovery_contatos_novo_web_robo a                                                                    
       JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON b.IdContacto = a.id_contato                                                                              
                WHERE  b.IdOperacion_SIR IN (                                                                                
                                              SELECT * FROM #tmp_recovery_operacoes                              
                                          );                                                                                
                                                                                
                DELETE  a FROM tbl_importacao_recovery_saldo_novo_web_robo a                                                                    
       JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON  b.IdOperacion_SIR = a.id_operacion_SIR                                                                                   
                WHERE b.IdOperacion_SIR IN (                                                                                
                                              SELECT * FROM #tmp_recovery_operacoes                                                                                
                        );                                         
                                                                                
                DELETE   FROM tbl_importacao_recovery_emails_novo_web_robo                                 
          WHERE id_contato IN (                                                                                
                                        SELECT * FROM #tmp_recovery_contatos       
                                    );                                                                                
                                                                                
                                                                       
                                                                    
              DELETE FROM tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
                WHERE id_contato IN (                                                                                
                                        SELECT * FROM #tmp_recovery_contatos                           
                                    );                                         
                                                                                
                DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
                WHERE id_contato IN (                                                                                
                SELECT * FROM #tmp_recovery_contatos                                         
                                    );                                                                                
                                                                                
            END;                                                                                
                        
        END; -- [ FIM ]                                                                                                  
                                                                                
        BEGIN -- [ INICIO - PADRONIZAÇÃO DE CPF_CNPJ ]                                                                                                  
                                                    
            -- FÍSICA                                                                                                     
            UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
            SET nro_doc = RIGHT('00000000000' + nro_doc, 11)                                         
   WHERE tipo_pessoa LIKE 'F%'                                                                                
                  AND ISNULL(nro_doc, '') <> ''; -- IS NOT NULL                                                                                                      
                                                                                
            -- JURÍDICA                           
       UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
            SET cuil_cuit = RIGHT('00000000000000' + cuil_cuit, 14)                                                                                
            WHERE tipo_pessoa LIKE 'J%'                                               
                  AND ISNULL(cuil_cuit, '') <> ''; -- IS NOT NULL                                                                                                        
                                                                                
        END; -- [ FIM ]                                                    
                                                                                
        BEGIN -- [ INICIO - AJUSTA O NÚMERO DE TELEFONE  ]                                       
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                  'IMPORTACAO',                                                                                
                                               'Carteira - 288',                               'AJUSTA O NÚMERO DE TELEFONE',                     
                                               'FALSE';                                                                                
                                                                                
            -----------------------------                                                                                                  
            --AJUSTA EMAIL--                                      
            -----------------------------                                                                       
            DELETE FROM tbl_importacao_recovery_emails_NOVO_web_robo                                                                                
            WHERE email LIKE 'TESTE@GRUPORECOVERY%';                                                                                
                                                          
            -----------------------------                                                                                          
            --AJUSTA TELEFONES                                                                                                  
            -----------------------------                                                             
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                            
            WHERE cod_area LIKE '%[a-zA-Z,.;:/?*]%';                                                      
                                                                                
            UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            SET cod_area = REPLACE(cod_area, '0', '');                                             
                                                                                
            UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                   
            SET telefone = REPLACE(telefone, '-', '')                                                                                
            WHERE telefone LIKE '%-%';                                      
                                                                                
            UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            SET cod_area = REPLACE(cod_area, '-', '')                                                                                
            WHERE cod_area LIKE '%-%';                                         
                                                                                
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            WHERE telefone LIKE '%x%';                                                                                
                                                                                
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            WHERE cod_area = 'AN';                                       
                                                                      
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo           
            WHERE cod_area LIKE '%)%';                                      
                                                                                
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            WHERE cod_area LIKE '%(%';                                                                                
                                                                                
                                                                           
            -- 29/09/2015                
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            WHERE ISNULL(cod_area, '') = '';                                                                                
                                                                                
            -- 29/09/2015                                                                      
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                           
            WHERE LEN(LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4)) > 2;                                                                                
                                                                                
            --29/09/2015                                                                                                     
  DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            WHERE LEN(telefone) < 8;                                                                                
                                                                                
            --29/09/2015                                                             
            DELETE FROM tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
    WHERE LEN(telefone) > 9;                                                                                
                                                                                
                                                                                
                                                      
            UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                       
            SET telefone = dbo.AjustaCelular(                                                             
                                                LEFT(CAST(CAST(REPLACE(                                                                                
                                             SUBSTRING(                                                                                
                                   cod_area,                                                                                
                                                            CHARINDEX('(', cod_area) + 1,                                                                                
                                                                                       4                                                                                
                                                                                   ),                                                           
                                                    ')',                                                                                
         ''                                                                      
                                                                      ) AS INT) AS VARCHAR), 4),                      
                                                dbo.ajustaTelefone(telefone)                                                                                
            )                                                                                
            WHERE telefone NOT LIKE '%[a-zA-Z,.;:/?*]%';       
                                                                  
                                                                                
                                                                                
            UPDATE dbo.tbl_importacao_recovery_telefones_NOVO_web_robo                 
            SET ativo = CASE                                                                                
                            WHEN ativo = 'TRUE' THEN                                                                                
1                                                                                
                            WHEN ativo = '1' THEN                                                                    
                                1                                                                                
                            ELSE                                                                   
                                0                                                                                
                        END;                                                                               
                                                                                
            UPDATE dbo.tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
  SET ativo = CASE                                                                                
                            WHEN ativo = 'TRUE' THEN                                                 
                                1                                                                                
                            WHEN ativo = '1' THEN                                                                                
   1                                                                                
                            ELSE                                                                                
            0                                                                                
                        END;                                                                                
                              
            UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
            SET telefone = dbo.AjustaCelular(                                                                                
                                                LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4),                                                                                
                                                dbo.ajustaTelefone(telefone)                                                                                
                  );                                                                                
                                                                                
        END; -- [ FIM ]                           
                                                             
                                                                                
        --------------------------------------------                                                                                                  
        --AJUSTA TELEFONES MARCADOS COMO BLACKLIST                                                                                                  
        --------------------------------------------          
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        WHERE cod_area LIKE '%[a-zA-Z,.;:/?*()]%';                                                                                
                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
 WHERE cod_area LIKE '%An%';                                                                                
                                       
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                         
        WHERE cod_area LIKE '%##%';                                                                                
                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        WHERE cod_area LIKE '%!2%';                                            
                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                       
        WHERE cod_area LIKE '%()%';                                                    
                                                                                
        DELETE FROM dbo.tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        WHERE LEN(RTRIM(LTRIM(telefone))) > 9;                                                                            
                                             
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                 
        WHERE ISNULL(telefone, '0') = '0';                                                                                
                                                                                
        UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist                                        
        SET cod_area = REPLACE(cod_area, '-', '')                                                                                
        WHERE cod_area LIKE '%-%';                                                                                
                                         
        --  DELETE  FROM tbl_importacao_recovery_telefones_web_robo                                                                                                                                                          
        --  WHERE   LEN(LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4)) < 2                                                                                                                                      
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
                
                                          
                                            
                                              
                                                
                                                  
                                  
        --                                                                                                                                                          
        --  DELETE  FROM tbl_importacao_recovery_telefones_web_robo                                 
        --  WHERE   LEN(LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR),                                                                                               
        --       4)) > 2                                                                                                                                              
                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                            
        WHERE ISNULL(cod_area, '') = '';                                                                                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                 
        WHERE LEN(telefone) < 8;                                                                                
                                                                                
        DELETE FROM tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        WHERE LEN(telefone) > 9;                                                                                
                                                                                
       UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        SET telefone = REPLACE(telefone, '-', '')                                                                                
   WHERE telefone LIKE '%-%';                                                                                
                                                                                
        UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        SET cod_area = REPLACE(cod_area, '-', '')                                                               
      WHERE cod_area LIKE '%-%';                                                                                
                                                     
        UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        SET cod_area = REPLACE(cod_area, '0', '');                                                                        
                                                                        
        UPDATE dbo.tbl_importacao_recovery_telefones_web_robo_blacklist                                                                                
        SET ativo = CASE                             
                        WHEN ativo = 'TRUE' THEN                                                                                
                            1                                                                                
                        WHEN ativo = '1' THEN                                                                             
                            1                                                                                
                        ELSE                                                                                
                            0                                                                                
                    END;                                                                                
                                                                                
        UPDATE tbl_importacao_recovery_telefones_web_robo_blacklist                
        SET id_devedor = tbl_contrato.id_devedor                                                                                
        FROM dbo.tbl_importacao_recovery_telefones_web_robo_blacklist AS tbl_importacao_recovery_telefones_web_robo_blacklist                                       
            INNER JOIN dbo.tbl_contrato AS tbl_contrato                                                                                
                ON tbl_importacao_recovery_telefones_web_robo_blacklist.id_contato = tbl_contrato.firma                                                                                
        WHERE tbl_importacao_recovery_telefones_web_robo_blacklist.id_devedor IS NULL;                                                         
                                                                             
                                                                                
        BEGIN -- [ INICIO - DEVEDORES ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                            
             'IMPORTACAO',                                                      
                                               'Carteira - 288',                                                                                
                                               'IDENTIFICA DEVEDORES EXISTENTES',                                                                                
                                'FALSE';                                                                                
            BEGIN -- [ INICIO - Identifica devedores existentes ]                                                                                                  
                                                                      
            -- FÍSICA                                                                                                     
                UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                           
                SET id_devedor = tbl_devedor.id_devedor                                                                                
        FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                                     
     JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON id_contato =IdContacto                                                                               
                    INNER JOIN tbl_devedor (NOLOCK)                                                                           
                        ON tbl_importacao_recovery_contatos_NOVO_web_robo.nro_doc = tbl_devedor.cpf_cnpj                                                                    
        WHERE tipo_pessoa LIKE 'F%'                                                                                
                      AND ISNULL(nro_doc, '') <> '' -- IS NOT NULL                                                                                                     
                      AND relacao = 'TITULAR';                                                                                
                                                                                
                                                      
                -- JURÍDICA                                                               
                UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
               SET id_devedor = tbl_devedor.id_devedor                                                                                
               FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                                     
     JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON id_contato =IdContacto                                                                                                   INNER JOIN tbl_devedor (NOLOCK)                               
                                                 
                        ON tbl_importacao_recovery_contatos_NOVO_web_robo.cuil_cuit = tbl_devedor.cpf_cnpj                                                                                
                WHERE tipo_pessoa LIKE 'J%'                                                    
                      AND ISNULL(cuil_cuit, '') <> '' -- IS NOT NULL                                                                                  
                      AND relacao = 'TITULAR';                                              
                                                                                
            END; -- [ FIM ]                                                          
                                                                                
 EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                       
                                               'IMPORTACAO',                                                
                                               'Carteira - 288',                                                                                
                                               'INSERE NOVOS DEVEDORES',                                        
                 'FALSE';                                                                                
            BEGIN -- [ INICIO - Insere novos devedores ]                                                                                                  
                                                                                INSERT INTO tbl_devedor                                                                                
                (                                                                                
                    cod_devedor,                                                                                
                    nome,                                                                                
                    cpf_cnpj,                                                                                
                    tipo,                                                                  
                    dt_nascimento,                                               
                    operador,                                                                                
                    id_lote                                         
                )                                                                    
                SELECT DISTINCT                                        
                    id_contato,                                                                                
                    LEFT(sobrenome_razaosocial, 50) AS sobrenome_razaosocial,                                                                                
                    CASE                                                                                
                     WHEN ISNULL([cuil_cuit], '') <> '' THEN                                                                                
              [cuil_cuit]                                                                                
                        ELSE                                        
                            [nro_doc]                                                                                
                    END AS cpf_cnpj,                                                                                
                    CASE                                                             
                        WHEN ISNULL([cuil_cuit], '') <> '' THEN                                                                          
                            'J'      
                        ELSE                                                                                
                            'F'                                                                                
                    END AS tipo_pessoa,                                                                                
                    data_nascimento,                                                                                
                    'CARGA AUTOMATICA' AS operador,                                   
                    MAX(id_lote) AS id_lote                                                                                
               FROM dbo.tbl_importacao_recovery_contatos_NOVO_web_robo a                                                                     
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON a.id_contato = b.IdContacto                                                                              
                WHERE id_devedor IS NULL                                                                     
                      AND relacao = 'TITULAR' --05/11/2014          
                      AND NOT EXISTS                                                                                
       (                                                                  
                    SELECT 1                                                                                
                    FROM tbl_devedor (NOLOCK)                                                                                
                    WHERE CASE                                                                   
                              WHEN ISNULL([cuil_cuit], '') <> '' THEN                                                                                
                                  [cuil_cuit]                                                                                
        ELSE                                                                                
                                  [nro_doc]                                                                        
            END = tbl_devedor.cpf_cnpj                                                                                
                )                                                                      
                GROUP BY id_contato,                                                                                
                         LEFT(sobrenome_razaosocial, 50),                                                                                
                         CASE                                                                                
                             WHEN ISNULL([cuil_cuit], '') <> '' THEN                                                                                
                                 [cuil_cuit]                                                                        
                             ELSE                                                                                
           [nro_doc]                                                                                
                         END,                                                                                
                         CASE                    WHEN ISNULL([cuil_cuit], '') <> '' THEN                                                                                
'J'                                                                                
                             ELSE                                                                                
                                 'F'                                                                                
                         END,                                                            
                         data_nascimento                           
                ORDER BY sobrenome_razaosocial;                                                                                
END; -- [ FIM ]                                                                                                    
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                           
                                               'Carteira - 288',                                                                                
                                               'IDENTIFICA DEVEDORES IMPORTADOS',                                         
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Identifica devedores importados ]                                                                      
                                                                      
                -- FÍSICA                                                                                                    
                UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
                SET id_devedor = tbl_devedor.id_devedor                                                                                
                FROM tbl_importacao_recovery_contatos_NOVO_web_robo a                                                                    
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON a.id_contato = b.IdContacto                                                                                 
                    INNER JOIN tbl_devedor (NOLOCK)                                                                                
                    ON a.nro_doc = tbl_devedor.cpf_cnpj                                                                    
                WHERE a.id_devedor IS NULL                                                                                
                      AND tipo_pessoa LIKE 'F%'                                                                                
                      AND relacao = 'TITULAR' --05/11/2014                                                                                                  
                      AND ISNULL(nro_doc, '') <> ''; -- IS NOT NULL                                                                   
                                                                                
   -- JURÍDICA                                                                           
                UPDATE tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
                SET id_devedor = tbl_devedor.id_devedor                                                                                
               FROM tbl_importacao_recovery_contatos_NOVO_web_robo a                                                             
     JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON a.id_contato = b.IdContacto                                                                                 
                    INNER JOIN tbl_devedor (NOLOCK)                                                                                
                        ON a.cuil_cuit = tbl_devedor.cpf_cnpj                                                                                
                  whERE a.id_devedor IS NULL                                                                                
                      AND tipo_pessoa LIKE 'J%'                                                                                
                      AND relacao = 'TITULAR' --05/11/2014                                                                                                  
                      AND ISNULL(cuil_cuit, '') <> ''; -- IS NOT NULL                  
                              
            END; -- [ FIM ]                                                                                             
                                                                                
            BEGIN -- [ INICIO - Atualiza dados devedores complementar   ]                                               
                                                                      
                UPDATE tbl_devedor_complementar                                                                                
                SET trabalha = tbl_importacao_recovery_contatos_NOVO_web_robo.trabaja,                                                                                
                    empresa = tbl_importacao_recovery_contatos_NOVO_web_robo.empresa,                                                                                
                    cargo = tbl_importacao_recovery_contatos_NOVO_web_robo.cargo,                                                                                
                    salario_liquido = tbl_importacao_recovery_contatos_NOVO_web_robo.salario_neto,                                          
          salario_bruto = tbl_importacao_recovery_contatos_NOVO_web_robo.salario_bruto,                                                                                
               sexo_financiado = sexo,                                                    
                    id_estado_civil = CASE                                                                                
                                  WHEN estado_civil = 'Casado' THEN                                                                                
                                              1                                                                                
                                          WHEN estado_civil = 'Solteiro' THEN                                                                            
                            2                                                                                
                                          WHEN estado_civil = 'Divorciado' THEN                                                                                
  3                                                                                
            WHEN estado_civil = 'Desquitado' THEN                                                                       
                                              4                                                           
                                          WHEN estado_civil = 'Marital' THEN                                                                                
                                              5                                                     
                                          WHEN estado_civil = 'Separado' THEN                                                                                
                                              6                                                                                
              WHEN estado_civil = 'Uniao Estavel' THEN                        
             7                                                                                
                                          WHEN estado_civil = 'Viúvo' THEN                                                                                
                                              8                                                                                
                                          ELSE                                                                                
                    9                                                                                
                      END                                                                                
               FROM dbo.tbl_devedor_complementar                                                                                
                    INNER JOIN tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
                        ON dbo.tbl_devedor_complementar.id_devedor = dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor;                                                                    
                                                                                
            END; -- [ FIM ]                                                                                                  
                                                                                
BEGIN -- [ INICIO - Insere novos devedores complemetares  ]                                                                                                  
                INSERT INTO dbo.tbl_devedor_complementar                                                        
                (                                                                                
             id_devedor,                                                                                
                    id_lote,                               
                    trabalha,                                                                                
                    empresa,                                                                   
                    cargo,                                                                                
             salario_liquido,                                                                                
                    salario_bruto,                                                                                
                    sexo_financiado,                                                                                
                    id_estado_civil                                                                                
                )                                                                                
             SELECT DISTINCT                                                                                
id_devedor,                                                                               
          id_lote,                                                                                
                    trabaja,                     
                    empresa,                                                                                
      cargo,                                                                                
                    salario_neto,                                                                                
                    salario_bruto,                                                                                
                    sexo,                                                                                
                    CASE                                                                                
                        WHEN estado_civil = 'Casado' THEN                                                                                
                            1                                                                                
 WHEN estado_civil = 'Solteiro' THEN                           
                            2                                                                                
   WHEN estado_civil = 'Divorciado' THEN                                                                                
                            3                                                                                
                        WHEN estado_civil = 'Desquitado' THEN                                  
                            4                                                                                
                        WHEN estado_civil = 'Marital' THEN                                                                                
                            5                                                                           
                        WHEN estado_civil = 'Separado' THEN                                                                                
                            6                                                                                
                        WHEN estado_civil = 'Uniao Estavel' THEN                                                                                
                     7                                                                                
                        WHEN estado_civil = 'Viúvo' THEN                                                                   
                            8                                                                                
                        ELSE                                                                                
                     9                                                                    
                    END AS id_estado_civil                                                                                
                FROM dbo.tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
                WHERE NOT EXISTS                                                                                (                            
                   SELECT 1                                                                                
                    FROM tbl_devedor_complementar                                                                                
                    WHERE id_devedor = tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                                                                                
                )                                                                                
                      AND id_devedor IS NOT NULL;                                                                          
                                                                                
            END; -- [ FIM ]                                                                                          
                                                                                
                                                                                
                                                                                
                                                            
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                          
       'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                            
                                               'IDENTIFICA DEVEDORES IMPORTADOS - ENDEREÇOS',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza o id_devedor nas demais tabelas de importação - ENDERECO ]                                                                                                  
                                                                                
     --09/10/2015                                                                                                   
                DECLARE @carteira_dados VARCHAR(50);                                           
                SET @carteira_dados =                                                                                
                (                                                                                
                    SELECT DISTINCT                                                   
                   descricao_produto                                                                                
                    FROM dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo a                                                                    
      JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo b ON a.idoperacao_SIR = b.IdOperacion_SIR                                                                       
     JOIN dbo.tbl_tipo_produto_cliente ON   b.IdCartera_Compra = cod_carteira                                                                               
               );                                    
                                                                                
                                                                    
                                                                      
                                                                 
                -- ENDEREÇOS                                                              
                UPDATE tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
                SET id_devedor = tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                                                  
                FROM tbl_importacao_recovery_contatos_NOVO_web_robo                             
                    INNER JOIN tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
           ON tbl_importacao_recovery_contatos_NOVO_web_robo.id_contato = tbl_importacao_recovery_enderecos_NOVO_web_robo.id_contato                                                                    
                WHERE tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL;                                                                                
                               
                --- localizar pela firma na tbl_contrato, pois um devedor pode ter mais de um id_contato                                                                                                           
                UPDATE tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
                SET id_devedor = tbl_contrato.id_devedor                                                                                
                FROM tbl_importacao_recovery_enderecos_NOVO_web_robo tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
                    INNER JOIN dbo.tbl_contrato tbl_contrato                                                                                
                        ON id_contato = firma                                                                                
 WHERE tbl_importacao_recovery_enderecos_NOVO_web_robo.id_devedor IS NULL                                                                                
                      AND carteira = @carteira_dados;                                                                                                       
                                               
                --15/09/2015                                                                                                      
                UPDATE tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
                SET id_devedor = tbl_endereco.id_devedor                    
                 FROM tbl_importacao_recovery_enderecos_NOVO_web_robo tbl_importacao_recovery_enderecos_NOVO_web_robo                                                                                
                    INNER JOIN dbo.tbl_endereco tbl_endereco                                                                                
                        ON id_endereco_cliente = id_domicilio                                                                      
                WHERE tbl_importacao_recovery_enderecos_NOVO_web_robo.id_devedor IS NULL;                                                                                
                                                                                
  END; -- [ FIM ]                                                                                              
                                                                         
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                      
                                               'IMPORTACAO',                                                                     
                                               'Carteira - 288',                                                                 
                                               'IDENTIFICA DEVEDORES IMPORTADOS - TELEFONES',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza o id_devedor nas demais tabelas de importação - TELEFONES ]                         
                                                                                
                                                              
                                                                    
                UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
                SET id_devedor = tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                                                                                
                FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                           
            INNER JOIN tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
                        ON tbl_importacao_recovery_contatos_NOVO_web_robo.id_contato = tbl_importacao_recovery_telefones_NOVO_web_robo.id_contato                                                                                
                WHERE tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL;                                                                                
                                                                                
                -- localizar pela firma na tbl_contrato, pois um devedor pode ter mais de um id_contato                                                                                  
       UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
      SET id_devedor = tbl_contrato.id_devedor                                                                                
                FROM tbl_importacao_recovery_telefones_NOVO_web_robo tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
           INNER JOIN dbo.tbl_contrato tbl_contrato                                 
                        ON id_contato = firma                                                                                
                WHERE tbl_importacao_recovery_telefones_NOVO_web_robo.id_devedor IS NULL                  
                      AND carteira = @carteira_dados;                    
                                                                      
                UPDATE tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
                SET id_devedor = tbl_telefone.id_devedor                                                                                
                FROM tbl_importacao_recovery_telefones_NOVO_web_robo tbl_importacao_recovery_telefones_NOVO_web_robo                                                                                
                    INNER JOIN dbo.tbl_telefone tbl_telefone                                                                                
                        ON id_telefone_cliente = tbl_importacao_recovery_telefones_NOVO_web_robo.id_telefone                                                                                
         WHERE tbl_importacao_recovery_telefones_NOVO_web_robo.id_devedor IS NULL;                                                                                
                                       
            END; -- [ FIM ]                                                                                                  
                                                                     
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                          
                                               'IMPORTACAO',                                                                                
                              'Carteira - 288',                                                                                
                                               'IDENTIFICA DEVEDORES IMPORTADOS - EMAIL',                           
                  'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza o id_devedor nas demais tabelas de importação - EMAILs ]                                                               
                UPDATE tbl_importacao_recovery_emails_NOVO_web_robo                                                                                
                SET id_devedor = tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                                                                                
                FROM tbl_importacao_recovery_contatos_NOVO_web_robo                             
                    INNER JOIN tbl_importacao_recovery_emails_NOVO_web_robo                                                                       
                 ON tbl_importacao_recovery_contatos_NOVO_web_robo.id_contato = tbl_importacao_recovery_emails_NOVO_web_robo.id_contato                                                                                
 WHERE tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL;                                                                                
                                                                                
                --- localizar pela firma na tbl_contrato, pois um devedor pode ter mais de um id_contato                                                                                                      
                UPDATE tbl_importacao_recovery_emails_NOVO_web_robo                                                                                
                SET id_devedor = tbl_contrato.id_devedor                                                                                
                FROM tbl_importacao_recovery_emails_NOVO_web_robo                                                                                 
                    INNER JOIN dbo.tbl_contrato tbl_contrato                                                     
                        ON id_contato = firma                                 
                WHERE tbl_importacao_recovery_emails_NOVO_web_robo.id_devedor IS NULL                                                                                
                      AND carteira = @carteira_dados;                            
                                                                                
                                
                UPDATE tbl_importacao_recovery_emails_NOVO_web_robo                                                                                
                SET id_devedor = tbl_email.id_devedor                                                                         
      FROM dbo.tbl_importacao_recovery_emails_NOVO_web_robo tbl_importacao_recovery_emails_NOVO_web_robo                                                                                
                    INNER JOIN dbo.tbl_email tbl_email                                                                                
                   ON id_email_cliente = id_endereco_email                 
                WHERE tbl_importacao_recovery_emails_NOVO_web_robo.id_devedor IS NULL;                                             
                                          
         END; -- [ FIM ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
                   'IDENTIFICA DEVEDORES IMPORTADOS - OPERAÇÕES',                                                                                
                                      'FALSE';                                                                                
      BEGIN -- [ INICIO - Atualiza o id_devedor nas demais tabelas de importação - OPERAÇÕES]                                                                                                  
                UPDATE dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                SET id_devedor = tbl_contrato.id_devedor                                                                                
                FROM tbl_contrato                                                                                                         
                    INNER JOIN dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo                                                         
                        ON tbl_contrato.numero = tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR;                                                                                
                                                                                
                                                             
         
                UPDATE dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                SET id_devedor = dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                                                            
   FROM dbo.tbl_importacao_recovery_contatos_NOVO_web_robo                              
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON IdContacto = id_contato                                                                          
                    INNER JOIN tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
             ON tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR                           
                WHERE dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL                                                                                
                      AND dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor IS NULL;                                                                     
                                                         
                                                                        
                                                                           
                                                                                      
            END; -- [ FIM ]                                                                                
                                                                                
 EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                  'IMPORTACAO',                                                                        
                        'Carteira - 288',                                                         
                                               'IDENTIFICA DEVEDORES IMPORTADOS - SALDO',                                                                                
                                               'FALSE';                                          
            BEGIN -- [ INICIO -  - Atualiza o id_devedor nas demais tabelas de importação - SALDO ]                                                                                               
                UPDATE dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                    
                SET id_devedor = tbl_contrato.id_devedor                                                                                
                FROM tbl_contrato                                                                                               
                    INNER JOIN dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
         ON tbl_contrato.numero = dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_operacion_SIR;                                                                                
                                             
                                                                                
                UPDATE dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
           SET id_devedor = dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor                     
                FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                                     
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON IdContacto = id_contato                                              
                    INNER JOIN dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
                        ON dbo.tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR = dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_operacion_SIR                                                                                
                WHERE dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL                                                                   
                      AND dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_devedor IS NULL;                                                                                
         END; -- [ FIM ]                                                                                                  
                                                     
        END; -- [ FIM ]                                                 
                                                                                
BEGIN -- [ INICIO - CONTRATOS ]                                                                                                  
                                                               
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                           
                                               'IMPORTACAO',                 
                   'Carteira - 288',                                                                                
                                               'ATUALIZA CONTRATOS EXISTENTES',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza contratos existentes ]                                                               
                UPDATE tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                SET id_contrato = tbl_contrato.id_contrato                                                                                
                FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                    INNER JOIN tbl_contrato (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_contrato.id_devedor                          
                           AND numero = idoperacao_SIR                                                                    
                WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato IS NULL;                                               
          
                                                                                
                UPDATE dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
                SET id_contrato = tbl_contrato.id_contrato                                                                                
                FROM dbo.tbl_importacao_recovery_saldo_NOVO_web_robo (NOLOCK)                                                                                
                    INNER JOIN tbl_contrato (NOLOCK)                                                                                
                        ON dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_operacion_SIR = tbl_contrato.numero                                                                                                            
   WHERE tbl_importacao_recovery_saldo_NOVO_web_robo.id_contrato IS NULL;                                                                                
                            
                UPDATE tbl_contrato                                                                              
                SET ativo = CASE                                   
                     WHEN dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao NOT LIKE '%ACTIVA%'           
                                     OR dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao = 'INACTIVA'                                                                                               
                    THEN                                                                                
                                    0                                                                                
                                ELSE   
                                    1                                                                                
                            END,                                                                                
                                                                                                      
                     data_base = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.data_inicio_mora,                                                           
                    operacao_campanha = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.campanha_gestao,                                                                                
        lote_compra = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.lote,                                                                                
                    campanha = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.campanha,                                                                                
                    nome_loja = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.segmento ,              
     id_seg_creditado = tbl_importacao_recovery_operacoes_NOVO_web_robo.id_segmento              
               FROM dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo (NOLOCK)                                                                                
                    INNER JOIN tbl_contrato (NOLOCK)                                                                                
                        ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato = tbl_contrato.id_contrato                                                                                
                    INNER JOIN dbo.tbl_parcela parcela (NOLOCK)                                                                                
                        ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato = parcela.id_contrato;                                                                                
                                
                                                                                
                UPDATE dbo.tbl_contrato_complementar                                  
                SET data_corte_prescricao = CASE                                                                                
                                   WHEN tbl_importacao_recovery_operacoes_NOVO_web_robo.data_corte_prescricao LIKE '%/%' THEN                                                                                
                               CONVERT(                                                                                
                                           SMALLDATETIME,                                                                  
          CONVERT(                                                                                
 VARCHAR(19),                                                                                
                                                                          tbl_importacao_recovery_operacoes_NOVO_web_robo.data_corte_prescricao,                                                                                
                                                                          120                                                                                
                                                                      ),                                                                                
                                                 103                                   
            )                                                                                  
         ELSE                                                                                
               CONVERT(                                                                                
                 SMALLDATETIME,                              
           CONVERT(                                                                                
                       VARCHAR(19),                                                                                
                                                                          tbl_importacao_recovery_operacoes_NOVO_web_robo.data_corte_prescricao,                                                                                
                                                                          120                                                                                
                                                                      )                                                                                                 )                                                                                
                 END                                                                         
            FROM tbl_importacao_recovery_operacoes_NOVO_web_robo (NOLOCK)                                                                                
                    INNER JOIN dbo.tbl_contrato_complementar (NOLOCK)                                                                                                 
  ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato = dbo.tbl_contrato_complementar.id_contrato                                                                                
                WHERE RTRIM(LTRIM(ISNULL(tbl_importacao_recovery_operacoes_NOVO_web_robo.data_corte_prescricao, ''))) <> ''                                                                                
                      AND LEN(tbl_importacao_recovery_operacoes_NOVO_web_robo.data_corte_prescricao) > 1;                                                                    
                                                                                
            END; -- [ FIM ]                                                                                      
                                                                                
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                      
                                               'IMPORTACAO',                          
                                               'Carteira - 288',                                                              
                                               'INSERE NOVOS CONTRATOS',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Insere novos contratos ]                                                    
                                                                                
                                                                       
                                                                                    
          INSERT INTO tbl_contrato                                                                                
                (                                                                                
                    id_devedor,                                                              
                    firma,                                                                                
                    numero,                                                                                
                    numero_cartao,                       
                    numero_plastico,                                                                                
                  --  complemento_cartao,                                          
                    nome_linha_credito,    
                    nome_loja,                                                                                
                    data_base,                                                                                
                    cod_tipo_contrato,                                                                                
                    id_lote,                                                                          
                    operacao_campanha,                                                                                
                    cod_linha_credito,                                                                                
                    ativo,                                                                                
                    carteira,                                                                                
                    lote_compra,                                                                                
                    campanha ,              
     id_seg_creditado              
                )                                                                      
     SELECT DISTINCT                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor,                                        
                    tbl_devedor.cod_devedor,                                                                                                     
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR AS numero,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.operid AS numero_cartao,                                                                                                 
              tbl_importacao_recovery_operacoes_NOVO_web_robo.numero_operacao AS numero_plastico,                                                                                                                                                             
   
   
      
        
          
            
              
                
                  
               -- tbl_importacao_recovery_operacoes_NOVO_web_robo.numero_caso AS complemento_cartao,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.tipo_carteira AS nome_linha_credito,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.segmento AS nome_loja,                                                       
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.data_inicio_mora AS data_base,                                                                                
                  tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.idcaso_SIR AS cod_tipo_contrato,                                                                     
                    @lote,                                                     
        tbl_importacao_recovery_operacoes_NOVO_web_robo.campanha_gestao,                                                                                
                    tbl_tipo_produto_cliente.id_tipo_produto AS cod_linha_credito,                                                                                
                    1 AS ativo,                                                                                
                    tbl_tipo_produto_cliente.descricao_produto,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.lote,                                                                        
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.campanha,               
     tbl_importacao_recovery_operacoes_NOVO_web_robo.id_segmento              
              FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                       
           JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo  ON idoperacao_SIR = IdOperacion_SIR                                                                    
                  INNER JOIN tbl_devedor                                                                                
                        ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_devedor.id_devedor                                                    
                    INNER JOIN tbl_tipo_produto_cliente                                                                                
                        ON tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdCartera_Compra = tbl_tipo_produto_cliente.cod_carteira                                                      
                           AND tbl_tipo_produto_cliente.id_campanha = 288                                                                                
                WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor IS NOT NULL                                                                       
                      AND NOT EXISTS                                   
                (                       
                    SELECT 1                                                                                
                    FROM tbl_contrato (NOLOCK)                                                                                
                    WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_contrato.id_devedor                                                                                
                       AND dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR = tbl_contrato.numero                                                                                
             );                                                       
                                                                                
                                                                   
                                                                                     
                                                                    
             SELECT DISTINCT                                                                                
                    '288' AS id_campanha,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor,                                                                                
                    'CONTRATO : ' + CONVERT(VARCHAR, tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR) AS OBS,                                
                    '81' AS cod_ocorrencia                                                                                
                INTO #novos_contratos_ocorrencia                                                                                
                FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                   
                 JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON idoperacao_SIR = idoperacao_SIR                                                                             
                    INNER JOIN tbl_devedor                                                  
                        ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_devedor.id_devedor                                                                                
                    INNER JOIN tbl_tipo_produto_cliente                                                                                
         ON tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdCartera_Compra = tbl_tipo_produto_cliente.cod_carteira          
                       AND tbl_tipo_produto_cliente.id_campanha = 288                                                                                
                WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor IS NOT NULL                    
                      AND dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao <> 'INACTIVA'                                                                                
          AND NOT EXISTS                                                           
                (                                                                                
                    SELECT 1                                                                                
                    FROM tbl_contrato (NOLOCK)                                                                                
                    WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_contrato.id_devedor                                                                                
                          AND dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR = tbl_contrato.numero                                                                                
                );                                                                        
                                                                                
              SELECT DISTINCT                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR AS numero                                                                                
               INTO #novos_contratos_ciclo                                                                                
   FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                                   
    --            JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON idoperacao_SIR = idoperacao_SIR                                                                                
    --INNER JOIN tbl_devedor                                                                                
    --                    ON dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_devedor.id_devedor                                                                                
    --                INNER JOIN tbl_tipo_produto_cliente                                                               
    --                    ON tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdCartera_Compra = tbl_tipo_produto_cliente.cod_carteira                                                                                
    --                       AND tbl_tipo_produto_cliente.id_campanha = 288                                                                                
                WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor IS NOT NULL                                                                                
                      AND NOT EXISTS                                                                                
                (                                                                  
                    SELECT *                                             
                    FROM dbo.tbl_contrato_ciclo                                                                                
                    WHERE id_operacion_sir = idoperacao_SIR                                 
                );                                                                                
                                                                              
                                                                                         
                                                                                
 INSERT INTO dbo.tbl_contrato_ciclo                            
(                              
    id_contrato,                                                                          
    id_operacion_sir,                                                 
    id_caso_sir,                                                                          
    carteira,                                                                          
    data_ultima_atualizacao                                                                          
)                                                                          
SELECT DISTINCT                                                                          
    id_contrato,                                                         
    #novos_contratos_ciclo.numero,                                                                          
    cod_tipo_contrato,                                                                          
    carteira,                                                                          
    GETDATE()                                                                          
FROM #novos_contratos_ciclo                                                                          
    INNER JOIN dbo.tbl_contrato                                                                          
        ON #novos_contratos_ciclo.numero = dbo.tbl_contrato.numero                                                                          
WHERE NOT EXISTS                                                      
(                                                                   
    SELECT 1                                                                          
    FROM dbo.tbl_contrato_ciclo                                                                 
    WHERE id_operacion_sir = #novos_contratos_ciclo.numero                                                    
          AND id_contrato = dbo.tbl_contrato.id_contrato                                                                          
)                                                                          
      AND NOT EXISTS                                                                          
(                                                   
    SELECT 1                                                                          
    FROM dbo.tbl_contrato_ciclo                                                                          
    WHERE id_operacion_sir = #novos_contratos_ciclo.numero                                                                          
)                                                                          
      AND dbo.tbl_contrato.id_contrato NOT IN ( 1741370, 1784362, 1809188, 1810654, 8741553, 5810689, 5809293, 5809454,5809336 )                                                         
      AND numero_plastico NOT IN ( '3454004445202-00-3218', '3977000000940-00-2798', '0557130011151000173',                                                                          
                                   '11173-000309000172846', '11173-220100019128', '11998-64900043379',                                                                          
                                   '3454004445202218', '3231130002214000261', '8621980239356-00-3218',                                                                          
            '3454004445202218', '11998-64900043379','000000750770281','000000750771479'                                       
                                 )                                                                          
      AND #novos_contratos_ciclo.numero != 8741553                          
   AND tbl_contrato.numero NOT IN(5765379,5765285)                          
      AND saldo_contrato IS NOT NULL                                                                                 
                                                                              
                                                  
                                                 
                                                                
                INSERT INTO ACIONAMENTO_COBRANCA.dbo.tbl_ocorrencia_lote_batch                                                                                
                (                                   
                    id_campanha,                                                   
                    id_devedor,                                                                              
                    obs,                                                                                
                    usuario,                                                                                
                    cod_ocorrencia,                                                 
                    data_insercao,                                                                                
                    query                                                      
                )                   
                SELECT DISTINCT                                                                                
                    id_campanha,                                                                                
                    id_devedor,                                                                                
                    OBS,                                                                                
                    'CARGA AUTOMATICA',                                            
                    cod_ocorrencia,                                                                                
                    GETDATE(),                                                                         
                    '' AS query                                                                                
                FROM #novos_contratos_ocorrencia;                                                             
                                                                                                       
           END; -- [ FIM ]                                                                                                  
                                                       
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                   'IMPORTACAO',                                                                                
                        'Carteira - 288',                                                                                
            'ATUALIZA OS CONTRATOS INSERIDOS',                                                                                
 'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza os contratos inseridos ]                                          
                                                            
                UPDATE contrato                                                                                
                SET firma = id_contato                                                          
                FROM tbl_contrato contrato                                                                                
                    INNER JOIN dbo.tbl_importacao_recovery_contatos_NOVO_web_robo contatos                                                                    
    JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo  ON contatos.id_contato = IdContacto                                                                                
                        ON IdOperacion_SIR = numero --idoperacao_SIR                                                                                      
                WHERE id_contato <> firma                                                                                
    AND relacao = 'TITULAR';                                                                                
                                                                                
                UPDATE tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                SET id_contrato = tbl_contrato.id_contrato                                                                                
               FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                            
    INNER JOIN tbl_contrato (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = tbl_contrato.id_devedor                                                                                
                                                                                                    
                 AND tbl_contrato.numero = tbl_importacao_recovery_operacoes_NOVO_web_robo.idoperacao_SIR                                                                                
                WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato IS NULL;                                                                                
                                                                  
                UPDATE tbl_contrato_complementar                                                                    
                SET tbl_contrato_complementar.nome_agencia_estudio_cobro = tbl_importacao_recovery_operacoes_NOVO_web_robo.nome_agencia_estudio_cobro,                                                                    
                    tbl_contrato_complementar.nome_agencia_estudio = tbl_importacao_recovery_operacoes_NOVO_web_robo.nome_agencia_estudio,                                                                          
                    tbl_contrato_complementar.id_produto = CASE                                                                                
                                                               WHEN tbl_importacao_recovery_operacoes_NOVO_web_robo.nome_agencia_estudio LIKE '%INTERVALOR%' THEN                                                                                
                                                                   1                                                                                
                                                               ELSE                                                                                
                                                                   15                                                                                
                                                           END,                                                                                
                    tbl_contrato_complementar.estado_operacao = tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao,                                                                                
       tbl_contrato_complementar.subestado_operacao = tbl_importacao_recovery_operacoes_NOVO_web_robo.subestado_operacao,                                                                             
                    FechaDesasignacionFutura = tbl_importacao_recovery_operacoes_NOVO_web_robo.FechaDesasignacionFutura                                                                                
                FROM tbl_contrato_complementar                                                   
                    INNER JOIN tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                        ON dbo.tbl_contrato_complementar.id_contrato = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato;                                        
                    
            END; -- [ FIM ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                
                             'Carteira - 288',                                                                       
                  'INSERE NOVOS CONTRATOS COMPLEMENTARES',                                                                        
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Insere novos contratos complementares ]                                             
                                                                                
                -- Agora devemos considerar a data corte prescrição. Se vier nula nem inserimos o caso na tabela. Será usado nos cálculos.                                                                                                   
                INSERT INTO dbo.tbl_contrato_complementar                                                      
                (                                                                                
                    id_contrato,                                        
 id_filial,                                                                                        nome_agencia_estudio_cobro,                                                                                
                    nome_agencia_estudio,                                                                                
                    id_produto,                                                                                
                    estado_operacao,                                
                    subestado_operacao                                                                                
              )                                                                                
                SELECT DISTINCT                                 
                   id_contrato,                                                                                
                    0,                                                                                
                    nome_agencia_estudio_cobro,                         
                    nome_agencia_estudio,                                                                                
                    CASE                                                                                
                        WHEN nome_agencia_estudio LIKE '%INTERVALOR%' THEN                                                                        
                            1                   
                        ELSE                                                                                
                            15                                                                                
                    END AS id_produto,                                                                                
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao,                             
                    tbl_importacao_recovery_operacoes_NOVO_web_robo.subestado_operacao                                                                                
                FROM dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
   WHERE NOT EXISTS                                                                                
                (                             
                    SELECT 1                                                                       
                    FROM dbo.tbl_contrato_complementar                                                                                
              WHERE dbo.tbl_contrato_complementar.id_contrato = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato                                                                                
                )                                                                                
                      AND ISNULL(                                                        
                                RTRIM(LTRIM(tbl_importacao_recovery_operacoes_NOVO_web_robo.nome_agencia_estudio_cobro)),                                                                                
                ''                                                                                
                                ) <> ''                                                                                
                      AND dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato IS NOT NULL;                                                                                
                                                                                             
                                                                                
            END; -- [ FIM ]                                                                                         
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                       
                                               'IMPORTACAO',                                                                        
                                               'Carteira - 288',                                                                                
                        'ATUALIZA OS CONTRATOS COMPLEMENTAR',                                                                                
                                               'FALSE';                                                                           
            BEGIN                                                                                                  
                                                                                
                UPDATE tbl_contrato_complementar                                               
               SET tbl_contrato_complementar.nome_agencia_estudio_cobro = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.nome_agencia_estudio_cobro                                                    
               FROM tbl_contrato_complementar                                                                                
                    INNER JOIN dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                        ON dbo.tbl_contrato_complementar.id_contrato = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato;                                                               
                                                                              
            END; -- [ FIM ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                   
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
               'ATUALIZA O ID_CONTRATO PARA AS PARCELAS DO CONTRATO',                                                                                
                                               'FALSE';                                             
            BEGIN -- [ INICIO - Atualiza o id_contrato para as parcelas do contrato   ]                                                                                                  
                UPDATE dbo.tbl_importacao_recovery_saldo_NOVO_web_robo                                                                         
 SET id_contrato = tbl_contrato.id_contrato                                                       
                 FROM tbl_contrato (NOLOCK)                                                                                                 
                    INNER JOIN dbo.tbl_importacao_recovery_saldo_NOVO_web_robo (NOLOCK)                                             
                        ON tbl_contrato.numero = dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_operacion_SIR                                                                             
       WHERE dbo.tbl_importacao_recovery_saldo_NOVO_web_robo.id_contrato IS NULL;                                                                                
END; -- [ FIM ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
             'IMPORTACAO',                                                                                
            'Carteira - 288',                                                                                
                                               'ATUALIZA DEMAIS INFORMAÇÕES NA TBL_CONTRATO',                                                               
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza demais informações na tbl_contrato ]                                                                                                  
                UPDATE tbl_contrato                          
                SET moeda = tbl_importacao_recovery_saldo_NOVO_web_robo.moeda,                                                                                
                   -- saldo_contrato = tbl_importacao_recovery_saldo_NOVO_web_robo.saldo_traspaso,                                                                                
                  --  atrasadas = tbl_importacao_recovery_saldo_NOVO_web_robo.qtde_cobrancas,                                        
                    data_ultima_alteracao = tbl_importacao_recovery_saldo_NOVO_web_robo.data_ultima_cobranca,                                                                    
                    tipo_financiamento = CASE                                                                                
                                   WHEN tbl_importacao_recovery_saldo_NOVO_web_robo.saldo_operativo > 10000 THEN                                               
                 'A'                                  
                                             ELSE                                                                                
                  'B'                                                                                
                                         END                                                   
                 FROM tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
                    INNER JOIN tbl_contrato (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_saldo_NOVO_web_robo.id_contrato = tbl_contrato.id_contrato                                                                                
                           AND id_operacion_SIR = numero;                                                                                
                                                                                                  
                                                                                
                UPDATE tbl_contrato_complementar                                                                                
                SET loja = SUBSTRING(nome_loja, CHARINDEX('|', nome_loja, 0) + 1, 1000)                                                                                
               FROM dbo.tbl_contrato_complementar                               
                    INNER JOIN dbo.tbl_contrato tbl_contrato                                                                                
                        ON tbl_contrato.id_contrato = dbo.tbl_contrato_complementar.id_contrato                                                                                
                    INNER JOIN tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                        ON dbo.tbl_contrato_complementar.id_contrato = dbo.tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato;                                                                          
            END; -- [ FIM ]                                                                                        
                                
                       
     EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                         
                                               'IMPORTACAO',                                                                                
              'Carteira - 288',                                                                                
                                   'VERIFICA CASOS ANTIGOS',                                                                                
                                               'FALSE';                                                     
  BEGIN -- [ INICIO - Atualiza demais informações na tbl_contrato ]                                                                                                  
                                                                                
                -- Verifica casos antigos                                                   
                UPDATE tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
                SET id_parcela = tbl_parcela.id_parcela                                                     
                 FROM tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
 INNER JOIN tbl_parcela (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_saldo_NOVO_web_robo.id_contrato = tbl_parcela.id_contrato                                                                                
                WHERE tbl_importacao_recovery_saldo_NOVO_web_robo.id_parcela IS NULL;                                   
                                                
                                                
                                                
      UPDATE tbl_importacao_recovery_operacoes_novo_web_robo                                                                                
                SET id_parcela = tbl_parcela.id_parcela                                                     
                 FROM tbl_importacao_recovery_operacoes_novo_web_robo                                                                                
         INNER JOIN tbl_parcela (NOLOCK)                                                           
                    ON tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato = tbl_parcela.id_contrato                                      
                WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_parcela IS NULL;                                               
                                                
                                                
                                                                                 
                                                                                
               IF @@ROWCOUNT > 0                                                                                
                BEGIN                                                                                
                                                                                
                    --- atualizar o campo com o valor anterior, pois quando atualizar o campo valor para zero, perdemos referência do valor anterior.                              
                                                                                
                        UPDATE tbl_parcela                                                                                
                    SET valor_original_divida = tbl_parcela.valor,                                                                       
                        valor = tbl_importacao_recovery_saldo.saldo_operativo,                                                                                
                        valor_GCA = tbl_importacao_recovery_saldo.divida_atualizada                                                                                
                  FROM dbo.tbl_importacao_recovery_saldo_NOVO_web_robo tbl_importacao_recovery_saldo                                                                   
                        INNER JOIN dbo.tbl_parcela tbl_parcela                                                                                
                            ON tbl_importacao_recovery_saldo.id_contrato = tbl_parcela.id_contrato                                                                                
        AND tbl_importacao_recovery_saldo.id_parcela = tbl_parcela.id_parcela;                                                                                
                                                                          
                                                       
                    SELECT DISTINCT                                                    
                        '288' AS id_campanha,                                                                                
  tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor,                                                                                
                        'CONTRATO : ' + CONVERT(VARCHAR, idoperacao_SIR) AS OBS,                                                                                
                  CASE                                                                                
                            WHEN tbl_importacao_recovery_saldo_NOVO_web_robo.saldo_operativo = 0                                                   
                                 OR tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                                 OR tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao = 'INACTIVA'                                                                                                   
                        THEN                                                                                
                       0                                                                              
                            ELSE                                                                                
                             1                                                                                
                        END AS ativo,                                                                                
                        dbo.tbl_parcela.ativo AS ativo_intervalor,                                                                                
                        '80' AS cod_ocorrencia                                                                                
                    INTO #tmp_dados_ocorrencia                                                                       
        FROM tbl_importacao_recovery_saldo_NOVO_web_robo                                                                                
                        INNER JOIN tbl_parcela                                                                       
                            ON tbl_importacao_recovery_saldo_NOVO_web_robo.id_parcela = tbl_parcela.id_parcela                                                      
                        INNER JOIN tbl_importacao_recovery_operacoes_NOVO_web_robo (NOLOCK)                                         
                            ON tbl_importacao_recovery_saldo_NOVO_web_robo.id_contrato = tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato;                                                                         
                                                                                
                    DELETE FROM #tmp_dados_ocorrencia                                                                             
                    WHERE #tmp_dados_ocorrencia.ativo = ativo_intervalor;                                                                                
                                                                               
                    DELETE FROM #tmp_dados_ocorrencia                                                                                
                    WHERE #tmp_dados_ocorrencia.ativo = 0                                                                                
                          AND ativo_intervalor = 1;                                                                                
                                                                                
                    INSERT INTO ACIONAMENTO_COBRANCA.dbo.tbl_ocorrencia_lote_batch                                                                                
                    (                                                                                
                        id_campanha,                                                                                
                        id_devedor,                                                                                
                        obs,                                                                            
                        usuario,                                                                                
                        cod_ocorrencia,                                                                     
                        data_insercao,                                                     
                        query                                                    
                    )                                                                                
                    SELECT DISTINCT                          
                        id_campanha,                                                                                
                         id_devedor,                     
                         OBS,                                                                                
                        'CARGA AUTOMATICA',                                                                                
                        cod_ocorrencia,                                                                                
          GETDATE(),                                                           
                        '' AS query                                                                                
                FROM #tmp_dados_ocorrencia                                                        
                    WHERE NOT EXISTS                                                                                
                    (                                                                                
                        SELECT 1                                                                                
                        FROM dbo.tbl_ocorrencia tbl_ocorrencia                                                                                
                            INNER JOIN dbo.tbl_ligacao tbl_ligacao                                                                                
                            ON tbl_ocorrencia.id_ligacao = tbl_ligacao.id_ligacao                                                                                
                            INNER JOIN dbo.tbl_atendimento tbl_atendimento                                                                                
            ON tbl_ligacao.id_atendimento = tbl_atendimento.id_atendimento                                                                                
 INNER JOIN dbo.tbl_tipo_ocorrencia tbl_tipo_ocorrencia                                                                                
                                ON tbl_ocorrencia.id_tipo_ocorrencia = tbl_tipo_ocorrencia.id_tipo_ocorrencia                                                                                
                 WHERE tbl_tipo_ocorrencia.cod_ocorrencia = #tmp_dados_ocorrencia.cod_ocorrencia                                                                                
                              AND tbl_ocorrencia.obs = #tmp_dados_ocorrencia.OBS                                                                                
                              AND tbl_atendimento.id_devedor = #tmp_dados_ocorrencia.id_devedor                                                                     
                    );                                                                                
                                                                                
                                                              
                                                  
       UPDATE tbl_parcela                                                                                
                    SET                                                                       
                        data_entrada = GETDATE(),                                                                                
                        ativo = CASE                                                                                
             WHEN                                                                         
                                          tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                                         OR tbl_importacao_recovery_operacoes_NOVO_web_robo.estado_operacao = 'INACTIVA'                                                              
                        THEN                                                                       
                                        0                                       
                             ELSE                            
                                        1                                              
                     END,                                                                                
                       data_devolucao = CASE                                                                                
                         WHEN                                                                                
                                                   tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                
                      OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                       
                                                                                    
                        THEN                                                                                
                                                 GETDATE()                                                                                
                                             ELSE                                                              
                                                 NULL                                                                                
                                         END,                                                            
                        --- acrescentado para retirar o motivo de devolução, caso exista preenchido.                                                                                                  
                        motivo_devolucao = CASE                                                             
                                               WHEN                                                                            
                                                     dbo.tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                          
                                                    OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA' --25/02/2015                                                              
                        THEN                                                                           
                                              motivo_devolucao                                                                                
                                               ELSE                                                                                
                                                   NULL                                                               
                                           END,                                                                   
                        id_devolucao = CASE                                                                                
                                          WHEN                                                                             
                                                 tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                                                OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA' --25/02/2015                                                                                                           
                        THEN                                                                                
                                        @id_lote_log                                                                              
                               ELSE                                                                                
                                               NULL                                                                                
                                       END,           
          vencimento = tbl_importacao_recovery_operacoes_novo_web_robo.data_inicio_mora,                                                     
                        data_pagamento_boleto_percapita = CASE                                                                           
                 WHEN                                                                                 
                       dbo.tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                                                                 OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                                                  
                        THEN                                                                                
                                                                  data_pagamento_boleto_percapita                                                                                
                                                          ELSE                                                                                
                                                NULL                                                                                
   END,                                                                                
                        id_boleto_pagamento_percapita = CASE                                                                                
                                                            WHEN                                                                              
                                                            dbo.tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                                                                 OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                                
                        THEN          
                          id_boleto_pagamento_percapita                                                                                
                                                            ELSE                                                                                
                                          NULL                                                                                
                                                        END                                                                                
                 FROM tbl_importacao_recovery_operacoes_novo_web_robo                                                              
                        INNER JOIN tbl_parcela                                                                                
                            ON tbl_importacao_recovery_operacoes_novo_web_robo.id_parcela = tbl_parcela.id_parcela                                
                                                                
                                            
                                            
                                            
                    UPDATE tbl_parcela                                                                                
                    SET valor = tbl_importacao_recovery_saldo_NOVO_web_robo.saldo_operativo,                                                               
                        valor_GCA = tbl_importacao_recovery_saldo_NOVO_web_robo.divida_atualizada,                                                                                
                        data_entrada = GETDATE(),                                                                                
                        ativo = CASE                                                                                
                                    WHEN tbl_importacao_recovery_saldo_NOVO_web_robo.saldo_operativo = 0                                
                                      
                        THEN                                                                                
                                        0                                 
                                    ELSE                                  
                                        1                                                                                
                                END,                                                                                
                       data_devolucao = CASE                                                                                
                                             WHEN tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                                                
                                           
                                                                                    
                        THEN                                                                                
         GETDATE()                                                                                
                                             ELSE                                                                                
                                                 NULL                                                                                
                                         END,                                                                                
                        --- acrescentado para retirar o motivo de devolução, caso exista preenchido.                                                                      
                        motivo_devolucao = CASE                                                             
                                               WHEN dbo.tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                                                
                                                                                                                                
                THEN                                                                                
                                              motivo_devolucao                                                                           
                   ELSE                                                                     
                                                   NULL                                                                                
                                           END,                                                                   
                        id_devolucao = CASE                                                                                
                                          WHEN tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                                                
                                                                                                                                                      
                        THEN                                                                                
                                               tbl_importacao_recovery_saldo_novo_web_robo.id_lote                                                                                
                               ELSE                                                                                
                                               NULL                                                         
                                       END,                                                                                
                                                                                                       
    data_pagamento_boleto_percapita = CASE                                     
                 WHEN dbo.tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                               
                                                                                                                        
                        THEN                                                     
                                                                  data_pagamento_boleto_percapita                                                                                
                                                          ELSE                                       
                                                                  NULL                                                                                
                    END,                                                                                
                        id_boleto_pagamento_percapita = CASE                                                                                
                                                            WHEN  dbo.tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                                                
                                                                                                                                                              
                        THEN                                                                                
                                    id_boleto_pagamento_percapita                                                                                
    ELSE                                                                                
                                                          NULL                                                                                
                                                        END                                                                                
                   FROM tbl_importacao_recovery_saldo_novo_web_robo                                                              
                        INNER JOIN tbl_parcela                                                          
     ON tbl_importacao_recovery_saldo_novo_web_robo.id_parcela = tbl_parcela.id_parcela                                                                                
                                                                                  
                                                             
                END;                                                                                
                                                           
                                            
            END; -- [ FIM ]                                                                                           
                                                          
        END; -- [ FIM ]                                                                                                  
                                                                                
        BEGIN -- [ INICIO - PARCELAS ]                                                                                                  
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
   'IMPORTACAO',                                                                                
      'Carteira - 288',                                                                                
                                               'INSERE NOVAS PARCELAS',                                                                           
                      'FALSE';                                
            BEGIN -- [ INICIO - Insere novas parcelas ]                                             
                INSERT INTO tbl_parcela                                                                                
           (                                                                                
                id_contrato,                                                   
                    valor,                                                                                
                    valor_GCA,                                                                                                 
     --valor_CGA,                                                              
                    vencimento,                                                                                
                    numero,                                                                                
                    id_lote,                                                                                
                    operador,                                
                  ativo,                                                                                
                    data_devolucao,                                                                                
                    id_devolucao,                                                                                
                 valor_original_divida                                                                                                  
                )                                                                           
                SELECT DISTINCT                                                                                
                    tbl_importacao_recovery_saldo_novo_web_robo.id_contrato,                                                                                
                    tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo AS valor,                                                                                
                 -- tbl_importacao_recovery_saldo_novo_web_robo.divida_atual_data_fixa AS valor_GCA,                                                                                
                    tbl_importacao_recovery_saldo_novo_web_robo.divida_atualizada AS valor_CGA,                
                    tbl_importacao_recovery_operacoes_novo_web_robo.data_inicio_mora AS vencimento,                                                                                
                    1 AS numero,                                                                      
                    tbl_importacao_recovery_saldo_novo_web_robo.id_lote,                                              
                    'CARGA AUTOMATICA' AS operador,                              CASE                                                                                
     WHEN tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                                     
      OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                    OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                                                            
                    THEN                                                                                
                     0                                                                                
                        ELSE                                                                                
                            1                                                                                
                    END AS ativo,                             
                    CASE                                                                                
   WHEN tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                                             
        OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                             OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                                                     
                    THEN                                                                                
                            GETDATE()                                                                                
             ELSE               
                            NULL                                                                                
                    END data_devolucao,                                     
                    CASE                                                                                
                        WHEN tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0                                               
     OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                               
                             OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA'                                                                                                        
                    THEN                                                                                
                            tbl_importacao_recovery_saldo_novo_web_robo.id_lote                                                           
                        ELSE                                                                                
                            NULL                                                                                
                    END id_devolucao,                                                                   
     dbo.tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo AS valor_original_divida                                          
                                                                      
FROM tbl_importacao_recovery_saldo_novo_web_robo (NOLOCK)                                            
                    INNER JOIN tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_saldo_novo_web_robo.id_contrato = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                            
                WHERE tbl_importacao_recovery_saldo_novo_web_robo.id_contrato IS NOT NULL                                                                                
                      AND tbl_importacao_recovery_saldo_novo_web_robo.id_parcela IS NULL                                                                                
                      AND NOT EXISTS                                
                (                                                                               
                    SELECT 1                                                                                
                    FROM tbl_parcela                                                                                
                    WHERE tbl_importacao_recovery_saldo_novo_web_robo.id_contrato = tbl_parcela.id_contrato                                   
      AND tbl_importacao_recovery_operacoes_novo_web_robo.data_inicio_mora = tbl_parcela.vencimento   
              );                                          
                                                                                
            END; -- [ FIM ]                                                                                                  
                        
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                   
                                               'Carteira - 288',                                 
                                       'ATUALIZA PARCELAS INSERIDAS',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza parcelas inseridas ]                                                                                   
                UPDATE tbl_importacao_recovery_saldo_novo_web_robo                       
                SET id_parcela = tbl_parcela.id_parcela                                                                                
                FROM tbl_importacao_recovery_saldo_novo_web_robo                                                                                
                    INNER JOIN tbl_parcela (NOLOCK)                                                                                
                        ON tbl_importacao_recovery_saldo_novo_web_robo.id_contrato = tbl_parcela.id_contrato                                   
                WHERE tbl_importacao_recovery_saldo_novo_web_robo.id_parcela IS NULL;                                                                                
       END; -- [ FIM ]                                                                                                  
                                                                                
        END; -- [ FIM ]                                                                                                  
                                                             
        BEGIN -- [ INICIO - INSERE OS CASOS NA DEFINE_CAMPANHA ]                                                                                    
                                                               
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                     
        'IMPORTACAO',                                             
             'Carteira - 288',                                                                                
                                               'INSERE OS CASOS NA DEFINE_CAMPANHA',                                                                                
                                               'FALSE';                                                                                
                                                                                
            INSERT INTO tbl_define_campanha                                                                                
            SELECT DISTINCT                                       
                tbl_importacao_recovery_saldo_novo_web_robo.id_devedor,                                                                                
                tbl_importacao_recovery_saldo_novo_web_robo.id_contrato,                                                    
                tbl_importacao_recovery_saldo_novo_web_robo.id_parcela,                                                         
                288 AS id_campanha                                                                                
            FROM tbl_importacao_recovery_saldo_novo_web_robo                                                                                
           LEFT JOIN tbl_define_campanha                                                                                
                    ON tbl_importacao_recovery_saldo_novo_web_robo.id_devedor = tbl_define_campanha.id_devedor                                                                                
                    AND tbl_importacao_recovery_saldo_novo_web_robo.id_contrato = tbl_define_campanha.id_contrato                                                                                
                       AND tbl_importacao_recovery_saldo_novo_web_robo.id_parcela = tbl_define_campanha.id_parcela                                                                                
             AND tbl_define_campanha.id_campanha = 288                                                                                
      WHERE tbl_define_campanha.id_parcela IS NULL                                                                                
       AND tbl_importacao_recovery_saldo_novo_web_robo.id_parcela IS NOT NULL;                                                                                
                                                                                
        END; -- [ FIM ]                           
                                                                                
        BEGIN -- [ INICIO - ENDEREÇOS ]                                                                                                  
                                                                                
       EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                             
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
                                               'INSERE OS ENDEREÇOS',                                                                                
                                               'FALSE';                                                                                
                          
            UPDATE tbl_endereco                                                                                
  SET id_endereco_cliente = tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio,                                                                  
                id_lote = CASE                                                                    
                   WHEN tbl_endereco.id_lote IS NULL THEN                                                                                
                                  tbl_importacao_recovery_enderecos_novo_web_robo.id_lote                                                                 
                              ELSE                         
       tbl_endereco.id_lote                                                                                
                          END                                                                                
            FROM tbl_endereco                                                                                
                INNER JOIN tbl_importacao_recovery_enderecos_novo_web_robo                                                    
                    ON tbl_endereco.id_devedor = tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor                                                                                
 AND tbl_endereco.municipio = tbl_importacao_recovery_enderecos_novo_web_robo.cidade                                                                                
                       AND tbl_endereco.uf = ISNULL(SUBSTRING(estado, CHARINDEX('(', estado) + 1, 2), '')                                                                                
        AND tbl_endereco.cep = tbl_importacao_recovery_enderecos_novo_web_robo.cep                                                             
                       AND REPLACE(tbl_endereco.logradouro, ' ', '') = REPLACE(                                                                                
                                                                                  tbl_importacao_recovery_enderecos_novo_web_robo.rua,                                                                             
                                       ' ',                                                              
                                                                                  ''                                                                                
                                       )                                                                                
            WHERE ISNULL(tbl_endereco.id_endereco_cliente, 0) = 0;                                                                                
                                                                                
            BEGIN -- [ INICIO - Insere o retorno dos dados  feito pela exportacao ]                                                                                                  
                                                                                
                UPDATE dbo.tbl_historico_envio_endereco                                                                                
                SET ativo = 0,                                                
    data_retorno = GETDATE(),                                                                                
                    id_endereco_cliente = tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio                                                     
                 FROM tbl_historico_envio_endereco                                                                                
                    INNER JOIN tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
                        ON tbl_historico_envio_endereco.CEP = tbl_importacao_recovery_enderecos_novo_web_robo.cep                                                                                
                           AND RTRIM(LTRIM(REPLACE(tbl_historico_envio_endereco.Rua, ' ', ''))) = RTRIM(LTRIM(REPLACE(                                                                
                                                                                               tbl_importacao_recovery_enderecos_novo_web_robo.rua,                                                         
                                                                                                                         ' ',                                                                                
                             ''                                                                                
                                                                                   )                                                                                
                                                                                                             )                                                                            
                                                                                            );                                                                                
                                                    
                --- separar do campo nro os dados que devem entrar no complemento.                  
                IF OBJECT_ID('tempdb..#tmp_ajusta_numero') IS NOT NULL                                                                                
                    DROP TABLE #tmp_ajusta_numero;                                                                                
                                                          
                SELECT nro = CASE                                                                                
      WHEN ISNUMERIC(RTRIM(LTRIM(SUBSTRING(nro, 1, CHARINDEX(' ', nro, 1))))) = 1 THEN                                                                                
                       SUBSTRING(nro, 1, CHARINDEX(' ', nro, 1))                                                                                
                                 WHEN ISNUMERIC(RTRIM(LTRIM(SUBSTRING(nro, 1, CHARINDEX(' ', nro, 1))))) = 0                                           
                                 AND                                                                                
                                     (                                                                                
                                          nro NOT LIKE 'SN%'                                                                                
                                          OR nro NOT LIKE 'S/N%'                                             
                                      ) THEN                                                                       
            'S/N'                                                                                
           END,                                                                                
                       andar = RTRIM(LTRIM(   CASE                                                                                
                                                  WHEN ISNUMERIC(SUBSTRING(nro, 1, CHARINDEX(' ', nro, 1))) = 1 THEN                                                                                
                                                     SUBSTRING(nro, CHARINDEX(' ', nro, 1), LEN(nro))                                                                                
                                                      + ISNULL(' | ' + andar, '')                                                          
                                    WHEN ISNUMERIC(SUBSTRING(nro, 1, CHARINDEX(' ', nro, 1))) = 0                                                                      
                         AND                                                                                
                                                       (                                                                                
              nro NOT LIKE 'SN%'                                                    
                OR nro NOT LIKE 'S/N'                                                                                
                                                       ) THEN                                                                                
                                                      RTRIM(LTRIM(REPLACE(REPLACE(nro, 'SN', ''), 'S/N', '')))                                                          
                                                      + ISNULL(' | ' + andar, '')                                                      
                      END                                                                                
                                          )                                                                                
                                    ),                                                                                
         id_domicilio,                                                                                
                       id_devedor                                    
                INTO #tmp_ajusta_numero                                                                                
                FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo                                                                 
                WHERE ISNUMERIC(RTRIM(LTRIM(ISNULL(nro, 0)))) = 0                     
                      AND nro NOT IN ( 'S/N', 'SN' );                                                             
                                        
                UPDATE tbl_endereco                                                                                
                SET logradouro = UPPER(LEFT(ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.rua, ''), 100)),                                                                                
                    numero = ISNULL(                                                                                
                                       #tmp_ajusta_numero.nro,                         
                                  CASE                                                                                
                                           WHEN tbl_importacao_recovery_enderecos_novo_web_robo.nro IS NULL THEN                                                       
                                               'S/N'                                                                                
                                           ELSE                                                          
                                               dbo.ajustaNumeros(LEFT(tbl_importacao_recovery_enderecos_novo_web_robo.nro, 7))                                                                                
                                       END                                              
                            ),                                                                
           complemento = ISNULL(                                                                                
                                            LEFT(#tmp_ajusta_numero.andar, 50),                                                             
           LEFT(tbl_importacao_recovery_enderecos_novo_web_robo.andar, 50)                                                                                
                                        ),                                                                                
                    cep = LEFT(ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.cep, ''), 8),                                                                                
                    bairro = UPPER(LEFT(ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.bairro, ''), 40)),                                                                                
                    municipio = UPPER(LEFT(ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.cidade, ''), 40)),                                                                                
                    uf = UPPER(LEFT(ISNULL(                                                                                
                                          SUBSTRING(                                                           
                                                           ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.estado, ''),                                                                                
                                                           CHARINDEX(                                                                           
                                                                        '(',                                                                      
          ISNULL(                                                                                
                                                       tbl_importacao_recovery_enderecos_novo_web_robo.estado,                                                
                                                                                  ''                                                                                
                                )                                                                                
                       ) + 1,                                                                                
                                            2                                                            
                                                     ),                                                                                
                                              ''                                                                    
                                          ), 2)                                                                                
                              ),                                                                                
                    tipo_endereco = UPPER(LEFT(tbl_importacao_recovery_enderecos_novo_web_robo.tipo_domicilio, 15))                                                                                
               FROM tbl_endereco                                                                                
                    INNER JOIN tbl_importacao_recovery_enderecos_novo_web_robo                                  
                  ON tbl_endereco.id_devedor = tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor                                                                                
                           AND id_domicilio = ISNULL(id_endereco_cliente, 0)                                                                                
                    LEFT JOIN #tmp_ajusta_numero                                                                                
               ON #tmp_ajusta_numero.id_domicilio = tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio                                                       
                WHERE tbl_importacao_recovery_enderecos_novo_web_robo.rua IS NOT NULL                                                                                
                      AND tbl_importacao_recovery_enderecos_novo_web_robo.cep IS NOT NULL                                                             
                      AND LEN(tbl_importacao_recovery_enderecos_novo_web_robo.nro) <= 7;                                                                                
                                                                              
                                                                                
                                                                            
                                                                                                  
    UPDATE endereco                                                   
        SET ativo = 1,                                                                                                          
                    id_endereco_cliente = CASE                                                                                
                                              WHEN imp_endereco.ativo = 0 THEN                                                                                
                                                  0                                                                                
                   ELSE                                                                                
                                                  id_endereco_cliente                                                                         
          END                                                                                
                FROM dbo.tbl_endereco endereco                                                                                
                    INNER JOIN dbo.tbl_importacao_recovery_enderecos_novo_web_robo imp_endereco                                                    
                        ON id_endereco_cliente = imp_endereco.id_domicilio;                                                                                
                                 
                                                                                                           
                UPDATE endereco                                                        
                SET ativo = 0                                                                                                           
                FROM dbo.tbl_endereco endereco                                                                                
               INNER JOIN dbo.tbl_importacao_recovery_enderecos_novo_web_robo imp_endereco                                                                                
                           ON id_endereco_cliente = imp_endereco.id_domicilio                                                                                
                WHERE imp_endereco.ativo = 0;                                                            
                                                                                
                                                                        
                INSERT INTO tbl_endereco                                                                                
                (                                               
                    id_devedor,                                                                                
                    logradouro,                                                                     
                    numero,                                            
                    complemento,                                                                                
                    cep,                                                                                
                    bairro,                                                                                
                    municipio,                           
uf,                                                                                
        id_lote,                                                                                
                    operador,                                                                                
                    tipo_endereco,                                                                    
                    id_endereco_cliente,                                                                                
                    ativo,                                                                                
                    usuario_alta,                                                                                
fecha_alta,                                                         
                    usuario_ult_mod,                                                                                
      fecha_ult_mod                                                                                
                )                     
        SELECT DISTINCT                                                                                
                    tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor,                                                                                
                    UPPER(LEFT(ISNULL(rua, ''), 100)) AS logradouro,                                                                                
                    LEFT(ISNULL(                                                                                
                    #tmp_ajusta_numero.nro,                                                             
                                   CASE                                                                   
                WHEN ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.nro, '') = '' THEN                                                                                
                            'S/N'                                                                                
                           ELSE                                                                                
                                           dbo.ajustaNumeros(LEFT(tbl_importacao_recovery_enderecos_novo_web_robo.nro, 7))                                          
                                   END                                                                                
                               ), 7) AS numero,                                                                       
       LEFT(ISNULL(#tmp_ajusta_numero.andar, tbl_importacao_recovery_enderecos_novo_web_robo.andar), 50) AS complemento,                                                                   
    LEFT(ISNULL(cep, ''), 8) AS cep,                                                          
                    UPPER(LEFT(ISNULL(bairro, ''), 40)) AS bairro,                                                                                
                    UPPER(LEFT(ISNULL(cidade, ''), 40)) AS cidade,                                                                                
                    UPPER(LEFT(ISNULL(SUBSTRING(ISNULL(estado, ''), CHARINDEX('(', ISNULL(estado, '')) + 1, 2), ''), 2)) AS uf,                                                                                
                    id_lote,                                                                                
                    'CARGA AUTOMATICA' AS operador,                                                                                
                    UPPER(LEFT(tipo_domicilio, 15)) AS tipo_endereco,                                                                                
                    tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio,                                                                                
                   CASE                                                                     
                        WHEN ISNULL(dbo.tbl_importacao_recovery_enderecos_novo_web_robo.ativo, 1) <> 1 THEN                                                                    
 0                                                                                
           ELSE                                                                                
                            1                                                                                
                    END AS ativo,                                                                                
                    usuario_alta,                                                                                
                    fecha_alta,                                           
                    usuario_ult_mod,                                                                                
                    fecha_ult_mod                                                                                
                FROM tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
                    LEFT JOIN #tmp_ajusta_numero                                                                                
                        ON #tmp_ajusta_numero.id_domicilio = tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio                                                                                                      
                                                                      
                WHERE tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor IS NOT NULL                                                                                
              AND tbl_importacao_recovery_enderecos_novo_web_robo.ativo = 1                                                                                
                      AND NOT EXISTS                                                                                
                (                                
     SELECT 1                                                                       
                    FROM tbl_endereco WITH (NOLOCK)                                                                                
                    WHERE tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor = tbl_endereco.id_devedor                                                                                
                          AND tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio = ISNULL(id_endereco_cliente, 0)                                                                                
                )                                                                                
              AND tbl_importacao_recovery_enderecos_novo_web_robo.rua IS NOT NULL                                                 
                      AND tbl_importacao_recovery_enderecos_novo_web_robo.cep IS NOT NULL;                                                                                
                                                                              
    END; -- [ FIM ]                                                                                                  
                                                                        
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                 
                                               'ATUALIZA O ID_ENDERECO_ATUAL',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualiza o id_endereco_atual ]                                                                                                  
                                                                                
                UPDATE dbo.tbl_devedor                                                                       
                SET tbl_devedor.id_endereco_atual = ivw_endereco_atual.id_endereco                                                                                
                FROM dbo.tbl_devedor                                                                             
                    INNER JOIN                                                                                
                    (                                                                 
                        SELECT MIN(tbl_endereco.id_endereco) AS id_endereco,                                    
                               tbl_endereco.id_devedor                                                                                
                        FROM dbo.tbl_endereco                                                                   
                            INNER JOIN tbl_devedor                                                                                
                                ON tbl_endereco.id_devedor = tbl_devedor.id_devedor                                                                                
                        WHERE tbl_devedor.id_endereco_atual IS NULL                                                                                
                        GROUP BY tbl_endereco.id_devedor                    ) ivw_endereco_atual                                                                                
                        ON tbl_devedor.id_devedor = ivw_endereco_atual.id_devedor;                                                                  
                           
            END; -- [ FIM ]                                                                                                  
                                                        
        END; -- [ FIM ]                                                                                                   
                                                 
        BEGIN -- [ INICIO - TELEFONES ]                                                                     
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
                                               'INSERE OS TELEFONES',                                                                                
                                               'FALSE';                                             
                                                                        
                                                            
            SELECT  id_telefone AS id_telefone,                                                                           
                   telefone,                                                                         
cod_area ,                                                                             
        ROW_NUMBER() OVER (PARTITION BY id_telefone ORDER BY id_contato DESC) AS fake_id                                                                                  
            INTO #ultima_data_maior                                                                                                     
            FROM tbl_importacao_recovery_telefones_novo_web_robo                                                                                
            WHERE CASE                                                                                
                      WHEN ISNULL(tbl_importacao_recovery_telefones_novo_web_robo.ativo, 1) <> 1 THEN                                                                                
                          0                                                                              
                      ELSE                                        
                  1                                                                                
   END = 1                                                                                
                  AND telefone <> '0'                                                              
                                                                   
                                                                        
                                                                        
                                                                        
             CREATE INDEX #ultima_data_maior ON #ultima_data_maior (id_telefone);                                                                                
                                                                                
                                                           
            BEGIN -- [ INICIO - Verifica os casos que estão inativos na carga ]                                                                                                  
                                                                                
                -- Deixamos  o  campo id_telefone_cliente zerado, pois caso esse telefone sejá ativado novamente receberemos um novo login                                                                                                           
                  
                SELECT b.id_devedor,                               
                       b.id_telefone AS id_telefone_cliente,                                                                                
                     b.ativo,                                                                                
                       b.cod_area,                                     
             b.telefone,                                                                                
                       'TELEFONE INATIVADO PELA RECOVERY' AS obs,                                                                                
                       b.usuario_alta,                                                                                
                       b.fecha_alta,                                                                                
   b.usuario_ult_mod,                                                                                
                       b.fecha_ult_mod,                                                                                
                       b.origem,                                                 
                       a.id_telefone,                                                                              
                       b.id_lote,                                           
                       b.tipo_telefone                                                                                
                INTO #telefone_inativo                                                           
  FROM dbo.tbl_telefone a                                                  
                   JOIN tbl_importacao_recovery_telefones_novo_web_robo b                                                                                
      ON a.id_devedor = b.id_devedor                                                                                
                           AND a.telefone = b.telefone                                                                                
                           AND LEFT(CAST(CAST(SUBSTRING(b.cod_area, CHARINDEX('(', b.cod_area) + 1, 4) AS INT) AS VARCHAR), 4) = a.ddd                                                                     
                WHERE b.ativo = 0;                                                                              
                                                                                
                CREATE INDEX ix_telefone_inativo ON #telefone_inativo (id_devedor);                                                                                
CREATE INDEX ix_telefone_inativo_id_telefone_cliente                                                                                
                ON #telefone_inativo (id_telefone_cliente);                                                                                
                CREATE INDEX ix_telefone_inativo_id_telefone                                                                                
                ON #telefone_inativo (id_telefone);                                                                                
                                                                                
                UPDATE tbl_telefone                                                                        
                SET ativo = #telefone_inativo.ativo,                                                                                
                    id_telefone_cliente = #telefone_inativo.id_telefone_cliente,                                  
                    ddd = LEFT(CAST(CAST(SUBSTRING(                                                                      
                                                      #telefone_inativo.cod_area,                                                                                
                                                      CHARINDEX('(', #telefone_inativo.cod_area) + 1,                             
                                                      4                                                                               
                         ) AS INT) AS VARCHAR), 4),                            
                    telefone = #telefone_inativo.telefone,                                                                     
                    usuario_alta = #telefone_inativo.usuario_alta,                                                                                
                    fecha_alta = #telefone_inativo.fecha_alta,                                                  
                    usuario_ult_mod = #telefone_inativo.usuario_ult_mod,                                                         
                    fecha_ult_mod = #telefone_inativo.fecha_ult_mod,                                                                                
                    origem = #telefone_inativo.origem,                                                                                
                    id_lote = #telefone_inativo.id_lote,                                                                                
            tipo_telefone = #telefone_inativo.tipo_telefone                                                                                
              FROM #telefone_inativo                                                                                
              JOIN dbo.tbl_telefone                                                                                
                        ON #telefone_inativo.id_telefone = dbo.tbl_telefone.id_telefone;                                                                                
                                                                             
            END; -- [ FIM ]              
                                                                                
            INSERT INTO ACIONAMENTO_COBRANCA.dbo.tbl_ocorrencia_lote_batch                                                                                
            (                                           
                id_campanha,                                                                                
                id_devedor,                                             
                obs,                                                                                
                usuario,                                                                                
                cod_ocorrencia,                                                                                
  data_insercao,                                                                                
                query                                                                                
)                                                                                
            SELECT DISTINCT                                           
              288,                                                                         
                id_devedor,                                                                                
                obs,                                                                                
                'CARGA AUTOMATICA',                                                      
                '2003',                    
                GETDATE(),                                                                                
                '' AS query                                                                                
            FROM #telefone_inativo (NOLOCK)                                                                                
            WHERE NOT EXISTS                                                                                
            (                                                                                
                SELECT 1                                  
                FROM dbo.tbl_ocorrencia tbl_ocorrencia                                                                         
                    INNER JOIN dbo.tbl_ligacao tbl_ligacao                                                                                
                        ON tbl_ocorrencia.id_ligacao = tbl_ligacao.id_ligacao                                                
                    INNER JOIN dbo.tbl_atendimento tbl_atendimento                                                                                
                        ON tbl_ligacao.id_atendimento = tbl_atendimento.id_atendimento                                                                                
                    INNER JOIN dbo.tbl_tipo_ocorrencia tbl_tipo_ocorrencia                                                                         
                        ON tbl_ocorrencia.id_tipo_ocorrencia = tbl_tipo_ocorrencia.id_tipo_ocorrencia                                                                                
                WHERE cod_ocorrencia = 2003                                                                                
                      AND obs = obs                        
                      AND tbl_atendimento.id_devedor = #telefone_inativo.id_devedor                                                                                
            );                                                                       
                              
                                                                                
            -- Verifica os casos que estão ativo na carga atualizamos os dados do  telefone                                                                                                    
            SELECT b.id_devedor,                                                                                
                   b.id_telefone AS id_telefone_cliente,                                                                                
                   b.ativo,                            
                   b.cod_area,                                                                                
                   b.telefone,                                                      
                   b.usuario_alta,                                                                                
                   b.fecha_alta,                                                                                
                   b.usuario_ult_mod,                                                                
                   b.fecha_ult_mod,                                              
                   b.origem,                                                                                
                   a.id_telefone,                                                                                
                   b.id_lote,                                    
                   b.tipo_telefone,                                                                                
                  -- b.CodEfectividad,                            
                   b.NroPrioridad                                                                                
            INTO #telefone_ativo --DROP TABLE   #telefone_ativo                                                                                           
            FROM dbo.tbl_telefone a                                                                                
             JOIN tbl_importacao_recovery_telefones_novo_web_robo b                                                                                
     ON a.id_devedor = b.id_devedor                                                                                
                       AND a.telefone = b.telefone                                                                                
                       AND LEFT(CAST(CAST(SUBSTRING(b.cod_area, CHARINDEX('(', b.cod_area) + 1, 4) AS INT) AS VARCHAR), 4) = a.ddd                                                                            
            WHERE b.ativo = 1                                            
   AND b.blacklist <> 1                                              
                                               
                                                                                 
            CREATE INDEX ix_telefone_ativo ON #telefone_ativo (id_devedor);                                       
            CREATE INDEX ix_telefone_ativo_id_telefone_cliente                       
            ON #telefone_ativo (id_telefone_cliente);                                                                                
            CREATE INDEX ix_telefone_ativo_id_telefone                                                                                
     ON #telefone_ativo (id_telefone);                                                                                
                                                                                
            UPDATE tbl_telefone                                                                                
             SET ativo = #telefone_ativo.ativo,                                      
                id_telefone_cliente = #telefone_ativo.id_telefone_cliente,                                                                                
                ddd = LEFT(CAST(CAST(SUBSTRING(                                                                                
      #telefone_ativo.cod_area,                                                                         
                                                  CHARINDEX('(', #telefone_ativo.cod_area) + 1,                                                                                
                                                             4                                                                                
                                              ) AS INT) AS VARCHAR), 4),                                                           
                telefone = #telefone_ativo.telefone,                                                                                
            usuario_alta = #telefone_ativo.usuario_alta,                                                                    
                fecha_alta = #telefone_ativo.fecha_alta,                                                                                
                usuario_ult_mod = #telefone_ativo.usuario_ult_mod,                                                                                
                fecha_ult_mod = #telefone_ativo.fecha_ult_mod,                                                                                
                origem = #telefone_ativo.origem,                                                                                
                id_lote = #telefone_ativo.id_lote,      
                tipo_telefone = #telefone_ativo.tipo_telefone,                                                                                
              --  CodEfectividad = #telefone_ativo.CodEfectividad,                                     
                NroPrioridad = #telefone_ativo.NroPrioridad                                 
            FROM #telefone_ativo                                                                             
                JOIN dbo.tbl_telefone                                                                      
                    ON #telefone_ativo.id_telefone = dbo.tbl_telefone.id_telefone;                                                       
                                                                                
            --====================================================================                                                                                                        
            -- Gravamos as  informações de retorno  das informações de remesa                                              
            --====================================================================                                                                                                        
                                                                                
UPDATE tbl_historico_envio_telefone                                                                                
            SET id_telefone_cliente = b.id_telefone,                                                                                
   ativo = 0,                                                               
                data_retorno = GETDATE()                                                                                
            FROM tbl_historico_envio_telefone a                                                                                
                JOIN tbl_importacao_recovery_telefones_novo_web_robo b                                                                                
              ON a.IDContato = b.id_contato                                          
                       AND a.ddd = b.cod_area                                                   
                       AND a.telefone = b.telefone                                                                                
            WHERE a.ativo = 1;                                                        
                                                                                
            UPDATE tbl_telefone                                                                 
            SET tipo_telefone = tbl_importacao_recovery_telefones_novo_web_robo.tipo_telefone                                                                                
            FROM dbo.tbl_telefone                                                                                
                JOIN tbl_importacao_recovery_telefones_novo_web_robo                                                    
                    ON dbo.tbl_telefone.id_devedor = dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
                       AND dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = tbl_telefone.id_telefone_cliente;                                                                                
                                                                                
            BEGIN -- [ INICIO - Insere tbl_telefone ]                                                                                                  
                                                                                
                                                                     
                                                                                
            SELECT pk_telefones,                                                                                
                     id_contato,                                                                 
                       id_telefone,                                                                                
                       origem,                                                      
            NroPrioridad,                                         
                       ROW_NUMBER() OVER (PARTITION BY id_telefone ORDER BY id_contato DESC) AS fake_id                                                                           
    INTO #tmp_ajusteTel --DROP TABLE #tmp_ajusteTel                                                                                            
                FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo;                                                                                
                                                                                
                CREATE INDEX ix_ajusteTel ON #tmp_ajusteTel (id_telefone);                                                             
                                                                                
                                                                                
                SELECT COUNT(id_telefone) AS num,                                                                                
                       id_telefone,                                                                                
                id_contato                                                                                
                INTO #tmp_delete_tel_dupl --DROP TABLE #tmp_delete_tel_dupl                                                                                            
                FROM #tmp_ajusteTel                                                                         
                GROUP BY id_telefone,                                       
                         id_contato                                                                                
                HAVING COUNT(id_telefone) > 1;                                                                                
                                                                                
                                                                                
                CREATE INDEX ix_delete_tel_dupl ON #tmp_delete_tel_dupl (id_telefone);                                                                                
                                                    
                                                                                
                DELETE #tmp_ajusteTel                                                                                
                FROM #tmp_ajusteTel                                                                                
                    JOIN #tmp_delete_tel_dupl                                                                                
                        ON #tmp_delete_tel_dupl.id_telefone = #tmp_ajusteTel.id_telefone                                                                                
                           AND #tmp_delete_tel_dupl.id_contato = #tmp_ajusteTel.id_contato                                                                                
                WHERE num = fake_id;                                                                                
                                                            
                                                                                
                DELETE tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                FROM tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                WHERE NOT EXISTS                                                                                
      (                                                                                
                   SELECT *                                                            
                    FROM #tmp_ajusteTel                                                                                
                    WHERE tbl_importacao_recovery_telefones_novo_web_robo.origem = #tmp_ajusteTel.origem                                                                                
                          AND tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = #tmp_ajusteTel.id_telefone                                                                                
                );                                                                                
                       
                                                        
                                                                        
  SELECT id_contato,                                     
                id_telefone,                                                               
tipo_telefone,                                                                        
                cod_pais,                                                                        
                cod_area,                                                                        
                telefone,                                                                        
             --   interno,                                                                        
   --  observacoes,                                                                        
                data_verificacao,                                                                        
                usuario_verificador,                                                                        
               id_lote,                                                                                    
    id_devedor,                       
                envio,                                                                        
                ativo,                                                                        
                usuario_alta,                                                                        
                fecha_alta,                                                                        
                usuario_ult_mod,                                                                        
                fecha_ult_mod,                                                                        
                origem,                                                                        
               -- SkipTrace,                                                                        
                blacklist,                                                                        
              --  CodEfectividad,                                               
                NroPrioridad,                                                                        
   ROW_NUMBER() OVER (PARTITION BY id_telefone ORDER BY id_contato DESC) AS fake_id                                                                         
   INTO #tmp_importacao_recovery_telefones_novo_web_robo                                             
   FROM tbl_importacao_recovery_telefones_novo_web_robo                                                                        
                                                   
                                                                    
    INSERT INTO tbl_telefone                                                                                
                (                                                                                
                    id_devedor,                                                                                
                    ddd,                                                                                
                    telefone,                                                                                
                   -- ramal,                  
               tipo_telefone,                                                                                
                    id_lote,                                                                                
                    operador,                                                          
                    id_telefone_cliente,                                                                                
                    ativo,                                                                     
                    usuario_alta,                                       
                    fecha_alta,                                                                                
                    usuario_ult_mod,                                                                                
                    fecha_ult_mod,                                                                 
                    origem,                                                                                
                   -- CodEfectividad,                                                                                
   NroPrioridad                                                                         
                )                              
                SELECT DISTINCT                                                                                
                    id_devedor,                                                                                
                    LEFT(CAST(CAST(SUBSTRING(tbl_importacao_recovery_telefones_novo_web_robo.cod_area, CHARINDEX('(', tbl_importacao_recovery_telefones_novo_web_robo.cod_area) + 1, 4) AS INT) AS VARCHAR), 4) AS ddd,                                       
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
          
                                    
                                      
                                        
                                         
               tbl_importacao_recovery_telefones_novo_web_robo.telefone AS telefone,                                                                                
                    --LEFT(interno, 5) AS ramal,                                    
                    CASE                                                                                
         WHEN envio = 1 THEN                                                                                
                            LEFT('TELEFONE HOT', 15)                                                             
                        ELSE                                                                                
                            LEFT(tipo_telefone, 15)                                             
                    END AS tipo_telefone,                                                                                
                    id_lote,                                                                                
                    'CARGA AUTOMATICA' AS operador,                          
     tbl_importacao_recovery_telefones_novo_web_robo.id_telefone,                                                               
                    CASE                                                                                
              WHEN ISNULL( tbl_importacao_recovery_telefones_novo_web_robo.ativo, 1) <> 1 THEN                                                                              
                            0                                                                                
                        ELSE                                                                                
                            1                                                                                
                    END AS ativo,                                          
                    tbl_importacao_recovery_telefones_novo_web_robo.usuario_alta,                                      
                    tbl_importacao_recovery_telefones_novo_web_robo.fecha_alta,                                                                                
                    usuario_ult_mod,                   
                    fecha_ult_mod,                                                                                
                    origem,                                                                                
                  --  CodEfectividad,                                                                                
                    NroPrioridad                                                                      
             FROM #tmp_importacao_recovery_telefones_novo_web_robo tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                    JOIN #ultima_data_maior                                                                                
     ON #ultima_data_maior.id_telefone = tbl_importacao_recovery_telefones_novo_web_robo.id_telefone                                                                                
       AND tbl_importacao_recovery_telefones_novo_web_robo.fake_id = #ultima_data_maior.fake_id                                                                             
                WHERE id_devedor IS NOT NULL                                                                                
                      AND tbl_importacao_recovery_telefones_novo_web_robo.cod_area IS NOT NULL                                                                              AND tbl_importacao_recovery_telefones_novo_web_robo.telefone IS NOT NULL           
 
     
      
        
         
            
              
                 
                                                                     
                      AND ISNUMERIC(tbl_importacao_recovery_telefones_novo_web_robo.cod_area) = 1                                                                    
                      AND LEN(tbl_importacao_recovery_telefones_novo_web_robo.telefone) < 10                                                                         
       AND tbl_importacao_recovery_telefones_novo_web_robo.fake_id =1                                              
    AND tbl_importacao_recovery_telefones_novo_web_robo.ativo = 1                                            
    AND tbl_importacao_recovery_telefones_novo_web_robo.blacklist <> 1                                                                          
                      AND CASE                                                                           
          WHEN ISNULL(tbl_importacao_recovery_telefones_novo_web_robo.ativo, 1) <> 1 THEN                                                                                
                0                                                                                
                              ELSE                                                                                
                                  1                                                                                
                          END = 1                                                                                
                      AND NOT EXISTS                                                                   
                (                           
                    SELECT 1                                                                                
                    FROM tbl_telefone WITH (NOLOCK)                                                                                
                    WHERE tbl_importacao_recovery_telefones_novo_web_robo.telefone = tbl_telefone.telefone                                             
               AND LEFT(CAST(CAST(SUBSTRING(tbl_importacao_recovery_telefones_novo_web_robo.cod_area, CHARINDEX('(', tbl_importacao_recovery_telefones_novo_web_robo.cod_area) + 1, 4) AS INT) AS VARCHAR), 4) = tbl_telefone.ddd )                          
          AND tbl_importacao_recovery_telefones_novo_web_robo.telefone NOT IN ('996448285','988161687')                        
                            
                             
                                                   
                                                                        
            END; -- [ FIM ]                                                                                         
                                                                                
            IF ISNULL(                                                                                
          (                                                    
                   SELECT COUNT(*)                                                                                
                   FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                   WHERE LEN(telefone) >= 10                                                                                
               ),                                                                                
               0                           
                     ) > 0                                                                              
        BEGIN                                                   
                SELECT 'TELEFONE COM MAIS DE 9 CARACTERES',                                                                                
                id_contato,                                                                                
                       tipo_telefone,                                                                                
                       cod_area,                                                                                
     telefone,                                                                                
                       id_devedor                                                                  
                FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                                                                                
  WHERE LEN(telefone) >= 10;                                                                                
            END;                                                                                
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                        
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                  
                                               'ALTERAÇÃO  PARA ATUALIZAR  O USUARIO_ALTA PARA CALLFLEX QUANDO VIER NA CARGA',                                                                                
                                        'FALSE';                                   
            BEGIN -- [ INICIO - Alteração  para   atualizar  o usuario_alta para CALLFLEX quando vier na carga ]                                                                                                  
                                                                                
                UPDATE tbl_telefone                                                                                
                SET usuario_alta = 'CALLFLEX',                                                                                
                    usuario_ult_mod = 'CALLFLEX'                                                                    
              FROM dbo.tbl_telefone                                                                                
                    JOIN tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                        ON dbo.tbl_telefone.id_devedor = dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
                           AND dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = tbl_telefone.id_telefone_cliente                                                                                
                WHERE tbl_importacao_recovery_telefones_novo_web_robo.usuario_alta = 'CALLFLEX'         
                      AND ISNULL(tbl_telefone.usuario_alta, '') <> 'CALLFLEX';                                                                                
                       
                UPDATE tbl_telefone                                                                                
                SET tipo_telefone = 'TELEFONE HOT'                                                                                
                 FROM dbo.tbl_telefone                                                                                
                    JOIN tbl_importacao_recovery_telefones_novo_web_robo                                                                                
                        ON dbo.tbl_telefone.id_devedor = dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                              
                           AND dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = tbl_telefone.id_telefone_cliente                                                                                
                WHERE tbl_importacao_recovery_telefones_novo_web_robo.envio = '1'                                                     
                AND tbl_telefone.tipo_telefone <> 'TELEFONE HOT'                                                                                
                      AND tbl_telefone.telefone IS NOT NULL                                                               
                      AND dbo.tbl_telefone.telefone <> '0'                                                                                
                      AND tbl_importacao_recovery_telefones_novo_web_robo.ativo = 1;          
                                                                          
                                                                             
                UPDATE tbl_telefone                                                                        
           SET tipo_telefone = 'TELEFONE HOT'                                                                                
                 FROM dbo.tbl_telefone                                                                         
                    JOIN tbl_importacao_recovery_telefones_novo_web_robo                                                                                
  ON dbo.tbl_telefone.id_devedor = dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
                           AND dbo.tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = tbl_telefone.id_telefone_cliente                             
                WHERE --tbl_importacao_recovery_telefones_novo_web_robo.SkipTrace = '1'                                                                                
                     -- AND                                                                      
       tbl_telefone.tipo_telefone <> 'TELEFONE HOT'                                                                                
                      AND tbl_telefone.telefone IS NOT NULL                                                                                
                      AND dbo.tbl_telefone.telefone <> '0'                                                                                
  AND tbl_importacao_recovery_telefones_novo_web_robo.ativo = 1;                                                                                
                                                                                
            END; -- [ FIM ]                                                                                                  
                             
        END; -- [ FIM ]                                                                                                  
                                                                                
        BEGIN -- [ INICIO - E-MAIL  ]                                                                                              
                                                                                
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                    'IMPORTACAO',                                                                        
                                     'Carteira - 288',                                                                                
                                               'AJUSTA O E-MAIL DO CLIENTE',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualizar se não tem e-mail preenchido na tbl_devedor ]           
                                                                                
                -----------------------------------------------------------------------------------------                                                                                                  
                --## marcando o registro para saber a data da ultima vez que foi enviado como blacklist.                                                                                                  
       -----------------------------------------------------------------------------------------                                                                                                  
    UPDATE tbl_telefone_blacklist                                                                                
                SET data_ultima_atualizacao = GETDATE()                                                                                
               FROM dbo.tbl_importacao_recovery_telefones_web_robo_blacklist b                                                                                
                    INNER JOIN dbo.tbl_telefone_blacklist AS tbl_telefone_blacklist                                                  
                        ON tbl_telefone_blacklist.id_devedor = b.id_devedor                                                                                
         AND tbl_telefone_blacklist.ddd = b.cod_area                                                                                
                         AND tbl_telefone_blacklist.telefone = b.telefone;                                    
                                                                                
                IF OBJECT_ID('tempdb..#telefone_blacklist') IS NOT NULL                                                                                
                BEGIN                                                                                
                    DROP TABLE #telefone_blacklist;                          
                END;                                                                                
                                                                                
                SELECT b.id_devedor,                                                                                
                       b.cod_area,                                                                                
                       b.telefone,                             
                       GETDATE() AS data_inclusao,                                                                      
                       GETDATE() AS data_inicio_vigencia,                                                                                
        NULL AS data_fim_vigencia                                                  
        INTO #telefone_blacklist                                                                                
              FROM dbo.tbl_importacao_recovery_telefones_web_robo_blacklist b                                                
        WHERE 1 = 1                                                                                
                     AND ISNULL(b.id_devedor, 0) <> 0                                                    
                      AND ISNUMERIC(b.cod_area) = 1                                                                                
                      AND ISNUMERIC(b.telefone) = 1                                                                                
                     AND NOT EXISTS                                                               
                (                                                                                
                    SELECT 1                                                                                
                    FROM dbo.tbl_telefone_blacklist WITH (NOLOCK)                                                                                
                    WHERE 1 = 1                                                                             
                          AND id_devedor = b.id_devedor                                                                                
                          AND ddd = b.cod_area                                                                                
          AND telefone = b.telefone                                                                                
                      );                                                                                
                                                                                
                CREATE CLUSTERED INDEX ndx                                                                          
                ON #telefone_blacklist                                                                                
                (                                                                                
                    id_devedor,                              
                    cod_area,                                                                                
                    telefone                                                                                
                );                                                                                
                                                                                
                INSERT INTO dbo.tbl_telefone_blacklist                                                                                
                (                          
                    id_devedor,                                                                                
                    ddd,                                                                               
                    telefone,                                                                                
                    data_inclusao,                                                                                
                    data_inicio_vigencia,                                                                                
                    data_fim_vigencia                                                                                
                )                        
                SELECT id_devedor,                                                                                
                       LEFT(cod_area, 2) AS cod_area,                                                                       
                       telefone,                                                                                
                       data_inclusao,                                                                      
                       data_inicio_vigencia,                                                                                
                       data_fim_vigencia                                            
          FROM #telefone_blacklist                                                                                
                ORDER BY id_devedor;                                                                                
                                                                                
                DECLARE @id_ocorrencia_retorno INT = 0;                                                                                
                DECLARE @observacao_bkl VARCHAR(500) = '';                                                                                
                DECLARE @id_devedor_bkl INT;                                                                                
                DECLARE @ddd_bkl CHAR(2);                                                                 
                DECLARE @telefone_bkl VARCHAR(9);                                                                                
                DECLARE @data_processamento DATETIME = GETDATE();                                      
                                      
                DECLARE blacklist_cursor CURSOR FOR                                              
                SELECT DISTINCT                                                                                
                    tbl_telefone.id_devedor,                                                                   
                    tbl_telefone.ddd,                                    
                    tbl_telefone.telefone                                                                                
                FROM #telefone_blacklist                                                                                
                    INNER JOIN dbo.tbl_telefone WITH (NOLOCK)                                                                                
                        ON tbl_telefone.id_devedor = #telefone_blacklist.id_devedor                                                                                
             AND tbl_telefone.ddd = #telefone_blacklist.cod_area                                                        
AND tbl_telefone.telefone = #telefone_blacklist.telefone                                                                                
                WHERE 1 = 1                                   
                      AND                                                              
        (                                                                              
                          tbl_telefone.ativo = 0                                                                                
                          OR tbl_telefone.ativo = 1                                   
);                                                                                
                                                                                
                OPEN blacklist_cursor;                                                                                
                                                                 
        FETCH NEXT FROM blacklist_cursor                                                                                
                INTO @id_devedor_bkl,                               
          @ddd_bkl,                                                                                
                     @telefone_bkl;                                                                                
                                                                                
                WHILE @@FETCH_STATUS = 0                                                                                
                BEGIN                                                                                
                                 
                    SET @observacao_bkl                                                                                
                        = 'TELEFONE BLOQUEADO (' + ISNULL(@ddd_bkl, '') + ') ' + @telefone_bkl                                                                           
                          + ' - BLACKLIST RECOVERY';                                                                                
                                                                                
                    EXEC dbo.proc_insere_ocorrencia_padrao @id_devedor = @id_devedor_bkl,                         -- int                                                                                                  
                                                           @id_campanha = 0,                                       -- int                                                                                                  
                                                           @obs = @observacao_bkl,                                 -- varchar(500)                                                
                                                           @operador = 'CARGA_BAIXA',                              -- varchar(30)                                                                                                  
                             @cod_ocorrencia = '2003',                               -- varchar(10)                                                            
              @data_ocorrencia = @data_processamento,                 -- datetime                                                                                                  
                                                           @numero_parcela = '',                                   -- varchar(5)                                                                                                  
                                      @tipo_devedor = '',                                     -- char(1)                                                            
                              @id_tipo_atendimento = '6',                             -- char(1)                                                                                                  
                                                           @id_tipo_ligacao = '',                                  -- char(1)                                                                                                  
                      @complemento = '',                                      -- varchar(20)                                                                                  
                                                           @retorno_id = 0,                                -- int                                                                                                  
          @id_boleto = 0,                                         -- int                                               
                                                           @id_telefone = 0,                                       -- int                                                                           
       @tabela_telefone = '',            -- char(1)                                                                                                  
                                @telefone = '',                                         -- varchar(20)                                                                                                  
                                                           @id_ocorrencia_cliente = 0,                             -- bigint                                         
                                                           @id_ligacao = 0,         -- int                                        
                                    @id_atendimento = 0,                                    -- int                                                                                    
                                                           @id_ocorrencia_retorno = @id_ocorrencia_retorno OUTPUT, -- int                                                                         
                                                    @id_tipo_canal = 0,      -- int                                                                                                  
               @id_email = 0,                                          -- int                                                                                                  
                                                           @id_endereco = 0,                                     -- int                                                                             
                                                           @data_fim = @data_processamento,                        -- datetime                                                                                                
                                                           @id_tipo_discador = 0;                                  -- int                                                                                                  
                                                                              
                    FETCH NEXT FROM blacklist_cursor                                                                                
                    INTO @id_devedor_bkl,                                                                                
                         @ddd_bkl,                                                                   
                         @telefone_bkl;                                                                         
                                                                                
 END;                                                                                
                                                                                
                CLOSE blacklist_cursor;                                          
    DEALLOCATE blacklist_cursor;                                                                                
                                                
                --## inativando telefone marcando como blacklist                                                                                          
                UPDATE tbl_telefone                                                                                
                SET ativo = 255 -- [255] inativação solicitada pelo contratante                                                                          
                FROM #telefone_blacklist                                                                                
                    INNER JOIN dbo.tbl_telefone WITH (NOLOCK)                                                                                
                        ON tbl_telefone.id_devedor = #telefone_blacklist.id_devedor                                                
                        AND tbl_telefone.ddd = #telefone_blacklist.cod_area                                                                          
                           AND tbl_telefone.telefone = #telefone_blacklist.telefone                                                                                
                WHERE 1 = 1                                                                                
                      AND                                                                                
                      (                                                  
                          tbl_telefone.ativo = 0                                                                                
                          OR tbl_telefone.ativo = 1                                                      
                      );                                                                                
                                                                                
                --===================     
                --   gravar  log  --                                                                                                                                                          
                --===================                              
                                                                                
                UPDATE tbl_devedor                                                                                
            SET email = LOWER(tbl_importacao_recovery_emails_novo_web_robo.email),                                                                                
                    aceita_receber_email = CASE                                                                                
                                               WHEN ISNULL(tbl_importacao_recovery_emails_novo_web_robo.envio, 'SI') = 'SI' THEN                                                                                
                                                   1                                                                                
             ELSE                                                                                
                                                   0                                                                                
                                       END,                                                                                
                    id_email_cliente = tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email                                                            
                FROM tbl_importacao_recovery_emails_novo_web_robo                                                                                
                    INNER JOIN tbl_devedor                                  
                        ON tbl_importacao_recovery_emails_novo_web_robo.id_devedor = tbl_devedor.id_devedor                                                                                
                WHERE tbl_importacao_recovery_emails_novo_web_robo.email IS NOT NULL                                                                                
                      AND ISNULL(   CASE                                                                                
                                        WHEN dbo.tbl_importacao_recovery_emails_novo_web_robo.ativo = 'True' THEN                                                                                
                           1                                                                      
                                        WHEN dbo.tbl_importacao_recovery_emails_novo_web_robo.ativo = 1 THEN                                                                                
                                1                                                                                
                             ELSE                                                                                
                                            0                                                                                
   END,                                         
                                    1                                                               
                             ) = 1                                                          
 AND ISNULL(dbo.tbl_importacao_recovery_emails_novo_web_robo.envio, 'SI') = 'SI';                                                                   
                                                  
                                                         
    UPDATE tbl_devedor                                     
                SET email = LOWER(tbl_importacao_recovery_emails_novo_web_robo.email),                     
                    aceita_receber_email = CASE                                                                                
                                               WHEN ISNULL(tbl_importacao_recovery_emails_novo_web_robo.envio, 'SI') = 'SI' THEN                                                                                
                                                   1                       
                                               ELSE                                                                                
                0                                                                                
                                           END,                                                                                
                    id_email_cliente = tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email                                                                                
              FROM tbl_importacao_recovery_emails_novo_web_robo                                                                                
                    INNER JOIN tbl_devedor                                                                                
                        ON tbl_importacao_recovery_emails_novo_web_robo.id_devedor = tbl_devedor.id_devedor                                                     
                           AND tbl_devedor.id_email_cliente = tbl_importacao_recovery_emails_NOVO_web_robo.id_endereco_email                                                                                
                WHERE tbl_importacao_recovery_emails_NOVO_web_robo.email IS NOT NULL                                                                                
                      AND ISNULL(   CASE                                                                         
                                        WHEN dbo.tbl_importacao_recovery_emails_NOVO_web_robo.ativo = 'True' THEN                                                                     
                                            1                                                                                
 WHEN dbo.tbl_importacao_recovery_emails_NOVO_web_robo.ativo = 1 THEN                                                     
              1                                                                                
                                        ELSE                                                                                
                                            0                                                                                
                                    END,                                                                                
                                    0                 
             ) = 0;                                                                                                          
                                                                                
            END; -- [ FIM ]                                                                                                  
               
     EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
                                           'INSERE NOVOS E-MAILS PARA O CLIENTE',                                                                                
              'FALSE';                                                                                
            BEGIN -- [ INICIO - Insere novos e-mails para o cliente ]                                                                       
                                                            
                --- atualizar os e-mails que houveram alteração.                                 
                                           
                UPDATE a                                                 
                SET email = b.email,                      
   usuario_alta = b.usuario_alta,                                                                                
                    fecha_alta = b.fecha_alta,                                                                                
                    usuario_ult_mod = b.usuario_ult_mod,                                                                                
                    fecha_ult_mod = b.fecha_ult_mod,                                                                           
                    origem = b.origem,                                                                                
   aceita_receber_email = CASE                                                                                
                                               WHEN ISNULL(b.envio, 'SI') = 'SI' THEN                                                                                
                                                   1                                                                                
     ELSE                                                                                
                                                   0                  
                                           END,                                                                                
                    id_email_cliente = CASE                                                                                
                                           WHEN b.ativo IN ( 'FALSE', '0' ) THEN                                                                                
                                               0                                                                                
                               ELSE                         
                                               id_email_cliente                                                                                
                                       END, --- se está inativo no arquivo, zero o id_email_cliente                                                                                                        
                   -- CodEfectividad = b.CodEfectividad,  Rodrigo                                                                              
                    NroPrioridad = b.NroPrioridad                                                                                
                 FROM dbo.tbl_email a                                                                                
                    INNER JOIN dbo.tbl_importacao_recovery_emails_NOVO_web_robo b                                                                                
                        ON id_email_cliente = id_endereco_email                                                                                
                WHERE b.email IS NOT NULL;                                  
                                                                                
                UPDATE tbl_email                                                                                
                SET data_exclusao = tbl_importacao_recovery_emails_novo_web_robo.fecha_ult_mod                                                                          
        FROM tbl_email                                                                                
              JOIN dbo.tbl_importacao_recovery_emails_novo_web_robo                                                                                
                        ON id_endereco_email = id_email_cliente                
            WHERE ativo = 0;                                                                                
                                                                                
                UPDATE dbo.tbl_email                                                                                
             SET id_email_cliente = dbo.tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email,                                                                                
                    id_lote = CASE                                                                                
                                  WHEN tbl_email.id_lote IS NULL THEN                           
                                 tbl_importacao_recovery_emails_novo_web_robo.id_lote                                                      
                    ELSE                                                                                
                tbl_email.id_lote                                                                               
                              END,                                                           
                    usuario_alta = tbl_importacao_recovery_emails_novo_web_robo.usuario_alta,                                                                                
                    fecha_alta = tbl_importacao_recovery_emails_novo_web_robo.fecha_alta,                                 
                    usuario_ult_mod = tbl_importacao_recovery_emails_novo_web_robo.usuario_ult_mod,                                                               
                    fecha_ult_mod = tbl_importacao_recovery_emails_novo_web_robo.fecha_ult_mod,                                                                                
                    origem = tbl_importacao_recovery_emails_novo_web_robo.origem,                                                                                
                  --  CodEfectividad = tbl_importacao_recovery_emails_novo_web_robo.CodEfectividad,      Rodrigo                                                                          
                    NroPrioridad = tbl_importacao_recovery_emails_novo_web_robo.NroPrioridad                                                                                
             FROM dbo.tbl_importacao_recovery_emails_novo_web_robo                                       
                    INNER JOIN dbo.tbl_email                                                                                
                   ON tbl_importacao_recovery_emails_novo_web_robo.id_devedor = tbl_email.id_devedor                                                                                
                           AND tbl_importacao_recovery_emails_novo_web_robo.email = dbo.tbl_email.email                                                                                
                WHERE (                                                                                
                          tbl_email.id_email_cliente = 0                                                             
                          OR tbl_email.id_email_cliente IS NULL                                                                                
                      )                   
                      AND tbl_importacao_recovery_emails_novo_web_robo.email IS NOT NULL;                                                                                
                                                                                
                INSERT INTO dbo.tbl_email                                                                                
                (                                                                                
                    id_devedor,                                                                                
                    email,                                                                                
                    aceita_receber_email,                                                     
                    data_cadastro,                                                                                
                    data_validacao,                                                                                
                operador,                                                                                
                    id_lote,                                                                                
                    id_lote_pesquisa,                                                                                
                    id_email_cliente,                                                                                
                    usuario_alta,                                                                                
                    fecha_alta,                                                                                
                    usuario_ult_mod,                                      fecha_ult_mod,                                                                                
                    origem,                                                                         
    data_exclusao,                                                                          
                  --  CodEfectividad,                                                                                
NroPrioridad                               
                )                               
                SELECT dbo.tbl_importacao_recovery_emails_novo_web_robo.id_devedor,                                                                                
                       dbo.tbl_importacao_recovery_emails_novo_web_robo.email,                                        
                       CASE                                                                                
                           WHEN ISNULL(tbl_importacao_recovery_emails_novo_web_robo.envio, 'SI') = 'SI' THEN                                                                
         1                                                                                
                           ELSE                                                                           
                     0                                                                                
                       END,                                                                                
              GETDATE() AS data_cadastro,                                                                        
             GETDATE() AS data_validacao,                                     
                       'CARGA AUTOMATICA' AS operador,                                           
                       dbo.tbl_importacao_recovery_emails_novo_web_robo.id_lote,                                                                                
                       NULL AS id_lote_pesquisa,                                                                                
                       dbo.tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email,                                                                         
        usuario_alta,                                                                                
         fecha_alta,                                                     
                       usuario_ult_mod,                                                                                
                       fecha_ult_mod,                                                                                
                       origem,                                                                   
                      CASE                                                                                
                           WHEN tbl_importacao_recovery_emails_novo_web_robo.ativo IN ( 'FALSE', '0' ) THEN                                                                                
                               GETDATE()                                                                             
                           ELSE                                                                  
        NULL                                                  
                       END AS data_exclusao,                                                                                
                       --CodEfectividad,                                                                                
                       NroPrioridad                                                                                
                FROM tbl_importacao_recovery_emails_novo_web_robo                                                                                
                WHERE tbl_importacao_recovery_emails_novo_web_robo.email IS NOT NULL                                                                                
   AND tbl_importacao_recovery_emails_novo_web_robo.id_devedor IS NOT NULL                                                                                
                      AND ISNULL(   CASE                                                                                
                                        WHEN dbo.tbl_importacao_recovery_emails_novo_web_robo.ativo = 'True' THEN                                                                                
              1                                                                                
                                        WHEN dbo.tbl_importacao_recovery_emails_novo_web_robo.ativo = 1 THEN                                                                                
1                                                                      
                                        ELSE                                                                                
                                  0                               
                                    END,                                                                                
1                                               
                             ) = 1                                             
                      AND NOT EXISTS                               
                (                                                                                
                    SELECT 1                                                                                
                    FROM dbo.tbl_email                                                                                
                    WHERE tbl_importacao_recovery_emails_novo_web_robo.id_devedor = tbl_email.id_devedor                                                                                
        AND tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email = ISNULL(                                                                                
                                                                                                    dbo.tbl_email.id_email_cliente,                                                                                
       0                                                                                
                                       )                                                                                
                );                                 
                                                          
            END; -- [ FIM ]                                                                                                  
                                                                       
            BEGIN -- [ INICIO - Atualizaca do controle de envio/recebimento de emails para a recovery  ]                                                                                                  
                                                                    
                UPDATE tbl_historico_envio_email                                                                                
                SET id_email_cliente = b.id_endereco_email,                                                                                
                    ativo = 0,                                                                                
                    data_retorno = GETDATE()                                                                                
                FROM tbl_historico_envio_email a                                                                                
                    JOIN tbl_importacao_recovery_emails_novo_web_robo b                                                                                
                        ON a.IDContato = b.id_contato                                                                                
                           AND a.id_devedor = b.id_devedor                                                                                
                WHERE a.ativo = 1;                                                                                
                                                                                
            END; -- [ FIM ]                                                                                                  
                                                        
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                                                
                                               'Carteira - 288',                                                                                
'ATUALIZACA ID_EMAIL_CLIENTE PARA OS EMAILS QUE NÃO ESTÃO ATUALIZADOS',                                                                                
                                               'FALSE';                                                                                
            BEGIN -- [ INICIO - Atualizaca id_email_cliente para os emails que não estão atualizados ]                               
                                                                                
        --- identificar o id_contato dos e-mails                                                                                                   
             INSERT INTO dbo.tbl_email_complementar                            
                (                                                    
                    id_email,                                                                                
                    id_email_cliente,                                                                   
       id_contato                                                                                
                )                             
                SELECT DISTINCT                                                                                
                  email.id_email,                                     
                    email.id_email_cliente,                                                                            
                    email_web.id_contato                                                                                
                FROM dbo.tbl_importacao_recovery_emails_novo_web_robo email_web (NOLOCK)                                                                                
                INNER JOIN dbo.tbl_email email (NOLOCK)                                                                                
                  ON id_endereco_email = id_email_cliente                                                                                
                           AND email_web.id_devedor = email.id_devedor                                                                                
                    LEFT JOIN dbo.tbl_email_complementar email_complementar (NOLOCK)                                                                                
                        ON email.id_email = email_complementar.id_email                            
                           AND email.id_email_cliente = email_complementar.id_email_cliente                                                                                
                WHERE email_complementar.id_email_cliente IS NULL;                                                                      
                                                  
                                                                                
                                                                                
                                                                                
                INSERT INTO dbo.tbl_email_complementar_novo                                                                                
                (                                                                                
                    id_email_cliente,                                                                         
                    id_contato,                                                                          
                    carteira                                                                      
                )                                                                                
                SELECT DISTINCT                                                                                
                    tbl_importacao_recovery_emails_novo_web_robo.id_endereco_email,                                                                                
                    tbl_importacao_recovery_emails_novo_web_robo.id_contato,                                                                                
                   @carteira                                                                              
                FROM dbo.tbl_importacao_recovery_emails_novo_web_robo                                                                                
                  JOIN dbo.tbl_contrato ON firma =  tbl_importacao_recovery_emails_novo_web_robo.id_contato                                  
        JOIN dbo.tbl_contrato_ciclo ON tbl_contrato_ciclo.id_contrato = tbl_contrato.id_contrato                                                                            
        LEFT JOIN tbl_email_complementar_novo                                                                                
                        ON tbl_email_complementar_novo.id_email_cliente = id_endereco_email                                                                                
                           AND tbl_email_complementar_novo.id_contato = tbl_importacao_recovery_emails_novo_web_robo.id_contato                                                                     
      AND tbl_email_complementar_novo.carteira = @carteira                                                                                    WHERE tbl_importacao_recovery_emails_novo_web_robo.ativo = 1                                     
                      AND tbl_email_complementar_novo.id_email_complementar IS NULL                                            
       AND blacklist = 0             
    AND tbl_importacao_recovery_emails_novo_web_robo.id_devedor IS NOT null                                      
     AND dbo.tbl_contrato.carteira = @carteira                                   
                                                        
                                                                  
                SELECT id_endereco_email                                                                      
                INTO #retirar_processo_email                                                                                
                FROM dbo.tbl_importacao_recovery_emails_novo_web_robo                                                                                
                WHERE ativo = 0;                                                                                
                                      
                                                                                
                DELETE FROM dbo.tbl_email_complementar_novo                                                                                
                WHERE id_email_cliente IN (                                                                                
                         SELECT id_endereco_email FROM #retirar_processo_email                                         
                                                                                               
                                          )                                                                                
                      AND carteira = @carteira;                                              
                                                   
                                                   
        SELECT id_endereco_email                                                                                
                INTO #retirar_processo_email_blacklist                                                                                
                FROM dbo.tbl_importacao_recovery_emails_novo_web_robo                                                                                
                WHERE blacklist =1                                                                                
                                                                    
                                                      
                                                                                
                DELETE FROM dbo.tbl_email_complementar_novo                                                                                
                WHERE id_email_cliente IN (                                                                                
              SELECT id_endereco_email FROM #retirar_processo_email_blacklist                                                                                
)                                                                                
                      AND carteira = @carteira;                                                                                
                                                                       
        
   
 IF @carteira IS NOT NULL  
  BEGIN  
  
   INSERT INTO dbo.tbl_controle_email_carga_historia  
   (  
    id_endereco_email,  
    id_contato,  
    carteira,  
    data_insert  
   )  
   SELECT DISTINCT  
       b.id_endereco_email,  
       b.id_contato,  
       @carteira,  
       GETDATE()  
   FROM dbo.tbl_importacao_recovery_emails_novo_web_robo b  
   WHERE ativo = 1  
      AND b.id_endereco_email NOT IN  
       (  
        SELECT a.id_endereco_email  
        FROM tbl_controle_email_carga_historia a  
        WHERE a.id_endereco_email = b.id_endereco_email  
        AND a.carteira = @carteira  
       );  
  END;  
  
      
      
          END; -- [ FIM ]                                                                                                  
                                                                                
  END; -- [ FIM ]                                                                                                  
                                                                                
        -- ======================                                                                                                     
        -- PROCESSO DE INATIVAÇÃO                                                                        
        -- ======================                                                                                                       
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                  'IMPORTACAO',                    
'Carteira - 288',               
                             'PROCESSO DE INATIVAÇÃO',                                               
                                           'FALSE';                                                         
                                                                                
        UPDATE tbl_importacao_recovery_operacoes_novo_web_robo                                                                       
        SET id_parcela = tbl_parcela.id_parcela                                                                          
        FROM tbl_importacao_recovery_operacoes_novo_web_robo                                                                                
            INNER JOIN tbl_parcela (NOLOCK)                                                                                
                ON tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato = tbl_parcela.id_contrato                                                                                
        WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_parcela IS NULL;                                               
                                                             
                                                                                
        -- VALORES ZERADOS DEVEM SER INATIVADOS                                                                                                  
        DECLARE @id_lote AS INT;                                          
        SELECT @id_lote = id_lote                                                                                
        FROM dbo.tbl_importacao_recovery_saldo_novo_web_robo;                                                                
                                                                                
        -- Insere numa temporária todos os casos que devem ser inativados e tirar o acordo.                                                                                                  
        SELECT tbl_contrato.id_devedor,                                                                                
               tbl_contrato.id_contrato,                                                                           
               tbl_parcela.id_parcela,                                                                                
               tbl_parcela.id_acordo                                                                                
INTO #temp_processo_inativacao -- drop table #temp_processo_inativacao                                                                                                  
        FROM dbo.tbl_contrato                                                                                
            INNER JOIN tbl_parcela (NOLOCK)                                                                                
                ON tbl_contrato.id_contrato = tbl_parcela.id_contrato                                                                                
            INNER JOIN tbl_define_campanha (NOLOCK)                                                                                
                ON tbl_contrato.id_devedor = tbl_define_campanha.id_devedor                                                                                
                   AND tbl_parcela.id_contrato = tbl_define_campanha.id_contrato                                                                                
                   AND tbl_parcela.id_parcela = tbl_define_campanha.id_parcela                                                                                
       AND tbl_define_campanha.id_campanha = 288                                                                                
            INNER JOIN dbo.tbl_importacao_recovery_operacoes_novo_web_robo WITH (NOLOCK)                                            
                ON dbo.tbl_importacao_recovery_operacoes_novo_web_robo.id_devedor = tbl_contrato.id_devedor                                                                    
                   AND dbo.tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato = tbl_contrato.id_contrato                                                                          
                   AND dbo.tbl_importacao_recovery_operacoes_novo_web_robo.id_parcela = tbl_parcela.id_parcela                                           
                   AND (  dbo.tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao NOT LIKE '%ACTIVA%'                                                                                
                   OR tbl_importacao_recovery_operacoes_novo_web_robo.estado_operacao = 'INACTIVA')                                                                                                   
        WHERE tbl_parcela.ativo = 1                                                                                
              AND tbl_parcela.id_boleto_pagamento_percapita IS NULL                                                                                
              AND data_devolucao IS NULL                                                                                
        UNION ALL                                                                                
        SELECT tbl_contrato.id_devedor,                                                                                
               tbl_contrato.id_contrato,                                                                                
               tbl_parcela.id_parcela,                                                                             
               tbl_parcela.id_acordo                                                                               
        FROM dbo.tbl_contrato                                                                                
            INNER JOIN tbl_parcela (NOLOCK)                                                                                
           ON tbl_contrato.id_contrato = tbl_parcela.id_contrato                                                                                
            INNER JOIN tbl_define_campanha (NOLOCK)                                                                                
                ON tbl_contrato.id_devedor = tbl_define_campanha.id_devedor                                                                                
                   AND tbl_parcela.id_contrato = tbl_define_campanha.id_contrato                                                                                
                   AND tbl_parcela.id_parcela = tbl_define_campanha.id_parcela                                                                                
                   AND tbl_define_campanha.id_campanha = 288                                                                                
            INNER JOIN dbo.tbl_importacao_recovery_saldo_novo_web_robo (NOLOCK)                                                                                
       ON dbo.tbl_importacao_recovery_saldo_novo_web_robo.id_parcela = tbl_parcela.id_parcela                                                                                
     WHERE tbl_parcela.ativo = 1                                                                                
              AND tbl_parcela.id_boleto_pagamento_percapita IS NULL                                                                                
              AND dbo.tbl_importacao_recovery_saldo_novo_web_robo.saldo_operativo = 0;                                                                                
                                                                                
        
        -- Inativa o acordo                                                                     
        UPDATE dbo.tbl_acordo                                                                                
        SET ativo = 0                  
        FROM #temp_processo_inativacao                                                                                
        WHERE dbo.tbl_acordo.id_acordo = #temp_processo_inativacao.id_acordo;                                                                                
               
        -- Inativa as parcelas do acordo                                                            
        UPDATE dbo.tbl_parcela_acordo                                      
        SET ativo = 0                                       
        FROM #temp_processo_inativacao                                                                                
        WHERE dbo.tbl_parcela_acordo.id_acordo = #temp_processo_inativacao.id_acordo;                                                                          
        -- Inativa a parcela                                                                                                   
        UPDATE dbo.tbl_parcela                                                                                
        SET ativo = 0,                                                                                
            id_acordo = NULL,                                                                              
            id_devolucao = @id_lote,                                                                                
            data_devolucao = GETDATE(),                                                                                
            motivo_devolucao = 'A'                                                                                
        FROM #temp_processo_inativacao                                                                                
        WHERE dbo.tbl_parcela.id_parcela = #temp_processo_inativacao.id_parcela;                                                                                
                                                                                
        -- Inativa o contrato                                                                                                          
        UPDATE dbo.tbl_contrato                                                                                
        SET ativo = 0                                                                       
        FROM #temp_processo_inativacao                             
        WHERE dbo.tbl_contrato.id_contrato = #temp_processo_inativacao.id_contrato;                                                                                
                                                                                
        -- INSERE DADOS DE AVALISTA -- 06/11/2014                                                                                      
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                     
                                           'IMPORTACAO',                                                                                
                                           'Carteira - 288',                                                                                
                                           'INSERE DADOS DE AVALISTA',                                                                                
              'FALSE';                                                                                
                                                                                
        INSERT INTO dbo.tbl_avalista                          (                                                                     
   id_contato,                                                                                
            id_operacion_sir,                                                                                
            nome,                                                                  
            tipo_documento,              
            cpf_cnpj,                                                                                
            tipo_pessoa,                                                                                
            relacao,                                                        
            sexo,                                                                                
            estado_civil,                                                                                
            data_nascimento,                                 
            profissao,                                                                                
           -- categoria_IVA,                                                                                
            atividade,                        
      caract_atividade,                            
            tipo_sociedade,                                                                                
            estado,                                                                                
            data_verificacao,                                                                          
     usuario_verificador,                                      
            id_lote_original,                                                                          id_devedor                                                                                
        )                                                                                
        SELECT DISTINCT                                                                                
            tbl_importacao_recovery_contatos.id_contato,                                                                                
            0 AS id_operacion_SIR,                                                                                
       tbl_importacao_recovery_contatos.sobrenome_razaosocial AS nome,                                                                                
            tbl_importacao_recovery_contatos.tipo_doc AS tipo_documento,                                                                        
            CASE                                                                                
                WHEN tbl_importacao_recovery_contatos.tipo_pessoa LIKE 'J%' THEN                                                                                
                    cuil_cuit                                  
                ELSE                                                                                
                    nro_doc                                                                                
END AS cpf_cnpj,                                                                                
            tbl_importacao_recovery_contatos.tipo_pessoa,                                                                                
            ISNULL(tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.relacao, ''),                                                                                
            tbl_importacao_recovery_contatos.sexo,                                                           
            ISNULL(tbl_importacao_recovery_contatos.estado_civil, ''),                                                                                
            tbl_importacao_recovery_contatos.data_nascimento,                                                                                
            ISNULL(tbl_importacao_recovery_contatos.profissao, ''),                                                                                
            --ISNULL(tbl_importacao_recovery_contatos.categoria_IVA, ''),                                                                              
            ISNULL(tbl_importacao_recovery_contatos.atividade, ''),                                                                                
            ISNULL(tbl_importacao_recovery_contatos.caract_atividade, ''),                                                                   
            ISNULL(tbl_importacao_recovery_contatos.tipo_sociedade, ''),                                                                                
            ISNULL(tbl_importacao_recovery_contatos.estado, ''),                                                                    
            tbl_importacao_recovery_contatos.data_verificacao,                                                                                
            ISNULL(tbl_importacao_recovery_contatos.usuario_verificador, ''),                                                                                
            tbl_importacao_recovery_contatos.id_lote,                                                                                
       tbl_contrato.id_devedor                            
        FROM dbo.tbl_importacao_recovery_contatos_novo_web_robo tbl_importacao_recovery_contatos (NOLOCK)                                                                      
  JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo   ON IdContacto = id_contato                                      
            INNER JOIN dbo.tbl_contrato tbl_contrato (NOLOCK)                                                                                
     ON tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR = numero                                                                                
        WHERE tbl_importacao_recovery_contatos.id_devedor IS NULL                                                                                
              AND tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.relacao <> 'TITULAR'                                                                                
              AND NOT EXISTS                                           
        (                                                                                
            SELECT 1                                                                                
            FROM dbo.tbl_avalista tbl_avalista (NOLOCK)                                                                                
            WHERE tbl_avalista.id_devedor = tbl_contrato.id_devedor                                                                                
                  AND tbl_avalista.id_contato = tbl_importacao_recovery_contatos.id_contato );                                                                           
                                                                                
                                                                                
        --- Inserir os contratos de avalista                                                                                                          
                                                                                
        INSERT INTO dbo.tbl_avalista_contrato                                                         
        (                                                                    
            id_operacion_SIR,                                       
            id_devedor,                                                                                
            id_contrato,                                                                                
            id_contato                                                                                
        )                                                                        
        SELECT DISTINCT tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR,                                                                                
               tbl_contrato.id_devedor,                                                                                
               tbl_contrato.id_contrato,                                             
               tbl_importacao_recovery_contatos.id_contato                                                   
      FROM dbo.tbl_importacao_recovery_contatos_novo_web_robo tbl_importacao_recovery_contatos (NOLOCK)                                                                     
   JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo   ON IdContacto = id_contato               
            INNER JOIN dbo.tbl_contrato tbl_contrato (NOLOCK)                                                                                
           ON IdOperacion_SIR = numero                                                                                
        WHERE tbl_importacao_recovery_contatos.id_devedor IS NULL                                                                                
              AND relacao <> 'TITULAR'                                                                                
              AND NOT EXISTS                                                                                
        (                                                     
            SELECT 1                                                 
            FROM dbo.tbl_avalista_contrato tbl_avalista (NOLOCK)                                                                          
            WHERE tbl_avalista.id_devedor = tbl_contrato.id_devedor                                                                             
                  AND tbl_avalista.id_operacion_SIR = tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR                                                                               
                  AND tbl_avalista.id_contato = tbl_importacao_recovery_contatos.id_contato                                                                                
    );                                                                                
                                                                                                
                                                                                
        -- identificar telefones de avalistas.                                                                                                    
        INSERT INTO dbo.tbl_avalista_telefone                                                                                
        (                                                                                
            id_contato,                                                                                
            id_telefone_cliente,                                                                     
            tipo_telefone                                                                                                          
        )                                                     
        SELECT DISTINCT                                                                                
            tbl_avalista.id_contato,                                                                                
            tbl_importacao_recovery_telefones.id_telefone,                                                                                
            CASE                       
                WHEN envio = 1 THEN                                                                                
                    'TELEFONE HOT'                                                                                
                ELSE                                                                                
                    UPPER(LEFT(tbl_importacao_recovery_telefones.tipo_telefone, 15))                                                                                
            END AS tipo_telefone                                                                                                     
        FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo tbl_importacao_recovery_telefones                                                                               
            INNER JOIN dbo.tbl_avalista tbl_avalista                                                                                
                ON tbl_importacao_recovery_telefones.id_contato = tbl_avalista.id_contato                                                                                
        WHERE NOT EXISTS                                                                      
        (                                                                   
            SELECT 1                                                                                
            FROM dbo.tbl_avalista_telefone avalista_telefone                                                                                
            WHERE avalista_telefone.id_telefone_cliente = tbl_importacao_recovery_telefones.id_telefone                                                                                
                  AND avalista_telefone.id_contato = tbl_importacao_recovery_telefones.id_contato                                             
                                                                                     
        )                                            
  AND tbl_importacao_recovery_telefones.ativo = 1           
  AND tbl_importacao_recovery_telefones.blacklist = 0                                                                                
                                                                                
        --- INSERE TELEFONES DE AVALISTA E ASSOCIA PARA O DEVEDOR "TITULAR".                                                                                                   
                                                                                
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                      
                                           'IMPORTACAO',                                                                 
                                           'Carteira - 288',                                                                                
                                           'INSERE TELEFONES DE AVALISTA E ASSOCIA PARA O DEVEDOR - TITULAR',                                               
                               'FALSE';                                                                                
                                                                                
                                                                                
        SELECT tbl_avalista.id_devedor,                                                                                
               LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4) AS ddd,                                                                         
               tbl_importacao_recovery_telefones.telefone,                                                                                
               MAX(id_telefone) AS id_telefone                                                                                
        INTO #maior_tel_ava                                                                    
        FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo tbl_importacao_recovery_telefones                                  
            INNER JOIN dbo.tbl_avalista tbl_avalista                                                            
                ON tbl_importacao_recovery_telefones.id_contato = tbl_avalista.id_contato                                                                                
        WHERE cod_area IS NOT NULL                                                                                
              AND telefone IS NOT NULL                                                                                
              AND ISNUMERIC(cod_area) = 1                                                                                
              AND CASE                           
                      WHEN ISNULL(tbl_importacao_recovery_telefones.ativo, 1) <> 1 THEN                                                                                
                          0                                                                                
          ELSE                                               
                          1                           
      END = 1                                                                                
                                                                      
             AND NOT EXISTS                                                (                                                                                
            SELECT 1                                                             
            FROM tbl_telefone WITH (NOLOCK)                                                                                
            WHERE tbl_importacao_recovery_telefones.telefone = tbl_telefone.telefone                                                                                
                  AND LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4) = tbl_telefone.ddd                                                                                
   )                                                                                
        GROUP BY tbl_avalista.id_devedor,                                                                                
              LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4),                                                                                
   telefone;                                                                                
                                                                                
                                                                                
                                                 
        SELECT DISTINCT                                                                                
            tbl_avalista.id_devedor,                                                                                
            LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4) AS ddd,                                
            tbl_importacao_recovery_telefones.telefone AS telefone,                                                                                
          --  LEFT(interno, 5) AS ramal,                                                                       
            'AVALISTA' AS tipo_telefone,                                                                       
            id_lote,                                                                                
            'CARGA AUTOMATICA' AS operador,                                                                                
            MAX(tbl_importacao_recovery_telefones.id_telefone) AS id_telefone,                                                                                
            CASE                                                                                
                WHEN ISNULL(tbl_importacao_recovery_telefones.ativo, 1) <> 1 THEN                                                                                
                    0                                                                                
                ELSE                                                                                
                    1                                                                                
            END AS ativo                                                  
        INTO #tmp_telefone_t                                                                                
FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo tbl_importacao_recovery_telefones                              
            INNER JOIN dbo.tbl_avalista tbl_avalista                                                                                
                ON tbl_importacao_recovery_telefones.id_contato = tbl_avalista.id_contato                                                                                
            INNER JOIN #maior_tel_ava a                        
                ON a.id_telefone = tbl_importacao_recovery_telefones.id_telefone                                                          
                   AND a.telefone = tbl_importacao_recovery_telefones.telefone                                                                                
        WHERE cod_area IS NOT NULL                                                                                
              AND tbl_importacao_recovery_telefones.telefone IS NOT NULL                                                                                
              AND ISNUMERIC(cod_area) = 1                                                                                
              AND CASE                                                                                
                      WHEN ISNULL(tbl_importacao_recovery_telefones.ativo, 1) <> 1 THEN                                                                                
                          0                                                                        
                      ELSE                                            
           1                                                                                
                  END = 1                                
      AND tbl_importacao_recovery_telefones.blacklist = 0                                                                              
              AND NOT EXISTS                                                                                
        (                                                                                
            SELECT 1                                                                 
            FROM tbl_telefone WITH (NOLOCK)                                                                                
            WHERE tbl_importacao_recovery_telefones.telefone = tbl_telefone.telefone                                        
                  AND LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4) = tbl_telefone.ddd                                                                                
        )                                                         
        GROUP BY tbl_avalista.id_devedor,                                                                                
                 LEFT(CAST(CAST(SUBSTRING(cod_area, CHARINDEX('(', cod_area) + 1, 4) AS INT) AS VARCHAR), 4),                                                                                
                 tbl_importacao_recovery_telefones.telefone,                                                                                
       --   interno,                                                                                
      id_lote,                                              
                 tbl_importacao_recovery_telefones.ativo;                                                                                
                                                                                
                                                                                
                                                                                
      CREATE INDEX ix_tmp_telefone_t ON #tmp_telefone_t (id_devedor);                                                              
        INSERT INTO tbl_telefone                                                                      
        (                                                                                
            id_devedor,                                                     
  ddd,                                                                                
            telefone,                                                                                
           -- ramal,                                                           
            tipo_telefone,                                                                         
            id_lote,                                                                                
            operador,                                             
        id_telefone_cliente,                                                                                
            ativo                                                                                
        )                                                                                
        SELECT MAX(id_devedor),                                                                                
               ddd,                                                                                
               telefone,                                                                                
            --   ramal,                                       
               tipo_telefone,                                                                                
               id_lote,                                                                                
               operador,                                                                                
    id_telefone,                                                                  
             ativo                    
        FROM #tmp_telefone_t                                                                   
        GROUP BY ddd,                                                                                
                 telefone,                                                                   
               --  ramal,                                                                                
                 tipo_telefone,                                                                                
                 id_lote,                                                                               
                 operador,                                                                                
                 id_telefone,                                                                                
                 ativo;                                                                                
                                  
                                                                                
                                                                                
                                                                                
        --- identificar o id_contato do telefone                                                        
        INSERT INTO dbo.tbl_telefone_complementar                                                                                
        (                                                                                
            id_telefone,                                                                                
            id_telefone_cliente,                                                                                
            id_contato                                                                                
        )                                                         
        SELECT DISTINCT                                                                                
            telefone.id_telefone,                                                                   
            telefone.id_telefone_cliente,                                                                                
   telefone_web.id_contato                                                                                
        FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo telefone_web (NOLOCK)                                                                                
            INNER JOIN dbo.tbl_telefone telefone (NOLOCK)                                                                                
    ON telefone_web.id_devedor = telefone.id_devedor                                                                                
                   AND telefone_web.id_telefone = id_telefone_cliente                                                                                
            LEFT JOIN dbo.tbl_telefone_complementar telefone_complementar (NOLOCK)                                                                          
                ON telefone.id_telefone = telefone_complementar.id_telefone                                                     
AND telefone.id_telefone_cliente = telefone_complementar.id_telefone_cliente                                                                                
        WHERE telefone_complementar.id_telefone_complementar IS NULL                                            
  AND telefone_web.ativo = 1                                            
  AND telefone_web.blacklist = 0                                                                                
                                       
                                                                             
                                                                                
        INSERT INTO dbo.tbl_telefone_complementar_novo                                              
        (                                                                                
            id_telefone_cliente,                                                                                
            id_contato,                                    
carteira                                                                                
      )                                                                                
        SELECT DISTINCT                                                                           
            tbl_importacao_recovery_telefones_novo_web_robo.id_telefone,                                                                                
            tbl_importacao_recovery_telefones_novo_web_robo.id_contato,                                                                                
            @carteira                                                                              
         FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                                                                      
           JOIN dbo.tbl_contrato ON firma =  tbl_importacao_recovery_telefones_novo_web_robo.id_contato                                  
        JOIN dbo.tbl_contrato_ciclo ON tbl_contrato_ciclo.id_contrato = tbl_contrato.id_contrato                                                      
      LEFT JOIN tbl_telefone_complementar_novo                                                                                
                ON tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = id_telefone_cliente                                                                                
                   AND tbl_telefone_complementar_novo.id_contato = tbl_importacao_recovery_telefones_novo_web_robo.id_contato                                                                                
                   AND tbl_telefone_complementar_novo.carteira =  @carteira                                                              
        WHERE tbl_importacao_recovery_telefones_novo_web_robo.ativo = 1                                              
  AND blacklist = 0                                               
  AND tbl_importacao_recovery_telefones_novo_web_robo.id_devedor IS NOT NULL                                                                               
  AND tbl_telefone_complementar_novo.id_telefone_complementar IS NULL                                  
  AND tbl_contrato.carteira = @carteira                                                                                
                                                          
                                                                    
                                                     
     INSERT INTO dbo.tbl_telefone_complementar_novo_historias                                                                               
        (                                                                      
            id_telefone_cliente,                                                                                
            id_contato,                                                                                
            carteira,                                           
   idoperacion_sir                                                                       
        )                                                                                
        SELECT DISTINCT                                                                           
            tbl_importacao_recovery_telefones_novo_web_robo.id_telefone,                                                                                
            tbl_importacao_recovery_telefones_novo_web_robo.id_contato,                                                                                
            @carteira ,                                              
   tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo.IdOperacion_SIR                                                                        
         FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                                                             
  JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo ON IdContacto= tbl_importacao_recovery_telefones_novo_web_robo.id_contato                                                                            
            JOIN dbo.tbl_devedor                                                     
                ON tbl_devedor.id_devedor = tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
            LEFT JOIN tbl_telefone_complementar_novo_historias                                                                                
                ON tbl_importacao_recovery_telefones_novo_web_robo.id_telefone = id_telefone_cliente                                                             
                   AND tbl_telefone_complementar_novo_historias.id_contato = tbl_importacao_recovery_telefones_novo_web_robo.id_contato                                                                                
                   AND carteira = @carteira                                                                                
        WHERE ativo = 1                                                                                
              AND tbl_telefone_complementar_novo_historias.id_telefone_complementar IS NULL                                            
     AND blacklist = 0                                                                                   
                                                                             
                                                     
                                                                                  
        SELECT id_telefone                                                                                
        INTO #retirar_processo                                                                                
        FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                                                                                
 WHERE ativo = 0                                            
                                                                                  
                                     
                                                  
        DELETE FROM dbo.tbl_telefone_complementar_novo                                                                                
        WHERE id_telefone_cliente IN (                                                                                
                  SELECT id_telefone FROM #retirar_processo                                                                                
                                     )                                                                       
              AND carteira = @carteira;                                                                                
                                                                                
                                              
                                                
     SELECT id_telefone                 
        INTO #retirar_processo_blacklist                                                                                
        FROM dbo.tbl_importacao_recovery_telefones_novo_web_robo                           
        WHERE blacklist = 1                                            
                                                                                  
                                                                                
                                                                                
        DELETE FROM dbo.tbl_telefone_complementar_novo                                                                                
        WHERE id_telefone_cliente IN (                                                                                
                  SELECT id_telefone FROM #retirar_processo_blacklist                                                                                
                                     )                                                                             
              AND carteira = @carteira;                                                
                                                                          
                                            
                                
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                                                
                                           'Carteira - 288',                                                                                
 'INSERE FLAG DO TELEFONE',                                                                               
                                           'FALSE';                                                                                
                                                                                
                                                     
        --=================================================                                                                                                       
        --    INICIO - FLAG DO TELEFONE                                                                                                     
        --=================================================                                                                          
        IF OBJECT_ID('tempdb..#Telefone') IS NOT NULL                       
            DROP TABLE #Telefone;                                                                            
                                                                                
        CREATE TABLE #Telefone                                                
  (                                                                                
            id_telefone INT,                                                                    
            tipo_telefone VARCHAR(15)   
        );                                                                               
                                                                                
        INSERT INTO #Telefone                                                                                
        (                                                                             
            id_telefone,                                                                                
            tipo_telefone                                                                                
        )                                                            
        SELECT telefone.id_telefone,                                                                                
               telefone.tipo_telefone                 
        FROM tbl_telefone telefone                                                                                
            INNER JOIN tbl_importacao_recovery_telefones_novo_web_robo telefone_web_robo                         
                ON telefone_web_robo.id_telefone = telefone.id_telefone_cliente                                                                                
        WHERE telefone.telefone IS NOT NULL                                                                                
              AND telefone.telefone <> '0';                                                                                
                                                                                
        DECLARE @id_telefone_flag VARCHAR(MAX);                                                                                
        DECLARE @data_inicio_vigencia_flag DATETIME;                                                                                
                                         
        SET @id_telefone_flag = '';                                                                                
        SET @data_inicio_vigencia_flag = GETDATE();                                                                                
                                                                                
        SELECT @id_telefone_flag = @id_telefone_flag + CONVERT(VARCHAR, id_telefone) + ','                                                                                
        FROM #Telefone                                                                           
        WHERE UPPER(tipo_telefone) = 'AVALISTA';                                                                                
                                                                                
                           
        EXEC dbo.proc_flag_telefone_insere_lista_telefone @lista_telefones = '',                                                                                
                                                      @id_flag = 147,                                     
                                                          @data_inicio_vigencia = @data_inicio_vigencia_flag,                                                                                
                                                       @data_fim_vigencia = '9999-12-30 00:00:00',                                                                                
                @lista_id_telefones = @id_telefone_flag;                                                                                
                                                                               
                                                                                
        SET @id_telefone_flag = '';                                                                                
                         
        SELECT @id_telefone_flag = @id_telefone_flag + CONVERT(VARCHAR, id_telefone) + ','                                                                                
        FROM #Telefone                                                                                
  WHERE UPPER(tipo_telefone) = 'SOCIO';                                                                                
                                                                                
        EXEC dbo.proc_flag_telefone_insere_lista_telefone @lista_telefones = '',                   
                                                          @id_flag = 148,                                                                                
                                                   @data_inicio_vigencia = @data_inicio_vigencia_flag,                                                                                
                                                          @data_fim_vigencia = '9999-12-30 00:00:00',                                                                                
             @lista_id_telefones = @id_telefone_flag;                                             
                                                                 
        SET @id_telefone_flag = '';                                         
                                   
        SELECT @id_telefone_flag = @id_telefone_flag + CONVERT(VARCHAR, id_telefone) + ','                                                                                
        FROM #Telefone                                                                                
        WHERE UPPER(tipo_telefone) = 'TELEFONE HOT';                                                                                
                                                     
        EXEC dbo.proc_flag_telefone_insere_lista_telefone @lista_telefones = '',                                                                                
                                                          @id_flag = 149,                                                                                
                                   @data_inicio_vigencia = @data_inicio_vigencia_flag,                                                          
                                                          @data_fim_vigencia = '9999-12-30 00:00:00',                                                       
                                                          @lista_id_telefones = @id_telefone_flag;                                                                                
                                                                                
                                                                         
        SET @id_telefone_flag = '';                                                                               
                                                                                
        SELECT @id_telefone_flag = @id_telefone_flag + CONVERT(VARCHAR, id_telefone) + ','                                                                                
        FROM #Telefone                                                                                
        WHERE UPPER(tipo_telefone) NOT IN ( 'AVALISTA', 'SOCIO', 'TELEFONE HOT' );                                                                                
                                                                                
      EXEC dbo.proc_flag_telefone_insere_lista_telefone @lista_telefones = '',                                                                                
                                                          @id_flag = 150,                                                                                
                                                          @data_inicio_vigencia = @data_inicio_vigencia_flag,                                                                                
                                                          @data_fim_vigencia = '9999-12-30 00:00:00',                                                        
                @lista_id_telefones = @id_telefone_flag;                                          
                                
                                                                                
        --=================================================                                                                          
        --    FIM - FLAG DO TELEFONE                                                                                             
        --=================================================                                                                                                      
                                 
        -- identificar endereços de avalistas                                                                                                          
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                        
                                           'Carteira - 288',                                                                                
                                           'IDENTIFICAR ENDEREÇOS DE AVALISTAS',                                  
     'FALSE';                                                                                
                                         
        INSERT INTO dbo.tbl_avalista_endereco                                                                                
        (                                                                                
       id_contato,                                                                                
            id_endereco_cliente,                                                                                
            tipo_endereco                                                                          
        )                                                                                
        SELECT DISTINCT                                                                                
            tbl_avalista.id_contato,                                                                                
            id_domicilio,                                                                                
            UPPER(LEFT(tipo_domicilio, 15))                                                                                           
        FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo tbl_importacao_recovery_enderecos                                                                                
            INNER JOIN dbo.tbl_avalista tbl_avalista                                                                       
                ON tbl_importacao_recovery_enderecos.id_contato = tbl_avalista.id_contato                                                              
        WHERE NOT EXISTS                                                                                
        (                                                                                
            SELECT 1                                                               FROM dbo.tbl_avalista_endereco avalista_endereco                                        
            WHERE avalista_endereco.id_endereco_cliente = tbl_importacao_recovery_enderecos.id_domicilio                                                                                
                  AND avalista_endereco.id_contato = tbl_importacao_recovery_enderecos.id_contato                                                                                
        );                                                                                
                                                                                
        --- INSERE ENDEREÇOS DE AVALISTA E ASSOCIA PARA O DEVEDOR "TITULAR".                                                                                                  
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                               
                                           'Carteira - 288',                                                                                
                                           'INSERE ENDEREÇOS DE AVALISTA E ASSOCIA PARA O DEVEDOR - TITULAR',                                                                                
                                           'FALSE';                                                                            
                                                                                
        INSERT INTO tbl_endereco                                                                                
 (                                                                 
            id_devedor,        
            logradouro,                                                                                
            numero,                                                                                
            complemento,                                                       
            cep,                                 
            bairro,                                                                                
            municipio,                                                                                
            uf,                                                                                
            id_lote,                                                               
            operador,                                                              
            tipo_endereco,                                                                                
            id_endereco_cliente,                                                                                
            ativo                                                                                
 )                                                                                
        SELECT DISTINCT                                                                             
            tbl_avalista.id_devedor,                                                 
            UPPER(LEFT(ISNULL(rua, ''), 100)) AS logradouro,                                                                                
            LEFT(ISNULL(                                                                                
                           #tmp_ajusta_numero.nro,                                                                                
                           CASE                
                               WHEN ISNULL(tbl_importacao_recovery_enderecos.nro, '') = '' THEN                                           
                                   'S/N'                                                                                
                               ELSE                                                                                
                                   dbo.ajustaNumeros(LEFT(tbl_importacao_recovery_enderecos.nro, 7))                                                                                
                           END                                                   
                       ), 7) AS numero,                                                                                                  
            LEFT(ISNULL(#tmp_ajusta_numero.andar, tbl_importacao_recovery_enderecos.andar), 50) AS complemento,                                                                                
            LEFT(ISNULL(cep, ''), 8) AS cep,                                   
            UPPER(LEFT(ISNULL(bairro, ''), 40)) AS bairro,                                                                  
       UPPER(LEFT(ISNULL(cidade, ''), 40)) AS cidade,         
            UPPER(LEFT(ISNULL(                                                                                
                                 SUBSTRING(                                                                                
ISNULL(tbl_importacao_recovery_enderecos.estado, ''),                                                          
                                              CHARINDEX('(', ISNULL(tbl_importacao_recovery_enderecos.estado, '')) + 1,                                                                                
                                              2                                                                                
                                          ),                                                                                
                                 ''                                                                                
                             ), 2)                                                  
                 ) AS uf,                                                                                
            tbl_importacao_recovery_enderecos.id_lote,                                                      
            'CARGA AUTOMATICA' AS operador,                                        
      'AVALISTA' AS tipo_endereco,                                                                                
          tbl_importacao_recovery_enderecos.id_domicilio,                                                                                
            CASE                                                                                
                WHEN ISNULL(tbl_importacao_recovery_enderecos.ativo, 1) <> 1 THEN                                                                                
                    0                                                                                
ELSE                                                                                
         1                                                
  END AS ativo                                                                                
        FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo tbl_importacao_recovery_enderecos                                                
            INNER JOIN dbo.tbl_avalista tbl_avalista                                                                                
                ON tbl_importacao_recovery_enderecos.id_contato = tbl_avalista.id_contato                                                                                
                   AND tbl_avalista.id_devedor = tbl_importacao_recovery_enderecos.id_devedor                                                                                
            LEFT JOIN #tmp_ajusta_numero                                                                 
        ON #tmp_ajusta_numero.id_domicilio = tbl_importacao_recovery_enderecos.id_domicilio                                                                                                          
                                                                                
        WHERE NOT EXISTS                                                                                
        (                                                             
            SELECT 1                                                                     
            FROM tbl_endereco WITH (NOLOCK)                                                                                
            WHERE tbl_avalista.id_devedor = tbl_endereco.id_devedor                                                                                       
                  AND ISNULL(id_endereco_cliente, 0) = tbl_importacao_recovery_enderecos.id_domicilio)                                                                                
      AND tbl_importacao_recovery_enderecos.rua IS NOT NULL      
                  AND tbl_importacao_recovery_enderecos.cep IS NOT NULL                                                                                
                  AND tbl_importacao_recovery_enderecos.ativo = 1;                                                                                
                                                                  
        --- Identificar o id_contato do endereço.                                                             
        INSERT INTO dbo.tbl_endereco_complementar_auxiliar                                                                                
(                                                                                
            id_endereco,                                                                                
            id_endereco_cliente,                                                                                
            id_contato                                                                      
        )                                                                         
        SELECT DISTINCT                                                                                
            tbl_endereco.id_endereco,                                                                                
            tbl_endereco.id_endereco_cliente,                                                                                
    importacao.id_contato                                                    
        FROM tbl_importacao_recovery_enderecos_novo_web_robo importacao (NOLOCK)                                                                                
            INNER JOIN dbo.tbl_endereco tbl_endereco (NOLOCK)                                                                                
                ON importacao.id_devedor = tbl_endereco.id_devedor                                                                                
        AND id_domicilio = id_endereco_cliente                                                                                
            LEFT JOIN dbo.tbl_endereco_complementar_auxiliar endereco_complementar_aux (NOLOCK)                                      
                ON tbl_endereco.id_endereco = endereco_complementar_aux.id_endereco                                                                                
                   AND tbl_endereco.id_endereco_cliente = endereco_complementar_aux.id_endereco_cliente                                                                                
        WHERE endereco_complementar_aux.id_endereco IS NULL;                                                                                
                                                                                
        INSERT INTO dbo.tbl_endereco_complementar_novo                                                                                
        (                                                                                
            id_endereco_cliente,                                                           
     id_contato,                                                              
            carteira                                                                                
        )                                                                                
        SELECT DISTINCT                                                                                
            tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio,                           
            tbl_importacao_recovery_enderecos_novo_web_robo.id_contato,                                                                                 
          @carteira                    
        FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
       JOIN dbo.tbl_contrato ON firma =  tbl_importacao_recovery_enderecos_novo_web_robo.id_contato                                  
        JOIN dbo.tbl_contrato_ciclo ON tbl_contrato_ciclo.id_contrato = tbl_contrato.id_contrato                                                                               
            LEFT JOIN tbl_endereco_complementar_novo                                                                                
                ON tbl_endereco_complementar_novo.id_endereco = tbl_importacao_recovery_enderecos_novo_web_robo.id_domicilio                                                                                
                   AND tbl_endereco_complementar_novo.id_contato = tbl_importacao_recovery_enderecos_novo_web_robo.id_contato                                                                                
                  AND tbl_endereco_complementar_novo.carteira =@carteira                                
   WHERE tbl_importacao_recovery_enderecos_novo_web_robo.ativo = 1                                                          
   AND tbl_endereco_complementar_novo.id_endereco_complementar IS NULL             
   AND blacklist = 0                                         
    AND tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor IS NOT NULL                                    
    AND dbo.tbl_contrato.carteira =  @carteira                                                      
                                             
                                             
                                                                     
       
        SELECT id_domicilio                                                                                
        INTO #retirar_processo_domicilio                                                           
        FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo                                                                                
        WHERE ativo = 0;                                                                        
                                                                                
                                                                                
        DELETE FROM dbo.tbl_endereco_complementar_novo                                                                                
        WHERE id_endereco_cliente IN (                                                                                
                        SELECT id_domicilio FROM #retirar_processo_domicilio                             
       )                                                                                
              AND carteira = @carteira;                                                                                
                                                                                
                                            
                     
     SELECT id_domicilio                                                                                
        INTO #retirar_processo_domicilio_blackList                                                                              
        FROM dbo.tbl_importacao_recovery_enderecos_novo_web_robo                    
        WHERE blacklist = 1                                                                         
                                                                                
                                                                    
        DELETE FROM dbo.tbl_endereco_complementar_novo                                                       
        WHERE id_endereco_cliente IN (                                                                                
                        SELECT id_domicilio FROM #retirar_processo_domicilio_blackList                                                                                
       )                                                                                
              AND carteira = @carteira;                                              
                                            
        -- =====================================                                                                                                   
        -- BAIXAR CONTRATO COM ACORDOS QUITADOS                                                           
   -- =====================================                                                                                                    
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                                                
                                           'Carteira - 288',                                                                                
                                           'BAIXAR CONTRATO COM ACORDOS QUITADOS',                                                                                
                                           'FALSE';                                                                                
                                
        DECLARE @id_lote_devolucao AS INT;                                                                                
                                                                                
        SELECT DISTINCT                                                                                
            @id_lote_devolucao = id_lote                                                                          
        FROM tbl_importacao_recovery_contatos_novo_web_robo;                                                                      
                                                                                
                                                                   
                                                                                
      SELECT DISTINCT                                                                                
            id_acordo,                              
     id_devedor                                                                                
        INTO #tmp_retira_contrato                                                                         
  FROM tbl_acordo                                                                                
    WHERE NOT EXISTS                                                                                
        (                                                                                
            SELECT 1                                                                                
            FROM dbo.tbl_parcela_acordo                                                                         
            WHERE id_acordo = tbl_acordo.id_acordo                                                        
 AND ativo IN ( 1, 2 )                                                                                
        );                                              
                                                                                
        SELECT DISTINCT                                                                                
            #tmp_retira_contrato.id_devedor,                                     
            dbo.tbl_parcela.id_acordo                                                                                
        INTO #tmp_devedor_acordo                                                                                
        FROM dbo.tbl_contrato                                                                                
            INNER JOIN dbo.tbl_parcela                                                                                
                ON dbo.tbl_contrato.id_contrato = dbo.tbl_parcela.id_contrato                                                                                
            INNER JOIN #tmp_retira_contrato                                                        
       ON dbo.tbl_parcela.id_acordo = #tmp_retira_contrato.id_acordo                                                                                
                   AND tbl_contrato.id_devedor = #tmp_retira_contrato.id_devedor                                                                                
        WHERE tbl_contrato.ativo = 1                                                                                
              AND dbo.tbl_parcela.ativo = 1;                                                                                
                                                                                
        SELECT DISTINCT                                                                                
            #tmp_devedor_acordo.id_devedor,                                                                                
            tbl_acordo.id_acordo                                                                                
        INTO #tmp_devedor_acordo1                                                                      
      FROM tbl_acordo                                                                                
           INNER JOIN #tmp_devedor_acordo                                                                                
                ON dbo.tbl_acordo.id_devedor = #tmp_devedor_acordo.id_devedor;                                                                                
                                                                      
        SELECT *                                                
        INTO #tmp_devedor_acordo2 --DROP TABLE #tmp_devedore_acordo2                                                                                                  
        FROM #tmp_devedor_acordo1                                                              
        WHERE NOT EXISTS                                                                  
        (                                                                                
            SELECT 1                                                                                
            FROM dbo.tbl_parcela_acordo                                   
                INNER JOIN dbo.tbl_acordo                                                                                
      ON dbo.tbl_parcela_acordo.id_acordo = dbo.tbl_acordo.id_acordo                                                                                
            WHERE #tmp_devedor_acordo1.id_devedor = dbo.tbl_acordo.id_devedor                                                                                
                  AND tbl_parcela_acordo.ativo IN ( 1, 2 )                                                                                
        );                                                                                
                                                                                
        SELECT *                                                                                
INTO #tmp_devedor_acordo3                                                                                
        FROM #tmp_devedor_acordo2                                                                                
        WHERE NOT EXISTS                                                                     
        (                                                                                
            SELECT *                                                                                
            FROM tbl_parcela_acordo                                                                                
            WHERE id_acordo = #tmp_devedor_acordo2.id_acordo                                                                                
                  AND tbl_parcela_acordo.data_renegociacao IS NULL                                                                                
                  AND tbl_parcela_acordo.id_boleto_pagamento_percapita IS NULL                                                                                
        );                                                            
        SELECT dbo.tbl_contrato.id_contrato,                                          
               dbo.tbl_parcela.id_parcela,                                                                                
               dbo.tbl_acordo.id_acordo                                                                                
  INTO #temp_dados_acordo_quidados                                                                                
        FROM #tmp_devedor_acordo3                                                                                
            INNER JOIN dbo.tbl_acordo                                                                                
                ON #tmp_devedor_acordo3.id_acordo = dbo.tbl_acordo.id_acordo                                                                                
                   AND #tmp_devedor_acordo3.id_devedor = dbo.tbl_acordo.id_devedor                                                       
     INNER JOIN dbo.tbl_contrato                                                                       
            ON dbo.tbl_acordo.id_devedor = dbo.tbl_contrato.id_devedor                                                                                
            INNER JOIN dbo.tbl_parcela                                                                                
                ON dbo.tbl_contrato.id_contrato = dbo.tbl_parcela.id_contrato                                                                                
                   AND dbo.tbl_parcela.id_acordo = dbo.tbl_acordo.id_acordo                                                                                
        WHERE dbo.tbl_contrato.ativo = 1                                                              
             AND dbo.tbl_parcela.ativo = 1;                                                                                
                                                                                
        UPDATE dbo.tbl_acordo                                                                                
        SET dbo.tbl_acordo.ativo = '0'                                                                                
        FROM dbo.tbl_acordo                                                                                
            INNER JOIN #temp_dados_acordo_quidados                                                                                
                ON dbo.tbl_acordo.id_acordo = #temp_dados_acordo_quidados.id_acordo;                                                                                
                                                                                
        UPDATE tbl_contrato                                                
       SET tbl_contrato.ativo = '0'                         
        FROM #temp_dados_acordo_quidados                                                                           
            INNER JOIN tbl_contrato                                                                               
                ON tbl_contrato.id_contrato = #temp_dados_acordo_quidados.id_contrato;                                                                                
                                                                                
        UPDATE tbl_parcela                                                                                
        SET tbl_parcela.id_devolucao = @id_lote_devolucao,                                                                                
            tbl_parcela.data_devolucao = GETDATE(),                                                    
            tbl_parcela.motivo_devolucao = 'L',                              
            tbl_parcela.ativo = '0'                                                                    
        FROM #temp_dados_acordo_quidados                                                                          
            INNER JOIN tbl_parcela                                                                                
                ON tbl_parcela.id_contrato = #temp_dados_acordo_quidados.id_contrato                                                                                
                   AND tbl_parcela.id_parcela = #temp_dados_acordo_quidados.id_parcela;                                                                        
                                                                                
        -- Inserir dados necessários para classificação de segmentação.                        
        -- Esta tabela será utilizada na proc proc_segmentacao_base_recovery                                                                                                  
        -- Esta procedure será executada toda noite e atualizará com os dados recebidos na importação. Após a execução, essa tabela será apagada                                                                                                     
        -- para que a tabela esteja disponível para a próxima importação.                                                                        
             
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                                                
                                           'Carteira - 288',                                                                                
         'INSERIR DADOS NECESSÁRIOS PARA CLASSIFICAÇÃO DE SEGMENTAÇÃO',                                                             
                                           'FALSE';                                                                                
                
        INSERT INTO dbo.tbl_importacao_recovery_classificao_segmentos                                                                              
        (                                                                                
            carteira,                                                                                
            numero_contrato,                                                                                
            estado_operacao,                                                                                
            segmento,                                                                                
            saldo_operativo,                                                                                
            id_devedor                                                                                
        )                                                                                
        SELECT descricao_produto,                                                                                
               idoperacao_SIR,                                                                                
               estado_operacao,                                                                          
               segmento,                                                                             
               SUM(saldo_operativo),                                                                                
               operacoes.id_devedor                                                                                
   FROM dbo.tbl_importacao_recovery_operacoes_novo_web_robo operacoes (NOLOCK)                                                           
   JOIN tbl_importacao_recovery_ContatoOperacaoCaso_novo_web_robo   ON operacoes.idoperacao_SIR=IdOperacion_SIR                                                           
   JOIN dbo.tbl_tipo_produto_cliente ON  IdCartera_Compra = cod_carteira                                                     
 INNER JOIN dbo.tbl_importacao_recovery_saldo_novo_web_robo saldo (NOLOCK)                                                                                
                ON idoperacao_SIR = id_operacion_SIR                                                                                
        WHERE NOT EXISTS                                                                                
        (                                                                                
            SELECT 1                                                   
            FROM tbl_importacao_recovery_classificao_segmentos a                                                                                
            WHERE a.carteira = tbl_tipo_produto_cliente.descricao_produto                    
                  AND numero_contrato = idoperacao_SIR                                                                                
        )                                                                                
        GROUP BY descricao_produto,                                                                                
                 idoperacao_SIR,                                                                                
                 estado_operacao,                              
                 segmento,                                                                                
                 operacoes.id_devedor;                                                                                
                                                                                
                        
                    
                         
   UPDATE dbo.tbl_importacao_recovery_classificao_segmentos                      
   SET saldo_operativo = saldo.saldo_operativo,                      
      estado_operacao = operacoes.estado_operacao                      
  FROM tbl_importacao_recovery_classificao_segmentos                      
  INNER JOIN dbo.tbl_importacao_recovery_operacoes_novo_web_robo operacoes WITH (NOLOCK)  ON numero_contrato = operacoes.idoperacao_SIR                      
  INNER JOIN dbo.tbl_importacao_recovery_saldo_novo_web_robo saldo WITH(NOLOCK)                 
     ON operacoes.idoperacao_SIR = saldo.id_operacion_SIR                        
                      
                   
                   
  -- ===============================                                                                            
        -- INSERE DADOS NA TABELA_DINAMICA                                                                                           
        -- ===============================                                                                                            
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                      
                                           'Carteira - 288',                                                                                
                                           'INSERE DADOS NA TABELA_DINAMICA',                                                                                
                            'FALSE';                                           
                                                                                
        IF OBJECT_ID('tempdb..#temp') IS NOT NULL                                
            DROP TABLE #temp;                                                                                
                                                                                
        CREATE TABLE #temp                                                             
        (                          
            id_tabela_dinamica VARCHAR(100),                                                                                
         id_coluna VARCHAR(100),                             
            id_referencia INT,                                                                                
            num_linha INT,                                                                                
            desc_dados VARCHAR(1000)                                                                                
        );                                                          
        INSERT INTO #temp                                                                                
        (                                                                                
            id_tabela_dinamica,                                                                                
            id_coluna,                                                                                
            id_referencia,                                                                                
            desc_dados                           
)             
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'sexo' AS id_coluna,                                                                                
         tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                                    
             CAST(tbl_importacao_recovery_contatos_novo_web_robo.sexo AS VARCHAR) AS desc_dados                                                                                
FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                       
               AND tbl_importacao_recovery_contatos_novo_web_robo.sexo IS NOT NULL                                                                                
               AND NOT EXISTS                            
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                         
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
     AND tbl_tabela_dinamica_dados.id_coluna = 'sexo'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = CAST(tbl_importacao_recovery_contatos_novo_web_robo.sexo AS VARCHAR)                                                                                
         ))                                                                                
        UNION ALL                                                                                
(SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'estado_civil' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.estado_civil AS desc_dados                                                
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                   
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.estado_civil, '') <> ''                                                                                
           AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'estado_civil'                          
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
      AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.estado_civil                                                                                
         ))                                                                                
        UNION ALL                                                                            
        (SELECT DISTINCT                                                      
      'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                   
             'profissao' AS id_coluna,                                                                                
  tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.profissao AS desc_dados                                                                                
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                           
      WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.profissao, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                           
             SELECT 1                                                      
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                              
                   AND tbl_tabela_dinamica_dados.id_coluna = 'profissao'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.profissao                                                                                
         ))                           
                                                           
        UNION ALL                                                                         
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
   'atividade' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_Novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.atividade AS desc_dados                                                                
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.atividade, '') <> ''                                                                                
               AND NOT EXISTS                                
         (          
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'atividade'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.atividade                         
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                        
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'caracteristica_atividade' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.caract_atividade AS desc_dados                                                       
  FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                            
          AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.caract_atividade, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                         
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
   AND tbl_tabela_dinamica_dados.id_coluna = 'caracteristica_atividade'                                     
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.caract_atividade                                                                                
         ))                                                                          
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
           'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'tipo_sociedade' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                      
             tbl_importacao_recovery_contatos_novo_web_robo.tipo_sociedade AS desc_dados                                                                      
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                              
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.tipo_sociedade, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'tipo_sociedade'                                                                                
              AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                              
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.tipo_sociedade                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'estado' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                
             tbl_importacao_recovery_contatos_novo_web_robo.estado AS desc_dados              
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.estado, '') <> ''                                                                                
           AND NOT EXISTS                                                                          
         (                                                                                
             SELECT 1                                              
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'estado'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                         
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.estado                                                                          
         ))                                                
        UNION ALL                                                                                
       (SELECT DISTINCT                                                                                                    
             'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'data_verificacao' AS id_coluna,                                                                                
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                                          
             CONVERT(VARCHAR, tbl_importacao_recovery_contatos_novo_web_robo.data_verificacao, 121) AS desc_dados                                       
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                             
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.data_verificacao, '1901-01-01') <> '1901-01-01'                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
        WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'data_verificacao'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = CONVERT( VARCHAR,tbl_importacao_recovery_contatos_novo_web_robo.data_verificacao,121)                                                                                
         ))                                                                                
        UNION ALL                                                         
        (SELECT DISTINCT                                                                                                      
        'tabdadosadicionais_REC' AS id_tabela_dinamica,                                                                                
             'usuario_verificador' AS id_coluna,                                                        
             tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                                        
         tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador AS desc_dados                                                                                
        FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                              
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
          WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'usuario_verificador'                                             
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador                                                                 
         ))                                                                                    UNION ALL                                                                  
        (SELECT DISTINCT                                                                                                    
             'tabdadosadicionais_REC_EMAIL' AS id_tabela_dinamica,                                                                     
             'usuario_verificador' AS id_coluna,                                              
             tbl_importacao_recovery_emails_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_emails_novo_web_robo.usuario_verificador AS desc_dados                                                                                
         FROM tbl_importacao_recovery_emails_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_emails_novo_web_robo.id_devedor IS NOT NULL                                                     
               AND ISNULL(tbl_importacao_recovery_emails_novo_web_robo.usuario_verificador, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                        
             SELECT 1                                                                        
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                  
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_EMAIL'                                                                                
    AND tbl_tabela_dinamica_dados.id_coluna = 'usuario_verificador'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_emails_novo_web_robo.id_devedor                                           
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_emails_novo_web_robo.usuario_verificador                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                                   
             'tabdadosadicionais_REC_EMAIL' AS id_tabela_dinamica,                                                                                
             'usuario_baixa' AS id_coluna,                                                                                
             tbl_importacao_recovery_emails_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_emails_novo_web_robo.usuario_baixa AS desc_dados                                                                                
         FROM tbl_importacao_recovery_emails_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_emails_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_emails_novo_web_robo.usuario_baixa, '') <> ''                                                                                
   AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                         
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
   WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_EMAIL'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'usuario_baixa'                                                                                
           AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_emails_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_emails_novo_web_robo.usuario_baixa                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC_EMAIL' AS id_tabela_dinamica,                                                           
             'ativo' AS id_coluna,                                              
             tbl_importacao_recovery_emails_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_emails_novo_web_robo.ativo AS desc_dados                                                                                
         FROM tbl_importacao_recovery_emails_novo_web_robo (NOLOCK)                                                                      
         WHERE tbl_importacao_recovery_emails_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_emails_novo_web_robo.ativo, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                                              
             SELECT 1            
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_EMAIL'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'ativo'                                                                                
                 AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_emails_novo_web_robo.id_devedor                                                                 
             AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_emails_novo_web_robo.ativo                                                                                
         ))                                                                                
        UNION ALL                                                     
        (SELECT DISTINCT                                           
             'tabdadosadicionais_REC_END' AS id_tabela_dinamica,                                                                                
             'pais' AS id_coluna,                
             tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor AS id_referencia,                                                                                
 tbl_importacao_recovery_enderecos_novo_web_robo.pais AS desc_dados                                                                     
         FROM tbl_importacao_recovery_enderecos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor IS NOT NULL                                                                 
               AND tbl_importacao_recovery_enderecos_novo_web_robo.pais IS NOT NULL                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                          
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                    
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_END'                                                                               
                   AND tbl_tabela_dinamica_dados.id_coluna = 'pais'                                                                                
          AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_enderecos_novo_web_robo.pais                                                                    
         ))                                                         
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                            
             'tabdadosadicionais_REC_END' AS id_tabela_dinamica,                                   
             'envio' AS id_coluna,                                                                                
             tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor AS id_referencia,                                                                        
        tbl_importacao_recovery_enderecos_novo_web_robo.envio AS desc_dados                                                                                
         FROM tbl_importacao_recovery_enderecos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor IS NOT NULL                        
               AND ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.envio, '') <> '' -- IS NOT NULL                                                                                                   
               AND NOT EXISTS                                                                                
         (                        
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_END'                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'envio'                                                                         
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_enderecos_novo_web_robo.envio                                                                                
         ))                                                                      
        UNION ALL                                                                                
(SELECT DISTINCT                                                                                             
             'tabdadosadicionais_REC_END' AS id_tabela_dinamica,                                                                                
             'data_verificacao' AS id_coluna,                                                                                
             tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor AS id_referencia,                                                                                
             CONVERT(VARCHAR, tbl_importacao_recovery_enderecos_novo_web_robo.data_verificacao, 121) AS desc_dados                                               
         FROM tbl_importacao_recovery_enderecos_novo_web_robo (NOLOCK)                                                           
         WHERE tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_enderecos_novo_web_robo.data_verificacao, '1901-01-01') <> '1901-01-01'                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                               
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_END'                           
            AND tbl_tabela_dinamica_dados.id_coluna = 'data_verificacao'                                                                                
   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_enderecos_novo_web_robo.id_devedor                                  
                   AND tbl_tabela_dinamica_dados.desc_dados = CONVERT(                                                                                
                                                                         VARCHAR,                                                                                
                                                                         tbl_importacao_recovery_enderecos_novo_web_robo.data_verificacao,                                                                                
                                                                         121                 
                                                                     )                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                               
             'tabdadosadicionais_REC_END' AS id_tabela_dinamica,                                                                                
  'usuario_verificador' AS id_coluna,                                                                                
        tbl_importacao_recovery_contatos_novo_web_robo.id_devedor AS id_referencia,                                  
             tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador AS desc_dados                                                                                
         FROM tbl_importacao_recovery_contatos_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_contatos_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                 
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_END'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'usuario_verificador'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_contatos_novo_web_robo.id_devedor                                                                 
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_contatos_novo_web_robo.usuario_verificador                                                                                
  ))                                                                                
        UNION ALL                                                                         
                                                                    
        (SELECT DISTINCT                                                                                                   
             'tabdadosadicionais_REC_TEL' AS id_tabela_dinamica,                                                                         
             'data_verificacao' AS id_coluna,                                                                                
             tbl_importacao_recovery_telefones_novo_web_robo.id_devedor AS id_referencia,                                                                                
             CONVERT(VARCHAR, tbl_importacao_recovery_telefones_novo_web_robo.data_verificacao, 121) AS desc_dados                                                                                
         FROM tbl_importacao_recovery_telefones_novo_web_robo (NOLOCK)                                                                               
         WHERE tbl_importacao_recovery_telefones_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_telefones_novo_web_robo.data_verificacao, '1901-01-01') <> '1901-01-01' -- IS NOT NULL         
               AND NOT EXISTS                                                                       
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_TEL'                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'data_verificacao'                                                                   
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
AND tbl_tabela_dinamica_dados.desc_dados = CONVERT(VARCHAR,tbl_importacao_recovery_telefones_novo_web_robo.data_verificacao,121)                                                          
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                              
             'tabdadosadicionais_REC_TEL' AS id_tabela_dinamica,                                                                                
             'usuario_verificador' AS id_coluna,                                                                                
             tbl_importacao_recovery_telefones_novo_web_robo.id_devedor AS id_referencia,                                                                                
             tbl_importacao_recovery_telefones_novo_web_robo.usuario_verificador AS desc_dados                                                                                
         FROM tbl_importacao_recovery_telefones_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_telefones_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_telefones_novo_web_robo.usuario_verificador, '') <> '' -- IS NOT NULL                                                                                             
               AND NOT EXISTS                                                                                
         (                                                    
             SELECT 1                                                                                
            FROM tbl_tabela_dinamica_dados (NOLOCK)                                  
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_TEL'                                                                             
                   AND tbl_tabela_dinamica_dados.id_coluna = 'usuario_verificador'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_telefones_novo_web_robo.usuario_verificador                                                                                
         ))                                                     
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                                       
             'tabdadosadicionais_REC_TEL' AS id_tabela_dinamica,                                                                                
           'envio' AS id_coluna,                                                                                
             tbl_importacao_recovery_telefones_novo_web_robo.id_devedor AS id_referencia,                                                                                
             CONVERT(VARCHAR, tbl_importacao_recovery_telefones_novo_web_robo.envio) AS desc_dados                                                                                
         FROM tbl_importacao_recovery_telefones_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_telefones_novo_web_robo.id_devedor IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_telefones_novo_web_robo.usuario_verificador, '') <> '' -- IS NOT NULL                                                                                                   
               AND NOT EXISTS                                                                      
  (                                                                                
SELECT 1                                                                   
      FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_TEL'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'envio'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_telefones_novo_web_robo.id_devedor                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = CONVERT( VARCHAR, tbl_importacao_recovery_telefones_novo_web_robo.envio)                                                                                
         ))                                                                                
        UNION ALL                                               
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                                                                
             'tipo_garantia' AS id_coluna,                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                       
             tbl_importacao_recovery_operacoes_novo_web_robo.tipo_garantia AS desc_dados                                                                                
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                      
      WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                                
    AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.tipo_garantia, '') <> ''                                                                                
               AND NOT EXISTS                                                                                
  (                                                                                
             SELECT 1                                            
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'tipo_garantia'                                                       
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.tipo_garantia                                                                                
))                                                                                
       UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                                                                
             'garantia' AS id_coluna,                                                 
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.garantia AS desc_dados                                                                                
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                               AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.garantia, '') <> ''           
  
    
      
        
          
            
              
                
                            
               AND NOT EXISTS                                                     
(                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                              
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'garantia'                                                  
      AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                       
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.garantia                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                                       
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                                                                
             'tipo_produto' AS id_coluna,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.tipo_produto AS desc_dados                                                                                
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                   
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                             
      AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.tipo_produto, '') <> '' -- IS NOT NULL                                                                                                     
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1          
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                      
                   AND tbl_tabela_dinamica_dados.id_coluna = 'tipo_produto'                                        
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                                
                AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.tipo_produto                                                                                
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                   
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                                                                
             'produto' AS id_coluna,                    
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                                
         tbl_importacao_recovery_operacoes_novo_web_robo.produto AS desc_dados                                                                          
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                                                                          
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.produto, '') <> ''                                                                                
              AND NOT EXISTS                                                                                
         (                                                                                
          SELECT 1                                                             
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'produto'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.produto                                                                               
         ))                                                                                
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                   
             'lote' AS id_coluna,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                               
             tbl_importacao_recovery_operacoes_novo_web_robo.lote AS desc_dados                                                                           
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                            
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                           
             AND tbl_importacao_recovery_operacoes_novo_web_robo.lote IS NOT NULL                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                                                
      AND tbl_tabela_dinamica_dados.id_coluna = 'lote'                                                                                
          AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                           
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.lote                                                                
         ))                                                                      
        UNION ALL                               
        (SELECT DISTINCT                                                                                
        'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                                                       
             'tipo_carteira' AS id_coluna,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.tipo_carteira AS desc_dados                                                                
         FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                                        
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.tipo_carteira, '') <> ''                                          
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                               
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                         
 WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                                                                                
                   AND tbl_tabela_dinamica_dados.id_coluna = 'tipo_carteira'                                                                                
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                                                
                  AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.tipo_carteira                                                                                
         ))                                                   
                                                                             
        UNION ALL                                                                   
        (SELECT DISTINCT                                                                                                       
             'tabdadosadicionais_REC_CTR' AS id_tabela_dinamica,                              
   'subestado_operacao' AS id_coluna,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato AS id_referencia,                                                                                
             tbl_importacao_recovery_operacoes_novo_web_robo.subestado_operacao AS desc_dados                                                                                
      FROM tbl_importacao_recovery_operacoes_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato IS NOT NULL                                                                                
               AND ISNULL(tbl_importacao_recovery_operacoes_novo_web_robo.subestado_operacao, '') <> '' -- IS NOT NULL                                               
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                                                
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
             WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_CTR'                            
                   AND tbl_tabela_dinamica_dados.id_coluna = 'subestado_operacao'                                                   
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_operacoes_novo_web_robo.id_contrato                                                              
                   AND tbl_tabela_dinamica_dados.desc_dados = tbl_importacao_recovery_operacoes_novo_web_robo.subestado_operacao                                                    
         ))                                                                         
                                                              
        UNION ALL                                                                                
        (SELECT DISTINCT                                                                                
             'tabdadosadicionais_REC_PARC' AS id_tabela_dinamica,                                                                                
             'cobranca' AS id_coluna,                                                                             
             tbl_importacao_recovery_saldo_novo_web_robo.id_parcela AS id_referencia,                                                                                
             CONVERT(VARCHAR, tbl_importacao_recovery_saldo_novo_web_robo.cobranca) AS desc_dados                                                                                
         FROM tbl_importacao_recovery_saldo_novo_web_robo (NOLOCK)                                                                                
         WHERE tbl_importacao_recovery_saldo_novo_web_robo.id_parcela IS NOT NULL                                                                
               AND tbl_importacao_recovery_saldo_novo_web_robo.cobranca IS NOT NULL                                                                                
               AND NOT EXISTS                                                                                
         (                                                                                
             SELECT 1                                                       
             FROM tbl_tabela_dinamica_dados (NOLOCK)                                                                                
          WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = 'tabdadosadicionais_REC_PARC'                                                                                
       AND tbl_tabela_dinamica_dados.id_coluna = 'cobranca'             
                   AND tbl_tabela_dinamica_dados.id_referencia = tbl_importacao_recovery_saldo_novo_web_robo.id_parcela                                                                                
                   AND tbl_tabela_dinamica_dados.desc_dados = CONVERT( VARCHAR,tbl_importacao_recovery_saldo_novo_web_robo.cobranca )                                                                                
         ))                                                                         
                                                                    
        IF @@ROWCOUNT > 0                                                                                
        BEGIN                                                                                
            CREATE CLUSTERED INDEX ix_temp                                                    
         ON #temp                                                                                
     (                                                                                
                id_tabela_dinamica,                                                                                
       id_coluna,                                                                
                id_referencia                                                                                
            );                                                                                
            CREATE INDEX ix_temp2                                                                                
            ON #temp                                                                                
           (                            
                id_tabela_dinamica,                                                                                
                id_coluna,                             
                num_linha                                                                                
            );                                                                    
                                                                                
            -------------------------                                                                        
            -- Limpa Casos Duplicados                                 
            -------------------------                                   
   EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                               'IMPORTACAO',                                                           
                                               'Carteira - 288',                                                                                
                                               'LIMPA CASOS DUPLICADOS NA TABELA_DINAMICA',                                                                                
                                               'FALSE';                                                                
                                                                                
                                                                                
                                                                                
            DELETE #temp                                                                                
            FROM                                                                                
            (                                                                                
                SELECT id_tabela_dinamica,                                                                                
                       id_coluna,                                                                                
      id_referencia,                               
                       desc_dados                                     
                FROM #temp                                          
                GROUP BY id_tabela_dinamica,                                                                                
                         id_coluna,                                                                                
                         id_referencia,                                                                 
                         desc_dados                                                                              
                HAVING COUNT(*) > 1                                                    
            ) tmp                                                                                
                INNER JOIN #temp                                                                                
                    ON #temp.id_tabela_dinamica = tmp.id_tabela_dinamica                                                                       
                       AND #temp.id_coluna = tmp.id_coluna                                                                                
                       AND #temp.id_referencia = tmp.id_referencia                                                                                
                 AND #temp.desc_dados = tmp.desc_dados;                                                                                
                                                                                
            ------------------------------------                                                         
            -- Limpa casos que já existe na base.                                                                                                  
       ------------------------------------                                                                               
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                         
                                       'IMPORTACAO',                                                      
                                               'Carteira - 288',                                                                                
                                               'LIMPA CASOS QUE JÁ EXISTE NA TABELA_DINAMICA',                                                                                
                                               'FALSE';                                                                                
                                                                                
            DELETE FROM #temp                                          
            WHERE desc_dados IN ( 'SEM DADOS', 'SIN DATOS' );                                                                                
                                               
            ------------------------------                                                                                                   
            -- Inserindo dados auxiliares.                                                                                                   
     ------------------------------                                                                                                  
            EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                         
                                               'IMPORTACAO',                                                
                                               'Carteira - 288',                                                                                
                                               'INSERINDO DADOS AUXILIARES',                                                                                
                                               'FALSE';                                                                                
                                                                                
       
            DECLARE @id_tabela_dinamica AS VARCHAR(30),                                  
                    @id_coluna AS VARCHAR(30),                                                                                
                    @num_linha_aux AS INT,                                                           
         @id_referencia AS INT,                                              
                    @desc_dados AS VARCHAR(1000);                                                                                
                                                                                
            --- Verificará o próximo registro de num_linha a ser inserido, independente do id_tabela_dinamica, para não ocorrer duplicidade neste campo.                                                                                                  
                                                                                
                                                          
            SET @num_linha_aux = ISNULL(                                                                                
                                 (                                                                                
                                     SELECT ISNULL(MAX(num_linha), 0) + 1 NULO FROM tbl_tabela_dinamica_dados                                                                                
     ),                                                           
                                 1                                                                                
                                       );                                                                                
                                                                                
      DECLARE dimanica_insere CURSOR FOR                                                               
            SELECT id_tabela_dinamica,                                                          
                   id_coluna,                                                        
          id_referencia,                                                                                
                   desc_dados                              
            FROM #temp                                                              
            ORDER BY id_tabela_dinamica,                                                                                
  id_referencia,                                                                                
                     id_coluna;                                                                                
                                                                                
            OPEN dimanica_insere;                                                                                
                                   
 FETCH NEXT FROM dimanica_insere                                                           
            INTO @id_tabela_dinamica,                                                                                
                 @id_coluna,                     
                 @id_referencia,                                                                                             
     @desc_dados;                                                                                
                                                                                  
                                                                                
            WHILE @@FETCH_STATUS = 0                                                                                
            BEGIN                                                                                
                                                                               
                                                                                
                UPDATE #temp                                                                                
                SET num_linha = @num_linha_aux                                                                      
                WHERE id_tabela_dinamica = @id_tabela_dinamica                              
                  AND id_coluna = @id_coluna                                                                                
                      AND id_referencia = @id_referencia                                                              
                      AND @desc_dados = #temp.desc_dados;                                                                                
                                                                                
                SET @num_linha_aux = @num_linha_aux + 1;                                           
        FETCH NEXT FROM dimanica_insere                                                                                
                INTO @id_tabela_dinamica,                                                                                
                     @id_coluna,                                                                                
                     @id_referencia,                                                                                
                     @desc_dados;                                                                                
            END;                                                                                
                                                                  
            CLOSE dimanica_insere;                                                                                
            DEALLOCATE dimanica_insere;                                                                                
                                                                                
DELETE FROM #temp                                      WHERE num_linha IS NULL;                                                                
                                                                                
            -- Limpa Casos Duplicados                                                                                                    
            DELETE #temp                                                                                
            FROM                                                       
            (                                                                                
                SELECT id_tabela_dinamica,                                                                                
                      id_coluna,                                                        
             num_linha,                                                                                
                       desc_dados                                                             
                FROM #temp                                                                                
                GROUP BY id_tabela_dinamica,                                                         
            id_coluna,                                                             
                         num_linha,                                                                                
                         desc_dados                                                                                
                HAVING COUNT(*) > 1                                                                                
            ) tmp                                                                      
                INNER JOIN #temp                                                               
                    ON #temp.id_tabela_dinamica = tmp.id_tabela_dinamica                                                                                
                       AND #temp.id_coluna = tmp.id_coluna                                                                                
           AND #temp.num_linha = tmp.num_linha                                                                                
  AND #temp.desc_dados = tmp.desc_dados;                                                                                
                                                                                
            --VERIFICA SE JÁ EXISTE O REGISTRO E A DESCRIÇÃO É DIFERENTE. CASO SEJA, ATUALIZO O CAMPO.                                                                                                          
            UPDATE dinamica                                                                                
            SET desc_dados = #temp.desc_dados             
            FROM #temp                                      
                INNER JOIN dbo.tbl_tabela_dinamica_dados dinamica                                                                                
                    ON dinamica.id_tabela_dinamica = #temp.id_tabela_dinamica                                                                                
                       AND dinamica.id_coluna = #temp.id_coluna                                                    
       AND dinamica.id_referencia = #temp.id_referencia                                                                                
                       AND dinamica.desc_dados <> #temp.desc_dados;                                                                                
                                                  
                                                                                
            DELETE FROM #temp                                                                                
            WHERE EXISTS                                                                                
            (                                     
                SELECT 1                                                                                
                FROM dbo.tbl_tabela_dinamica_dados tbl_tabela_dinamica_dados                                                                                
                WHERE tbl_tabela_dinamica_dados.id_tabela_dinamica = #temp.id_tabela_dinamica                                                                                
                      AND tbl_tabela_dinamica_dados.id_coluna = #temp.id_coluna                                                                                
               AND tbl_tabela_dinamica_dados.id_referencia = #temp.id_referencia                                     
                      AND tbl_tabela_dinamica_dados.desc_dados = #temp.desc_dados                                                                                
            );                                                                                
                                                                                
            INSERT INTO tbl_tabela_dinamica_dados                                                  
(                                                                                
                id_tabela_dinamica,                                                                                
                id_coluna,                                                                                
       num_linha,                                                                      
                id_referencia,                                                                                
                desc_dados                                                                                
            )                                                                                
            SELECT DISTINCT                                                                                
                id_tabela_dinamica,                                                        
                id_coluna,                                                                                
                num_linha,                                          
     id_referencia,         
                desc_dados                                                                                
            FROM #temp                                                                                
            ORDER BY id_referencia;                                                                                
        END;                                                                                
                                                                                
        DROP TABLE #temp;                                                                                
                                                  
                                                                       
  -- ======================                                                                                                    
        -- ATUALIZAÇÃO DE SALDO                                                                    
        -- ======================                                                                                                    
                                                                                
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                  
                                           'IMPORTACAO',                                                                   
                                           'Carteira - 288',                                   
  'EXECUTANDO A PROC: proc_carrega_telefones_validos',                                                                                
                                           'FALSE';           
                                                                                
                                                                                
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,           
               'IMPORTACAO',                                                                                
                'Carteira - 288 importacao_recovery_webservice_robo',                                                                                
                                           'CARGA PROCESSADA',                                                                                
     'FALSE';                                                                                
                                                                                
                                                                                
                                                              
        --=============== jucios--=========================                                                                        
                                                                                
        UPDATE tbl_importacao_recovery_juciosdetalhe_novo_web_robo                                                                                
        SET id_devedor = tbl_contrato.id_devedor,                                                                                
            id_contrato = tbl_contrato.id_contrato                                                                          
        FROM tbl_importacao_recovery_juciosdetalhe_novo_web_robo                                                                                
            JOIN tbl_contrato                                                                                
                ON numero = IdOperacionSir;                                                                                
                                                                                
        UPDATE tbl_importacao_recovery_jucioscabeceira_novo_web_robo                                                                                
        SET id_devedor = tbl_importacao_recovery_juciosdetalhe_novo_web_robo.id_devedor,                                                                                
            id_contrato = tbl_importacao_recovery_juciosdetalhe_novo_web_robo.id_contrato                                                                                
        FROM tbl_importacao_recovery_jucioscabeceira_novo_web_robo                                                                                
            JOIN tbl_importacao_recovery_juciosdetalhe_novo_web_robo                                                          
                ON dbo.tbl_importacao_recovery_jucioscabeceira_novo_web_robo.Id_Juicio = dbo.tbl_importacao_recovery_juciosdetalhe_novo_web_robo.Id_Juicio;                                                                                
                                                                                
                              
                                                                        
        INSERT INTO dbo.tbl_juciosdetalhe                                                                                
        (                                            
            id_lote,                                                    
            Id_Juicio,                                                 
            NumeroCaso,                                                                                
            IdCasoSir,                                                                                
        IdOperacionSir,                                                                                
            id_devedor,                                                      
      id_contrato                                                                                
        )                                                                                
        SELECT id_lote,                                                                             
              Id_Juicio,                                                                                
               NumeroCaso,           
               IdCasoSir,                                                                                
               IdOperacionSir,                                                                                
               id_devedor,                                                                                
               id_contrato                                                                                
      FROM tbl_importacao_recovery_juciosdetalhe_novo_web_robo;                                                 
                                                                                
                                                                     
                                                                                
      INSERT INTO dbo.tbl_jucioscabeceira                                                                                
        (                                                       
            id_lote,                                                                                
            Id_Juicio,                                                                                
            Jurisdiccion,                                                                                
            JurisdiccionDetalle,                                                                           
          TipoJuicio,                                                                                
            Etapa,                                                    
            FechaEtapa,                                                                                
          --  FechaLimiteEtapa,                                                                                
            Estado,                                                                                
           -- SentenciaFirme,                                                                               
            FechaPresentacionDemanda,                                                                                
            CoDemandado,                                           
         -- Demandante,                                                                                
            DescJuzgado,                                                                                
            Fuero,                                                                                
            Secretaria,                                                                                
            NroExpediente,                                               
            NroCNJ,                                                                                
            ObjetoDelProceso,                                                                                
           -- Moneda,                                 
            MontoDemanda,                              
            --MontoQuirografario,                                                                                
            --decMontoConPrivilegio,                                                                                
      MontoSentencia,                                                                                
   --Alimento,                  
            --EmbargoHaberes,                                                                                
            --EmbargoInmuebles,                                                                                
            --EmbargoOtros,                                                                                
            --Igb,                                                 
            --Excepcion,                                                                                
            --FechaProrrogaEstado,                                                                                
            --CantDiasProrroga,                                                                                
            bitVerificado,          
            FechaVerificacion,                                                   
            UsuarioVerificador,                                            
            Activo,                                                                                
            Fase,                                                                        
            Sub_Fase,                                                                    
  id_devedor,                                                                                
            id_contrato                                                                                
        )                                                                                
        SELECT id_lote,                                                                                
               Id_Juicio,                            
               Jurisdiccion,                                                                                
               JurisdiccionDetalle,                                                                                
               TipoJuicio,                                                                                
               Etapa,                                                                                
               FechaEtapa,                                                                        
             --  FechaLimiteEtapa,                                                                                
               Estado,                                                                                
               --SentenciaFirme,                        
               FechaPresentacionDemanda,                                                                                
               CoDemandado,                                                        
               --Demandante,                                                                                
               DescJuzgado,                                                                          
     Fuero,                                                                                
Secretaria,                                                                                
               NroExpediente,                                                                                
               NroCNJ,                                                                                
               ObjetoDelProceso,                                                                                
              -- Moneda,                                                                                
               MontoDemanda,                                                                                
              -- MontoQuirografario,                                                                                
         -- decMontoConPrivilegio,                             
               MontoSentencia,                                                                                
             --  Alimento,                                                           
            --   EmbargoHaberes,                                                                                
              -- EmbargoInmuebles,                                                     
            --   EmbargoOtros,                             
            --   Igb,                                                                                
            --   Excepcion,                                                         
              -- FechaProrrogaEstado,                                                                                
             --  CantDiasProrroga,                                                                 
               bitVerificado,                               
               FechaVerificacion,                                                                             
               UsuarioVerificador,                                                            
               Activo,                                                   
               Fase,                                                              
          Sub_Fase,                                                                                
               id_devedor,                                
               id_contrato                                                                                
        FROM tbl_importacao_recovery_jucioscabeceira_novo_web_robo;                                                                                
                                                                                
                                                                                
        --===================================================================                                                                                            
        --Retirar  os casos que não estão mais associados para intervalor                                                                 
        --===================================================================                                                                                                     
                                                                       
        UPDATE tbl_importacao_recovery_bajas_operaciones_novo_web_robo                                                                                
        SET id_contrato = tbl_contrato.id_contrato,                                                                             
            id_devedor = tbl_contrato.id_devedor                                                                                
       FROM dbo.tbl_importacao_recovery_bajas_operaciones_novo_web_robo                                                                                
            JOIN tbl_contrato                                                        
                ON numero = intIdOperacion;        
                                                                         
                                                                
                                                                                
                                                                                
        IF OBJECT_ID('tempdb..#tmp_inativar') IS NOT NULL                                                                                
            DROP TABLE #tmp_inativar;                                                                                
        --- 'TT' Casos Retirados Totalmente da Intervalor                                                                                                  
                                                       
        SELECT tbl_contrato.id_devedor,                                                                                
               tbl_contrato.id_contrato,                                                                                
               id_acordo                                                                                
        INTO #tmp_inativar                                                                                
        FROM tbl_parcela                                                                                
            JOIN  tbl_importacao_recovery_bajas_operaciones_novo_web_robo                                                                                
    ON dbo.tbl_parcela.id_contrato = tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato                                                             
        JOIN dbo.tbl_contrato                                                                                
                ON dbo.tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato = dbo.tbl_contrato.id_contrato                                                                                
        WHERE tipo IN ( 'TT' );                                                                                
            
        --- 'AC' Casos Retirados da Agência Cobro da Intervalor                                                                                                  
        INSERT INTO #tmp_inativar                                                                                
        (                                                                                
            id_devedor,                                                                                
            id_contrato,                                                                          
            id_acordo                                                                                
        )                                                                                
        SELECT tbl_contrato.id_devedor,                                                                                
               tbl_contrato.id_contrato,                                                                                
               id_acordo             
        FROM tbl_parcela                                                                                
            JOIN tbl_importacao_recovery_bajas_operaciones_novo_web_robo                                                                                
          ON dbo.tbl_parcela.id_contrato = tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato                                                                              
            JOIN dbo.tbl_contrato                                                 
                ON dbo.tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato = dbo.tbl_contrato.id_contrato                                                                                
            JOIN dbo.tbl_contrato_complementar                                                                                
                ON dbo.tbl_contrato.id_contrato = dbo.tbl_contrato_complementar.id_contrato                                                       
   WHERE tipo IN ( 'AC' )                             
              AND nome_agencia_estudio <> 'INTERVALOR COBRANÇA GESTÃO LTDA';                                                                                
                                                                                
        --- 'AA' Casos Retirados da Agência Atual da Intervalor                                                                                                  
        INSERT INTO #tmp_inativar                                                                                
        (                                                                                
            id_devedor,                                                                                
            id_contrato,                                                      
        id_acordo                                                                                
        )                                                                                
        SELECT tbl_contrato.id_devedor,                                                                                
        tbl_contrato.id_contrato,                                                                          
               id_acordo                                                                       
        FROM tbl_parcela                                                  
  JOIN tbl_importacao_recovery_bajas_operaciones_novo_web_robo                                                                                
                ON dbo.tbl_parcela.id_contrato = tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato                                                                                
        JOIN dbo.tbl_contrato                                                                                
                ON dbo.tbl_importacao_recovery_bajas_operaciones_novo_web_robo.id_contrato = dbo.tbl_contrato.id_contrato                    
            JOIN dbo.tbl_contrato_complementar                                                                              
                ON dbo.tbl_contrato.id_contrato = dbo.tbl_contrato_complementar.id_contrato                                 
   WHERE tipo IN ( 'AA' )                                                                                
              AND nome_agencia_estudio_cobro <> 'INTERVALOR COBRANÇA GESTÃO LTDA';                                                                                
                                                                                
        --- Exclusão da Contrato Ciclo                                                                                                          
                                                                                
        DELETE FROM dbo.tbl_contrato_ciclo                                                               
        WHERE id_contrato IN (                                                                                
                                 SELECT id_contrato FROM #tmp_inativar                                  
                         );                                                                                
                                                                                
                                                                       
                                                                 
        UPDATE dbo.tbl_acordo                                                                                
        SET dbo.tbl_acordo.ativo = '0'                                                                                
     FROM dbo.tbl_acordo                                                                                
            INNER JOIN #tmp_inativar                                                                              
                ON dbo.tbl_acordo.id_acordo = #tmp_inativar.id_acordo                                                            
                   AND #tmp_inativar.id_devedor = dbo.tbl_acordo.id_devedor                                                  
      WHERE dbo.tbl_acordo.ativo =1                                                  
                                                                                     
                                                                                
                                                                                
        -- Inativa as parcelas do acordo                                                         
        UPDATE dbo.tbl_parcela_acordo                                             
        SET ativo = 0                                                                                
        FROM #tmp_inativar                                                                                
            JOIN tbl_parcela_acordo                            ON tbl_parcela_acordo.id_acordo = #tmp_inativar.id_acordo                                                  
                                                                                   
                                    
                                                                                
                                                                                
        UPDATE tbl_parcela                                                                     
        SET tbl_parcela.id_devolucao = @id_lote_devolucao,                                                                                
            tbl_parcela.data_devolucao = GETDATE(),                                                                                
            tbl_parcela.motivo_devolucao = 'B',                                                            tbl_parcela.ativo = '0'                           
        FROM #tmp_inativar                                                                             
            INNER JOIN tbl_parcela                                                                                
                ON tbl_parcela.id_contrato = #tmp_inativar.id_contrato                                                  
    WHERE tbl_parcela.ativo = 1                                                                               
                                                                                
                                                                    
                                                                                
        UPDATE tbl_contrato                                                                        
        SET tbl_contrato.ativo = '0'                                                                                
        FROM #tmp_inativar                                                                                
            INNER JOIN tbl_contrato                                                                                
                ON tbl_contrato.id_contrato = #tmp_inativar.id_contrato                                                                                
                   AND #tmp_inativar.id_devedor = tbl_contrato.id_devedor;                                                                                
                     
                                                                                
                       
                                 
                                
INSERT INTO dbo.tbl_originacao_detalhe                                
(                                
    id_operacion_sir,                                
    observacao                                
)                                
SELECT DISTINCT                                
    id_operacion_sir,                                
    Observaciones                                
FROM tbl_importacao_recovery_originacao_detalhe_novo_web_robo a                                
WHERE id_operacion_sir NOT IN (                                
                                  SELECT id_operacion_sir                        
                                  FROM tbl_originacao_detalhe                                
                                  WHERE a.id_operacion_sir = tbl_originacao_detalhe.id_operacion_sir                                
   );                                
                                
                                 
                                 
UPDATE dbo.tbl_originacao_detalhe                                
SET observacao = Observaciones                                
FROM tbl_originacao_detalhe                                
    JOIN tbl_importacao_recovery_originacao_detalhe_novo_web_robo                                
        ON tbl_importacao_recovery_originacao_detalhe_novo_web_robo.id_operacion_sir = tbl_originacao_detalhe.id_operacion_sir;                                
                                
                                
                                                                          
                                                                                
        INSERT INTO ACIONAMENTO_COBRANCA.dbo.tbl_ocorrencia_lote_batch                                                                            
        (                                                                                
            id_campanha,                                                                                
           id_devedor,                        
            obs,                                                                                
            usuario,                                                                                
            cod_ocorrencia,                                                                                
            data_insercao,                                                                                
            query                                                                                
        )                                                                                
        SELECT DISTINCT                                                                                
288,                                                            
            id_devedor,                 
            'RETIRADA DE CONTRATO PELA RECOVERY',                                                                                
            'CARGA AUTOMATICA',                                                                                
            9952,                                                                                
            GETDATE(),                                                                                
            '' AS query                                                                                
        FROM #tmp_inativar;                                                                                
                                                                                
        -- ======================                                                                                                         
        -- ESTRUTURA DE BI FISICO                                                                                                  
        -- ======================                                                                                                      
        EXEC dbo.PROC_ROBO_INSERT_LOG_LOTE @id_lote_log,                                                                                
                                           'IMPORTACAO',                                                                        
                        'Carteira - 288',                                                                            
           'ESTRUTURA DE BI FISICO',                                                                                
                                           'FALSE';                                                                
                                                                                
        -- INSERE OS DEVEDORES RELACIONADOS NA CARGA                                                             
        INSERT INTO tbl_bi_fisico_lote                                                            
        SELECT DISTINCT                                                                                
            id_devedor,                                                                                
    'CARGA D',                                                                                
          GETDATE(),                                                                                
            'CARGA AUTOMATICA DE DEVEDORES'                                                                             
     FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                     
        WHERE NOT EXISTS                                                                                
        (                                                                                
            SELECT 1                                                                     
            FROM tbl_bi_fisico_lote bi                                                 
WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor = bi.id_referencia                                                                           
                  AND bi.flag = 'CARGA D'                          
        )                                    
              AND tbl_importacao_recovery_operacoes_NOVO_web_robo.id_devedor IS NOT NULL;                                                                                
                                                                                
        BEGIN -- [ INICIO - INSERE OS CONTRATOS RELACIONADOS NA CARGA ]                                                                                                  
                                                                                
   BEGIN -- [ INICIO - Casos com o id_contrato is not null  ]                                                                                                  
                INSERT INTO tbl_bi_fisico_lote                                                                                
                SELECT DISTINCT                                                                                
                    id_contrato,                                                                                
                    'CARGA C',                                                                    
                    GETDATE(),                                                                                
                    'CARGA AUTOMATICA DE CONTRATOS'                                                                                
                FROM tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                WHERE NOT EXISTS                                                                                
                (                                                                                
                    SELECT 1                                                                                
                    FROM tbl_bi_fisico_lote bi                                                                                
                    WHERE tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato = bi.id_referencia                                                                                
                          AND bi.flag = 'CARGA C'                                                                                
                )                                                                                
                      AND tbl_importacao_recovery_operacoes_NOVO_web_robo.id_contrato IS NOT NULL;                                                                                
                                                                          
   INSERT INTO tbl_bi_fisico_lote                                                                                
                SELECT DISTINCT                                                                                      id_contrato,                                                                                
                    'CARGA C',                                                                                
                    GETDATE(),                                                                                
           'CARGA AUTOMATICA DE CONTRATOS'                                       
                FROM #temp_dados_acordo_quidados;                                                          
                                                                                
                INSERT INTO tbl_bi_fisico_lote                                                                                
                SELECT DISTINCT                                                                        id_contrato,                                                                                
                    'CARGA C',                                                                          
                    GETDATE(),                                                                                
                    'CARGA AUTOMATICA DE CONTRATOS'                              
      FROM #tmp_inativar;                                                                                
                                               
                                                                                
                INSERT INTO tbl_bi_fisico_lote                                                         
                SELECT DISTINCT                                                 
                    id_devedor,                                                               
                    'CARGA D',                           
                    GETDATE(),                                                                                
                    'CARGA AUTOMATICA DE DEVEDORES'                                                                  
                FROM #tmp_inativar;                                                                                
            END; -- [ FIM ]                                                                         
                                                                                
            BEGIN -- [ INICIO - Casos com id_lote da importação e não estão na tabela temporária ]                                                                                                  
                INSERT INTO tbl_bi_fisico_lote                                 
                SELECT DISTINCT                                                                                
                    tbl_parcela.id_contrato,                                                                                
                    'CARGA C',                                                                                
      GETDATE(),                                                                                
                    'CARGA AUTOMATICA DE CONTRATOS'                                                                                
                FROM tbl_parcela                                                                                
                    INNER JOIN tbl_importacao_recovery_operacoes_NOVO_web_robo                                                                                
                        ON tbl_parcela.id_parcela = tbl_importacao_recovery_operacoes_NOVO_web_robo.id_parcela                                                                                
                WHERE tbl_parcela.ativo = 1                                                         
                      AND tbl_parcela.id_boleto_pagamento_percapita IS NULL                                          
                      AND NOT EXISTS                                                                         
                (                                                                     
                    SELECT 1                                                                                
                    FROM tbl_bi_fisico_lote bi                                                                                
                    WHERE tbl_parcela.id_contrato = bi.id_referencia                                                                                
    AND bi.flag = 'CARGA C'                                                                                
                );                                                                                
            END; -- [ FIM ]                                                                                                  
                                                                                
        END; -- [ FIM ]                                                                                                  
                                                                  
        BEGIN -- [ INICIO - RESUMO ]                                                                                                  
            INSERT INTO dbo.tbl_importacao_recovery_resumo                                                                                
            (                                                                                
                data_processamento,                                                                                
                nome_processo,               
                descricao,                                                                         
                total_processado,                                                                                
                cpf_cnpj                                                                                
       )                                                                                
            SELECT DISTINCT                                                                                
                CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 103), 103) AS DATA,                                              
                'CARGA' AS processo,           
                'TOTAL DE NOVOS DEVEDORES' AS descrição,                                                                                
                (                                  
                    SELECT COUNT(DISTINCT nro_doc)                                                                                
FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                      
       ) AS total,                                                                                
                nro_doc AS cpf_cnpj                                                          
            FROM tbl_importacao_recovery_contatos_NOVO_web_robo                                                                                
   WHERE dbo.tbl_importacao_recovery_contatos_NOVO_web_robo.id_devedor IS NOT NULL;                                                                                
        END; -- [ FIM ]                                                                                                  
                                                                                
        SELECT @erro_imp_web = 0;                                                                       
                                                                                
    END TRY                                                                                
    BEGIN CATCH                                                                                
                                                                                
        -- EVITA DE DEIXAR MAIS DE UMA TRANSAÇÃO ABERTA, FINALIZANDO TODAS                                   
        WHILE @@TRANCOUNT > 0                                                                          
        BEGIN                               
            ROLLBACK;                                                                                
        END;                                                                                
                                                    
        DECLARE @ERROR_MESSAGE AS VARCHAR(200),                                                                                
                @ERROR_LINE AS VARCHAR(200),                                                                                
                @ERROR_PROCEDURE AS VARCHAR(200),                                                  @resumo AS VARCHAR(500);                                                                                
                                       
        SELECT @ERROR_MESSAGE = ISNULL(ERROR_MESSAGE(), ''),                                                                                
    @ERROR_LINE = ISNULL(ERROR_LINE(), ''),                                                                                
               @ERROR_PROCEDURE = ISNULL(ERROR_PROCEDURE(), '');                                                                                
                                                                                
        SET @resumo = @ERROR_MESSAGE + '/' + @ERROR_LINE + '/' + @ERROR_PROCEDURE;                                                                      
                                                                                
        EXEC SPO.RECOVERY.dbo.PROC_ROBO_INSERT_LOG_LOTE @lote,                                              
                                                        'IMPORTACAO',                                                                                
                                                        'Carteira - 288',                                                                                
                                                        @resumo,                                                                                
                                                        'FALSE';                                                                                
                                                                                
    SELECT -1 AS COD_MSG,                                                                                
               @resumo AS MSG;                                      
                                                                                
                                                                                
    END CATCH;                                                                                                  
END; 
