CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    pad_string   VARCHAR,
    update_time   TIMESTAMP(3)
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.price.min'='1',
  'fields.price.max'='100',
  'fields.item_id.min'='1',
  'fields.item_id.max'='3',
  'fields.pad_string.length'='5'
);

CREATE FUNCTION mean_udf AS 'basic_udf.mean_udf' LANGUAGE PYTHON;

SELECT item_id, avg(price) as avg_price_origin, mean_udf(price) as avg_price FROM t_item group by item_id;
