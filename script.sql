-- ----------------------------------------------------------------
-- 5 Exportação dos dados
--escreva a sua solução aqui

-------------------------------------------------------------
-- 4 Armazenamento dos resultados
--escreva a sua solução aqui

--tabela para armazenar os resultados:
CREATE TABLE tb_price_and_description(
     cod_country SERIAL PRIMARY KEY,
     nome_pais VARCHAR(200),
     preco_medio FLOAT,
     descricao_mais_longa VARCHAR(2000)
)
-- ---

-- adiciona função no cursor não vinculado para inserir o resultado na tabela
DO $$
DECLARE
    cur_paises_precos REFCURSOR; 
    v_country TEXT;
    v_avg_price NUMERIC(10, 2); 
BEGIN 
    OPEN cur_paises_precos FOR 
        SELECT 
            country, 
            AVG(price)::NUMERIC(10, 2) 
        FROM 
            tb_wine_reviews 
        WHERE 
            country IS NOT NULL 
        GROUP BY 
            country 
        ORDER BY 
            country; 
    LOOP 
        FETCH cur_paises_precos INTO v_country, v_avg_price; 
        EXIT WHEN NOT FOUND; 
        RAISE NOTICE 'País: %, Preço Médio: %', v_country, v_avg_price;
        INSERT INTO tb_price_and_description(nome_pais, preco_medio) VALUES (v_country, v_avg_price);
    END LOOP; 
    CLOSE cur_paises_precos; 
END $$;

--adiciona função no cursor vinculado para inserir o resultado na tabela
DO $$
DECLARE
    v_country TEXT;
    v_longa_descricao TEXT;

    cur_paises_descricoes CURSOR FOR
        SELECT DISTINCT ON (country)
            country,
            description
        FROM tb_wine_reviews
        WHERE country IS NOT NULL
          AND description IS NOT NULL
        ORDER BY country, LENGTH(description) DESC;
BEGIN
    OPEN cur_paises_descricoes;

    LOOP
        FETCH cur_paises_descricoes INTO v_country, v_longa_descricao;
        EXIT WHEN NOT FOUND;

        UPDATE tb_price_and_description
        SET descricao_mais_longa = v_longa_descricao
        WHERE nome_pais = v_country;

        RAISE NOTICE 'País: %, Descrição Mais Longa: %', v_country, v_longa_descricao;
    END LOOP;

    CLOSE cur_paises_descricoes;
END $$;

-- ----------------------------------------------------------------
-- 3 Cursor vinculado (Descrição mais longa)
--escreva a sua solução aqui

DO $$
DECLARE
    v_country TEXT;
    v_longa_descricao TEXT;
 
    cur_paises_descricoes CURSOR FOR
        SELECT DISTINCT ON (country)
            country,
            description
        FROM
            tb_wine_reviews
        WHERE
            country IS NOT NULL AND description IS NOT NULL
        ORDER BY
            country, LENGTH(description) DESC;
BEGIN
    OPEN cur_paises_descricoes;
 
    LOOP
        FETCH cur_paises_descricoes INTO v_country, v_longa_descricao;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'País: %, Descrição Mais Longa: %', v_country, v_longa_descricao;
    END LOOP;
 
    CLOSE cur_paises_descricoes;
END $$;


-- ----------------------------------------------------------------
-- 2 Cursor não vinculado (cálculo de preço médio)
--escreva a sua solução aqui

DO $$
DECLARE
    cur_paises_precos REFCURSOR; 
    v_country TEXT;
    v_avg_price NUMERIC(10, 2); 
BEGIN 
    OPEN cur_paises_precos FOR 
        SELECT 
            country, 
            AVG(price)::NUMERIC(10, 2) 
        FROM 
            tb_wine_reviews 
        WHERE 
            country IS NOT NULL 
        GROUP BY 
            country 
        ORDER BY 
            country; 
    LOOP 
        FETCH cur_paises_precos INTO v_country, v_avg_price; 
        EXIT WHEN NOT FOUND; 
        RAISE NOTICE 'País: %, Preço Médio: %', v_country, v_avg_price;
            -- INSERT INTO tb_price_and_description(country, description) VALUES (v_country, v_avg_price);
    END LOOP; 
    CLOSE cur_paises_precos; 
END $$;

-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
-- escreva a sua solução aqui

-- CREATE TABLE tb_wine_reviews(
--      cod_wine SERIAL PRIMARY KEY,
--      country VARCHAR(200),
--      description VARCHAR(2000),
--      points INTEGER,
--      price FLOAT
-- );
