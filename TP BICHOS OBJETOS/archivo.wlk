/* TRABAJO PRÁCTICO 2022 - OBJETOS "BichOS" */

/* HORMIGAS Y HORMIGUEROS */

/* USADO PARA CALCULAR DISTANCIAS */
object distancia{

    method calcularDistancia(unPunto, otroPunto){
        return ((unPunto.posicionX() - otroPunto.posicionX())**2 + (unPunto.posicionY() - otroPunto.posicionY())**2).squareRoot()
    }

 }

class Punto{
    const property posicionX
    const property posicionY
}

class Recorrido{
	var property origen
    var property destino

    method distanciaRecorrida(){
        return distancia.calcularDistancia(origen, destino) 
    }
}

class Alimento{
    var property masaDisponible
    const property posicionAlimento

    method perderMasa(unaCantidad){ 
        masa -= (unaCantidad + 1)
    }
    
    method masaDisponible(){
        return (masaDisponible - 1).max(0)
    }
     
    method cuantoPuedePerder(unaCantidad){
        return unaCantidad - (unaCantidad - masa - 1).abs()
    }
}


/* ESTADOS */
class Estado{
    method descansar(unaHormiga)

    method despuesDeMoverse(unaHormiga, ultimosMetrosRecorridos)

    method capacidadMaxima(){
        return 10
    }
}


object cansancio inherits Estado{
    
    method descansar(unaHormiga){
        unaHormiga.cambiarA(normal)
    }
    
    method despuesDeMoverse(unaHormiga, ultimosMetrosRecorridos){
        /**/
    }
}

object normal inherits Estado{
    method descansar(unaHormiga){
        unaHormiga.cambiarA(exaltado)
    }

    method despuesDeMoverse(unaHormiga , ultimosMetrosRecorridos){ 
        if(unaHormiga.estaCansada()){ 
            unaHormiga.cambiarA(cansada) 
        }  
    }
}

object exaltado inherits Estado{
    method descansar(unaHormiga){
        // no hace nada
    }
    method despuesDeMoverse(unaHormiga, ultimosMetrosRecorridos){
        if(ultimosMetrosRecorridos > 5){
            unaHormiga.cambiarA(normal) 
        }  
    }  

    override method capacidadMaxima(){
        return 20
    }
}


