-- DROP TABLE Aviao;
-- DROP TABLE EmpresaManutencao;
-- DROP TABLE PessoalDaCasa
-- DROP TABLE RegistoDaManutencao;
-- DROP TABLE RegistodaSituacao;
-- DROP TABLE Tripulante;
-- DROP TABLE Piloto;
-- DROP TABLE HospedeirosDeBordo;
-- DROP TABLE HospedeirosDeBordo_ChefeDeCabine;
-- DROP TABLE HospedeirosDeBordo_PessoalDeCabine;
-- DROP TABLE Comandante;
-- DROP TABLE CoPiloto;
-- DROP TABLE TipoDeAviao;
-- DROP TABLE PilotoTipoDeAviao;
-- DROP TABLE Aeroporto;
-- DROP TABLE Rota;
-- DROP TABLE Distancia;
-- DROP TABLE Voo;
-- DROP TABLE PessoaCancelamento;
-- DROP TABLE RazaoDoCancelamento;
-- DROP TABLE Escala;

CREATE TABLE Aviao (
    matricula VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    data_aquisição DATE NOT NULL,
    CONSTRAINT Aviao_pk PRIMARY KEY(matricula)
    );

CREATE TABLE EmpresaManutencao (
    id INTEGER(10),
    id_registodamanutencao INTEGER(10),
    data_entrega DATETIME DEFAULT CURRENT_TIMESTAMP,
    nome VARCHAR(255) NOT NULL DEFAULT,
    preco DECIMAL(10,4),
    CONSTRAINT EmpresaManutencao_pk PRIMARY KEY(id, id_registodamanutencao, data_entrega),
    CONSTRAINT EmpresaManutencao_id_registodamanutencao FOREIGN KEY (id_registodamanutencao) REFERENCES RegistoDaManutencao(id),
    CONSTRAINT EmpresaManutencao_data_entrega FOREIGN KEY (data_entrega) REFERENCES RegistoDaManutencao(data_entrega)
);

CREATE TABLE PessoalDaCasa (
    id INTEGER(10),
    nome VARCHAR(255) NOT NULL,
    CONSTRAINT PessoalDaCasa_pk PRIMARY KEY(id)
    );

CREATE TABLE RegistoDaManutencao (
    id INTEGER(10),
    n_aterragens INTEGER(10) NOT NULL DEFAULT 0 CHECK (nr_aterragens >= 0),
    n_horas_voo INTEGER(20) NOT NULL DEFAULT 0 CHECK (horas_voo >= 0),
    n_milhas INTEGER(20) NOT NULL DEFAULT 0 CHECK (nr_milhas >= 0),            
    matricula_aviao VARCHAR(255) NOT NULL,
    data_inicio DATETIME DEFAULT '2021-01-21 00:00:00',
    data_entrega DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT RegistoManutencao_pk PRIMARY KEY (id)
);

CREATE TABLE RegistoDaSituacao (
    id INTEGER(10),
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT RegistoDaSituacao_pk PRIMARY KEY (id)
);

CREATE TABLE Tripulante (
    id	NUMERIC(5),
    nome VARCHAR(255) NOT NULL,  
    apelido VARCHAR(255) NOT NULL,      
    genero ENUM('Feminino', 'Masculino', 'Outros') NOT NULL, 
    data_de_nascimento DATETIME NOT NULL,
    morada VARCHAR(255) NOT NULL,  
    tipo ENUM('Comandante','Piloto','Chefe de Cabine','Pessoal da Cabine') NOT NULL,    
    escalao ENUM('Junior','Intermédio','Sénior') NOT NULL,  
    CONSTRAINT Tripulante_pk PRIMARY KEY(id),
    CONSTRAINT chk_Tripulante_genero CHECK (genero IN ('Feminino','Masculino','Outros')),
    CONSTRAINT chk_Tripulante_tipo CHECK (tipo IN ('Comandante','Piloto','Chefe de Cabine','Pessoal da Cabine')),
    CONSTRAINT chk_Tripulante_escalao CHECK (escalao IN ('Junior','Intermedio','Senior'))
);

CREATE TABLE Piloto (
    id_piloto NUMERIC(5) CHECK (id >= 0),
    n_descolagens NUMERIC(6) NOT NULL DEFAULT 0 CHECK (n_descolagens >= 0),    
    n_aterragens NUMERIC(6) NOT NULL DEFAULT 0 CHECK (n_aterragens >= 0),
    n_horas_voo NUMERIC(8) NOT NULL CHECK (horas_voo > 0),
    tipo VARCHAR(20),
    CONSTRAINT Piloto_pk PRIMARY KEY(id),
    CONSTRAINT fk_Piloto_id FOREIGN KEY (id) REFERENCES Tripulante(id),
    CONSTRAINT chk_Piloto_tipo CHECK (tipo IN ('Comandante','Co-Piloto'))
);

CREATE TABLE HospedeirosDeBordo (
    id_hospedeirosdebordo NUMERIC(5) CHECK (id >= 0),
    data_cumprida_de_partida TIMESTAMP,
    data_cumprida_de_chegada TIMESTAMP, 
    CONSTRAINT HospedeirosDeBordo_pk PRIMARY KEY(id),
    CONSTRAINT fk_HospedeirosDeBordo_id FOREIGN KEY (id) REFERENCES Tripulante(id),

);

CREATE TABLE ChefeDeCabine (
n_voo	NUMERIC(3),
id_chefecabine	NUMERIC(5),
CONSTRAINT pk_ChefeDeCabine PRIMARY KEY (n_voo,id_chefecabine),
CONSTRAINT fk_ChefeDeCabine_n_voo FOREIGN KEY (n_voo) REFERENCES Voo(n_voo),
CONSTRAINT fk_ChefeDeCabine_id_chefecabine FOREIGN KEY (id_chefecabine) REFERENCES Tripulante(id));
);

