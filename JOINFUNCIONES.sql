
--E2: JOINS Y FUNCIONES
/* 1.El campo FILE_NAME del archivo DBA_DATA_FILES contiene el nombre y camino de
los archivos f�sicos que conforman los espacios de tabla de la Base de Datos. Seleccione:
-Solamente el nombre del archivo (sin mencionar la carpeta o camino):*/
SELECT SUBSTR(FILE_NAME,(INSTR(FILE_NAME,'\',-1,1)+1),length(FILE_NAME)) FROM DBA_DATA_FILES;

/* 2. Obtenga la lista de empleados con su posici�n y salario vigente (El salario y la categor�a
vigente tienen la fecha fin nula � Un solo salario est� vigente en un momento dado). Debe
listar:
Nombre �rea, Apellido y nombre del empleado, Fecha Ingreso, categor�a, salario actual
La lista debe ir ordenada por nombre de �rea, y por apellido del funcionario.*/ 
SELECT a.nombre_area, e.apellido || ' ' || e.nombre as "Apellido y Nombre", 
POS.fecha_ini, cat.nombre_cat, cat.asignacion AS "SALARIO ACTUAL"
from B_POSICION_ACTUAL POS 
JOIN B_EMPLEADOS E 
ON E.CEDULA = POS.CEDULA
JOIN B_CATEGORIAS_SALARIALES cat
ON POS.COD_CATEGORIA = CAT.COD_CATEGORIA
JOIN B_AREAS A 
ON POS.ID_AREA = A.ID
WHERE CAT.fecha_fin IS NULL
AND POS.fecha_fin IS NULL
ORDER BY 1,2;

/* 3. Liste el libro DIARIO correspondiente al mes de enero del a�o 2019, tomando en cuenta la
cabecera y el detalle. Debe listar los siguientes datos:
ID_Asiento, Fecha, Concepto, Nro.Linea, c�digo cuenta, nombre cuenta, Monto d�bito,
Monto cr�dito (haga aparecer el monto del cr�dito o d�bito seg�n el valor del campo
d�bito_cr�dito � D � C)*/
SELECT D.ID, D.FECHA, D.CONCEPTO, DET.NRO_LINEA, DET.CODIGO_CTA, C.NOMBRE_CTA,
DECODE(DET.DEBE_HABER, 'C', IMPORTE, 0) CREDITO,
DECODE(DET.DEBE_HABER, 'D', IMPORTE, 0) DEBITO
FROM B_DIARIO_DETALLE DET 
JOIN B_DIARIO_CABECERA D
ON D.ID = DET.ID
JOIN B_CUENTAS C 
ON DET.CODIGO_CTA = C.CODIGO_CTA;

/* 4. Algunos empleados de la empresa son tambi�n clientes. Obtenga dicha lista a trav�s de una
operaci�n de intersecci�n. Liste c�dula, nombre y apellido, tel�fono. Tenga en cuenta s�lo a
las personas f�sicas (F) que tengan c�dula. Recuerde que los tipos de datos para operaciones
del �lgebra relacional tienen que ser los mismos. */
SELECT P.NOMBRE, P.Apellido, P.TELEFONO
FROM B_EMPLEADOS P
INTERSECT 
SELECT NOMBRE, APELLIDO, TELEFONO
FROM B_PERSONAS
WHERE TIPO_PERSONA = 'F';


/* 5. Se pretende realizar el aumento salarial del 5% para todas las categor�as. Debe listar la
categor�a (c�digo y nombre), el importe actual, el importe aumentado al 5% (redondeando la
cifra a la centena), y la diferencia.
Formatee la salida (usando TO_CHAR) para que los montos tengan los puntos de mil*/ 
SELECT COD_CATEGORIA, NOMBRE_CAT, asignacion, 
TO_CHAR(ASIGNACION + ASIGNACION*5/100, '999G999G999') AS "AUMENTO", 
TO_CHAR(ASIGNACION + ASIGNACION*5/100 - ASIGNACION, '999G999G999') AS "DIFERENCIA" 
FROM B_CATEGORIAS_SALARIALES;

/* 6.Se necesita tener la lista completa de personas (independientemente de su tipo), ordenando
por nombre de localidad. Si la persona no tiene asignada una localidad, tambi�n debe
aparecer. Liste Nombre de Localidad, Nombre y apellido de la persona, direcci�n, tel�fono*/
SELECT LOC.NOMBRE as localidad ,P.NOMBRE, P.APELLIDO,
P.TELEFONO, P.DIRECCION
FROM B_PERSONAS P
LEFT OUTER JOIN B_LOCALIDAD LOC
ON P.ID_LOCALIDAD = LOC.ID;

/* 7. En base a la consulta anterior, liste todas las localidades, independientemente que existan
personas en dicha localidad:*/
SELECT LOC.NOMBRE,P.NOMBRE, P.APELLIDO,
P.TELEFONO, P.DIRECCION
FROM B_PERSONAS P
RIGHT OUTER JOIN B_LOCALIDAD LOC
ON P.ID_LOCALIDAD = LOC.ID;

/* 8. Obtenga la misma lista del ejercicio 6, pero asegur�ndose de listar todas las personas,
independientemente que est�n asociadas a una localidad, y todas las localidades, a�n cuando
no tengan personas asociadas:*/
SELECT LOC.NOMBRE LOCALIDAD,P.NOMBRE, P.APELLIDO,
P.TELEFONO, P.DIRECCION
FROM B_PERSONAS P
FULL OUTER JOIN B_LOCALIDAD LOC
ON P.ID_LOCALIDAD = LOC.ID;

/* 9. Considerando la fecha de hoy, indique cu�ndo caer� el pr�ximo DOMINGO.*/
SELECT NEXT_DAY(SYSDATE, 'DOMINGO') FROM DUAL;

/* 10. Utilice la funci�n LAST_DAY para determinar si este a�o es bisiesto o no. Con CASE y con
DECODE, haga aparecer la expresi�n �bisiesto� o �no bisiesto� seg�n corresponda. (En un
a�o bisiesto el mes de febrero tiene 29 d�as) */

SELECT DECODE(
EXTRACT(DAY FROM LAST_DAY(TO_DATE('02/01/2020 01:00:00', 'MM/DD/YYYY HH:MI:SS'))),'29','BISIESTO', 'NO BISIESTO') TIPO_ANHO FROM DUAL;

/* 11. Tomando en cuenta la fecha de hoy, verifique que fecha dará redondeando al año? Y
truncando al año? Escriba el resultado. Pruebe lo mismo suponiendo que sea el 1 de Julio del
año. Pruebe también el 12 de marzo.*/

--KHE

/* 12.. Imprima su edad en años y meses. Ejemplo: Si nació el 23/abril/1972, tendría 43 años y 3
meses a la fecha.*/
SELECT CASE WHEN 
EXTRACT(MONTH FROM SYSDATE) < EXTRACT(MONTH FROM TO_DATE('20-11-1992', 'DD-MM-YYYY'))
THEN 
    TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE('20-11-1992', 'DD-MM-YYYY'))) - 1 || ' ANHOS'||
    TO_CHAR(EXTRACT(MONTH FROM TO_DATE('20-11-1992', 'DD-MM-YYYY'))-EXTRACT(MONTH FROM SYSDATE))||' MESES'||
    TO_CHAR(EXTRACT(DAY FROM SYSDATE) - EXTRACT(DAY FROM TO_DATE('20-11-1992', 'DD-MM-YYYY')))||' DIAS'
ELSE
	TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE('20-11-1992', 'DD-MM-YYYY'))) || ' ANHOS' ||
   TO_CHAR( EXTRACT(MONTH FROM SYSDATE) - EXTRACT(MONTH FROM TO_DATE('20-11-1992', 'DD-MM-YYYY')))||' MESES'||
   TO_CHAR( EXTRACT(DAY FROM SYSDATE) - EXTRACT(DAY FROM TO_DATE('20-11-1992', 'DD-MM-YYYY')))||' DIAS'
