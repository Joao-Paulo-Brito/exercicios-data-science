/*
PERGUNTAS A SEREM RESPONDIDAS COM SQL:

1️⃣ Quais são os 3 aplicativos com maior variação no tempo de uso ao longo dos dias?
→ Use STDDEV(Usage_minutes) para medir a variação do tempo de uso por aplicativo.

2️⃣ Qual foi o dia com mais notificações recebidas no geral?
→ Some Notifications por dia e encontre o maior valor.

3️⃣ Qual a média de tempo de uso por abertura dos aplicativos?
→ Calcule AVG(Usage_minutes / Times_Opened), para ver quais apps são usados por mais tempo quando abertos.

4️⃣ Quais os aplicativos que tiveram pelo menos um dia com mais de 100 minutos de uso?

5️⃣ Qual o percentual de participação de cada aplicativo no tempo total de uso?

6️⃣ Qual foi o tempo médio de uso diário em cada mês?

7️⃣ Quais aplicativos têm mais notificações do que tempo de uso?

8️⃣ Existe um padrão no horário de maior uso dos aplicativos? (Se houver coluna de horário)

9️⃣ Qual a relação entre quantidade de aberturas e tempo de uso nos aplicativos mais populares?

🔟 Os aplicativos mais notificados são também os mais abertos?
*/
SELECT * FROM screentime_analysis

/*Verificando se há valores nulos nas colunas*/
SELECT *
FROM screentime_analysis
WHERE ROW(screentime_analysis.*) IS NULL

/*
PRIMEIRA PERGUNTA

Para responder a primeira pergunta, é necessário calcular o desvio padrão, para saber o nível de dispersão do
tempo de uso, ou seja, sua variação ao longo do tempo.
*/
SELECT app,
	   ROUND(STDDEV(usage_minutes), 2) AS desvio_padrao
FROM screentime_analysis
GROUP BY app
ORDER BY 2 DESC
LIMIT 3

/*Respondendo a primeira pergunta: Os 3 aplicativos com maior variação ou desvio padrão do tempo de uso, é o Instagram,
a Netflix e o Whatsapp, sendo o Instagram com um desvio padrão de 30.31, a Netflix com 29.89 e o Whatsapp com 18.49*/

/*
SEGUNDA PERGUNTA

Para responder a segunda pergunta, é melhor converter a coluna 'date' para o tipo data
*/
ALTER TABLE screentime_analysis
ALTER COLUMN date TYPE DATE
USING date::DATE
	
SELECT EXTRACT (DAY FROM date) AS dia,
	   EXTRACT (MONTH FROM date) AS MES,
	   SUM(notifications) AS quantidade_de_notificacoes
FROM screentime_analysis
GROUP BY date
ORDER BY 3 DESC

/*
Respondendo a segunda pergunta: A Partir do comando, o dia que mais recebeu notificações foi o dia 23/08, com
451 notificações recebidas
*/

/*
TERCEIRA PERGUNTA
*/
SELECT ROUND(AVG(Usage_minutes / Times_opened), 2) AS media
FROM screentime_analysis

/*
Respondend a terceira pergunta: a média de tempo de uso pelas vezes que os aplicativos forma abertos, é de 6,54
*/

/*
QUARTA PERGUNTA
*/
SELECT  date,
		APP,
		usage_minutes
FROM screentime_analysis
WHERE usage_minutes >= 100

SELECT COUNT(*)
FROM screentime_analysis
WHERE usage_minutes >= 100 AND
	  app = 'Instagram'

SELECT COUNT(*)
FROM screentime_analysis
WHERE usage_minutes >= 100 AND
	  app = 'Netflix'

SELECT ROUND(AVG(usage_minutes), 2) AS media_tempo_instagram
FROM screentime_analysis
WHERE app = 'Instagram'

SELECT ROUND(AVG(usage_minutes), 2) AS media_tempo_netflix
FROM screentime_analysis
WHERE app = 'Netflix'

