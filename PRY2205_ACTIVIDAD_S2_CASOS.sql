//CASO N°1

SELECT * FROM factura;


SELECT 
numfactura AS "N° FACTURA",
TO_CHAR (fecha, 'dd "de" Month yyyy') AS "Fecha Emision",
rutvendedor AS "RUT Cliente",
TO_CHAR (neto, '$999G999') AS "Monto Neto",
iva AS "Monto IVA",
total AS "Total Factura",

CASE
WHEN total BETWEEN 0 AND 50000 THEN 'Bajo'
WHEN total BETWEEN 50001 AND 100000 THEN 'Medio'
ELSE 'Alto'
END AS "Categoria Monto",

CASE
codpago
WHEN  1 THEN 'EFECTIVO'
WHEN  2 THEN 'TAREJETA DEBITO'
WHEN  3 THEN 'TAREJETA CREDITO'
ELSE 'CHEQUE'
END AS "Forma de Pago"

FROM factura
WHERE EXTRACT (YEAR FROM fecha) = (EXTRACT (YEAR FROM SYSDATE) -1)
ORDER BY fecha DESC;


// CASO N°2

SELECT * FROM cliente;

SELECT
LPAD(rutcliente,12,'*') AS "RUT",
nombre AS "Cliente",
NVL(TO_CHAR(telefono), 'Sin telefono') AS "Telefono",
NVL(TO_CHAR(codcomuna), 'Sin comuna') AS "Comuna",
estado AS "Estado",

CASE 
WHEN (saldo / credito) < 0.5 THEN 'Bueno (' || TO_CHAR(credito - saldo, '$99G999G999') || ')'
WHEN (saldo / credito) BETWEEN 0.5 AND 0.8 THEN 'Regular (' || TO_CHAR(saldo, '$99G999G999') || ')'
ELSE 'Crítico'
END AS "Estado Crédito",
    
CASE 
WHEN mail IS NULL THEN 'Correo no registrado'
ELSE UPPER(SUBSTR(mail, INSTR(mail, '@') + 1))
END AS "Dominio Correo"

FROM cliente
WHERE estado = 'A' AND credito > 0
ORDER BY nombre ASC;



//CASO N°3

SELECT * FROM producto;

SELECT 
codproducto AS "ID",
descripcion AS "Descripcion de Producto",
totalstock AS "Stock",

CASE 
WHEN valorcompradolar IS NULL THEN 'Sin registro'
ELSE REPLACE(TO_CHAR(valorcompradolar), '.', ',') || ' USD'
END AS "Compra en USD",

CASE 
WHEN valorcomprapeso IS NULL THEN 'Sin registro'
ELSE TO_CHAR(valorcomprapeso, '$999G999') || ' PESOS'
END AS "USD convertido",


CASE
WHEN totalstock IS NULL THEN 'Sin datos'
WHEN totalstock <40 THEN 'ALERTA stock muy bajo'
WHEN totalstock BETWEEN 40 AND 60 THEN 'Reabastecer pronto'
ELSE 'OK'
END AS "Alerta Stock",

CASE
WHEN totalstock > 80 AND valorcomprapeso IS NOT NULL 
THEN TO_CHAR(ROUND(valorcomprapeso * 0.9), '$999G999')
ELSE 'N/A'
END AS "Precio Oferta"


FROM producto
WHERE UPPER(descripcion) LIKE '%ZAPATO%' AND TRIM(UPPER(procedencia)) = 'I'
ORDER BY codproducto DESC;