CREATE TABLE PessoalDeCabine (
n_voo	NUMERIC(3),
id_pessoalcabine NUMERIC(5),
CONSTRAINT pk_PessoalDeCabine PRIMARY KEY (n_voo,id_pcabine),
CONSTRAINT fk_PessoalDeCabine_n_voo FOREIGN KEY (n_voo) REFERENCES Voo(n_voo),
CONSTRAINT fk_PessoalDeCabine_id_pcabine FOREIGN KEY (id_pcabine) REFERENCES Tripulante(id));
);

CREATE TABLE Comandante (
    id_comandante	NUMERIC(5) CHECK (id >= 0),
    data_promocao DATE NOT NULL,
    n_horas_comando INTEGER(10) NOT NULL,
    CONSTRAINT Comandante_pk PRIMARY KEY (id),
    CONSTRAINT Comandante_id FOREIGN KEY (id) REFERENCES Piloto(id);
);

CREATE TABLE CoPiloto (
    id_copiloto	NUMERIC(5) CHECK (id >= 0),
    CONSTRAINT CoPiloto_pk PRIMARY KEY (id),
    CONSTRAINT CoPiloto_id FOREIGN KEY (id) REFERENCES Piloto(id);
);

CREATE TABLE TipoDeAviao (
    cod_tipo VARCHAR(4) NOT NULL,     
    marca ENUM("Airbus", "Embraer", "ATR", "Fokker",  'Cessna') NOT NULL,
    modelo ENUM("A330-900neo", "A330-200", "A321-200", "A320", "A320-200", "A319-100", 'A340' "Embraer195", "Embraer190", "ATR72-600", '100', '18') NOT NULL,
    carga INTEGER(10) NOT NULL CHECK (carga >= 0),
    n_passageiros_executiva INTEGER(10) NOT NULL CHECK (n_passageiros_executiva >= 0),
    n_passageiros_turistica INTEGER(10) NOT NULL CHECK (n_passageiros_turistica >= 0),            
    autonomia_milhas INTEGER(10) NOT NULL CHECK (autonomia_milhas >= 0),
    autonomia_horas TIME NOT NULL,
    contagem_horas_voo INTEGER(20) NOT NULL DEFAULT 0 CHECK (contagem_horas_voo >= 0),
    CONSTRAINT TipoDeAviao_pk PRIMARY KEY(cod_tipo),
    CONSTRAINT chk_TipoDeAviao_marca CHECK (marca IN ("Airbus", "Embraer", "ATR")),
    CONSTRAINT chk_TipoDeAviao_ modelo CHECK (modelo IN ("A330-900neo", "A330-200", "A321-200", "A320-200", "A319-100", "Embraer195", "Embraer190", "ATR72-600"))
);

CREATE TABLE PilotoTipoDeAviao (
    id_piloto INTEGER(10) CHECK (id >= 0),    
    cod_tipo VARCHAR(255) NOT NULL,    
    cod_aeroporto VARCHAR(255) NOT NULL,
    n_licenca NUMERIC(6) NOT NULL UNIQUE,
    data_emissao_licenca DATE NOT NULL, 
    CONSTRAINT PilotoTipoDeAviao_pk PRIMARY KEY(id_piloto, cod_tipo)
    ADD CONSTRAINT PilotoTipoDeAviao_id FOREIGN KEY (id_piloto) REFERENCES Piloto(id);
    ADD CONSTRAINT PilotoTipoDeAviao_cod_tipo FOREIGN KEY (cod_tipo ) REFERENCES TipoDeAviao(cod_tipo),
);

CREATE TABLE Aeroporto (
    cod VARCHAR(255) NOT NULL,
    localização VARCHAR(255) NOT NULL,
    CONSTRAINT Aeroporto_pk PRIMARY KEY(cod)
);

CREATE TABLE Rota (
    cod_rota NUMERIC(5) NOT NULL,
    cod_aeroporto_origem_1 VARCHAR(3) NOT NULL,
    cod_aeroporto_destino_2 VARCHAR(3) NOT NULL,
    CONSTRAINT Rota_pk PRIMARY KEY(cod_rota)
    CONSTRAINT fk_Rota_cod_aeroporto_origem_1 FOREIGN KEY (cod_aeroporto_origem_1) REFERENCES Aeroporto(cod_aeroporto),
    CONSTRAINT fk_Rota_cod_aeroporto_destino_2 FOREIGN KEY (cod_aeroporto_destino_2) REFERENCES Aeroporto(cod_aeroporto)
);

CREATE TABLE Distancia (
    cod_aerodist_origem_1  VARCHAR(3) NOT NULL,
    cod_aerodist_destino_2  VARCHAR(3) NOT NULL,
    milhas INTEGER(10) NOT NULL CHECK (milhas > 0),    
    CONSTRAINT Distancia_pk PRIMARY KEY(cod_aeroporto_distorigem_1, cod_aeroporto_distdestino_2)
    CONSTRAINT Distancia_fk1 FOREIGN KEY (cod_aeroporto_distorigem_1) REFERENCES Aeroporto(cod);
    CONSTRAINT Distancia_fk2 FOREIGN KEY (cod_aeroporto_distdestino_2) REFERENCES Aeroporto(cod),
);

