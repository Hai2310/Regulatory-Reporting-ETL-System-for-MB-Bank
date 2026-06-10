DECLARE 
    V_BUSINESS_DATE VARCHAR2(20) := '#HHAI_APPS.HHAI_V_BUSINESS_DATE' ;
    V_JOB_NAME VARCHAR2(20) := '#HHAI_APPS.HHAI_V_JOB_NAME' ;
    FLG VARCHAR2(30) ;
BEGIN 
    FOR V_FLG IN (SELECT DISTINCT(TABLE_NAME) 
                  FROM APPS.SOURCES_LOG
                  WHERE 1 = 1
                    AND FLAG = 'N'
                    AND BUSINESS_DATE = V_BUSINESS_DATE
                    AND JOB_NAME = V_JOB_NAME)
    LOOP
        IF FLG IS NULL THEN 
            FLG := V_FLG.TABLE_NAME;
        ELSE 
            FLG := FLG || ',' || V_FLG.TABLE_NAME ;
        END IF ;
    END LOOP;
    
    EXECUTE IMMEDIATE 
    'UPDATE APPS.HHAI_ETL_SYS_LOG
     SET STATUS = ''CHECK_SOURCE_FAIL'',
         ETL_END_DATE = SYSDATE,
         NOTE = ''MISSING DATA IN TABLE :'|| FLG ||' ''
     WHERE 1 = 1 
       AND JOB_NAME = '''|| V_JOB_NAME ||'''
       AND BUSINESS_DATE = '''| V_BUSINESS_DATE|'''
       AND STATUS = ''PROCESSING''
       AND ID = (SELECT MAX(ID)
                 FROM APPS.HHAI_ETL_SYS_LOG
                 WHERE 1 = 1
                   AND JOB_NAME = '''|| V_JOB_NAME ||'''
                   AND BUSINESS_DATE = '''| V_BUSINESS_DATE |'''
                   AND STATUS = ''PROCESSING'' )';
      EXECUTE IMMEDIATE 'COMMIT';  
END;