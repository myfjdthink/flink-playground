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

-- document https://nightlies.apache.org/flink/flink-docs-master/docs/dev/python/table/udfs/vectorized_python_udfs/
-- Pandas UDAFs are not supported in streaming mode currently

CREATE FUNCTION mean_udaf AS 'basic_udf.mean_udaf' LANGUAGE PYTHON;

select item_id, mean_udaf(price) AS item_mean from t_item group by item_id;
