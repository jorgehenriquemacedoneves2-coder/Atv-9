create database vendas_online_db;

IF DB_ID('vendas_online_db') IS NOT NULL
BEGIN
    ALTER DATABASE vendas_online_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE vendas_online_db;
END
GO

CREATE DATABASE vendas_online_db;
GO

USE vendas_online_db;
GO

CREATE TABLE clientes
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(120),
    cidade VARCHAR(60),
    ativo BIT DEFAULT 1
);
GO

CREATE INDEX idx_cidade
ON clientes(cidade);
GO

CREATE TABLE pedidos
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);
GO

CREATE INDEX idx_data_pedido
ON pedidos(data_pedido);
GO

INSERT INTO clientes(nome, cpf, cidade)
VALUES
('Ana Souza', '11111111111', 'São Paulo'),
('Bruno Lima', '22222222222', 'São Paulo'),
('Carla Nunes', '33333333333', 'Rio de Janeiro'),
('Diego Martins', '44444444444', 'Curitiba'),
('Elisa Rocha', '55555555555', 'São Paulo');
GO

INSERT INTO pedidos(id_cliente, valor, data_pedido)
VALUES
(1, 150.00, '2025-01-10'),
(1, 89.90, '2025-02-05'),
(2, 320.00, '2025-03-12'),
(3, 500.00, '2025-04-01'),
(3, 75.50, '2025-04-15'),
(4, 120.00, '2025-05-02');
GO

CREATE TABLE entregas
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    data_entrega DATE,
    status_entrega VARCHAR(20),
    valor_frete DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);
GO

CREATE INDEX idx_status
ON entregas(status_entrega);
GO

INSERT INTO entregas(id_pedido, data_entrega, status_entrega, valor_frete)
VALUES
(1, '2025-01-13', 'Entregue', 25.00),
(2, '2025-02-07', 'Entregue', 18.50),
(3, '2025-03-20', 'Cancelada', 0.00),
(4, '2025-04-05', 'Entregue', 35.00),
(5, '2025-04-17', 'Pendente', 28.90),
(6, '2025-05-06', 'Entregue', 22.00);
GO

CREATE VIEW resumo_entregas AS
SELECT
COUNT(*) AS total_entregas,
AVG(valor_frete) AS media_frete
FROM entregas;
GO

CREATE VIEW entregas_concluidas AS
SELECT
P.id AS id_pedido,
P.valor,
E.valor_frete,
E.data_entrega
FROM pedidos P
JOIN entregas E
ON P.id = E.id_pedido
WHERE E.status_entrega = 'Entregue';
GO

SELECT * FROM resumo_entregas;
GO

SELECT * FROM entregas_concluidas;
GO