CREATE TABLE Voo (
    n_voo NUMERIC(3) NOT NULL,
    data__prevista_de_partida TIMESTAMP NOT NULL,
    data_cumprida_de_partida TIMESTAMP,
    data_prevista_de_chegada TIMESTAMP NOT NULL,
    data_cumprida_de_chegada TIMESTAMP,
    estado ENUM('planeado', 'realizado', 'em curso', 'cancelado') DEFAULT 'planeado',
    cod_rota	NUMERIC(5),	
    id_comandante	NUMERIC(5),
    id_copiloto	NUMERIC(5),
    matricula	VARCHAR(6),
    CONSTRAINT Voo_pk PRIMARY KEY (n_voo),
    CONSTRAINT fk_Voo_cod_rota FOREIGN KEY (cod_rota) REFERENCES Rota(cod_rota),	
    CONSTRAINT fk_Voo_id_comandante FOREIGN KEY  (id_comandante) REFERENCES Piloto(id),
    CONSTRAINT fk_Voo_copiloto FOREIGN KEY (id_copiloto) REFERENCES Piloto(id),
    CONSTRAINT fk_Voo_matricula FOREIGN KEY (matricula) REFERENCES Aviao(matricula)),
    CONSTRAINT chk_Voo_estado CHECK (estado IN ('planeado', 'realizado', 'em curso', 'cancelado'))    
);

CREATE TABLE PessoaCancelamento (
    id_piloto INTEGER(10) CHECK (id >= 0),
    responsável VARCHAR(255) NOT NULL,  
    CONSTRAINT PessoaCancelamento_pk PRIMARY KEY (id)
);

CREATE TABLE RazaoDoCancelamento (
    n_razao VARCHAR(255) NOT NULL,    
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT RazaoDoCancelamento_pk PRIMARY KEY (n_razao)
);

CREATE TABLE Escala (
    cod_rota NUMERIC(5) NOT NULL,    
    cod_aeroporto VARCHAR(255) NOT NULL,
    n_ordem INTEGER(10) NOT NULL,
    CONSTRAINT Escala_pk PRIMARY KEY(cod_rota, cod_aeroporto)
    ADD CONSTRAINT Escala_cod_rota FOREIGN KEY (cod_rota) REFERENCES Rota(cod_rota);
    ADD CONSTRAINT Escala_cod_aeroporto FOREIGN KEY (cod_aeroporto) REFERENCES Aeroporto(cod),

);

INSERT INTO Aviao (matricula, nome, data_aquisicao)
    VALUES
        ('A', 'Sebastião I', '2008-02-28'),
        ('B', 'D. Manuel I', '2007-02-28'),
        ('C', 'D. Duarte I', '2008-02-28'),
        ('D', 'D. Joao I', '2009-02-28'),
        ('E', 'D. Fernando', '201o-02-28' ),
        ('F', 'D. Pedro I', '2012-02-28'),
        ('G', 'D. Afonso IV', '2013-02-28'),
        ('H', 'D. Dinis I', '2018-02-28' ),
        ('I', 'D. Afonso II', '2017-02-28'),
        ('J', 'D. Sancho I', '2016-02-28'),
        ('CS-ABG', 'D. Afonso Henriques', '2015-02-28'),
        ('CS-PDC', 'D. Fernando', '2015-02-28'),
        ('CS-LFV', 'D. Filipe', '2015-02-28');                        

INSERT INTO EmpresaManutencao (id, id_registodamanutencao, data_entrega, nome, preco)
VALUES
    (1, 1, '2013-02-28' 'Ka',  16930.9562),
    (2, 2, '2012-02-28' 'Lb', 9635.9627),
    (3, 3, '2015-02-28''Mc', 6339.8540),
    (4, 4, '2016-02-28' 'Nd', 18606.6876),
    (5, 5, '2016-03-28' 'Oe', 14779.1868),
    (6, 6, '2017-02-28''Pf', 5869.5689),
    (7, 7, '2020-02-28''Qg', 16985.4682),
    (8, 8, '2019-02-28' 'Rh', 12330.9812),
    (9, 9, '2017-03-28' 'Si', 3980.4365);
    (10, 10, '2017-02-28',  'Nuno Manutenção Ltd', 5981.4365);

INSERT INTO PessoalDaCasa (id, nome)
VALUES
    (1, 'Kim'),
    (2, 'Leandor'),
    (3, 'Manuel'),
    (4, 'Nuno'),
    (5, 'Olga'),
    (6, 'Pedro'),
    (7, 'Quim'),
    (8, 'Ricardo'),
    (9, 'Sebastião'),
    (10, 'Edgar' );

INSERT INTO RegistoManutencao (id, n_aterragens, n_horas_voo, n_milhas, matricula_aviao, data_inicio, data_entrega)
    VALUES 
        (1, 1000, 10000, 100000, 'A', '2012-12-28', '2013-02-28'),
        (2, 1001, 10001, 100001, 'B', '2011-12-28', '2012-02-28'),
        (3, 1002, 10002, 100002, 'C', '2014-12-28', '2015-02-28'),
        (4, 1003, 10003, 1000003, 'D', '2015-12-28','2016-02-28'),
        (5, 1004, 10004, 100004, 'E', '2016-01-28', '2016-03-28'),
        (6, 1005, 10005, 100005, 'F', '2016-12-28', '2017-02-28'),
        (7, 1006, 10006, 100006, 'G', '2017-12-28', '2018-02-28'),
        (8, 10007, 10007, 100007, 'H', '2018-12-28', '2019-02-28'),
        (9, 1008, 10008, 100008, 'I',  '2017-01-28', '2017-03-28'),
        (10, 1009, 10009, 100009, 'J', '2016-12-28', '2017-02-28');

