DROP TABLE IF EXISTS tb_wine_reviews;
CREATE TABLE tb_wine_reviews(
     cod_wine SERIAL PRIMARY KEY,
     country VARCHAR(200),
     description VARCHAR(2000),
     points INTEGER,
     price FLOAT
);