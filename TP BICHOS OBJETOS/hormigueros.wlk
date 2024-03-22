class Hormiguero{
	var hormigasHabitantes = #{}
	var property deposito
    const property posicionHormiguero = new Punto() 
	
	method cantidadDeHormigas(){
		return hormigasHabitantes.size()
	}
	
	method cantidadDeAlimentoRecolectado(){
		return hormigasHabitantes.sum({unaHormiga => unaHormiga.cantidadDeAlimentoQueLleva()})
	}
	
	method cantidadDeHormigasAlLimiteDeCapacidad(){
		return hormigasHabitantes.filter({unaHormiga => unaHormiga.estaAlLimite()}).size()
	}
	
	method reclamarAlimento(){
		hormigasHabitantes.forEach({unaHormiga => unaHormiga.descargarAlimento()})
	}
	
    method sumarAlimentoAlDeposito(unaCantidad){
        deposito = unaCantidad + deposito
    }

	method cantidadDeAlimentoTotal(){
		return self.cantidadDeAlimentoRecolectado() + deposito
	}

    method distanciaRecorridaPorTodasLasHormigas(){
        return hormigasHabitantes.sum({unaHormiga => unaHormiga.distanciaTotalRecorrida()})
    }

    method esIntruso(unIntruso){
        return self.estaAMenosDe(2, unIntruso) && !self.perteneceAlHormiguero(unIntruso)
    }

    method perteneceAlHormiguero(unBicho){
        return hormigasHabitantes.contains(unBicho)
    }

    method estaAMenosDe(unaDistancia, unBicho){
        return distancia.calcularDistancia(posicionHormiguero, unBicho.posicion()) < unaDistancia
    }

    method detectarIntruso(unIntruso){
        if(self.esIntruso(unIntruso)){
            self.defenderseDe(unIntruso)
        }
    }

    method defenderseDe(unIntruso){
        self.ordenarQueAtaquenA(hormigasHabitantes, unIntruso)
    }

    method ordenarQueAtaquenA(unasHormigas, unIntruso){
        unasHormigas.forEach({unaHormiga => unaHormiga.atacar(unIntruso)})
    }

    method asignarHormigasAExpedicion(unaExpedicion, unaCantidad){
        const hormigasAExpedicion = self.mandarHormigasAExpedicion(unaCantidad)
        hormigasAExpedicion.forEach({unaHormiga => self.eliminarHormiga(unaHormiga)})
        unaExpedicion.hormigasAsignadas(hormigasAExpedicion)
    }

    method mandarHormigasAExpedicion(unaCantidad){
        return self.hormigasAptasParaExpedicion().drop(unaCantidad)
    }

    method hormigasAptasParaExpedicion(){
        return hormigasHabitantes.filter({unaHormiga => unaHormiga.puedeIrAExpedicion()})
        // usamos esto ya que no tendria sentido mandar a la reina, un soldado o un zangano a la expedicion
    }

    method eliminarHormiga(unaHormiga){
        hormigasHabitantes.remove(unaHormiga)
    }

    method devolverHormigas(unasHormigas){
        hormigasHabitantes + unasHormigas
    }
}

class HormigueroQueSeDefiendeConHormigasCerca inherits Hormiguero{
    override method defenderseDe(unIntruso){
        self.ordenarQueAtaquenA(self.hormigasCercaDelHormiguero(), unIntruso)
    }

    method hormigasCercaDelHormiguero(){
        return hormigasHabitantes.filter({unaHormiga => distancia.calcularDistancia(posicionHormiguero, unaHormiga.posicionHormiga()) < 5})
    }
}

class HormigueroQueSeDefiendeConCualquierHormiga inherits Hormiguero{
    override method defenderseDe(unIntruso){
        const hormigasRandom = hormigasHabitantes.asList().take(10) // no se nos ocurre cómo sacar 10 hormigas random
        self.ordenarQueAtaquenA(hormigasRandom, unIntruso)
    }
}

class HormigueroQueSeDefiendeConHormigasViolentas inherits Hormiguero{
    override method defenderseDe(unIntruso){
        self.ordenarQueAtaquenA(self.hormigasViolentas(), unIntruso)
    }

    override method hormigasViolentas(){
        return hormigasHabitantes.filter({unaHormiga => unaHormiga.esViolenta()})
    }
}