INSERT INTO RegistoDaSituacao (id, observacao)
    VALUES 
        (1, 'Motor Engine fail'),
        (2, 'Weird Painting'),
        (3, 'Broken Wheel'),
        (4, 'Broken Button'),
        (5, 'Broken Window'),
        (6, 'Broken Door'),
        (7, 'Broken Toilet'),
        (8, 'Broken Seat'),
        (9, 'Broken Engine'),
        (10, 'Broken Chassis');

INSERT INTO Tripulante (id, nome, apelido genero, data_de_nascimento, morada, tipo, escalao)
    VALUES 
        (25111, 'C1', 'C2','Masculino', '1980-02-28', 'morada nº1', 'Comandante', 'Sénior'),
        (25112, 'C2', 'C3', 'Outros', '1981-02-28', 'morada nº2', 'Comandante', 'Intermedio'),
        (25113, 'C3', 'C4', 'Masculino','1982-02-28', 'morada nº3', 'Comandante', 'Junior'),
        (25114, 'C4','C5', 'Masculino', '1983-02-28', 'morada nº4', 'Comandante', 'Sénior'),
        (25115, 'C5', 'C6', 'Feminino', '1984-02-28', 'morada nº5', 'Comandante', 'Sénior'),
        (25116, 'C6', 'C7', 'Feminino', '1985-02-28', 'morada nº6', 'Comandante', 'Intermedio'),
        (25117, 'C7', 'C8', 'Feminino', '1986-02-28', 'morada nº7', 'Comandante', 'Intermedio'),
        (25118, 'C8', 'C9', 'Masculino', '1987-02-28', 'morada nº8', 'Comandante', 'Junior'),
        (25119, 'C9', 'C10', 'Feminino', '1988-02-28', 'morada nº9', 'Comandante', 'Intermedio'),
        (25120, 'C10', 'C11', 'Feminino', '1989-02-28', 'morada nº10', 'Comandante', 'Junior'),
        (25121, 'P1', 'P2', 'Masculino', '1990-02-28', 'morada nº11', 'Piloto', 'Intermédio'),
        (25122, 'P2', 'P3', 'Feminino', '1991-02-28' , 'morada nº12', 'Piloto', 'Sénior'),
        (25123, 'P3', 'P4', 'Outros', '1992-02-28', 'morada nº13', 'Piloto', 'Intermedio'),
        (25124, 'P4', 'P5', 'Feminino', '1979-02-28', 'morada nº14', 'Piloto', 'Junior'),
        (25125, 'P5', 'P6', 'Masculino', '1978-02-28', 'morada nº15', 'Piloto', 'Intermedio'),
        (25126, 'P6', 'P7', 'Masculino', '1977-02-28', 'morada nº16', 'Piloto', 'Intermedio'),
        (25127, 'P7', 'P8', 'Masculino', '1976-02-28', 'morada nº17', 'Piloto', 'Junior'),
        (25128, 'P8', 'P9', 'Feminino', '1977-02-28', 'morada nº18', 'Piloto', 'Sénior'),
        251(29, 'P9', 'P10', 'Feminino', '1976-02-28', 'morada nº19', 'Piloto', 'Intermedio'),
        (25130, 'P10', 'P11', 'Feminino', '1975-02-28', 'morada nº20', 'Piloto', 'Junior'),
        (25131, 'CC1', 'CC2', 'Feminino', '1974-02-28' , 'morada nº21', 'Chefe de Cabine', 'Sénior'),
        (25132, 'CC2', 'CC3', 'Feminino', '1973-02-28', 'morada nº22', 'Chefe de Cabine', 'Junior'),
        (25133, 'CC3', 'CC4', 'Masculino', '1972-02-28', 'morada nº23', 'Chefe de Cabine', 'Sénior'),
        (25134, 'CC4', 'CC5', 'Feminino', '1971-02-28', 'morada nº24', 'Chefe de Cabine', 'Junior'),
        (25135, 'CC5', 'CC6', 'Masculino', '1969-02-28', 'morada nº25', 'Chefe de Cabine', 'Junior'),
        (25136, 'CC6', 'CC7', 'Masculino', '1968-02-28', 'morada nº26', 'Chefe de Cabine', 'Junior'),
        (25137, 'CC7', 'CC8', 'Feminino', '1967-02-28', 'morada nº27', 'Chefe de Cabine', 'Intermedio'),
        (25138, 'CC8', 'CC9', 'Masculino', '1966-02-28', 'morada nº28', 'Chefe de Cabine', 'Sénior'),
        (25139, 'CC9', 'CC10', 'Feminino', '1965-02-28', 'morada nº29', 'Chefe de Cabine', 'Intermedio'),
        (25140, 'CC10', 'CC11', 'Masculino', '1964-02-28', 'morada nº30', 'Chefe de Cabine', 'Intermedio'),
        (18211, 'PC1', 'PC2', 'Outros', '1963-02-28', 'morada nº31', 'Pessoal da Cabine', 'Junior'),
        (18222, 'PC2', 'PC3', 'Feminino', '1962-02-28', 'morada nº32', 'Pessoal da Cabine', 'Intermedio'),
        (18233, 'PC3', 'PC4', 'Feminino', '1961-02-28' , 'morada nº33', 'Pessoal da Cabine', 'Junior'),
        (18244, 'PC4', 'PC5', 'Feminino', '1960-02-28' , 'morada nº34', 'Pessoal da Cabine', 'Sénior'),
        (18255, 'PC5', 'PC6', 'Masculino', '1961-02-28', 'morada nº35', 'Pessoal da Cabine', 'Junior'),
        (18266, 'PC6', 'PC7', 'Outros', '1962-02-28' , 'morada nº36', 'Pessoal da Cabine', 'Intermedio'),
        (18277, 'PC7', 'PC8', 'Feminino', '1963-02-28', 'morada nº37', 'Pessoal da Cabine', 'Junior'),
        (18288, 'PC8','PC9', 'Feminino', '1962-02-28', 'morada nº38', 'Pessoal da Cabine', 'Intermedio'),
        (18299, 'PC9', 'PC10', 'Feminino', '1960-02-28', 'morada nº39', 'Pessoal da Cabine', 'Sénior'),
        (18210, 'PC10', 'PC11', 'Feminino', '1959-02-28', 'morada nº40', 'Pessoal da Cabine', 'Junior'),
        (25100,'Abel', 'Antunes', 'Masculino', '1980-01-28', 'morada nº41', 'Piloto', 'Sénior')),
        (18200,'Carlos', 'Caldas', 'Masculino', '1980-02-28', 'morada nº42', 'Piloto', 'Sénior')), 
        (31100,'Diana', 'Dias', 'Feminino', '1980-03-28', 'morada nº43', 'Piloto', 'Sénior')), 
        (27900,'Gabriela', 'Gusmao', 'Feminino', '1980-04-28', 'morada nº44', 'Piloto', 'Sénior')), 
        (23200,'Bernardo', 'Borges', 'Masculino', '1980-05-28', 'morada nº45', 'Pessoal da Cabine', 'Sénior')),
        (22300,'Hilario', 'Hamas', 'Masculino', '1980-06-28', 'morada nº46', 'Pessoal da Cabine', 'Sénior')),
        (29200,'Ernesto', 'Elvas', 'Masculino', '1980-07-28', 'morada nº47', 'Pessoal da Cabine', 'Sénior')),
        (30300,'Fatima', 'Felgueiras', 'Feminino', '1980-08-28', 'morada nº48', 'Pessoal da Cabine', 'Sénior')),
        (25600,'Ilda', 'Ignara', 'Feminino', '1980-09-28', 'morada nº49',  'Pessoal da Cabine', 'Sénior')),
        (28900,'Jorge', 'Antunes', 'Masculino', '1980-010-28', 'morada nº50', 'Pessoal da Cabine', 'Sénior'));

