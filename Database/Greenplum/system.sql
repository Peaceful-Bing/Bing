/********************************************************************
    Maintenance operation performed
     VACUUM [FULL] [FREEZE] [VERBOSE] [ANALYZE] [table_name];
    - VACUUM :non-blocking mode, share lock
    - VACUUM FULL : exclusive lock on the table, meaning no other operations can be performed on the table while VACUUM FULL is running.
    - VACUUM FREEZE : Processes all pages to update the visibility map and freezes old transaction IDs. This is useful for tables that are rarely updated
    - VACUUM ANALYZE : VACUUM & ANALYZE
    - ANALYZE : Updates table statistics
********************************************************************/

vacuum full analyze ${c_schema}.${c_table} ;

-- All table in schema
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'my_schema'
    LOOP
        EXECUTE 'VACUUM ANALYZE ' || quote_ident(rec.tablename);
    END LOOP;
END $$;





/***************************************************************
    system table
***************************************************************/

-- set role
CREATE ROLE "tsoft";
CREATE ROLE "tsoft" LOGIN;
CREATE ROLE "tsoft" LOGIN PASSWORD 'tsoft';
GRANT Connect ON DATABASE "db_dalian" TO "market_dfda" WITH GRANT OPTION;
-- Table：
GRANT Usage ON SCHEMA "code" TO "tsoft" WITH GRANT OPTION;
GRANT Select ON TABLE "code"."t_codetype_manager_test" TO "tsoft" WITH GRANT OPTION;
GRANT Delete, Insert, References, Select, Trigger, Update ON TABLE "code"."t_dim" TO "tsoft" WITH GRANT OPTION;
-- Member：
GRANT "tsoft" TO "internet" WITH ADMIN OPTION;
REVOKE Select ON TABLE "code"."t_dim" FROM "tsoft";


-- terminate processes  
select * from pg_stat_activity --PID
select pg_terminate_backend(PID);

SELECT pg_cancel_backend(procpid);


-- table or database size
select pg_size_pretty(pg_relation_size('schema.tablename'));
select pg_size_pretty(pg_database_size('databasename'));

-- constraint 
select pg_size_pretty(pg_total_relation_size('tablename'));

-- database size
select datname,pg_size_pretty(pg_database_size(datname)) from pg_database;
SELECT * FROM gp_toolkit.gp_size_of_database ORDER BY sodddatname;

-- schema size
select 
    pg_size_pretty(cast( sum(pg_relation_size( schemaname  || '.' || tablename)) as bigint)), 
    schemaname
from pg_tables t
inner join pg_namespace d on t.schemaname=d.nspname 
group by schemaname order by schemaname; 

-- check table constraint
SELECT
 tc.constraint_type,
 tc.constraint_name, tc.table_name, kcu.column_name, 
 ccu.table_name AS foreign_table_name,
 ccu.column_name AS foreign_column_name,
 tc.is_deferrable,
 tc.initially_deferred
FROM 
	 information_schema.table_constraints AS tc 
	 JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
	 JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'tablename';

-- Data Distribution & Disk Space
select gp_segment_id,count(*) from table_name  group by gp_segment_id order by 1;

SELECT * FROM gp_toolkit.gp_disk_free ORDER BY dfsegment;

-- check lock info
select 
    locktype,
    database,
    c.relname,
    l.relation,
    l.transactionid,
    l.pid,
    l.mode,
    l.granted,
    a.current_query
from pg_locks l, pg_class c,pg_stat_activity a 
where l.relation=c.oid and l.pid = a.procpid
and c.relname = 'tablename'
order by c.relname;



--change distribution key
--Random Distribution  (Don't use unique）
ALTER TABLE db.table  set distributed randomly;

--Hash Distribution
ALTER TABLE db.table set distributed by(c_entname);
ALTER TABLE db.table set distributed by(column1,column2,column3);

-- Replicated Distribution 
ALTER TABLE db.table set distributed replicated;


--check distribution key
select 
    d.nspname||'.'||a.relname as table_name,
    string_agg(b.attname,',') as column_name
from pg_catalog.pg_class a
inner join pg_catalog.pg_attribute b on a.oid=b.attrelid
inner join pg_catalog.gp_distribution_policy c on a.oid=c.localoid
inner join pg_catalog.pg_namespace d on a.relnamespace=d.oid
where a.relkind='r' and b.attnum=any(c.attrnums) and a.relname not like '%prt%'
group by table_name
order by table_name desc;



--check distribution key（GP6）
select 
    d.nspname||'.'||a.relname as table_name,
    b.attname as column_name
from pg_catalog.pg_class a
inner join pg_catalog.pg_attribute b on a.oid=b.attrelid
inner join pg_catalog.gp_distribution_policy c on a.oid=c.localoid
inner join pg_catalog.pg_namespace d on a.relnamespace=d.oid
where a.relkind='r' and b.attnum::text=c.distkey::text and a.relname like 't_tag_ent'
group by table_name,b.attname
order by table_name desc;


-- table rowcount 
select 
    c.nspname as "schema",
    b.relname as "table",
    a.description as "description",
    b.reltuples as "rowcount"
from pg_class b LEFT JOIN pg_namespace c on b.relnamespace = c.oid
LEFT JOIN  (select * 
            from pg_description t
            where t.objsubid = 0
            )a on b.oid =a.objoid
where b.relkind = 'r'
order by c.nspname,b.relname;


-- table info
select 
    n.nspname as c_schema,
    c.relname as c_table,
    a.attname as c_column,
    col_description(a.attrelid,a.attnum) as c_column_comment,
    format_type(a.atttypid,a.atttypmod) as c_column_type
from pg_class c ,pg_attribute  a ,pg_namespace n 
where  c.relnamespace = n.oid 
    and  n.nspname = 'schemaname'
    and a.attrelid = c.oid
    and a.attnum >0
    and format_type(a.atttypid,a.atttypmod)!='-'
order by c.relname,a.attnum


-- all table in schema
SELECT 
    c.relname as tablename,
    a.attname as name,
    col_description(a.attrelid,a.attnum) as comment,
    format_type(a.atttypid,
    a.atttypmod) as type,
    a.attnotnull as notnull   
FROM pg_class as c,pg_attribute as a ,pg_namespace b
where b.nspname='schemaname'
    and b.oid = c.relnamespace
    and a.attrelid = c.oid 
    and a.attnum>0 
    --and c.relname like 't_%'