END AS EDAD FROM DUAL;
--REVISAR XD

/*13 */
/*14 Liste ID y NOMBRE de todos los artículos que no están incluidos en ninguna VENTA. Debe
utilizar necesariamente la sentencia MINUS.*/

SELECT ART.NOMBRE, ART.ID FROM B_ARTICULOS ART
MINUS
SELECT ART.NOMBRE, VENTA.ID_ARTICULO FROM B_DETALLE_VENTAS VENTA
JOIN B_ARTICULOS ART ON 
ART.ID = VENTA.ID_ARTICULO;

/*15.  La organización ha decidido mantener un registro único de todas las personas, sean éstas
proveedores, clientes y/o empleados. Para el efecto se le pide una operación de UNION entre
las tablas de B_PERSONAS y B_EMPLEADOS. Debe listar
CEDULA, APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIMIENTO.
En la tabla PERSONAS tenga únicamente en cuenta las personas de tipo FISICAS (F) y
que tengan cédula. Ordene la consulta por apellido y nombre*/

SELECT PER.CEDULA, PER.APELLIDO, PER.NOMBRE, PER.DIRECCION, PER.TELEFONO, PER.FECHA_NACIMIENTO FROM B_PERSONAS PER
WHERE TIPO_PERSONA = 'F' AND PER.CEDULA IS NOT NULL
UNION
SELECT TO_CHAR(E.CEDULA), E.APELLIDO, E.NOMBRE, E.DIRECCION, E.TELEFONO, E.FECHA_NACIM FROM B_EMPLEADOS E;