INSERT INTO Piloto (id, n_descolagens, n_aterragens, n_horas_voo)
    VALUES
        (25111, 3778, 3738, 1392),
        (25112, 3353, 3323, 1726),
        (25113, 4366, 4316, 2420),
        (25114, 1032, 1031, 2664),
        (25115, 4213, 4213, 1200),
        (25116, 1461, 1467, 1919),
        (25117, 675,  666, 2534),
        (25118, 4087, 4120, 2857),
        (25119, 4286, 4533, 1182),
        (25120, 2846, 2846, 2313),
        (25121, 323, 310, 473),
        (25122, 342, 248, 768),
        (25123, 212, 376, 822),
        (25124, 349, 262, 992),
        (25125, 403, 371, 773),
        (25126, 435, 309, 488),
        (25127, 223, 576, 449),
        (25128, 404, 214, 665),
        251(29, 479, 482, 881),
        (25130, 428, 241, 846),
        (25100, 123,123,5900),
        (18200, 123,123,5940), 
        (31100, 123,123,5490), 
        (27900, 123,123,1590); 

INSERT INTO HospedeirosDeBordo(id_hospedeirosdebordo, data_cumprida_de_partida, data_cumprida_de_chegada)
    VALUES
        (25131, "2019:01:09 09:40:00", "2019:01:09 11:20:00"),
        (25132, "2019:01:10 09:20:00", "2019:01:10 11:20:00"),
        (25133, "2019:01:11 09:40:00", "2019:01:11 11:20:00"),
        (25134, "2019:01:12 09:20:00", "2019:01:12 11:20:00"),
        (25135, "2019:01:13 09:40:00", "2019:01:13 11:20:00"),
        (25136, "2019:01:14 09:40:00", "2019:01:14 11:20:00"),
        (25137, "2019:01:15 09:40:00", "2019:01:15 11:20:00"),
        (25138, "2019:01:16 09:20:00", "2019:01:16 11:20:00"),
        (25139, "2019:01:17 09:20:00", "2019:01:17 11:20:00"),
        (25140, "2019:01:18 09:20:00", "2019:01:18 11:20:00"),
        (23200, '2015-10-12 05:30:32', '2015-10-13 11:32:23'),
        (22300, '2015-10-12 05:30:32', '2015-10-13 11:32:23'),
        (29200, '2015-10-12 05:30:32', '2015-10-13 11:32:23'),
        (30300, '2015-10-12 05:30:32', '2015-10-13 11:32:23'),
        (25600, '2015-10-12 05:30:32', '2014-12-01 17:21:36'),
        (28900, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18211, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18222, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18233, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18244, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18255, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18266, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18277, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18288, '2015-10-12 05:30:32', '2015-11-01 02:21:36'),
        (18299, '2015-10-12 05:30:32', '2015-11-01 02:21:36'), 
        (18210, "2018:01:18 09:20:00", "2018:01:18 11:20:00");

INSERT INTO ChefeDeCabine(n_voo, id)
    VALUES
        (700, 25131),
        (701, 25132),
        (702, 25133),
        (703, 25134),
        (704, 25135),
        (705, 25136),
        (706, 25137),
        (707, 25138),
        (708, 25139),
        (709, 25140);

