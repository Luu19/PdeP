/* PARCIAL 2022: CATAR 2022 */
/*
Sistema donde cocineros preparar y degustan platos

Hay difentes platos:
    ->entradas: no tienen azucar y son bonitas
    ->principales: pueden llevar o no azucar (poca cantidad) y pueden o no ser bonitos
    ->postres: llevan 120g de azucar, son bonitos y tienen 3 colores

Los cocineros saben cocinar y catar (degustar y calificar) un plato
Se dividen en:
    ->pasteleros: tienen un nivel deseado de dulzor  (maximo 10), luego de catar un plato dan una calificacion
    que se calcula como 5 * cantida azucar plato / dulzor deseado
    ->chefs: tienen definida una cantidad de calorias, cuando cata un plato da un 10 de calificacion
    en caso de que sea bonito y tenga hasta una cierta cantidad de calorias, caso contrario lo califica con 0 
    ->souschef: es como el chef pero si no se cumplen sus condiciones, la calificacion que pone es 
    cantidad de calorias / 100 (con un maximo de 6)
*/

/* PLATOS */
class Plato{
    var property cantidadAzucar
    var property esBonito

    method calorias(){
        return 3 * cantidadAzucar + 100
    }

    method esBonito()

    method tieneCalorias(unaCantidad){
        return self.calorias().equals(unaCantidad) 
    }
}

class Postre inherits Plato(cantidadAzucar = 120, esBonito = true){
    var cantidadColores
}

object entrada = new Plato(cantidadAzucar = 0, esBonito = true)

/* ESPECIALIDADES */
class Pasteleros{
    var nivelDeDulzorDeseado

    method cocinar(){
        return new Postre(cantidadColores = nivelDeDulzorDeseado / 50)
    }

    method catar(unPlato){
        return (5 * unPlato.cantidadAzucar() + nivelDeDulzorDeseado).max(10)
    }
}

class Chefs{
    var cantidadDeCaloriasDefinida

    method cocinar(){
        return new PlatoPrincipal(cantidadDeAzucar = cantidadDeCaloriasDefinida, esBonito = true)
    }

    method catar(unPlato){
        if(self.cumpleCondicionesDelChef(unPlato)){
            return 10
        }else{
            self.calificacionPorDefault(unPlato)
        }
    }

    method calificacionPorDefault(unPlato){
        return 0
    }

    method cumpleCondicionesDelChef(unPlato){
        return unPlato.esBonito() && unPlato.tieneCalorias(cantidadDeCaloriasDefinida)
    }
}

class SousChef inherits Chefs{

    override method cocinar(){
        return  entrada
    }

    override method calificacionPorDefault(unPlato){
        return (unPlato.calorias() / 100).max(6)
    }
}

/* COCINEROS */
class Cocinero{
    var especilidad

    method cambiarEspecialidad(unaEspecialidad){
        especilidad = unaEspecialidad
    }

    method cocinar(){
        return especialidad.cocinar()
    }

    method catar(unPlato){
        especialidad.catar(unPlato)
    }

    method participarEnTorneo(){
        return self.cocinar()
    }
}

/* TORNEO */
class Torneo{
    var catadores = #{}
    var participantes = #{}

    method agregarParticipante(unCocinero){
        participantes.add(unCocinero)
    }

    method ganadorDelTorneo(){
        return participantes.max({ unCocinero => self.calificarPlatoPresentado(unCocinero) })
    }

    method calificarPlatoPresentado(unCocinero){
        return catadores.sum({ unCatador => unCatador.catar(unCocinero.presentarPlato()) })
    }
}

/*
Cosas para preguntar a Fede: 
- diagrama de clases
- si lo de calificarPlatoPresentado esta bien
- si lo de calificacionPorDefault tiene forma de hacerse con super()
*/