
-- Projeto: ERP Industrial Analytics
-- Criacao dos apontamentos de producao

USE erp_industrial_analytics;

CREATE TABLE apontamentos_producao (

    id_apontamento BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    id_ordem_producao BIGINT UNSIGNED NOT NULL,

    numero_apontamento SMALLINT UNSIGNED NOT NULL,

    data_apontamento DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    etapa_producao VARCHAR(60) NOT NULL,

    centro_trabalho VARCHAR(50) NOT NULL,

    maquina VARCHAR(50),

    quantidade_produzida DECIMAL(14,3) NOT NULL,

    quantidade_aprovada DECIMAL(14,3) NOT NULL,

    quantidade_refugo DECIMAL(14,3)
        NOT NULL DEFAULT 0.000,

    tempo_minutos DECIMAL(10,2)
        NOT NULL DEFAULT 0.00,

    observacao TEXT,

    CONSTRAINT pk_apontamentos_producao
        PRIMARY KEY (id_apontamento),

    CONSTRAINT uk_apontamentos_ordem_numero
        UNIQUE (id_ordem_producao, numero_apontamento),

    CONSTRAINT fk_apontamentos_ordem
        FOREIGN KEY (id_ordem_producao)
        REFERENCES ordens_producao(id_ordem_producao)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_apontamentos_produzida
        CHECK (quantidade_produzida > 0),

    CONSTRAINT chk_apontamentos_aprovada
        CHECK (quantidade_aprovada >= 0),

    CONSTRAINT chk_apontamentos_refugo
        CHECK (quantidade_refugo >= 0),

    CONSTRAINT chk_apontamentos_quantidades
        CHECK (
            quantidade_produzida =
            quantidade_aprovada + quantidade_refugo
        ),

    CONSTRAINT chk_apontamentos_tempo
        CHECK (tempo_minutos >= 0),

    INDEX idx_apontamentos_ordem_data
        (id_ordem_producao, data_apontamento),

    INDEX idx_apontamentos_centro_data
        (centro_trabalho, data_apontamento)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
