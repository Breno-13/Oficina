-- Configurações iniciais para desabilitar verificações temporárias
SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, 
    SQL_MODE = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,
                ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Criação do schema e seleção
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

-- -----------------------------------------------------
-- Tabela OrdemServico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OrdemServico` (
  `idOrdemServico` INT NOT NULL,
  `data_emissao` DATETIME NOT NULL,
  `valor_total` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `data_conclusao` DATETIME NOT NULL,
  PRIMARY KEY (`idOrdemServico`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela Veiculo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculo` (
  `idVeiculo` INT NOT NULL,
  `placa` VARCHAR(45) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  `ano` INT NOT NULL,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  PRIMARY KEY (`idVeiculo`, `OrdemServico_idOrdemServico`)
) ENGINE=InnoDB;

CREATE INDEX `fk_Veiculo_OrdemServico1_idx` ON `Veiculo` (`OrdemServico_idOrdemServico` ASC);

-- -----------------------------------------------------
-- Tabela Cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  `Veiculo_idVeiculo` INT NOT NULL,
  PRIMARY KEY (`idCliente`, `Veiculo_idVeiculo`)
) ENGINE=InnoDB;

CREATE INDEX `fk_Cliente_Veiculo1_idx` ON `Cliente` (`Veiculo_idVeiculo` ASC);

-- -----------------------------------------------------
-- Tabela Mecanico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mecanico` (
  `idMecanico` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  `especialidade` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idMecanico`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela Equipe
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Equipe` (
  `idEquipe` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `Mecanico_idMecanico` INT NOT NULL,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  PRIMARY KEY (`idEquipe`, `Mecanico_idMecanico`, `OrdemServico_idOrdemServico`)
) ENGINE=InnoDB;

CREATE INDEX `fk_Equipe_Mecanico1_idx` ON `Equipe` (`Mecanico_idMecanico` ASC);
CREATE INDEX `fk_Equipe_OrdemServico1_idx` ON `Equipe` (`OrdemServico_idOrdemServico` ASC);

-- -----------------------------------------------------
-- Tabela Servico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Servico` (
  `idServico` INT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `valor_mao_obra` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idServico`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela Peca
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Peca` (
  `idPeca` INT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `valor_unitario` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPeca`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabela OrdemServico_has_Servico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OrdemServico_has_Servico` (
  `OrdemServico_idOrdemServico` INT NOT NULL,
  `Servico_idServico` INT NOT NULL,
  PRIMARY KEY (`OrdemServico_idOrdemServico`, `Servico_idServico`)
) ENGINE=InnoDB;

CREATE INDEX `fk_OrdemServico_has_Servico_Servico1_idx` ON `OrdemServico_has_Servico` (`Servico_idServico` ASC);
CREATE INDEX `fk_OrdemServico_has_Servico_OrdemServico1_idx` ON `OrdemServico_has_Servico` (`OrdemServico_idOrdemServico` ASC);

-- -----------------------------------------------------
-- Tabela Peca_has_OrdemServico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Peca_has_OrdemServico` (
  `Peca_idPeca` INT NOT NULL,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  PRIMARY KEY (`Peca_idPeca`, `OrdemServico_idOrdemServico`)
) ENGINE=InnoDB;

CREATE INDEX `fk_Peca_has_OrdemServico_OrdemServico1_idx` ON `Peca_has_OrdemServico` (`OrdemServico_idOrdemServico` ASC);
CREATE INDEX `fk_Peca_has_OrdemServico_Peca1_idx` ON `Peca_has_OrdemServico` (`Peca_idPeca` ASC);

-- Restaurar configurações originais
SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Inserções
-- -----------------------------------------------------

-- Inserções na tabela OrdemServico
INSERT INTO OrdemServico (idOrdemServico, data_emissao, valor_total, status, data_conclusao) VALUES
(1, '2025-07-20 08:00:00', '1200.00', 'Em andamento', NULL),
(2, '2025-07-22 09:30:00', '850.50', 'Concluído', '2025-07-23 17:00:00');

-- Inserções na tabela Veiculo
INSERT INTO Veiculo (idVeiculo, placa, modelo, marca, ano, OrdemServico_idOrdemServico) VALUES
(1, 'ABC-1234', 'Gol', 'Volkswagen', 2018, 1),
(2, 'XYZ-5678', 'Civic', 'Honda', 2020, 2);

-- Inserções na tabela Cliente
INSERT INTO Cliente (idCliente, nome, telefone, endereco, Veiculo_idVeiculo) VALUES
(1, 'Carlos Silva', '11987654321', 'Rua das Flores, 123', 1),
(2, 'Fernanda Souza', '21987654321', 'Av. Paulista, 987', 2);

-- Inserções na tabela Mecanico
INSERT INTO Mecanico (idMecanico, nome, endereco, especialidade) VALUES
(1, 'João Pereira', 'Rua das Laranjeiras, 456', 'Motor'),
(2, 'Ana Martins', 'Av. Brasil, 789', 'Elétrica');

-- Inserções na tabela Equipe
INSERT INTO Equipe (idEquipe, nome, Mecanico_idMecanico, OrdemServico_idOrdemServico) VALUES
(1, 'Equipe A', 1, 1),
(2, 'Equipe B', 2, 2);

-- Inserções na tabela Servico
INSERT INTO Servico (idServico, descricao, valor_mao_obra) VALUES
(1, 'Troca de óleo', '150.00'),
(2, 'Revisão elétrica', '250.00');

-- Inserções na tabela Peca
INSERT INTO Peca (idPeca, descricao, valor_unitario) VALUES
(1, 'Filtro de óleo', '50.00'),
(2, 'Bateria', '300.00');

-- Inserções na tabela OrdemServico_has_Servico
INSERT INTO OrdemServico_has_Servico (OrdemServico_idOrdemServico, Servico_idServico) VALUES
(1, 1),
(2, 2);

-- Inserções na tabela Peca_has_OrdemServico
INSERT INTO Peca_has_OrdemServico (Peca_idPeca, OrdemServico_idOrdemServico) VALUES
(1, 1),
(2, 2);

-- -----------------------------------------------------
-- Consultas
-- -----------------------------------------------------

-- 1. Recuperações simples com SELECT Statement
SELECT nome, telefone 
FROM Cliente;

-- 2. Filtros com WHERE Statement
SELECT placa, modelo, ano 
FROM Veiculo
WHERE ano >= 2019;

-- 3. Expressões para gerar atributos derivados
SELECT idOrdemServico, valor_total, 
       valor_total * 1.10 AS valor_com_taxa 
FROM OrdemServico;

-- 4. Ordenações dos dados com ORDER BY
SELECT nome, especialidade 
FROM Mecanico
ORDER BY nome ASC;

-- 5. Condições de filtros aos grupos – HAVING Statement
SELECT OrdemServico_idOrdemServico, COUNT(*) AS qtd_servicos
FROM OrdemServico_has_Servico
GROUP BY OrdemServico_idOrdemServico
HAVING COUNT(*) >= 2;

-- 6. Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
SELECT c.nome AS Cliente, v.modelo AS Veiculo, o.status AS StatusOrdem, o.valor_total
FROM Cliente c
JOIN Veiculo v ON c.Veiculo_idVeiculo = v.idVeiculo
JOIN OrdemServico o ON v.OrdemServico_idOrdemServico = o.idOrdemServico
ORDER BY o.data_emissao DESC;
