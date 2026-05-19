DROP TABLE IF EXISTS avaliacao CASCADE;
DROP TABLE IF EXISTS item_pedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS cep CASCADE;

CREATE TABLE cep (
    cep VARCHAR(8) PRIMARY KEY,
    bairro VARCHAR(100) NOT NULL
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    rua VARCHAR(120) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(120),
    cep VARCHAR(8) NOT NULL,

    CONSTRAINT fk_cliente_cep
        FOREIGN KEY (cep)
        REFERENCES cep(cep)
);

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10,2) NOT NULL CHECK (preco > 0),
    preco_comparacao NUMERIC(10,2),
    id_categoria INTEGER NOT NULL,

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),

    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);
