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

CREATE FUNCTION upper_udf AS 'python_basic_udf.upper_udf' LANGUAGE PYTHON;

select *, upper_udf(pad_string) AS UPPPP from t_item;