INSERT INTO PessoalDeCabine(n_voo, id)
    VALUES
        (700, 23200),
        (701, 22300),
        (702, 29200),
        (703, 30300),
        (704, 25600),
        (705, 28900),
        (706, 18211),
        (707, 18222),
        (708, 18233),
        (709, 18244),
        (710, 18255),
        (711, 18266),
        (712, 18277),
        (713, 18288),
        (714, 18299),
        (715, 18210);
       
INSERT INTO Comandante (id_comandante, data_promocao, n_horas_comando)
    VALUES
        (25111, "2020-12-07 14:26:31", 823),
        (25112, "2020-10-23 16:00:53", 682),
        (25113, "2020-06-17 08:27:47", 981),
        (25114, "2019-04-22 10:56:47", 839),
        (25115, "2020-09-28 08:46:09", 730),
        (25116, "2019-03-30 06:05:44", 613),
        (25117, "2020-11-26 10:56:17", 847),
        (25118, "2019-09-05 07:15:29", 739),
        (25119, "2020-11-22 12:36:34", 914),
        (25120, "2019-08-14 13:45:22", 859);

INSERT INTO CoPiloto  (id_copiloto)
    VALUES
        (25121),
        (25122),
        (25123),
        (25124),
        (25125),
        (25126),
        (25127),
        (25128),
        (25129),
        (25130),        
        (25100),
        (18200), 
        (31100),
        (27900); 

INSERT INTO TipoDeAviao (cod_tipo, marca, modelo, carga, n_passageiros_executiva, n_passageiros_turistica, autonomia_milhas, autonomia_horas, contagem_horas_voo)
    VALUES
        ('AB01', "Airbus", "A330-900neo", 13582, 30, 250,  7627, '13:30:51', 104376),
        ('AC01', "Airbus", "A320-200", 2000, 18, 154, 10843, '19:35:50', 239138),
        ('AD02', "Airbus", "A319-100", 6255, 0, 42,  5362, '11:00:55', 186398),
        ('AE01', "Airbus", "A330-200", 16242, 47, 135, 1441, '06:12:29',333603),
        ('AG02', "Embraer", "Embraer190"  18322, 61, 120,  8536, '07:53:02', 258965),
        ('AH02', "Airbus", "A321-200", 1304, 3, 24,  3853, '12:16:22', 163375),
        ('AI02', "Embraer", "Embraer195", 15391, 0, 37, , 6816, '02:44:14', 117597),
        ('AJ01', "Airbus", 'A340', 20000, 70, 201,  8223, '10:37:24', 163375),
        ('AL03', "ATR", "ATR72-600", 5910, 0, 66,  290, '04:27:41', 84299),
        ('AB32','Airbus','A320', 12998, 30, 300,  4000, '10:27:41', 14299),
        ('FK10','Fokker','100', 12997, 20, 150, 3000,'11:27:41', 24299),
        ('AB34','Airbus','A340', 12996, 40, 400,5000,'12:27:41', 34299),
        ('CESS', 'Cessna', '18', 12995, 5, 0, 250,'13:27:41', 44299);

INSERT INTO PilotoTipoDeAviao (id_piloto, cod_tipo, data_emissao_licenca, n_descolagens, n_aterragens, horas_voo, licenca)
    VALUES
        (25111, 'AB01', '2006-03-31 11:54:42', 501, 501, 5001, 34500),
        (25112, 'AC01', '2018-11-08 17:27:05', 502, 502, 5002, 345001),
        (25113, 'AD02', '2008-06-16 17:10:21', 503, 503, 5003, 34502),
        (25114, 'AE01', '2015-02-07 06:40:08', 504, 504, 5004, 34503),
        (25115, 'AG02', '2008-02-14 08:49:45', 505, 505, 5005, 34504),
        (25116, 'AH02', '2011-05-11 10:48:45', 506, 506, 5006, 34505),
        (25117, 'AI02', '2005-10-20 15:10:48', 507, 507, 5007, 34506),
        (25118, 'AJ01', '2011-05-16 09:20:05', 508, 508, 5008, 34507),
        (25119, 'AL03'. '2019-03-21 14:16:46', 509, 509, 5009, 34508),
        (25120, 'AB01', '2018-12-07 08:35:54', 510, 510, 5010, 34509),
        (25121, 'AC01', '2009-03-11 12:55:48', 511, 511, 5011, 34510),
        (25122, 'AD02', '2016-03-12 09:39:31', 512, 512, 5012, 34511),
        (25123, 'AE01', '2006-02-21 11:09:23', 513, 513, 5013, 34512),
        (25124, 'AG02', '2001-03-19 13:25:23', 514, 514, 5014, 34513),
        (25125, 'AH02'. '2011-02-28 13:03:18', 515, 515, 5015, 34514),
        (25126, 'AI02', '2012-05-16 17:07:55', 516, 516, 5016, 34515),
        (25127, 'AJ01', '2005-02-07 14:00:36', 517, 517, 5017, 34516),
        (25128, 'AL03', '2008-07-21 08:09:37', 518, 5018, 5018, 34517),
        (25129, 'AB01', '2003-05-25 10:17:03', 519, 519, 5019, 34518),
        (25130, 'AC01', '2009-11-30 07:23:15', 520, 520, 5020, 34519),  
        (25100, 'AB32', '2011-02-13', 521, 521, 5021, 34561),
        (25100, 'AB34', '2012-02-12', 521, 521, 5021, 34561),
        (25100, 'FK10', '2014-02-13', 521, 521, 5021, 34561),
        (18200, 'AB32', '2014-02-11', 521, 521, 5021, 34572),
        (18200, 'FK10', '2014-02-12', 521, 521, 5021, 34572),
        (31100, 'AB32', '2014-02-13', 522, 522, 5022, 34583),
        (27900, 'CESS', '2014-02-22', 523, 523, 5023, 34591),
        (27900, 'AB34', '2014-02-27', 524, 524, 5024,  34591);        

