/* 2020 RECUPERATORIO: CONTENIDOS PARA CELULARES */
/*
Sistema que maneje tanto la información de sus clientes registrados como los productos que ofrece
Descargas de contenidos pagos para celulares:
    ->ringtones
    ->juegos
    ->chistes

Por cada descarga, la empresa cobra un monto al usuario, ese monto se calcula sumando:
    ->monto derecho de autor
    ->cobro de telecomunicaciones del usuario
        *nacionales, cobran un 5% del monto por derecho de autor
        *extranjeras, cobran lo que cobra una nacional + un impuesto por la prestacion
    ->lo que gana la empresa por la comercializacion  (25% del monto por derecho de autor)

El monto por derecho de autor se calcula como:
    ->ringtone: depende lo que dure la misma y el precio por minuto del autor
    ->chiste: el precio se calcula a partir de un monto fijo multiplicado por la cantidad de caracteres
    ->juego: vienen con un monto que varia de acuerdo a cada juego

Un Usuario puede ser:
    ->prepago: se cobra un 10% por cada descarga + el precio anterior
        *si no le alcanza el saldo para pagar la descarga, el producto no se descarga
    ->facturado: no se cobra recargo
        *descargan sin problemas, pero debe acumularse cuanto fue gastando para luego cobrarle a fin de mes
Un usuario puede ir cambiando prepago o facturado, no pueden haber dos cambios en un mismo mes
*/