/*Os aplicativos com dias onde o tempo de uso é de no mínimo 100 minutos, são Instagram e Netflix,
em que cada um tem 7 dias com no mínimo 100 minutos de uso. Além disso, a média de tempo de uso do Instagram
e Netflix é de 75.92 e 72.76 minutos*/

/*
QUINTA PERGUNTA
*/
SELECT SUM(Usage_minutes) AS tempo_total
FROM screentime_analysis
	
SELECT APP,
	   SUM(Usage_minutes) AS Total_minutos,
       ROUND((SUM(Usage_minutes)::numeric/7550 * 100), 2) || ' %' AS Percentual 
FROM screentime_analysis
GROUP BY APP
ORDER BY 3 DESC

/*Obs: "::Numeric" converte para decimal e "||" é agregação*/

/*
SEXTA PERGUNTA
*/
SELECT EXTRACT(MONTH FROM date) AS mes,
	   AVG(Usage_minutes) AS media
FROM screentime_analysis
GROUP BY EXTRACT(MONTH FROM date)

/*Respondendo a sexta pergunta: O único mês da tabela é o 8, que no caso é Agosto, onde a
média é de 37.75 minutos*/

/*
SÉTIMA PERGUNTA
*/
SELECT APP,
	   ROUND(AVG(usage_minutes), 2) AS media_tempo_uso,
	   ROUND(AVG(notifications), 2) AS media_notificacoes
FROM screentime_analysis
GROUP BY APP
HAVING AVG(notifications) > AVG(Usage_minutes)

/*
Os aplicativos que tiveram uma quantidade de notificações maior que o tempo de uso em média, é o Facebook, que tem um
valor em média de 6,04 de notificações maior que a média do tempo de uso, e o WhatsApp, que tem um valor em média de
51,76 de notificações maior que a média do tempo de uso. Ou seja, o WhatsApp é o aplicativo com mais notificações do que
tempo de uso.
*/

/*
OITAVA PERGUNTA 

Não existe coluna de horário, logo não é possível responder essa pergunta
*/

/*
NONA PERGUNTA
*/
SELECT  APP,
		ROUND(CORR(Times_opened, Usage_minutes)::NUMERIC, 2) AS CORRELACAO
FROM screentime_analysis
WHERE app IN ('Instagram', 'WhatsApp', 'Netflix')
GROUP BY APP
ORDER BY 2 DESC

/*Através do número da correlação, existe uma relação entre o tempo de uso e a quantidade de aberturas, os aplicativos
mais populares como Instagram e Netflix tiveram uma correlação positiva, porém o Whatsapp teve uma correlação negativa
o que significa que o aumento da quantidade de aberturas influenciam no aumento do tempo de uso, com exceção do Whatsapp,
que tem uma quantidade de vezes aberto maior que a quantidade de tempo de uso.*/

/*
DÉCIMA PERGUNTA
*/
SELECT  APP,
		ROUND(CORR(Times_opened, NOTIFICATIONS)::NUMERIC, 2) AS CORRELACAO
FROM screentime_analysis
GROUP BY APP
ORDER BY 2 DESC

SELECT APP,
	   ROUND(SUM(usage_minutes), 2) AS soma_tempo_uso,
	   ROUND(SUM(notifications), 2) AS soma_notificacoes
FROM screentime_analysis
GROUP BY APP
ORDER BY 3 DESC


/*Aplicativos como Safari, Linkedin e Instagram tiveram uma correlação positiva, sendo Safari com uma maior correlação,
de 0.22, ou seja, a maioria dos aplicativos tem uma correlação positiva fraca e até negativa, sendo o 8 BALL Pool com
a menor correlação negativa, de -0.30, seguindo de X com -0.28 e Netflix com -0.25. Além disso, a soma do total de notificações
e do tempo de uso dos aplicativos, indicam que os aplicativos com mais notificações não são os mais usados, por exemplos,
o Whatsapp tem uma quantide de notificações de 2498, mas um tempo de uso de 1204 minutos, já o Instagram teve uma quantidade
de 1245 notificações e uma quantidade de tempo de uso de 1898. Então tudo indica que as notificações dos aplicativos mais
notificados não são os mais abertos.
*/