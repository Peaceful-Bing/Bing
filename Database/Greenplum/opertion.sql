--字段合并
--方法1：
	select deptno, string_agg(ename, ',') from jinbo.employee group by deptno;
/*	
	 deptno |  string_agg  
	--------+--------------
	     20 | JONES
	     30 | ALLEN,MARTIN
*/
	select deptno, string_agg(ename, ',' order by ename desc) from jinbo.employee group by deptno;
/*
	 deptno |  string_agg  
	--------+--------------
	     20 | JONES
	     30 | MARTIN,ALLEN
*/
--方法2：
	select deptno, array_agg(ename) from jinbo.employee group by deptno;
/*
	 deptno |   array_agg    
	--------+----------------
	     20 | {JONES}
	     30 | {ALLEN,MARTIN}
*/	
	select deptno, array_to_string(array_agg(ename),',') from jinbo.employee group by deptno;
/*
	 deptno | array_to_string 
	--------+-----------------
	     20 | JONES
	     30 | ALLEN,MARTIN
*/	
	select array_agg(distinct deptno) from jinbo.employee;
/*
	array_agg 
	-----------
	 {20,30}
	(1 row)
*/	
	select array_agg(distinct deptno order by deptno desc) from jinbo.employee;
/*
	 array_agg 
	-----------
	 {30,20}
	(1 row)
*/
--行转列
-- 方法1
	select
	c_MDSEid,
	count(c_Evaluation_result) filter (where c_Evaluation_result='好') as "n_goodCount",
           count(c_Evaluation_result) filter (where c_Evaluation_result='中') as "n_generalCount",
	count(c_Evaluation_result) filter (where c_Evaluation_result='差') as "n_poorCount"
	from syn_network.t_Net
	group by c_MDSEid
	order by c_MDSEid;
	
--拆分数据
    regexp_split_to_table(name,',')