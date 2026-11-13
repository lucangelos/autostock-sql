CREATE TABLE usuario (
  id_usuario INT(10) PRIMARY KEY AUTO_INCREMENT NOT NULL,
  nm_usuario VARCHAR(120) NOT NULL,
  nm_email VARCHAR(255) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  cd_telefone INT(11),
  perfil ENUM('admin','estoquista', 'gerente de estoque') NOT NULL DEFAULT 'Estoquista',
  ativo tinyint(1) NOT NULL DEFAULT 1
); 

CREATE TABLE fornecedor ( 
	id_fornecedor TINYINT(3) PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    nm_fornecedor VARCHAR(120) NOT NULL,
    marcaProduto VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    cd_telefone INT(11) NOT NULL
);

CREATE TABLE endereco (
	id_endereco TINYINT(5) AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(150) NOT NULL,
    numero INT(5) UNSIGNED NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    id_fornecedor TINYINT(3),
    CONSTRAINT fk_fornecedor_id FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE localizacao (
	id_localizacao TINYINT(2) AUTO_INCREMENT PRIMARY KEY,
    ds_localizacao VARCHAR(50) NOT NULL,
    fileira CHAR(2) NOT NULL
);

CREATE TABLE produto (
    cd_produto VARCHAR(25) PRIMARY KEY NOT NULL,
    nm_produto VARCHAR(200) NOT NULL,
    qt_valor_unitario DECIMAL(10,2) UNSIGNED NOT NULL,
    ds_produto VARCHAR(80) NOT NULL,
    qt_produto INT NOT NULL,
    status BOOLEAN NOT NULL,

    id_fornecedor TINYINT(3) NOT NULL,
    CONSTRAINT fk_fornecedor_id
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),

    id_localizacao TINYINT(2) NOT NULL,
    CONSTRAINT fk_localizacao_id
    FOREIGN KEY (id_localizacao) REFERENCES localizacao(id_localizacao)
);

CREATE TABLE categoria (
  id_categoria tinyint(3) PRIMARY KEY NOT NULL,
  nm_categoria varchar(60) NOT NULL
);


CREATE TABLE produto_categoria (
    cd_produto VARCHAR(25) NOT NULL,
    id_categoria TINYINT(3) NOT NULL,

    PRIMARY KEY (cd_produto, id_categoria),

    CONSTRAINT fk_produto_categoria_produto
    FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto),

    CONSTRAINT fk_produto_categoria_categoria
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

/*Pode haver pedido de saída de produtos dentro do estoque.
  O usuário irá solicitar o pedido de saída dos produtos, e a tabela pedido ficará responsável por guardar essas informações e enviar ao administrador
*/
CREATE TABLE pedido (
    id_pedido INT(10) AUTO_INCREMENT PRIMARY KEY,
    dt_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ds_status ENUM('pendente', 'em andamento', 'concluido', 'cancelado') NOT NULL DEFAULT 'pendente',
    vl_total DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0.00,

    id_usuario INT(10) NOT NULL,
    CONSTRAINT fk_pedido_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

/*É a ligação entre a tabela PRODUTO e PEDIDO*/
CREATE TABLE item_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    qt_quantidade INT UNSIGNED NOT NULL,
    vl_unitario DECIMAL(10,2) UNSIGNED NOT NULL,

    id_pedido INT NOT NULL,
    cd_produto VARCHAR(25) NOT NULL,

    CONSTRAINT fk_item_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),

    CONSTRAINT fk_item_produto
    FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto)
);

CREATE TABLE historico (
	id_historico INT AUTO_INCREMENT PRIMARY KEY,
    nm_mensagem VARCHAR (150) NOT NULL,
    ds_movimentacao ENUM('Entrada', 'Saída', 'Alteração', 'Solicitação') NOT NULL,
    dt_movimentacao DATETIME NOT NULL,
    
    id_usuario INT(10) NOT NULL,
    CONSTRAINT fk_usuario_id FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    
    id_pedido INT(10) NOT NULL,
    CONSTRAINT fk_pedido_id FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);
