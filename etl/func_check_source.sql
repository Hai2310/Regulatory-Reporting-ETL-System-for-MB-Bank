-- Hàm kiểm tra xem dữ liệu ở source đã được chạy đầy đủ chưa
CREATE OR REPLACE FUNCTION HHAI_FUNC_CHECK_SOURCE (V_JOB_NAME VARCHAR, V_ETL_DATE VARCHAR) 
RETURN INT 
IS 
    FLG INTEGER := 0 ; --biến kiểm tra
    V_COUNT_SRC NUMBER ; --tổng bảng ở source
    V_COUNT_FLG NUMBER ; --tổng bảng source khi đã bắt đầu chạy
BEGIN 
    SELECT COUNT(1) 
    INTO V_COUNT_SRC
    FROM APPS.SOURCES_CONFIG
    WHERE JOB_NAME = V_JOB_NAME;
    
    SELECT COUNT(1)
    INTO V_COUNT_FLG
    FROM APPS.SOURCES_LOG
    WHERE 1 = 1
      AND JOB_NAME = V_JOB_NAME 
      AND BUSINESS_DATE = V_ETL_DATE
      AND UPPER(FLAG) = 'Y';
      
    IF V_COUNT_SRC = V_COUNT_FLG
        AND V_COUNT_SRC > 0
        AND V_COUNT_FLG > 0 THEN 
        FLG := 1 ;
    ELSE 
        FLG := 0;
    END IF ;     
    RETURN FLG ;
END;