SELECT
    transaction_hash,
    collect(ROW(transaction_hash, log_index)) as multi_events
FROM (VALUES
	    ('aa', 'bb', 1),
	    ('aa', 'bb', 2),
	    ('aa', 'bb', 3),
	    ('aa', 'bb', 4),
	    ('cc', 'dd', 1),
	    ('cc', 'dd', 2))
AS test(block_number, transaction_hash, log_index)
GROUP by transaction_hash;


SELECT
    ROW(block_number, transaction_hash) as aaaa
FROM (VALUES
	    ('aa', 'bb', 1),
	    ('aa', 'bb', 2),
	    ('aa', 'bb', 3),
	    ('aa', 'bb', 4),
	    ('cc', 'dd', 1),
	    ('cc', 'dd', 2))
AS test(block_number, transaction_hash, log_index);