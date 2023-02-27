from pyflink.table import DataTypes
from pyflink.table.udf import udf


@udf(input_types=[DataTypes.STRING()], result_type=DataTypes.STRING())
def upper_udf(s: str):
   return s.upper()