class Expedicion{
    var inicioExpedicion 
    var objetoDelTerreno
    var property hormigasAsignadas
    const property estado = true // true == activa

    method hormigasNecesarias(){
        return (objetoDelTerreno.masaDisponible() / 10).roundUp(0)
    }

    method asignarHormigas(){
        inicioExpedicion.asignarHormigasAExpedicion(self, self.hormigasNecesarias())
        self.liberarCargaDeHormigas()
    }

    method liberarCargaDeHormigas(){
        hormigasAsignadas.forEach({unaHormiga => unaHormiga.descargarAlimento()})
    }

    method concretarMision(){
        self.validarExpedicion()
        hormigasAsignadas.forEach({unaHormiga => unaHormiga.recolectarComida(objetoDelTerreno)})
        hormigasAsignadas.forEach({unaHormiga => unaHormiga.descargarAlimento()})
    }

    method desarmarExpedicion(){
        self.validarExpedicion()
        inicioExpedicion.devolverHormigas(hormigasAsignadas)
        self.expedicionTerminada()
    }

    method expedicionTerminada(){
        estado = false
    }

    method validarExpedicion(){
        if(!self.expedicionActiva()){ // si esta terminada, lanza la excepcion
            throw new Exception(message = "La Expedicion no está activa")
        }
    }

    method expedicionActiva(){
        return estado
    }
}