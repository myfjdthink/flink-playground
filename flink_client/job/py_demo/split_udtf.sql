CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    pad_string   VARCHAR,
    update_time   TIMESTAMP(3)
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.item_id.min'='1',
  'fields.item_id.max'='5',
  'fields.pad_string.length'='5'
);

CREATE FUNCTION split_string AS 'basic_udf.split_string' LANGUAGE PYTHON;

SELECT item_id, pad_string, word, length FROM t_item, LATERAL TABLE(split_string(pad_string)) as T(word, length);
