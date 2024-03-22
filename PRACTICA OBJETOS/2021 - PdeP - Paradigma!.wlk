/* 2021 RECUPERATORIO : PARADIGMA */

//WEB
object paradigma{
    var usuarios = #{}
    
    method recategorizacion(){
        usuarios.forEach({ unUsuario => unUsuario.recategorizate() })
    }
}

//USUARIO
class Usuario{
    var property categoria
    var posts

    method postearContenido(unContenido){
        categoria.agregarPostPara(self, unContenido)
    }

    method agregarComentario(contenidoComentario, unPost){
        unPost.agregarComentario(contenidoComentario)
    }

    method calificarUnPost(unPost, unaCalificacion){
        unPost.recibirCalificacion(unaCalificacion)
    }

    method agregarPost(unPost){
        posts.add(unPost)
    }

    method puntajeUsuario(){
        return posts.sum({ unPost => unPost.calificion() })
    }

    method recategorizate(){
        categoria.promover(self)
    }

    method ascenderA(unaCategoria){
        categoria = unaCategoria
    }

    method tienenMasDePuntos(unosPuntos){
        return self.puntajeUsuario() > unosPuntos
    }

    method tieneUnPostConUnValorMayor(unaCalificacion){
        return posts.any({ unPost => unPost.tieneCalificacionMayorA(unaCalificacion) })
    }

    method cantidadPostInteresantes(){
        return self.postInteresantes().size()
    }

    method postInteresantes(){
        return posts.filter({ unPost => unPost.esIntesante() })
    }
}


// CATEGORIA USUARIO
class Categoria{
    method agregarPostPara(unUsuario, contenidoPost){
        const unPost = new PostComun(contenido = contenidoPost)
        unUsuario.agregarPost(unPost)
    }

    method promover(unUsuario)
}

object novato inherits Categoria{
    override method promover(unUsuario){
        if(unUsuario.tienenMasDePuntos(100)){
            unUsuario.ascenderA(intermedio)
        }
    }
}

object intermedio inherits Categoria{
    override method promover(unUsuario){
        if(unUsuario.tienenMasDePuntos(100) && unUsuario.tieneUnPostConUnValorMayor(500)){
            unUsuario.ascenderA(experto)
        }
    }
}


object experto inherits Categoria{
    override method agregarPostPara(unUsuario, contenidoPost){
        const unPost = new PostPremium(contenido = contenidoPost)
        unUsuario.agregarPost(unPost)
    }

    override promover(unUsuario){

    }
}

// POST
class Post{
    var contenido
    var comentarios
    var estado 
    var property calificion

    method agregarComentario(unComentario){
        self.validarEstado()
        comentarios.add(unComentario)
    }

    method validarEstado(){
        if(estado.estaCerrado()){
            throw new Exception(message = "No podes agregar comentario")
        }
    }

    method recibirCalificacion(unaCalificacion){
        calificion += unaCalificacion
    }

    method tieneCalificacionMayorA(unaCalificacion){
        return calificion > unaCalificacion
    }

    method cantidadComentariosExtensos(){
        return self.comentariosExtensos().size()
    }

    method comentariosExtensos(){
        return comentarios.filter({ unComentario => self.esExtenso(unComentario) })
    }

    method esExtenso(unComentario){
        return unComentario.words().size() > 240
    }

    method esIntesante()
}

class PostComun inherits Post{
    override method esIntesante(){
        return self.cantidadComentariosExtensos() > 20 && calificion <= 300 
    }
}

class PostPremium inherits Post{
    override method esIntesante(){
        return comentarios.all({ unComentario => self.esExtenso(unComentario) }) && calificion > 300
    }
}

// ESTADOS DE POST
object cerrado{
    method estaCerrado(){
        return true
    }
}

object publico{
    method estadoCerrado(){
        return false
    }
}

