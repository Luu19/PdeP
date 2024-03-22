class Hormiga{
    var property cantidadDeAlimentoQueLleva
    var property posicionHormiga
    var property recorridos = #{}
    const danioQueCausan
    const hormigueroAlQuePertenece
    var estaViva

    method moverseA(unaPosicion){
        recorridos.add(new Recorrido(origen = posicionHormiga, destino = unaPosicion))
		self.posicionHormiga(unaPosicion)
	}

    method estaAlLimite(){
        return cantidadDeAlimentoQueLleva.between(9, 10)
    }
	
	method descargarAlimento(){ 
        hormigueroAlQuePertenece.sumarAlimentoAlDeposito(cantidadDeAlimentoQueLleva)
        self.moverseA(hormigueroAlQuePertenece.posicionHormiguero())
		self.vaciarAlimentadoRecolectado()
	}
    
    method vaciarAlimentadoRecolectado(){ 
        cantidadDeAlimentoQueLleva = 0
    }

    method distanciaDesplazada(unaPosicion){
		return distancia.calcularDistancia(unaPosicion, posicionHormiga)
	}

    method distanciaTotalRecorrida(){
        return recorridos.sum({unRecorrido => unRecorrido.distanciaRecorrida()})
    }

    method distanciaPromedioRecorrida(){
        return self.distanciaTotalRecorrida() / recorridos.size()
    }

    method puntosPorLosQuePaso(){
        return recorridos.map({unRecorrido => unRecorrido.destino()}) 
    }
    
    method recolectarComida(unAlimento)

    method atacar(unIntruso){
        unIntruso.recibirDanio(danioQueCausan)
    }

    method recibirDanio(cantidadDeDanio){
        hormigueroAlQuePertenece.eliminarHormiga(self)
    }

    method esViolenta(){
        return false
    }

    method puedeIrAExpedicion(){
        return false
    }
}


class HormigaObrera inherits Hormiga(danioQueCausan = 2){
	var humor = normal
    var ultimosMetrosRecorridos = 0

	override method moverseA(unaPosicion){
        self.validarHumor()
        super(unaPosicion)
        ultimosMetrosRecorridos = ultimosMetrosRecorridos + self.distanciaDesplazada(unaPosicion)
        humor.humorDespuesDeMoverse(self , ultimosMetrosRecorridos)
	}
	
    method validarHumor(){
        if(self.estaCansada()){
            throw new Exception(message = "Te estoy ignorando!")
        }
    }

	override method estaAlLimite(){
		return cantidadDeAlimentoQueLleva.between(9, humor.capacidadMaxima())
	}
	
	override method descargarAlimento(unHormiguero){
        self.validarHumor()
        super(unHormiguero)
	}
    
    override method recolectarComida(unAlimento){
        self.validarHumor()
        self.moverseA(unAlimento.posicionAlimento())
        self.extraerComida(unAlimento, unAlimento.masaDisponible())
    }

    method puedeExtraer(unaCantidad){
        return unaCantidad < self.cuantoPuedeCargar()
    }

    method extraerComida(unAlimento, unaCantidad){
        if(!self.puedeExtraer(unaCantidad)) {
            self.cargarComida(self.cuantoPuedeCargar())
            unAlimento.perderMasa(self.cuantoPuedeCargar())
        }else{
            self.cargarComida(unaCantidad)
            unAlimento.perderMasa(unaCantidad)
        }
    }

    method cargarComida(unaCantidad){
        cantidadDeAlimentoQueLleva += unaCantidad
    }

    method cuantoPuedeCargar(){
        return 10 - cantidadDeAlimentoQueLleva
    }

    method estaCansada(){
        return ultimosMetrosRecorridos > 10
    }
    

    method descansar(){
        humor.descansar(self)
    }

    method cambiarA(unHumor){
        humor = unHumor
        ultimosMetrosRecorridos = 0
    }

    override method atacar (unIntruso){
        
    }

    override method puedeIrAExpedicion(){
        return true
    }
}

class HormigaZangana inherits Hormiga(cantidadDeAlimentoQueLleva = 1, danioQueCausan = 0, posicionHormiga = hormigueroAlQuePertenece.posicionHormiguero()){

    override method recolectarComida(unAlimento){
        throw new Exception(message = "Estoy al límite!")
    }

    override method estaAlLimite(){
        return true
    }

    override method moverseA(unaPosicion){

    }

    override method vaciarAlimentadoRecolectado(){ 
        cantidadDeAlimentoQueLleva = 1
    }

}

class HormigaReina inherits Hormiga(cantidadDeAlimentoQueLleva = 0, danioQueCausan = 0, posicionHormiga = hormigueroAlQuePertenece.posicionHormiguero()){
    override method recolectarComida(unAlimento){
        throw new Exception(message = "Soy la Reina, no entrego alimento!")
    }

    override method moverseA(unaPosicion){

    }
}

class HormigaSoldado inherits Hormiga(cantidadDeAlimentoQueLleva = 0, danioQueCausan = 5){ //no se menciona que entrega 0 como cantidad de alimento recolectado
    var unidadesDeVida = 20
    override method recolectarComida(unAlimento){

    }

    method descansar(){
       unidadesDeVida = 20
    }

    override method recibirDanio(unaCantidad){
        unidadesDeVida -= unaCantidad
        if(self.estaMuerta()){
            super(unaCantidad)
        }
    }

    method override esViolenta(){
        return true
    }

    method estaMuerta(){
        return unidadesDeVida <= 0
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------//
object langosta{
    var unidadesDeVida = 50
    var property posicion

    method recibirDanio(unDanio){
        unidadesDeVida -= unDanio
        self.atacar(unaHormiga)
        self.validarVida()
    }

    method atacar(unaHormiga){
        self.validarVida()
        unaHormiga.recibirDanio(10)
    }

    method validarVida(){
        if(self.estaMuerta()){
            throw new Exception(message = "Muerte :P")
        }
    }

    method estaMuerta(){
        return unidadesDeVida <= 0
    }
}
