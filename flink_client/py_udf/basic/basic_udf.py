from pyflink.common import Row
from pyflink.table import AggregateFunction, TableAggregateFunction, ListView, DataTypes
from pyflink.table.udf import udf, udaf, udtf, udtaf

@udf(input_types=[DataTypes.STRING()], result_type=DataTypes.STRING())
def upper_udf(s: str):
   return s.upper()

##  Pandas UDAFs are not supported in streaming mode currently
@udaf(result_type=DataTypes.FLOAT(), func_type="pandas")
def mean_udaf(v):
    return v.mean()

@udtf(result_types=[DataTypes.STRING(), DataTypes.INT()])
def split_string(string):
    for s in string.split(" "):
        yield s, len(s)


class Mean(AggregateFunction):

    def create_accumulator(self):
        # Row(sum, count)
        return Row(0, 0)

    def get_value(self, accumulator):
        if accumulator[1] == 0:
            return -1
        else:
            return accumulator[0] / accumulator[1]

    def accumulate(self, accumulator, value):
        accumulator[0] += value
        accumulator[1] += 1

    def retract(self, accumulator, value):
        accumulator[0] -= value
        accumulator[1] -= 1

    def get_accumulator_type(self):
        return DataTypes.ROW([
            # declare the first column of the accumulator as a string ListView.
            DataTypes.FIELD("f0", DataTypes.LIST_VIEW(DataTypes.FLOAT())),
            DataTypes.FIELD("f1", DataTypes.BIGINT())])
    def get_result_type(self):
        return DataTypes.FLOAT()

mean_udf = udaf(Mean())

# mean_udf()