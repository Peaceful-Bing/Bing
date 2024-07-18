/*------------------------------------------------------------
                查出所有时间字段
  ------------------------------------------------------------*/
DECLARE @TableName NVARCHAR(255)
DECLARE @ColumnName NVARCHAR(255)
DECLARE @SQL NVARCHAR(MAX)

-- 临时表用于存储各表各列的最大值
IF OBJECT_ID('tempdb..#MaxValues') IS NOT NULL
	DROP TABLE #MaxValues

CREATE TABLE #MaxValues (
	TableName NVARCHAR(255),
	ColumnName NVARCHAR(255),
	MaxValue DATETIME
)

-- 游标遍历所有列
DECLARE ColumnCursor CURSOR FOR
SELECT 
	t.TABLE_NAME,
	c.COLUMN_NAME
FROM 
	INFORMATION_SCHEMA.COLUMNS c
JOIN 
	INFORMATION_SCHEMA.TABLES t
	ON c.TABLE_NAME = t.TABLE_NAME
WHERE 
	c.DATA_TYPE IN ('datetime', 'date', 'smalldatetime', 'datetime2', 'datetimeoffset', 'timestamp')
	AND t.TABLE_TYPE = 'BASE TABLE'

OPEN ColumnCursor

FETCH NEXT FROM ColumnCursor INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SQL = '
		INSERT INTO #MaxValues (TableName, ColumnName, MaxValue)
		SELECT ''' + @TableName + ''', ''' + @ColumnName + ''', MAX([' + @ColumnName + '])
		FROM [' + @TableName + ']'

EXEC sp_executesql @SQL

FETCH NEXT FROM ColumnCursor INTO @TableName, @ColumnName
END

CLOSE ColumnCursor
DEALLOCATE ColumnCursor

-- 查询结果
SELECT * FROM #MaxValues
ORDER BY TableName, ColumnName
