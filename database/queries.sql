-- ============================================
-- COMANDOS INSERT
-- ============================================
-- IMPORTANTE: Execute os comandos na ordem apresentada!
-- 1. Primeiro insira os clientes
-- 2. Depois insira endereços, contatos e emails

-- PASSO 1: Inserir clientes
INSERT INTO clients (nome, cpf, data_nascimento) VALUES
('João Silva Santos', '123.456.789-01', '1990-05-15'),
('Maria Oliveira Costa', '234.567.890-12', '1985-08-22'),
('Pedro Henrique Souza', '345.678.901-23', '1992-11-10'),
('Ana Carolina Lima', '456.789.012-34', '1988-03-25'),
('Carlos Eduardo Alves', '567.890.123-45', '1995-07-18');

-- PASSO 2: Inserir endereços (os client_id devem existir)
-- Execute este bloco SOMENTE APÓS inserir os clientes acima
INSERT INTO enderecos (rua, numero, bairro, cep, cidade, estado, complemento, client_id) VALUES
('Rua das Flores', '123', 'Centro', '01234-567', 'São Paulo', 'SP', 'Apto 101', 1),
('Avenida Paulista', '1000', 'Bela Vista', '01310-100', 'São Paulo', 'SP', 'Sala 205', 2),
('Rua dos Andradas', '456', 'Santa Efigênia', '30110-009', 'Belo Horizonte', 'MG', NULL, 3),
('Rua Sete de Setembro', '789', 'Centro', '80010-000', 'Curitiba', 'PR', 'Casa', 4),
('Avenida Atlântica', '2000', 'Copacabana', '22021-001', 'Rio de Janeiro', 'RJ', 'Cobertura', 5);

-- PASSO 3: Inserir contatos (os client_id devem existir)
INSERT INTO contatos (telefone, tipo, client_id) VALUES
('(11) 98765-4321', 'Celular', 1),
('(11) 3456-7890', 'Fixo', 1),
('(11) 99876-5432', 'Celular', 2),
('(11) 3321-9876', 'Comercial', 2),
('(31) 98888-7777', 'Celular', 3),
('(41) 99999-8888', 'Celular', 4),
('(41) 3222-3333', 'Fixo', 4),
('(21) 97777-6666', 'Celular', 5);

-- PASSO 4: Inserir emails (os client_id devem existir)
INSERT INTO emails (endereco, tipo, client_id) VALUES
('joao.silva@email.com', 'Pessoal', 1),
('joao.trabalho@empresa.com', 'Comercial', 1),
('maria.costa@email.com', 'Pessoal', 2),
('maria@consultoria.com', 'Comercial', 2),
('pedro.souza@email.com', 'Pessoal', 3),
('ana.lima@email.com', 'Pessoal', 4),
('ana.lima@work.com', 'Comercial', 4),
('carlos.alves@email.com', 'Pessoal', 5);

-- ============================================
-- ALTERNATIVA: INSERT COMPLETO EM UMA TRANSAÇÃO
-- ============================================
-- Se preferir, execute tudo de uma vez em uma transação:

-- START TRANSACTION;
-- 
-- INSERT INTO clients (nome, cpf, data_nascimento) VALUES
-- ('João Silva Santos', '123.456.789-01', '1990-05-15');
-- SET @client1_id = LAST_INSERT_ID();
-- 
-- INSERT INTO enderecos (rua, numero, bairro, cep, cidade, estado, complemento, client_id) VALUES
-- ('Rua das Flores', '123', 'Centro', '01234-567', 'São Paulo', 'SP', 'Apto 101', @client1_id);
-- 
-- INSERT INTO contatos (telefone, tipo, client_id) VALUES
-- ('(11) 98765-4321', 'Celular', @client1_id),
-- ('(11) 3456-7890', 'Fixo', @client1_id);
-- 
-- INSERT INTO emails (endereco, tipo, client_id) VALUES
-- ('joao.silva@email.com', 'Pessoal', @client1_id),
-- ('joao.trabalho@empresa.com', 'Comercial', @client1_id);
-- 
-- COMMIT;

