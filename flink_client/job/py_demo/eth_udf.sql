
CREATE FUNCTION decode_event AS 'eth.decode_event' LANGUAGE PYTHON;
CREATE FUNCTION upper_udf AS 'eth.upper_udf' LANGUAGE PYTHON;

select decode_event(
        '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount0In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount0Out","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1Out","type":"uint256"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"Swap","type":"event"}]',
        '0x39fb7af42ef12d92a0d577ca44cd54a0f24c4915',
         '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001633a021c0915e140000000000000000000000000000000000000000000000000000000359c7a8310000000000000000000000000000000000000000000000000000000000000000',
         Array['0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822', '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45', '0xe5DD42696d56ED81DA5A9a9406BEB84274583852']
    ) AS res;



select upper_udf('[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount0In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount0Out","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1Out","type":"uint256"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"Swap","type":"event"}]') AS res;
select upper_udf('asdfadsf') AS res;

