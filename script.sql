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
    END LOOP; 
    CLOSE cur_paises_precos; 
END $$;


-- CREATE TABLE tb_wine_reviews(
--      cod_wine SERIAL PRIMARY KEY,
--      country VARCHAR(200),
--      description VARCHAR(2000),
--      points INTEGER,
--      price FLOAT
-- );