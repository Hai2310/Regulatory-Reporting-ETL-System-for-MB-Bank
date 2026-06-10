-- Tạo bảng báo cáo G044641
CREATE TABLE APPS.BC_NHNN_G044641_HHAI
(
    VON_TU_CO VARCHAR2(30),
    VON_DIEU_LE VARCHAR2(30),
    BUSINESS_DATE VARCHAR2(30)
);

CREATE OR REPLACE PROCEDURE APPS.HHAI_G044641 (v_business_date IN VARCHAR2)
AS
—/*
*----------------------------------------------------------------------*
* Program code : G044641
* Program name : 
* Created by : HHAI
* Created date : 2022-10-26
*----------------------------------------------------------------------*
* Modified management
* Date User Description
*
*----------------------------------------------------------------------*
*/
BEGIN
    --xóa dữ liệu trong bảng trước khi thêm dữ liệu
    DELETE from APPS.BC_NHNN_G044641_LINH where business_date = v_business_date;
EXECUTE IMMEDIATE '	

-- thêm dữ liệu vào bảng đích
    INSERT INTO APPS.BC_NHNN_G044641_HHAI
    (
        VON_TU_CO,
        VON_DIEU_LE,
        BUSINESS_DATE
    )

-- truy vấn dữ liệu từ hai bảng MB_GL_V6_BALANCES và mb_car_nn117_th để lấy dữ liệu
-- truyền vào trường VON_TU_CO, VON_DIEU_LE trong bảng BC_NHNN_G044641_LINH 
SELECT 
    TO_CHAR(ROUND(GIATRI)) VON_TU_CO,
    (select  ROUND(SUM(CUOIKY_CREDIT)/1e6)      
      from MB_GL_V6_BALANCES     
      where Transaction_Date = to_date('||v_business_date||', ''YYYYMMDD'')     
      and Line_GL = ''53100'') VON_DIEU_LE,
    REPORT_DATE as BUSINESS_DATE
from apps.mb_car_nn117_th_20211031
where STT = 1
and muc = ''A''
and VERSION = ''THANG''
and loai_bc = 2
and report_date = '||v_business_date||'' ;
commit;
END ;
