from pyspark.sql import SparkSession
import os
import shutil

# 创建Spark Session
spark = SparkSession.builder.appName("SingleCSVExport").getOrCreate()

# Step 1: 执行SQL查询
query = "SELECT * FROM your_table_name"
spark_df = spark.sql(query)

# Step 2: 将DataFrame重新分区为一个分区
single_partition_df = spark_df.coalesce(1)

# Step 3: 保存为单个CSV文件（在临时文件夹中）
temp_path = '/mnt/data/temp_output_folder'
single_partition_df.write.option("header", "true").option("encoding", "UTF-8").mode("overwrite").csv(temp_path)

# Step 4: 获取临时文件夹中的单一CSV文件并移动到目标位置
target_path = '/mnt/data/output/your_file_name.csv'

# 查找临时文件夹中名称含有part的CSV文件
csv_files = [f for f in os.listdir(temp_path) if f.startswith('part-') and f.endswith('.csv')]

# 移动并重命名单一CSV文件
if csv_files:
    temp_csv_path = os.path.join(temp_path, csv_files[0])
    shutil.move(temp_csv_path, target_path)
    print(f"CSV file successfully saved to: {target_path}")
else:
    print("No CSV file found in the temporary output folder.")

# 清理临时文件夹
shutil.rmtree(temp_path)



#################################################################################################################

# Step 1: 执行Spark SQL查询
query = "SELECT * FROM your_table_name"
spark_df = spark.sql(query)

# Step 2: 将Spark DataFrame转换为Pandas DataFrame
pandas_df = spark_df.toPandas()

# Step 3: 指定保存路径
file_path = '/mnt/data/output/your_file_name.csv'

# Step 4: 使用Pandas的to_csv方法保存为单个CSV文件
pandas_df.to_csv(file_path, encoding="utf_8_sig", header=True, index=False)

# 确认文件路径
print(f"CSV file saved to: {file_path}")