-- ============================================
-- QUERIES DE BUSCA COM FILTROS
-- ============================================

-- Buscar todos os clientes
SELECT * FROM clients;

-- Buscar cliente por ID
SELECT * FROM clients WHERE id = 1;

-- Buscar cliente por CPF
SELECT * FROM clients WHERE cpf = '123.456.789-01';

-- Buscar clientes por nome (busca parcial)
SELECT * FROM clients WHERE nome LIKE '%Silva%';

-- Buscar clientes nascidos após determinada data
SELECT * FROM clients WHERE data_nascimento > '1990-01-01';

-- Buscar clientes por faixa etária (nascidos entre datas)
SELECT 
    id, 
    nome, 
    cpf, 
    data_nascimento,
    TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) as idade
FROM clients 
WHERE data_nascimento BETWEEN '1985-01-01' AND '1995-12-31';

-- Buscar clientes ordenados por nome
SELECT * FROM clients ORDER BY nome ASC;

-- ============================================

-- Buscar endereço de um cliente específico
SELECT * FROM enderecos WHERE client_id = 1;

-- Buscar clientes por cidade
SELECT c.*, e.cidade, e.estado
FROM clients c
INNER JOIN enderecos e ON c.id = e.client_id
WHERE e.cidade = 'São Paulo';

-- Buscar clientes por estado
SELECT c.nome, c.cpf, e.cidade, e.estado
FROM clients c
INNER JOIN enderecos e ON c.id = e.client_id
WHERE e.estado = 'SP';

-- Buscar clientes por CEP
SELECT c.*, e.cep, e.rua, e.bairro
FROM clients c
INNER JOIN enderecos e ON c.id = e.client_id
WHERE e.cep LIKE '01%';

-- Buscar endereços por bairro
SELECT c.nome, e.rua, e.numero, e.bairro, e.cidade
FROM clients c
INNER JOIN enderecos e ON c.id = e.client_id
WHERE e.bairro = 'Centro';

-- ============================================

-- Buscar todos os contatos de um cliente
SELECT * FROM contatos WHERE client_id = 1;

-- Buscar contatos por tipo
SELECT c.nome, co.telefone, co.tipo
FROM clients c
INNER JOIN contatos co ON c.id = co.client_id
WHERE co.tipo = 'Celular';

-- Buscar clientes com múltiplos contatos
SELECT c.nome, COUNT(co.id) as total_contatos
FROM clients c
INNER JOIN contatos co ON c.id = co.client_id
GROUP BY c.id, c.nome
HAVING COUNT(co.id) > 1;

-- Buscar contatos por DDD
SELECT c.nome, co.telefone, co.tipo
FROM clients c
INNER JOIN contatos co ON c.id = co.client_id
WHERE co.telefone LIKE '(11)%';

-- ============================================

-- Buscar todos os emails de um cliente
SELECT * FROM emails WHERE client_id = 1;

-- Buscar emails por tipo
SELECT c.nome, e.endereco, e.tipo
FROM clients c
INNER JOIN emails e ON c.id = e.client_id
WHERE e.tipo = 'Comercial';

-- Buscar clientes com múltiplos emails
SELECT c.nome, COUNT(e.id) as total_emails
FROM clients c
INNER JOIN emails e ON c.id = e.client_id
GROUP BY c.id, c.nome
HAVING COUNT(e.id) > 1;

-- Buscar emails por domínio
SELECT c.nome, e.endereco
FROM clients c
INNER JOIN emails e ON c.id = e.client_id
WHERE e.endereco LIKE '%@email.com';

-- ============================================
-- RELATÓRIOS COMPLETOS
-- ============================================

-- Relatório completo de um cliente com todos os relacionamentos
SELECT 
    c.id,
    c.nome,
    c.cpf,
    c.data_nascimento,
    e.rua,
    e.numero,
    e.bairro,
    e.cep,
    e.cidade,
    e.estado
