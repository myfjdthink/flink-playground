import json

from eth_event import get_topic_map, decode_log
from pyflink.table import DataTypes
from pyflink.table.udf import udf

@udf(input_types=[DataTypes.STRING()], result_type=DataTypes.STRING())
def upper_udf(s: str):
   return s.upper()


@udf(input_types=[DataTypes.STRING(), DataTypes.STRING(), DataTypes.STRING(), DataTypes.ARRAY(DataTypes.STRING())], result_type=DataTypes.STRING())
def decode_event(abi_str: str, address: str, data: str, topics):
    abi = json.loads(abi_str)
    topic_map = get_topic_map(abi)

    logs = {}
    logs['address'] = address
    logs['topics'] = topics
    logs['data'] = data
    res = decode_log(logs, topic_map)
    return json.dumps(res)


# def test_decode_event():
#     abi_str = """[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount0In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1In","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount0Out","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount1Out","type":"uint256"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"Swap","type":"event"}]"""
#     address = '0x39fb7af42ef12d92a0d577ca44cd54a0f24c4915'
#     data = '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001633a021c0915e140000000000000000000000000000000000000000000000000000000359c7a8310000000000000000000000000000000000000000000000000000000000000000'
#     topics = ['0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822',
#               '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45', '0xe5DD42696d56ED81DA5A9a9406BEB84274583852']
#     res = decode_event(abi_str, address, data, topics)
#     print(res)


# test_decode_event()