INSERT INTO Aeroporto (cod, localização)
    VALUES 
        ("ARPT1", "Barcelona"),
        ("ARPT2", "Vienna"),
        ("ARPT3", "Stuttgart"),
        ("ARPT4", "Guadalajara"),
        ("ARPT5", "Lisboa-Portela"),
        ("ARPT6", "Vancouver"),
        ("ARPT7", "San Francisco"),
        ("ARPT8", "Seoul"),
        ("ARPT9", "Kyoto"),
        ("ARPT10", "Malmo"),
        ('LIS','Lisboa-Portela'),
        ('OPO','Oporto-FrSCarneiro'),
        ('MAD','Madrid-Barajas'),
        ('HND','Tokyo-Haneda'),
        ('FRA','Frankfurt'),
        ('BKK','Bangkok'),
        ('CDG', 'Paris');

INSERT INTO Rota (cod_rota, cod_aeroporto_origem_1 , cod_aeroporto_destino_2) 
        (12345,'LIS','MAD'),
        (12346,'LIS','HND'),
        (12347,'HND','LIS'),
        (12348,'MAD','LIS'),
        (12349,'LIS','OPO'),
        (12350,'OPO','LIS'),
        (12351,'OPO','MAD'),
        (12352,'LIS','BKK'),
        (12353,'BKK','LIS'),
        (12354,'LIS','CDG'),
        (12355,'LIS','BKK'),
        (12356,'OPO','HND'),
        (12357,'OPO','HND');

INSERT INTO Distancia (cod_aeroporto_distorigem_1, cod_aeroporto_distdestino_2, milhas)
    VALUES
        ("ARPT1", "ARPT10", 905),
        ("ARPT2", "ARPT9", 234),
        ("ARPT3", "ARPT8", 173),
        ("ARPT4", "ARPT7", 8458),
        ("ARPT5", "ARPT6", 734),
        ("ARPT6", "ARPT3", 347),
        ("ARPT7", "ARPT2" 3727),
        ("ARPT8", "ARPT7", 436),
        ("ARPT9", "ARPT4", 945),
        ("ARPT10", "ARPT7", 745);