FROM clients c
LEFT JOIN enderecos e ON c.id = e.client_id
WHERE c.id = 1;

-- Listar todos os clientes com suas informações básicas
SELECT 
    c.id,
    c.nome,
    c.cpf,
    TIMESTAMPDIFF(YEAR, c.data_nascimento, CURDATE()) as idade,
    e.cidade,
    e.estado
FROM clients c
LEFT JOIN enderecos e ON c.id = e.client_id
ORDER BY c.nome;

-- Relatório de clientes com contagem de contatos e emails
SELECT 
    c.id,
    c.nome,
    c.cpf,
    COUNT(DISTINCT co.id) as total_contatos,
    COUNT(DISTINCT em.id) as total_emails
FROM clients c
LEFT JOIN contatos co ON c.id = co.client_id
LEFT JOIN emails em ON c.id = em.client_id
GROUP BY c.id, c.nome, c.cpf;

-- Clientes por estado (estatística)
SELECT 
    e.estado,
    e.cidade,
    COUNT(c.id) as total_clientes
FROM enderecos e
INNER JOIN clients c ON e.client_id = c.id
GROUP BY e.estado, e.cidade
ORDER BY e.estado, total_clientes DESC;

-- ============================================
-- QUERIES DE VALIDAÇÃO
-- ============================================

-- Verificar se CPF já existe (para validação)
SELECT COUNT(*) as existe FROM clients WHERE cpf = '123.456.789-01';

-- Verificar CPF duplicado excluindo um ID específico
SELECT COUNT(*) as existe 
FROM clients 
WHERE cpf = '123.456.789-01' AND id != 1;

-- Clientes sem contatos (inconsistência)
SELECT c.* 
FROM clients c
LEFT JOIN contatos co ON c.id = co.client_id
WHERE co.id IS NULL;

-- Clientes sem emails (inconsistência)
SELECT c.* 
FROM clients c
LEFT JOIN emails e ON c.id = e.client_id
WHERE e.id IS NULL;

-- Clientes sem endereço (inconsistência)
SELECT c.* 
FROM clients c
LEFT JOIN enderecos e ON c.id = e.client_id
WHERE e.id IS NULL;

-- ============================================
-- QUERIES DE ATUALIZAÇÃO
-- ============================================

-- Atualizar dados do cliente
UPDATE clients 
SET nome = 'João Silva Santos Junior'
WHERE id = 1;

-- Atualizar endereço
UPDATE enderecos 
SET rua = 'Rua Nova', numero = '999'
WHERE client_id = 1;

-- Atualizar telefone
UPDATE contatos 
SET telefone = '(11) 99999-9999'
WHERE id = 1;

-- Atualizar email
UPDATE emails 
SET endereco = 'novo.email@example.com'
WHERE id = 1;

-- ============================================
-- QUERIES DE DELEÇÃO (CUIDADO!)
-- ============================================

-- Deletar contato específico
-- DELETE FROM contatos WHERE id = 1;

-- Deletar email específico
-- DELETE FROM emails WHERE id = 1;

-- Deletar cliente completo (cascade deleta relacionamentos)
-- DELETE FROM clients WHERE id = 1;

-- ============================================
-- QUERIES ÚTEIS PARA DEBUG
-- ============================================

-- Contar total de registros por tabela
SELECT 'clients' as tabela, COUNT(*) as total FROM clients
UNION ALL
SELECT 'enderecos', COUNT(*) FROM enderecos
UNION ALL
SELECT 'contatos', COUNT(*) FROM contatos
UNION ALL
SELECT 'emails', COUNT(*) FROM emails;

-- Ver últimos clientes cadastrados
SELECT * FROM clients ORDER BY id DESC LIMIT 5;

-- Ver estrutura das tabelas (MySQL/MariaDB)
DESCRIBE clients;
DESCRIBE enderecos;
DESCRIBE contatos;
DESCRIBE emails;
