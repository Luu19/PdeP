/* PARCIAL 2019: PDEPFONI */
/*
Una linea:
    ->tiene un numero de telefono 
    ->una linea puede tener varios packs activos
        *Estos packs sirven para que la linea pueda realizar consumos
    ->Hay dos tipos de consumo:
        1:consumo de internet (cada consumo es por una cantidad de MB)
        2:consumo de llamadas (cada consumo es por una cantidad de segundos)
    ->para poder realizar esos consumos se pueden agregar packs a la linea, algunos son:
        *Cierta cantidad de credito disponible
        *una cantidad de MB libres para navegar por internet
        *llamadas gratis
        *internet ilimitado los findes
    ->algunos packs pueden tener fecha de vencimiento, los packs vencidos no podran utilizarse

La empresa dispone de precios por MB y por segundo de llamada
Se cobra un precio fijo por los primeros 30s de llamada y luego se cobra por segundo pasado los 30s
*/

class Linea{

    method costoConsumoRealizado(){
        return consumos.sum({ unConsumo => unConsumo.precio() })
    }
}

/* CONSUMOS */
class ConsumoLlamada{
    const property cantidadSegundos

    method costo(){
        return (pdepFoni.precioFijo() + )
    }

}

object pdepFoni{
    var property preciosPorMB = 0.10
    var property precioPorSegLlamada = 0.05
    var property precioFijo = 1
}