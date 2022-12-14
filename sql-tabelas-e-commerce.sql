-- Criando database dioDBexperienceEcommerce
CREATE DATABASE dioDBexperienceEcommerce;

USE dioDBexperienceEcommerce;


-- Criando tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
  idCliente INT NOT NULL PRIMARY KEY auto_increment,
  endereco VARCHAR(45) NULL) 
ENGINE = InnoDB;

-- Criando tabela ClientePF
CREATE TABLE IF NOT EXISTS ClientePF (
  Cliente_idCliente INT NOT NULL PRIMARY KEY auto_increment,
  nome VARCHAR(45) NULL,
  cpf VARCHAR(11) NULL,  
  CONSTRAINT unq_clientePF unique (cpf),  
  CONSTRAINT fk_ClientePF_Cliente1
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

--Criando tabela ClientePJ
CREATE TABLE IF NOT EXISTS ClientePJ (
  Cliente_idCliente INT NOT NULL PRIMARY KEY auto_increment,
  razao_social VARCHAR(45) NULL,
  cnpj VARCHAR(15) NULL,  
  CONSTRAINT unq_clientePJ unique (cnpj),
  CONSTRAINT fk_ClientePJ_Cliente1
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Pedido
CREATE TABLE IF NOT EXISTS Pedido (
  idPedido INT NOT NULL PRIMARY KEY auto_increment,
  descricao VARCHAR(45) NULL,
  valor_frete DECIMAL(5,2) NULL,
  Cliente_idCliente INT NOT NULL,
  valor_pedido DECIMAL(5,2) NULL,   
  CONSTRAINT fk_Pedido_Cliente1
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Status_Pedido
CREATE TABLE IF NOT EXISTS Status_Pedido (
  idStatus_Pedido INT NOT NULL PRIMARY KEY auto_increment,
  status VARCHAR(45) NULL,
  descricao VARCHAR(45) NULL,
  Pedido_idPedido INT NOT NULL,    
  CONSTRAINT fk_Status_Pedido_Pedido1
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido (idPedido)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Produto
CREATE TABLE IF NOT EXISTS Produto (
  idProduto INT NOT NULL,
  descricao VARCHAR(45) NULL,
  categoria enum('Eletrônicos', 'Móveis', 'Ferramentas') NULL,
  valor_produto DECIMAL(5,2) NULL)  
ENGINE = InnoDB;

-- Criando tabela Empresa
CREATE TABLE IF NOT EXISTS Empresa (
  idEmpresa INT NOT NULL PRIMARY KEY auto_increment,
  razao_social VARCHAR(45) NULL,
  cnpj VARCHAR(45) NULL,
  CONSTRAINT unq_Empresa unique (cnpj)) 
ENGINE = InnoDB;

-- Criando tabela Fornecedor
CREATE TABLE IF NOT EXISTS Fornecedor (
  idfornecedor INT NOT NULL PRIMARY KEY auto_increment,
  Empresa_idEmpresa INT NOT NULL, 
  CONSTRAINT fk_fornecedor_Empresa1
    FOREIGN KEY (Empresa_idEmpresa) REFERENCES Empresa (idEmpresa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Vendedor
CREATE TABLE IF NOT EXISTS Vendedor (
  idVendedor INT NOT NULL PRIMARY KEY auto_increment,
  Empresa_idEmpresa INT NOT NULL,  
  CONSTRAINT fk_Vendedor_Empresa1
    FOREIGN KEY (Empresa_idEmpresa) REFERENCES Empresa (idEmpresa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Forma_Pagamento
CREATE TABLE IF NOT EXISTS Forma_Pagamento (
  idForma_Pagamento INT NOT NULL PRIMARY KEY auto_increment,
  descricao VARCHAR(45) NULL) 
ENGINE = InnoDB;


-- Criando tabela Forma_Pagamento_Cliente
CREATE TABLE IF NOT EXISTS Forma_Pagamento_Cliente (
  idForma_Pagamento_Cliente INT NOT NULL PRIMARY KEY auto_increment,
  descricao VARCHAR(45) NULL,
  data_vencimento VARCHAR(45) NULL,
  Cliente_idCliente INT NOT NULL,
  dados_forma_pagamento_cliente VARCHAR(45) NULL,
  idForma_Pagamento INT NOT NULL,
  CONSTRAINT unq_fpg_cliente unique (Cliente_idCliente, idForma_Pagamento),    
  CONSTRAINT fk_Cartao_Cliente_Cliente1
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Forma_Pagamento_Cliente_Forma_Pagamento1
    FOREIGN KEY (idForma_Pagamento) REFERENCES Forma_Pagamento (idForma_Pagamento)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Criando a tabela Pagamento_Pedido
CREATE TABLE IF NOT EXISTS Pagamento_Pedido (
  idPagamento_Pedido INT NOT NULL PRIMARY KEY auto_increment,
  data_hora VARCHAR(45) NULL,
  codigo_transacao VARCHAR(45) NULL,
  Pedido_idPedido INT NOT NULL,
  idForma_Pagamento_Cliente INT NOT NULL,
  CONSTRAINT unq_pgto_pedido unique (Pedido_idPedido), 
  CONSTRAINT fk_Pagamento_Pedido_Pedido1
    FOREIGN KEY (Pedido_idPedido)
    REFERENCES Pedido (idPedido)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Pagamento_Pedido_Forma_Pagamento_Cliente1
    FOREIGN KEY (idForma_Pagamento_Cliente)
    REFERENCES Forma_Pagamento_Cliente (idForma_Pagamento_Cliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Criando tabela Entrega
CREATE TABLE IF NOT EXISTS Entrega (
  idEntrega INT NOT NULL PRIMARY KEY auto_increment,
  data_hora VARCHAR(45) NULL,
  codigo_rastreio VARCHAR(45) NULL,
  status enum('Em Curso', 'Entregue', 'Cancelado') NULL,
  observacao VARCHAR(45) NULL,
  Pedido_idPedido INT NOT NULL,   
  CONSTRAINT fk_Entrega_Pedido1
    FOREIGN KEY (Pedido_idPedido)
    REFERENCES Pedido (idPedido)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Criando tabela Itens_Pedido
CREATE TABLE IF NOT EXISTS Itens_Pedido (
  idItens_Pedido INT NOT NULL PRIMARY KEY auto_increment,
  idPedido INT NOT NULL,
  idProduto INT NOT NULL,
  quantidade INT NULL,  
  CONSTRAINT unq_itens_pedido unique (idPedido, idProduto),
  CONSTRAINT fk_Itens_Pedido_idpedido
  FOREIGN KEY (idPedido) REFERENCES Pedido (idPedido)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  CONSTRAINT fk_Itens_Pedido_idproduto
  FOREIGN KEY (Produto_idProduto)
  REFERENCES Produto (idProduto)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Criando tabela Produto_Vendedor
CREATE TABLE IF NOT EXISTS Produto_Vendedor (
  Produto_idProduto INT NOT NULL,
  Vendedor_idVendedor INT NOT NULL,
  PRIMARY KEY (Produto_idProduto, Vendedor_idVendedor),  
  CONSTRAINT fk_Produto_has_Vendedor_Produto1
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produto_has_Vendedor_Vendedor1
    FOREIGN KEY (Vendedor_idVendedor) REFERENCES Vendedor (idVendedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Criando tabela Produto_Fornecedor
CREATE TABLE IF NOT EXISTS Produto_Fornecedor (
  idProduto_Fornecedor INT NOT NULL PRIMARY KEY auto_increment, 
  Produto_idProduto INT NOT NULL,
  fornecedor_idfornecedor INT NOT NULL,   
  CONSTRAINT unq_prod_fornec unique (Produto_idProduto, fornecedor_idfornecedor),  
  CONSTRAINT fk_Produto_has_fornecedor_Produto1
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produto_fornecedor_fornecedor1
    FOREIGN KEY (fornecedor_idfornecedor) REFERENCES fornecedor (idfornecedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Criando tabela Estoque
CREATE TABLE IF NOT EXISTS Estoque (
  idEstoque INT NOT NULL PRIMARY KEY auto_increment,
  local_distribuicao VARCHAR(45) NULL)
ENGINE = InnoDB;

-- Criando tabela Produto_Fornecedor_Estoque
CREATE TABLE IF NOT EXISTS Produto_Fornecedor_Estoque (
  idEstoque INT NOT NULL,
  quantidade INT NULL,
  idProduto_Fornecedor INT NOT NULL,
  PRIMARY KEY (idEstoque, idProduto_Fornecedor), 
  CONSTRAINT fk_Produto_Fornecedor_Estoque_Estoque1
    FOREIGN KEY (idEstoque) REFERENCES Estoque (idEstoque)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produto_Fornecedor_Estoque_Produto_Fornecedor1
    FOREIGN KEY (idProduto_Fornecedor) REFERENCES Produto_Fornecedor (idProduto_Fornecedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

