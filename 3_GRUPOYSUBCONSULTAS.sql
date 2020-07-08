SELECT LPAD(' ', 2*(LEVEL-1))|| TO_CHAR(CODIGO_CTA,'0000000') CODIGO_CTA, NOMBRE_CTA FROM B_CUENTAS
START WITH CODIGO_CTA = 1000000
CONNECT BY PRIOR CODIGO_CTA = CTA_SUPERIOR;

/* 1. El salario de cada empleado está dado por su posición, y la asignación de la categoría vigente
en dicha posición. Tanto la posición como la categoría vigente tienen la fecha fin nula – Un
solo salario está vigente en un momento dado). Tomando como base la lista de empleados,
verifique cuál es el salario máximo, el mínimo y el promedio. Formatee la salida para que se
muestren los puntos de mil.*/


SELECT TO_CHAR(MAX (CAT.ASIGNACION),'999G999G999') SALARIO_MAXIMO, TO_CHAR(MIN(CAT.ASIGNACION), '999G999G999') SALARIO_MINIMO,TO_CHAR(AVG(CAT.ASIGNACION),'999G999G999') PROMEDIO FROM B_CATEGORIAS_SALARIALES CAT
JOIN B_POSICION_ACTUAL POS
    ON CAT.COD_CATEGORIA = POS.COD_CATEGORIA
JOIN B_EMPLEADOS E
    ON E.CEDULA = POS.CEDULA
WHERE CAT.FECHA_FIN IS NULL
AND POS.FECHA_FIN IS NULL;

/*2. Basado en la consulta anterior, determine la mayor y menor asignación en cada área. Su
consulta tendrá: Nombre de área, Asignación Máxima, Asignación Mínima.*/

SELECT AREA.NOMBRE_AREA AREA, TO_CHAR(MAX (CAT.ASIGNACION),'999G999G999') SALARIO_MAXIMO, TO_CHAR(MIN(CAT.ASIGNACION), '999G999G999') SALARIO_MINIMO FROM B_CATEGORIAS_SALARIALES CAT
JOIN B_POSICION_ACTUAL POS
    ON CAT.COD_CATEGORIA = POS.COD_CATEGORIA
JOIN B_EMPLEADOS E
    ON E.CEDULA = POS.CEDULA
JOIN B_AREAS AREA
    ON AREA.ID = POS.ID_AREA
WHERE CAT.FECHA_FIN IS NULL
AND POS.FECHA_FIN IS NULL
GROUP BY AREA.NOMBRE_AREA;

/* 3.Determine el nombre y apellido, nombre de categoría, asignación y área del empleado (o
empleados) que tienen la máxima asignación vigente. Pruebe con un subquery normal, y luego
con la cláusula WITH:*/

SELECT E.NOMBRE ||' '|| E.APELLIDO AS "NOMBRE Y APELLIDO", CAT.NOMBRE_CAT, CAT.ASIGNACION, AREA.NOMBRE_AREA
FROM B_EMPLEADOS E 
JOIN B_POSICION_ACTUAL POS 
    ON E.CEDULA = POS.CEDULA 
JOIN B_CATEGORIAS_SALARIALES CAT 
    ON POS.COD_CATEGORIA = CAT.COD_CATEGORIA
JOIN B_AREAS AREA
    ON AREA.ID = POS.ID_AREA
WHERE CAT.ASIGNACION = (SELECT MAX (CAT.ASIGNACION) FROM B_CATEGORIAS_SALARIALES CAT
                        JOIN B_POSICION_ACTUAL POS
                        ON CAT.COD_CATEGORIA = POS.COD_CATEGORIA
                        JOIN B_EMPLEADOS E
                        ON E.CEDULA = POS.CEDULA
                        JOIN B_AREAS AREA
                        ON AREA.ID = POS.ID_AREA
                        WHERE CAT.FECHA_FIN IS NULL
                        AND POS.FECHA_FIN IS NULL
                        );

--UTILIZANDO WITH
WITH SALARIO_MAX AS (
SELECT MAX (CAT.ASIGNACION) MONTO FROM B_CATEGORIAS_SALARIALES CAT
JOIN B_POSICION_ACTUAL POS
    ON CAT.COD_CATEGORIA = POS.COD_CATEGORIA
JOIN B_EMPLEADOS E
    ON E.CEDULA = POS.CEDULA
JOIN B_AREAS AREA
    ON AREA.ID = POS.ID_AREA
WHERE CAT.FECHA_FIN IS NULL
    AND POS.FECHA_FIN IS NULL)
SELECT E.NOMBRE ||' '|| E.APELLIDO AS "NOMBRE Y APELLIDO", CAT.NOMBRE_CAT, CAT.ASIGNACION, AREA.NOMBRE_AREA
FROM B_EMPLEADOS E 
JOIN B_POSICION_ACTUAL POS 
    ON E.CEDULA = POS.CEDULA 
JOIN B_CATEGORIAS_SALARIALES CAT 
    ON POS.COD_CATEGORIA = CAT.COD_CATEGORIA
JOIN B_AREAS AREA
    ON AREA.ID = POS.ID_AREA
WHERE CAT.ASIGNACION = (SELECT MONTO FROM SALARIO_MAX);

/* 4. Determine el nombre y apellido, nombre de categoría, asignación y área del empleado (o
empleados) que tienen una asignación INFERIOR al promedio. Ordene por monto de salario en
forma DESCENDENTE. Intente la misma consulta con y sin WITH.*/

SELECT E.NOMBRE ||' '|| E.APELLIDO AS "NOMBRE Y APELLIDO", CAT.NOMBRE_CAT, CAT.ASIGNACION, AREA.NOMBRE_AREA
FROM B_EMPLEADOS E 
JOIN B_POSICION_ACTUAL POS 
    ON E.CEDULA = POS.CEDULA 
JOIN B_CATEGORIAS_SALARIALES CAT 
    ON POS.COD_CATEGORIA = CAT.COD_CATEGORIA
JOIN B_AREAS AREA
    ON AREA.ID = POS.ID_AREA
WHERE CAT.ASIGNACION < (SELECT AVG (CAT.ASIGNACION) FROM B_CATEGORIAS_SALARIALES CAT
                        JOIN B_POSICION_ACTUAL POS
                        ON CAT.COD_CATEGORIA = POS.COD_CATEGORIA
                        JOIN B_EMPLEADOS E
                        ON E.CEDULA = POS.CEDULA
                        JOIN B_AREAS AREA
                        ON AREA.ID = POS.ID_AREA
                        WHERE CAT.FECHA_FIN IS NULL
                        AND POS.FECHA_FIN IS NULL
                        );
    --WITH ,OTRO DIA XD  

/*5. Se necesita saber la cantidad de clientes que hay por cada localidad (Tenga en cuenta en la tabla
B_PERSONAS sólo aquellas que son clientes). Liste el id, la descripción de la localidad y la
cantidad de clientes. Asegúrese que se listen también las localidades que NO tienen clientes.*/

SELECT ES_CLIENTE FROM B_PERSONAS;

SELECT LOC.NOMBRE, COUNT (P.ID) FROM B_PERSONAS P 
LEFT OUTER JOIN B_LOCALIDAD LOC 
    ON  LOC.ID = P.ID_LOCALIDAD
WHERE P.ES_CLIENTE = 'S'
GROUP BY LOC.NOMBRE; --REVISAR XD 

select * from B_EMPLEADOS;

/*6. 