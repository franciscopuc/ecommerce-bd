# Relatorio Final - Plataforma de E-commerce

## Dominio

O projeto modela uma plataforma de e-commerce com clientes, produtos, categorias, estoque, pedidos, pagamentos, avaliacoes, cupons e logistica.

## DER final

O DER final esta em `e1-der/Conceptual model - BRMW.pdf`. Ele representa as entidades principais do dominio, relacionamentos comerciais e especializacao de pagamento em cartao, Pix e boleto.

## Esquema relacional final

O esquema relacional final esta documentado em `e2-logico/esquema_relacional.sql` e implementado em `e4-sql/schema.sql`.

Principais decisoes:

- Cliente possui telefone em tabela separada por ser atributo multivalorado.
- CEP foi separado de Cliente para reduzir redundancia de bairro, cidade e UF.
- Pedido e Produto possuem relacionamento M:N resolvido por Item Pedido.
- Produto e Estoque foram modelados em relacao 1:1 usando `id_produto` como PK/FK em Estoque.
- Pagamento foi especializado em Cartao, Pix e Boleto com PK/FK em cada subtipo.

## Script SQL

O arquivo `e4-sql/schema.sql` contem:

- DDL idempotente com `DROP TABLE IF EXISTS ... CASCADE`.
- PKs, FKs, NOT NULL, UNIQUE e CHECK constraints.
- Comentarios de tabelas e colunas.
- Dados de teste coerentes com o dominio.
- Consultas Q1 a Q10 comentadas.

## Reflexao

A principal dificuldade foi transformar o DER em um modelo relacional sem manter FKs redundantes. O relacionamento entre Pedido e Produto foi um ponto importante, pois nao deve haver `id_produto` direto em Pedido quando existe a tabela associativa Item Pedido.

Outro aprendizado foi a diferenca entre normalizar por teoria e apenas separar tabelas. A decomposicao de CEP e a retirada de subtotal armazenado em Item Pedido mostram como dependencias funcionais ajudam a evitar redundancia e inconsistencias.

Na implementacao SQL, o maior cuidado foi declarar restricoes explicitas para representar regras de negocio diretamente no banco. Isso torna o modelo mais confiavel e facilita a defesa tecnica, porque cada decisao de modelagem aparece tanto na documentacao quanto no script executavel.
