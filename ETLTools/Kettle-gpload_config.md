Kettle GPLoad config
===========================
>**Install Package or Software**
>- python-2.5.4.msi #只支持python2版本
>- PyYAML-3.05.win32-py2.5.exe
>- PyGreSQL-4.1.1.win-amd64-py2.5.msi
>- PyGreSQL-4.1.1.win-amd64-py2.5.exe
>- greenplum-loaders-4.3.26.0-WinXP-x86_32.msi

>**Execute gpfdist**
>C:\Program Files (x86)\Greenplum\greenplum-loaders-4.3.12.0\bin\gpfdist.exe

>**Configuration Environment**
>- PYTHONPATH: %GPHOME_LOADERS%bin\lib
>- PYTHON_HOME: C:\Python25\
>- Path: %GPHOME_LOADERS%bin;C:\Python25\;%GPHOME_LOADERS%bin;%GPHOME_LOADERS%lib
>- PGDATABASE: db_market
>- PGHOST: 172.18.15.123
>- PGPASSWORD:  market
>- PGPORT: 5432
>- PGUSER:  market_internet
>>![](/ETLTools/system.png)

>**Configure GPLoad in kettle**
>>![](/ETLTools/gpload.png)
>- Two option in [Load method]
>   - Automatic load (at the end)
>   - Manual load (only creation of file) : Only generate cfg and dat file, and it needs manual execute gpload command.The _cfg_ is gpload's yml file.The _dat_ is data files.
>- [Erase cfg/dat files after use] : Whether to delete files after loading data
>- [Load action]
>   - insert
>   - update
>   - merge
> 
>   Note: In table must choose one field as "Y" of _Match_ and _Update_._Update_ is meaning when the records existing kettle will update this field. If we don't saved the configurtion in panel, we can change this information in job file.
>
> >![](/ETLTools/GPLoad_Host.png)
> - [Local Host Names]
>    - Port is used for gpfdist
>    - Host is gpfdist's ip
>
>   Note:
> 