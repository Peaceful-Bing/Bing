-- Check table constraint
SELECT 
    name AS DefaultConstraintName, 
    parent_object_id, 
    parent_column_id 
FROM 
    sys.default_constraints 
WHERE 
    parent_object_id = OBJECT_ID('YourTableName') AND 
    parent_column_id = (
        SELECT 
            column_id 
        FROM 
            sys.columns 
        WHERE 
            object_id = OBJECT_ID('YourTableName') AND 
            name = 'row_id' -- row_id create_time
    );
	
ALTER TABLE ODS_CMMRCL_RETAILO2O_STORE_CITY
DROP CONSTRAINT Cnstr_e585fdd61c554789aaeb43f65cd15a7b;

-- Check table status
SELECT 
    schema_name(t.schema_id) AS schema_name, 
    t.name AS table_name,
    MAX(ius.last_user_seek) AS last_user_seek,
    MAX(ius.last_user_scan) AS last_user_scan,
    MAX(ius.last_user_lookup) AS last_user_lookup,
    MAX(ius.last_user_update) AS last_user_update
FROM 
    sys.dm_db_index_usage_stats ius
LEFT JOIN 
    sys.tables t ON ius.object_id = t.object_id
WHERE 
    ius.database_id = DB_ID('YourDatabaseName')
GROUP BY 
    t.schema_id, t.name
ORDER BY 
    schema_name, table_name;

--