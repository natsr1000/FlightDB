-- 1. Quais os comandantes que realizaram voos com destino a Paris entre 31/10/2015 e 30/11/2015.
Select piloto.id, tripulante.nome, tripulante.apelido, voo.data_cumprida_de_chegada AS chegada
FROM tripulante, piloto, voo, rota, aeroporto
WHERE tripulante.tipo = 'piloto' 
    AND tripulante.id = piloto.id 
    AND piloto.tipo = 'comandante'
    AND voo.id_comandante = piloto.id
    AND voo.cod_rota = rota.cod_rota
    AND rota.cod_aeroporto_destino = aeroporto.cod_aeroporto
    AND aeroporto.localização = 'Paris'
    AND ('31/10/2015' <= voo.data_chegada <= '30/11/2015');

-- 2. Qual é o número total de voos efetuados por cada avião desde o início do presente ano.
SELECT aviao.nome, aviao.matricula, COUNT(voo.n_voo) AS voos
FROM aviao, voo
WHERE voo.matricula = aviao.matricula
GROUP BY aviao.matricula;

-- 3. Em que voos em que o comandante Abel Antunes e o copiloto Carlos Caldas voaram juntos.
SELECT DISTINCT voo.n_voo AS voo, aviao.nome AS aviao, voo.matricula, voo.data_cumprida_partida AS partida, voo.data_cumproda_chegada AS chegada
FROM voo, aviao, tripulante, piloto 
WHERE voo.matricula = aviao.matricula
    AND voo.id_comandante = (SELECT tripulante.id FROM tripulante WHERE tripulante.nome = 'Abel' AND tripulante.apelido = 'Antunes') 
	AND voo.id_copiloto = (SELECT tripulante.id FROM tripulante WHERE tripulante.nome = 'Carlos' AND tripulante.apelido = 'Caldas')
ORDER BY aviao.matricula, voo.n_voo ASC;

-- 4 Quais os comandantes (nome completo, n.º licença e data de emissão da licença) habilitados a pilotar aviões cuja autonomia seja superior a 500km (310,685596 milhas). Pretende-se que o resultado seja ordenado alfabeticamente, por nome próprio e por apelido, respetivamente.
SELECT DISTINCT tripulante.nome, tripulante.apelido, pilototipodeaviao.n_licenca AS licença, pilototipodeaviao.data_emissao_licenca AS emissão
FROM tripulante, piloto, pilototipodeaviao, tipoaviao
WHERE tripulante.tipo = 'piloto' 
    AND tripulante.id = piloto.id 
    AND piloto.id = pilototipodeaviao.id_piloto
	AND piloto.tipo = 'comandante'
	AND pilototipodeaviao.cod_tipo = tipoaviao.cod_tipo
    AND tipoAviao.autonomia_milhas > 310,685596 
ORDER BY tripulante.nome, tripulante.apelido, pilototipodeaviao.data_emissao_licenca ASC;

-- 5. Quais são os pilotos que nunca realizaram voos da rota 12345.
SELECT DISTINCT piloto.id AS id, tripulante.nome, tripulante.apelido
FROM tripulante, piloto
WHERE tripulante.tipo = 'piloto'
    AND tripulante.id = piloto.id 
    AND piloto.tipo = 'comandante', 'copiloto'
    AND voo.id_comandante = piloto.id
    AND voo.id_co-piloto = piloto.id
    AND voo.cod_rota = rota.cod_rota
	AND piloto.id NOT IN (SELECT voo.id_comandante FROM voo WHERE voo.cod_rota = 12345)
    AND piloto.id NOT IN (SELECT voo.id_copiloto FROM voo WHERE voo.cod_rota = 12345);

-- 6. Quais são ps aviões que já efetuaram voos em todas as rotas da companhia (nenhum avião fez as 13 rotas). 
SELECT aviao.nome, aviao.matricula, COUNT(DISTINCT rota.cod_rota) AS rotas
FROM aviao, rota, voo
WHERE voo.matricula = aviao.matricula 
    AND voo.cod_rota = rota.cod_rota
GROUP BY aviao.matricula
HAVING COUNT(voo.cod_rota) = 13;

-- 7. Qual o nome e n.º de horas de voo dos copilotos que fizeram o maior número de voos. Pretende-se saber o n.º exato de voos feitos por cada um desses copilotos.
SELECT tripulante.nome, tripulante.apelido, piloto.n_horas_voo AS horas, COUNT(voo.n_voo) AS voos
FROM tripulante, piloto, voo
WHERE  tripulante.tipo = 'piloto'
    AND tripulante.id = piloto.id 
    AND piloto.tipo = 'copiloto'
	AND voo.id_copiloto = piloto.id
GROUP BY piloto.id;

-- 8. Voos que permitem viagens de Lisboa a Paris. Note que devem ser considerados também os voos que contenham escalas nestas duas cidades.
SELECT DISTINCT voo.n_voo, voo.matricula AS aviao
FROM voo, rota, escala, escala e1, escala e2, aeroporto
WHERE (voo.cod_rota = rota.cod_rota AND rota.cod_cod_aeroporto_origem_1 = 'LIS' AND rota.cod_aeroporto_destino_2 = 'CDG') 
	OR (voo.cod_rota = rota.cod_rota AND rota.cod_aeroporto_origem_1 = 'LIS' AND escala.cod_rota = rota.cod_rota AND escala.cod_aeroporto = 'CDG')
    OR (voo.cod_rota = rota.cod_rota AND rota.cod_aeroporto_destino_2 = 'CDG' AND escala.cod_rota = rota.cod_rota AND escala.cod_aeroporto = 'LIS' )
    OR (voo.cod_rota = rota.cod_rota AND e1.cod_rota = rota.cod_rota AND e2.cod_rota = rota.cod_rota AND e1.n_ordem < e2.n_ordem AND e1.cod_aeroporto = 'LIS' AND e2.cod_aeroporto = 'CDG')
ORDER BY voo.n_voo;

-- 9. Pretende-se obter todas as escalas por ordem ascendente e agrupadas por rota apresentando também a cidade, o aeroporto de origem (com respetiva cidade) e o aeroporto de destino (com respetiva cidade). A rota têm que passar em Lisboa e ter pelo menos 1 escala em Frankfurt ou Madrid.
SELECT escala.cod_rota, rota.cod_aeroporto_origem_1,
ae1.localização origem, rota.cod_aeroporto_destino_2,
ae2.localização destino, escala.cod_aeroporto,
ae3.localização paragem, escala.n_ordem
FROM aeroporto ae1, aeroporto ae2, aeroporto ae3, rota, escala
WHERE escala.cod_rota = rota.cod_rota
	AND (rota.cod_aeroporto_origem_1= 'LIS' OR rota.cod_aeroporto_destino_2 = 'LIS')
    AND (ae1.cod_aeroporto = rota.cod_aeroporto_origem_1)
    AND (ae2.cod_aeroporto = rota.cod_aeroporto_destino_2)
    AND (ae3.cod_aeroporto = escala.cod_aeroporto)    
GROUP BY escala.cod_rota
HAVING escala.cod_aeroporto = 'MAD'
ORDER BY escala.cod_rota ASC;