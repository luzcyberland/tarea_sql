DECLARE v_nombre varchar2(40);
begin
    SELECT
        nombre into v_nombre
    FROM b_empleados;
    exception
    when others then dbms_output.putline('error')
    end;