/*16. El área de CREDITOS Y COBRANZAS solicita un informe de las ventas a crédito
efectuadas en el año 2018 y cuyas cuotas tienen atraso en el pago. A las cuotas que se
encuentran en dicha situación se le aplica una tasa de interés del 0.5% por cada día de atraso.
Se considera que una cuota está en mora cuando ya pasó la fecha de vencimiento y no existe
aún pago alguno. Se pide mostrar los siguientes datos y ordenar de forma descendente por
días de atraso.*/

SELECT VENTAS.NUMERO_FACTURA,
E.NOMBRE ||' '||E.APELLIDO AS "VENDEDOR",
P.RUC, P.NOMBRE || ' '||P.APELLIDO AS "CLIENTE",
VENTAS.PLAZO || '/' || PLAN.NUMERO_CUOTA "CUOTA",
TRUNC(SYSDATE) - TRUNC(PLAN.VENCIMIENTO)  AS "DIAS DE ATRASO", VENTAS.MONTO_TOTAL * 0.5,( 
(VENTAS.MONTO_TOTAL + VENTAS.MONTO_TOTAL * 0.5) * (TRUNC(PLAN.VENCIMIENTO) - TRUNC(SYSDATE)))* -1 AS " TOTAL A PAGAR"
FROM B_VENTAS VENTAS 
JOIN B_PERSONAS P
    ON VENTAS.ID_CLIENTE = P.ID
JOIN B_EMPLEADOS E 
    ON VENTAS.CEDULA_VENDEDOR = E.CEDULA
JOIN B_PLAN_PAGO PLAN 
    ON VENTAS.ID = PLAN.ID_VENTA
WHERE PLAN.FECHA_PAGO IS NULL
AND PLAN.VENCIMIENTO < TRUNC(TO_DATE('06/02/20 01:00:00', 'DD/MM/YY HH:MI:SS'))
AND VENTAS.TIPO_VENTA = 'CR'
AND VENTAS.FECHA BETWEEN TRUNC(TO_DATE('01/01/18 01:00:00', 'DD/MM/YY HH:MI:SS')) AND TRUNC(TO_DATE('31/12/18 01:00:00', 'DD/MM/YY HH:MI:SS'))
ORDER BY "DIAS DE ATRASO" DESC;

/*17.*/


SELECT CAB.FECHA, CAB.CONCEPTO, 
DECODE(DET.DEBE_HABER, 'C', DET.IMPORTE, 0) CREDITO,
DECODE(DET.DEBE_HABER, 'D', DET.IMPORTE, 0) DEBITO,
P.NOMBRE AS "CLIENTE PROVEEDOR", 
LOC.ID AS "LOCALIDAD DEL CLIENTEPROVEEDOR", 
V.NUMERO_FACTURA
FROM B_DIARIO_CABECERA CAB
JOIN B_DIARIO_DETALLE DET 
ON CAB.ID = DET.ID
JOIN B_PERSONAS P 
ON P.ID = DET.ID
JOIN B_LOCALIDAD LOC
ON LOC.ID = P.ID_LOCALIDAD
JOIN B_VENTAS V
ON V.ID_CLIENTE= P.ID;