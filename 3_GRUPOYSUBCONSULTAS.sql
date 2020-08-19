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



/*6. Para tener una idea de movimientos, se desea conocer el volumen (cantidad) de ventas por mes
que se hicieron por cada artículo durante el año 2018. Debe listar también los artículos que no
tuvieron movimiento. La consulta debe lucir así:
Nombre Artículo| Ene| Feb |Mar| Abr| May| Jun| Jul| Ago| Sep| Oct| Nov| Dic|*/
SELECT  ART.NOMBRE, TOT.ENE, TOT.FEB, TOT.MAR, TOT.ABR, TOT.MAY, TOT.JUN, TOT.JUL, TOT.AGO, TOT.SEP, TOT.OCT, TOT.NOV, TOT.DIC FROM (
    SELECT D.ID_ARTICULO,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'O1',D.CANTIDAD,0)) ENE,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'O2',D.CANTIDAD,0)) FEB,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'03',D.CANTIDAD,0)) MAR,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'04',D.CANTIDAD,0)) ABR,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'05',D.CANTIDAD,0)) MAY,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'06',D.CANTIDAD,0)) JUN,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'07',D.CANTIDAD,0)) JUL,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'08',D.CANTIDAD,0)) AGO,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'09',D.CANTIDAD,0)) SEP,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'10',D.CANTIDAD,0)) OCT,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'11',D.CANTIDAD,0)) NOV,
    SUM(DECODE(TO_CHAR(V.FECHA,'MM'),'12',D.CANTIDAD,0)) DIC
FROM B_DETALLE_VENTAS D JOIN B_VENTAS V
    ON V.ID = D.ID_VENTA
    WHERE V.FECHA LIKE '%18'
GROUP BY D.ID_ARTICULO 
    )TOT
RIGHT OUTER JOIN B_ARTICULOS ART
ON ART.ID = TOT.ID_ARTICULO;

/*
8.Se necesita la cantidad de funcionarios por área. Ordene en forma jerárquica e incluya también la
cantidad de funcionarios de las áreas subordinadas de la siguiente manera:
ID                       NOMBRE AREA         CANTIDAD        CANTIDAD TOTAL
 000001                 Gerencia General        1                  13
 000002                 Gerencia Comercial      1                  12
 000004                 Ventas                  6                   7
 000006                 Atención al Cliente     0                   0
 000009                 Ventas Mayoristas       1                   1
 000010                 Ventas de Salón         0                   0
 000005                 Marketing               4                   4
 000007                 Promociones             0                   0
 000008                 Innovación              0                   0

ejemplos de connect by 
SELECT codigo_cta,nombre_cta
FROM b_cuentas
start with codigo_cta = 1000000
connect BY PRIOR codigo_cta = cta_superior;

SELECT LPAD(' ',2*(LEVEL-1))||
TO_CHAR(codigo_cta,'0000000') codigo_cta,
nombre_cta
FROM b_cuentas
start with codigo_cta = 1000000
connect BY PRIOR codigo_cta = cta_superior;*/

SELECT TO_CHAR(ID, '000000') FROM B_AREAS;

SELECT LPAD(' ', 2*(LEVEL-1))|| TO_CHAR(AREA.ID, '000000') ID, AREA.NOMBRE_AREA, 
(
    SELECT COUNT(E.CEDULA) CANTIDAD FROM B_EMPLEADOS E 
    JOIN B_POSICION_ACTUAL POS
        ON POS.CEDULA = E.CEDULA
    JOIN B_AREAS A
        ON POS.ID_AREA = A.ID
    WHERE POS.FECHA_FIN IS NULL 
    AND A.ID = AREA.ID
    GROUP BY A.ID
) CANTIDAD,
(
    SELECT SUM(CANTIDAD) FROM (
        SELECT A.ID, A.ID_AREA_SUPERIOR, A.NOMBRE_AREA, COUNT (E.CEDULA) CANTIDAD 
        FROM B_POSICION_ACTUAL P RIGHT OUTER JOIN B_AREAS A 
        ON A.ID = P.ID_AREA LEFT OUTER JOIN B_EMPLEADOS E ON E.CEDULA = P.CEDULA
        WHERE P.FECHA_FIN IS NULL
        GROUP BY A.ID, A.ID_AREA_SUPERIOR, A.NOMBRE_AREA) AR
        CONNECT BY PRIOR AR.ID = AR.ID_AREA_SUPERIOR
        START WITH AR.ID = AREA.ID
    )CANTIDAD_TOTAL
FROM B_AREAS AREA
CONNECT BY PRIOR AREA.ID = AREA.ID_AREA_SUPERIOR
START WITH AREA.ID_AREA_SUPERIOR IS NULL

