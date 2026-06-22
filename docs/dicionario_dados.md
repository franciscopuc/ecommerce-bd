# Dicionario de Dados - Plataforma de E-commerce

## cep

Descricao: normaliza dados de localizacao usados no endereco dos clientes.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| cep | VARCHAR(8) | PK | Codigo postal. |
| bairro | VARCHAR(100) | NOT NULL | Bairro do CEP. |
| cidade | VARCHAR(100) | NOT NULL | Cidade do CEP. |
| uf | CHAR(2) | NOT NULL, CHECK | Unidade federativa. |

## cliente

Descricao: compradores cadastrados na plataforma.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_cliente | INTEGER | PK, IDENTITY | Identificador do cliente. |
| nome | VARCHAR(120) | NOT NULL | Nome completo. |
| email | VARCHAR(120) | NOT NULL, UNIQUE | E-mail de contato e login. |
| senha | VARCHAR(255) | NOT NULL | Senha armazenada pela aplicacao. |
| cpf | VARCHAR(11) | NOT NULL, UNIQUE, CHECK | CPF com onze digitos. |
| rua | VARCHAR(120) | NOT NULL | Rua do endereco. |
| numero | VARCHAR(20) | NOT NULL | Numero do endereco. |
| complemento | VARCHAR(120) | NULL | Complemento do endereco. |
| cep | VARCHAR(8) | NOT NULL, FK | CEP do cliente. |

## cliente_telefone

Descricao: telefones dos clientes, separados por serem atributo multivalorado.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_cliente | INTEGER | PK, FK, NOT NULL | Cliente dono do telefone. |
| telefone | VARCHAR(20) | PK, NOT NULL, CHECK | Numero de telefone. |

## categoria

Descricao: grupos comerciais usados para organizar produtos.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_categoria | INTEGER | PK, IDENTITY | Identificador da categoria. |
| nome | VARCHAR(100) | NOT NULL, UNIQUE | Nome da categoria. |
| descricao | TEXT | NULL | Descricao da categoria. |

## produto

Descricao: itens vendidos pela plataforma.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_produto | INTEGER | PK, IDENTITY | Identificador do produto. |
| id_categoria | INTEGER | NOT NULL, FK | Categoria do produto. |
| nome | VARCHAR(120) | NOT NULL | Nome comercial. |
| descricao | TEXT | NULL | Descricao detalhada. |
| preco | NUMERIC(10,2) | NOT NULL, CHECK | Preco atual de venda. |
| preco_comparacao | NUMERIC(10,2) | NULL, CHECK | Preco promocional de referencia. |
| ativo | BOOLEAN | NOT NULL | Indica disponibilidade para venda. |

## estoque

Descricao: controle de quantidade por produto.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_produto | INTEGER | PK, FK | Produto controlado. |
| quantidade | INTEGER | NOT NULL, CHECK | Quantidade disponivel. |
| estoque_minimo | INTEGER | NOT NULL, CHECK | Quantidade minima desejada. |
| estoque_maximo | INTEGER | NOT NULL, CHECK | Quantidade maxima suportada. |

## cupom

Descricao: cupons promocionais aplicados opcionalmente a pedidos.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| codigo | VARCHAR(30) | PK | Codigo do cupom. |
| tipo_desconto | VARCHAR(20) | NOT NULL, CHECK | Percentual ou valor fixo. |
| desconto | NUMERIC(10,2) | NOT NULL, CHECK | Valor numerico do desconto. |
| ativo | BOOLEAN | NOT NULL | Indica se pode ser usado. |
| validade | DATE | NOT NULL | Data de vencimento do cupom. |

## logistica

Descricao: registro de rastreamento e status de entrega.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_logistica | INTEGER | PK, IDENTITY | Identificador logistico. |
| status_entrega | VARCHAR(30) | NOT NULL, CHECK | Status da entrega. |
| codigo_rastreio | VARCHAR(40) | UNIQUE | Codigo da transportadora. |
| data_atualizacao | TIMESTAMP | NOT NULL | Ultima atualizacao logistica. |

