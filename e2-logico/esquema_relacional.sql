-- E2 - Modelo logico em formato CREATE TABLE simplificado
-- Dominio: Plataforma de E-commerce

CREATE TABLE cep (
    cep VARCHAR(8) PRIMARY KEY,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    rua VARCHAR(120) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(120),
    cep VARCHAR(8) NOT NULL REFERENCES cep(cep)
);

CREATE TABLE cliente_telefone (
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente),
    telefone VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_cliente, telefone)
);

CREATE TABLE categoria (
    id_categoria INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE produto (
    id_produto INTEGER PRIMARY KEY,
    id_categoria INTEGER NOT NULL REFERENCES categoria(id_categoria),
    nome VARCHAR(120) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    preco_comparacao DECIMAL(10,2) CHECK (preco_comparacao IS NULL OR preco_comparacao >= preco),
    ativo BOOLEAN NOT NULL
);

CREATE TABLE estoque (
    id_produto INTEGER PRIMARY KEY REFERENCES produto(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade >= 0),
    estoque_minimo INTEGER NOT NULL CHECK (estoque_minimo >= 0),
    estoque_maximo INTEGER NOT NULL CHECK (estoque_maximo >= estoque_minimo)
);

CREATE TABLE cupom (
    codigo VARCHAR(30) PRIMARY KEY,
    tipo_desconto VARCHAR(20) NOT NULL CHECK (tipo_desconto IN ('percentual', 'valor')),
    desconto DECIMAL(10,2) NOT NULL CHECK (desconto > 0),
    ativo BOOLEAN NOT NULL,
    validade DATE NOT NULL
);

CREATE TABLE logistica (
    id_logistica INTEGER PRIMARY KEY,
    status_entrega VARCHAR(30) NOT NULL CHECK (status_entrega IN ('pendente', 'postado', 'em_transito', 'entregue', 'cancelado')),
    codigo_rastreio VARCHAR(40) UNIQUE,
    data_atualizacao TIMESTAMP NOT NULL
);

CREATE TABLE pedido (
    id_pedido INTEGER PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente),
    codigo_cupom VARCHAR(30) REFERENCES cupom(codigo),
    id_logistica INTEGER REFERENCES logistica(id_logistica),
    data_pedido TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL CHECK (status IN ('criado', 'pago', 'enviado', 'entregue', 'cancelado')),
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0)
);

CREATE TABLE item_pedido (
    id_pedido INTEGER NOT NULL REFERENCES pedido(id_pedido),
    id_produto INTEGER NOT NULL REFERENCES produto(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    PRIMARY KEY (id_pedido, id_produto)
);

CREATE TABLE pagamento (
    id_pagamento INTEGER PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedido(id_pedido),
    tipo_pagamento VARCHAR(20) NOT NULL CHECK (tipo_pagamento IN ('cartao', 'pix', 'boleto')),
    status VARCHAR(30) NOT NULL CHECK (status IN ('pendente', 'aprovado', 'recusado', 'cancelado')),
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    data_pagamento TIMESTAMP,
    transacao_gateway VARCHAR(80) UNIQUE
);

CREATE TABLE pagamento_cartao (
    id_pagamento INTEGER PRIMARY KEY REFERENCES pagamento(id_pagamento),
    numero_cartao VARCHAR(4) NOT NULL,
    nome_titular VARCHAR(120) NOT NULL,
    bandeira_cartao VARCHAR(30) NOT NULL,
    quantidade_parcelas INTEGER NOT NULL CHECK (quantidade_parcelas BETWEEN 1 AND 12)
);

CREATE TABLE pagamento_pix (
    id_pagamento INTEGER PRIMARY KEY REFERENCES pagamento(id_pagamento),
    chave_pix VARCHAR(120) NOT NULL,
    data_expiracao TIMESTAMP NOT NULL
);

CREATE TABLE pagamento_boleto (
    id_pagamento INTEGER PRIMARY KEY REFERENCES pagamento(id_pagamento),
    codigo_barras VARCHAR(80) NOT NULL UNIQUE,
    data_vencimento DATE NOT NULL
);

CREATE TABLE avaliacao (
    id_avaliacao INTEGER PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente),
    id_produto INTEGER NOT NULL REFERENCES produto(id_produto),
    nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATE NOT NULL,
    UNIQUE (id_cliente, id_produto)
);

-- Justificativas de mapeamento:
-- Cliente-Pedido e Categoria-Produto sao relacionamentos 1:N, portanto as FKs ficam em pedido e produto.
-- Pedido-Produto e um relacionamento M:N resolvido por item_pedido, que tambem guarda quantidade e preco_unitario.
-- Cliente.telefones foi separado em cliente_telefone por ser atributo multivalorado.
-- Endereco foi mantido em cliente, mas CEP foi separado porque cep determina bairro, cidade e UF.
-- Produto-Estoque foi modelado como 1:1 usando id_produto como PK/FK em estoque, evitando FK duplicada.
-- Pagamento possui especializacao total e disjunta por tipo_pagamento; cada subtipo usa id_pagamento como PK/FK.
-- Cupom e Logistica sao opcionais em pedido, por isso suas FKs aceitam NULL.
-- Avaliacao referencia cliente e produto e impede avaliacao duplicada do mesmo produto pelo mesmo cliente.
