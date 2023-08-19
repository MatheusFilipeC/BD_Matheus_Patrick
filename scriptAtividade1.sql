-- Criação da base de dados
CREATE DATABASE ds330;
USE ds330;

-- Criação das tabelas
CREATE TABLE Cliente
(
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    DataNascimento DATE,
    CNH VARCHAR(20),
    Telefone VARCHAR(20)
);

CREATE TABLE Endereco
(
    ID INT PRIMARY KEY,
    ClienteID INT,
    Logradouro VARCHAR(150),
    Numero VARCHAR(20),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    Estado VARCHAR(50),
    CEP VARCHAR(10),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ID)
);

CREATE TABLE Veiculo
(
    ID INT PRIMARY KEY,
    Marca VARCHAR(50),
    Modelo VARCHAR(50),
    Ano INT,
    Tipo VARCHAR(20),
    Disponivel BOOLEAN,
    Quilometragem INT,
    Combustivel VARCHAR(20)
);

CREATE TABLE Locacao
(
    ID INT PRIMARY KEY,
    ClienteID INT,
    VeiculoID INT,
    DataInicio DATETIME,
    DataFim DATETIME,
    Valor DECIMAL(10, 2),
    Status VARCHAR(20),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ID),
    FOREIGN KEY (VeiculoID) REFERENCES Veiculo(ID)
);

CREATE TABLE Acessorio
(
    ID INT PRIMARY KEY,
    Nome VARCHAR(50),
    Descricao TEXT
);

CREATE TABLE Veiculo_Acessorio
(
    VeiculoID INT,
    AcessorioID INT,
    PRIMARY KEY (VeiculoID, AcessorioID),
    FOREIGN KEY (VeiculoID) REFERENCES Veiculo(ID),
    FOREIGN KEY (AcessorioID) REFERENCES Acessorio(ID)
);

-- Inserção de dados de exemplo
INSERT INTO Cliente
    (ID, Nome, Email, DataNascimento, CNH, Telefone)
VALUES
    (1, 'João', 'joao@example.com', '1990-01-01', '123456', '123456789');

INSERT INTO Veiculo
    (ID, Marca, Modelo, Ano, Tipo, Disponivel, Quilometragem, Combustivel)
VALUES
    (1, 'Toyota', 'Corolla', 2022, 'Sedan', TRUE, 0, 'Gasolina');

INSERT INTO Acessorio
    (ID, Nome, Descricao)
VALUES
    (1, 'Ar Condicionado', 'Sistema de ar condicionado para o veículo.');


-- Inserir Endereço para o Cliente
INSERT INTO Endereco
    (ID, ClienteID, Logradouro, Numero, Bairro, Cidade, Estado, CEP)
VALUES
    (1, 1, 'Rua Principal', '123', 'Centro', 'Cidade', 'Estado', '12345-678');

-- Inserir Locação para o Cliente e Veículo
INSERT INTO Locacao
    (ID, ClienteID, VeiculoID, DataInicio, DataFim, Valor, Status)
VALUES
    (1, 1, 1, '2023-08-19 10:00:00', '2023-08-25 18:00:00', 350.00, 'Ativa');

-- Relacionar Acessórios com Veículo
INSERT INTO Veiculo_Acessorio
    (VeiculoID, AcessorioID)
VALUES
    (1, 1);

-- Listagem de Clientes com Endereços:

SELECT c.Nome, e.Logradouro, e.Cidade
FROM Cliente c
    JOIN Endereco e ON c.ID = e.ClienteID;


-- Listagem de Veículos Disponíveis com Acessórios:

SELECT v.Marca, v.Modelo, a.Nome AS Acessorio
FROM Veiculo v
    LEFT JOIN Veiculo_Acessorio va ON v.ID = va.VeiculoID
    LEFT JOIN Acessorio a ON va.AcessorioID = a.ID
WHERE v.Disponivel = TRUE;



-- Stored procedure para busca condicional
DELIMITER //

CREATE PROCEDURE BuscarLocacoesPorCliente(IN ClienteID INT)
BEGIN
    SELECT c.Nome AS NomeCliente, c.Telefone, l.ID, v.Marca, v.Modelo, l.DataInicio, l.DataFim
    FROM Locacao l
        JOIN Veiculo v ON l.VeiculoID = v.ID
        JOIN Cliente c ON l.ClienteID = c.ID
    WHERE l.ClienteID = ClienteID;
END;

//

DELIMITER ;

-- Stored procedure para listar acessórios de um veículo
DELIMITER //

CREATE PROCEDURE ListarAcessoriosPorVeiculo(IN VeiculoID INT)
BEGIN
    SELECT v.Marca, v.Modelo, a.Nome AS NomeAcessorio, a.Descricao
    FROM Veiculo v
        JOIN Veiculo_Acessorio va ON v.ID = va.VeiculoID
        JOIN Acessorio a ON va.AcessorioID = a.ID
    WHERE v.ID = VeiculoID;
END;

//

DELIMITER ;
