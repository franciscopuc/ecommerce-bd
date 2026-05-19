SELECT p.id_pedido, c.nome, p.valor_total
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id_cliente;
