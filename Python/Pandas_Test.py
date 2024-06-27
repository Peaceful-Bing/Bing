import pandas as pd


file_path = 'C:/Users/Z13581/OneDrive - The Coca-Cola Company/Desktop/Bing/Test/test.xlsx'
xls = pd.ExcelFile(file_path)

df = pd.read_excel(xls, sheet_name='Index')
#df.head()

six_month_col = None
for col in df.columns:
    if df[col].astype(str).str.contains('1月').any():
        print(df[col])
        six_month_col = col
        print(six_month_col)
        break

# Step 3: 提取 "6-Month" 列的值
if six_month_col:
    column_values = df[six_month_col].dropna().reset_index(drop=True)
    print(f"1月 列的值为:\n{column_values}")
else:
    print("1月 列未找到")


# 找出所需列的位置
columns_of_interest = ['6-Month', '7-Month', '8-Month', '9-Month']
cols_indices = [filtered_df.columns[filtered_df.iloc[0] == col].tolist()[0] for col in columns_of_interest]

# 提取所需列的值
data = filtered_df[cols_indices].iloc[1:].reset_index(drop=True)
data.columns = columns_of_interest