## pedido

Descricao: compra realizada por um cliente.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pedido | INTEGER | PK, IDENTITY | Identificador do pedido. |
| id_cliente | INTEGER | NOT NULL, FK | Cliente que realizou o pedido. |
| codigo_cupom | VARCHAR(30) | FK, NULL | Cupom aplicado ao pedido. |
| id_logistica | INTEGER | FK, NULL | Registro logistico do pedido. |
| data_pedido | TIMESTAMP | NOT NULL | Data e hora do pedido. |
| status | VARCHAR(30) | NOT NULL, CHECK | Status comercial do pedido. |
| valor_total | NUMERIC(10,2) | NOT NULL, CHECK | Valor total do pedido. |

## item_pedido

Descricao: tabela associativa entre pedido e produto.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pedido | INTEGER | PK, FK, NOT NULL | Pedido que contem o item. |
| id_produto | INTEGER | PK, FK, NOT NULL | Produto comprado. |
| quantidade | INTEGER | NOT NULL, CHECK | Quantidade comprada. |
| preco_unitario | NUMERIC(10,2) | NOT NULL, CHECK | Preco no momento da compra. |

## pagamento

Descricao: pagamento associado a um pedido.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pagamento | INTEGER | PK, IDENTITY | Identificador do pagamento. |
| id_pedido | INTEGER | NOT NULL, UNIQUE, FK | Pedido pago. |
| tipo_pagamento | VARCHAR(20) | NOT NULL, CHECK | cartao, pix ou boleto. |
| status | VARCHAR(30) | NOT NULL, CHECK | Status do pagamento. |
| valor | NUMERIC(10,2) | NOT NULL, CHECK | Valor pago. |
| data_pagamento | TIMESTAMP | NULL | Data de processamento. |
| transacao_gateway | VARCHAR(80) | UNIQUE | Codigo da transacao no gateway. |

## pagamento_cartao

Descricao: atributos especificos de pagamento por cartao.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pagamento | INTEGER | PK, FK | Pagamento especializado. |
| numero_cartao | VARCHAR(4) | NOT NULL, CHECK | Ultimos quatro digitos. |
| nome_titular | VARCHAR(120) | NOT NULL | Titular do cartao. |
| bandeira_cartao | VARCHAR(30) | NOT NULL | Bandeira do cartao. |
| quantidade_parcelas | INTEGER | NOT NULL, CHECK | Parcelas entre 1 e 12. |

## pagamento_pix

Descricao: atributos especificos de pagamento por Pix.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pagamento | INTEGER | PK, FK | Pagamento especializado. |
| chave_pix | VARCHAR(120) | NOT NULL | Chave ou identificador Pix. |
| data_expiracao | TIMESTAMP | NOT NULL | Expiracao da cobranca. |

## pagamento_boleto

Descricao: atributos especificos de pagamento por boleto.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_pagamento | INTEGER | PK, FK | Pagamento especializado. |
| codigo_barras | VARCHAR(80) | NOT NULL, UNIQUE | Codigo de barras do boleto. |
| data_vencimento | DATE | NOT NULL | Vencimento do boleto. |

## avaliacao

Descricao: avaliacao feita por cliente sobre produto.

| Atributo | Tipo | Restricoes | Descricao |
| --- | --- | --- | --- |
| id_avaliacao | INTEGER | PK, IDENTITY | Identificador da avaliacao. |
| id_cliente | INTEGER | NOT NULL, FK, UNIQUE composta | Cliente avaliador. |
| id_produto | INTEGER | NOT NULL, FK, UNIQUE composta | Produto avaliado. |
| nota | INTEGER | NOT NULL, CHECK | Nota entre 1 e 5. |
| comentario | TEXT | NULL | Comentario textual. |
| data_avaliacao | DATE | NOT NULL | Data da avaliacao. |