12-INSERT INTO Voo (n_voo, data__prevista_de_partida , data_cumprida_de_partida, data_prevista_de_chegada, data_cumprida_de_chegada, estado)
    VALUES 
        (710, "2019:01:09 09:20:00", "2019:01:09 09:40:00", "2019:01:09 11:20:00", "2019:01:09 11:40:00", 'realizado'),
        (711, "2019:01:10 09:20:00", "2019:01:10 09:20:00", "2019:01:10 11:20:00", "2019:01:10 11:20:00", 'realizado'),
        (712, "2019:01:11 09:20:00", "2019:01:11 09:40:00", "2019:01:11 11:20:00", "2019:01:11 11:40:00", 'realizado'),
        (713, "2019:01:12 09:20:00", "2019:01:12 09:20:00", "2019:01:12 11:20:00", "2019:01:12 11:20:00", 'realizado'),
        (714, "2019:01:13 09:20:00", "2019:01:13 09:40:00", "2019:01:13 11:20:00", "2019:01:13 11:40:00", 'realizado'),
        (715, "2019:01:14 09:20:00", "2019:01:14 09:40:00", "2019:01:14 11:20:00", "2019:01:14 11:40:00", 'realizado'),
        (716, "2019:01:15 09:20:00", "2019:01:15 09:40:00", "2019:01:15 11:20:00", "2019:01:15 11:40:00", 'realizado'),
        (717, "2019:01:16 09:20:00", "2019:01:16 09:20:00", "2019:01:16 11:20:00", "2019:01:16 11:20:00", 'realizado'),
        (718, "2019:01:17 09:20:00", "2019:01:17 09:20:00", "2019:01:17 11:20:00", "2019:01:17 11:20:00", 'realizado'),
        (719, "2019:01:18 09:20:00", "2019:01:18 09:20:00", "2019:01:18 11:20:00", "2019:01:18 11:20:00", 'realizado'),
        (720, "2018:01:18 09:20:00", "2018:01:18 09:20:00", "2019:01:18 11:20:00", "2018:01:18 11:20:00", 'realizado'),
        (755, '2015-10-12 05:30:32', '2015-10-12 05:30:32', '2015-10-13 11:32:23', '2015-10-13 11:32:23', 'realizado'),
        (756, '2015-10-12 05:30:32', '2015-10-12 05:30:32', '2015-10-13 11:32:23', '2015-10-13 11:32:23', 'realizado'),
        (757, '2015-10-12 05:30:32', '2015-10-12 05:30:32', '2015-10-13 11:32:23', '2015-10-13 11:32:23', 'realizado'),
        (758, '2015-10-12 05:30:32', '2015-10-12 05:30:32', '2015-10-13 11:32:23', '2015-10-13 11:32:23', 'realizado'),
        (759, '2015-10-12 05:30:32', '2015-10-12 05:30:32', '2015-10-13 11:32:23', '2015-10-13 11:32:23', 'realizado'),
        (741, '2014-12-01 08:21:59', '2015-10-12 05:30:32', '2014-12-01 17:21:36', '2015-10-13 11:32:23', 'realizado'),
        (700, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (701, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (702, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (703, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (704, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (705, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (706, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (707, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (708, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado'),
        (709, '2015-10-31 22:55:12', '2015-10-12 05:30:32', '2015-11-01 02:21:36', '2015-10-13 11:32:23', 'realizado');

INSERT INTO Cancelamento (id, responsavel)
    VALUES
        ("1", "Diretor do Departamento de Meteorologia"),
        ("2", "Diretor do Departamento de Meteorologia"),
        ("3",  "Diretor do Departamento de Meteorologia"),
        ("4", "Diretor do Departamento de Meteorologia"),
        ("5", "IPMA"),
        ("6", "Diretor do Departamento de Meteorologia"),
        ("7", "Diretor de mecânica da EasyJet"),
        ("8", "Diretor do Departamento de Meteorologia"),
        ("9", "Diretor do Departamento de Meteorologia"),
        ("10", "Diretor do Departamento de Meteorologia");

INSERT INTO Razao (n_razao , observacao)
    VALUES
        (1, "Condições atmosféricas adversas"),
        (2, "Condições atmosféricas adversas"),
        (3, "Condições atmosféricas adversas"),
        (4, "Condições atmosféricas adversas"),
        (5, "Condições atmosféricas adversas"),
        (6, "Condições atmosféricas adversas"),
        (7, "Anomalia no único avião disponível"),
        (8, "Condições atmosféricas adversas"),
        (9, "Condições atmosféricas adversas"),
        (10, "Condições atmosféricas adversas");

INSERT INTO Escala (id_rota, cod_aeroporto, n_ordem)
    VALUES
        (1245, "ARPT1", 1),
        (1248, "ARPT2", 0),
        (1250, "ARPT3", 0),
        (1251, "ARPT4", 1),
        (1254, "ARPT5", 1),
        (12346,'FRA',1),
        (12347,'FRA',1),
        (12352,'MAD',1),
        (12352,'FRA',2),
        (12353,'FRA',1),
        (12353,'MAD',2),
        (12355, 'CDG', 1),
        (12356, 'LIS', 1),
        (12356, 'CDG', 2),
        (12357, 'LIS', 1),

ALTER TABLE EmpresaManutencao
ADD CONSTRAINT EmpresaManutencao_id_registodamanutencao FOREIGN KEY (id_registodamanutencao) REFERENCES RegistoDaManutencao(id),
ADD CONSTRAINT EmpresaManutencao_data_entrega FOREIGN KEY (data_entrega) REFERENCES RegistoDaManutencao(data_entrega);
ALTER TABLE Piloto
Add CONSTRAINT Piloto_fk_id FOREIGN KEY (id) REFERENCES Tripulante(id);
ALTER TABLE HospedeirosDeBordo_ChefeDeCabine 
ADD CONSTRAINT fk_HospedeirosDeBordo_ChefeDeCabine_n_voo FOREIGN KEY (n_voo) REFERENCES Voo(n_voo),
ADD CONSTRAINT fk_HospedeirosDeBordo_ChefeDeCabine_id_chefecabine FOREIGN KEY (id_chefecabine) REFERENCES Tripulante(id));
ALTER TABLE HospedeirosDeBordo_PessoalDeCabine  
CONSTRAINT fk_HospedeirosDeBordo_PessoalDeCabine_n_voo FOREIGN KEY (n_voo) REFERENCES Voo(n_voo),
CONSTRAINT fk_HospedeirosDeBordo_PessoalDeCabine_id_pcabine FOREIGN KEY (id_pcabine) REFERENCES Tripulante(id));
ALTER TABLE Comandante
ADD CONSTRAINT Comandante_id FOREIGN KEY (id) REFERENCES Piloto(id);
ALTER TABLE CoPiloto
ADD CONSTRAINT CoPiloto_id FOREIGN KEY (id) REFERENCES Piloto(id);
ALTER TABLE PilotoTipoDeAviao
ADD CONSTRAINT PilotoTipoDeAviao_id FOREIGN KEY (id_piloto) REFERENCES Piloto(id);
ADD CONSTRAINT PilotoTipoDeAviao_cod_tipo FOREIGN KEY (cod_tipo ) REFERENCES TipoDeAviao(cod_tipo),
ALTER TABLE Rota
ADD CONSTRAINT fk_Rota_cod_designacao_aero_origem_1 FOREIGN KEY (cod_designacao_aero_origem_1) REFERENCES Aeroporto(cod_aeroporto),
ADD CONSTRAINT fk_Rota_cod_designacao_aero_destino_2 FOREIGN KEY (cod_designacao_aero_destino_2) REFERENCES Aeroporto(cod_aeroporto)
ALTER TABLE Distancia
ADD CONSTRAINT Distancia_fk1 FOREIGN KEY (cod_aero_origem_1) REFERENCES Aeroporto(cod);
ADD CONSTRAINT Distancia_fk2 FOREIGN KEY (cod_aero_destino_2) REFERENCES Aeroporto(cod),
ALTER TABLE Voo
CONSTRAINT fk_Voo_cod_rota FOREIGN KEY (cod_rota) REFERENCES Rota(cod_rota),	
CONSTRAINT fk_Voo_id_comandante FOREIGN KEY  (id_comandante) REFERENCES Piloto(id),
CONSTRAINT fk_Voo_copiloto FOREIGN KEY (id_copiloto) REFERENCES Piloto(id),
CONSTRAINT fk_Voo_matricula FOREIGN KEY (matricula) REFERENCES Aviao(matricula));
ALTER TABLE Escala
ADD CONSTRAINT Escala_cod_rota FOREIGN KEY (cod_rota) REFERENCES Rota(cod_rota);
ADD CONSTRAINT Escala_cod_aeroporto FOREIGN KEY (cod_aeroporto) REFERENCES Aeroporto(cod),