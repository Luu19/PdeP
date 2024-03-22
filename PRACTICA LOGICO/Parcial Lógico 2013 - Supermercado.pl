/* Parcial Logico : Supermercados 2013 */
/* BASE DE CONOCIMIENTO */
%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).

% 1:
descuento(arroz(_), 1.50).
descuento(salchichas(Marca, _), 0.50) :- Marca \= vienisima.
descuento(lacteo(Marca, Tipo), 2) :- descuentoSegun(Marca, Tipo).

descuentoSegun(Marca, queso) :- primeraMarca(Marca).
descuentoSegun(_, leche).

descuento(Producto, 0.5) :- 
    precioUnitario(Producto, Mayor),
    forall((precioUnitario(Otro, OtroPrecio), Otro \= Producto), OtroPrecio < Mayor).

% 2:
% esCompradorCompulsivo(Cliente).
esCompradorCompulsivo(Cliente) :-
    cliente(Cliente),
    forall(compro(Cliente, Producto, _), productoPrimeraMarcaConDesc(Producto)).

cliente(C) :- compro(C, _, _).
productoPrimeraMarcaConDesc(Producto) :- 
    descuento(Producto, _),
    marcaProducto(Producto, Marca),
    primeraMarca(Marca).

marcaProducto(arroz(Marca), Marca).
marcaProducto(lacteo(Marca, _), Marca).
marcaProducto(salchicas(Marca, _), Marca).

% 3:
% totalAPagar(Cliente, Total).
totalAPagar(Cliente, TotalAPagar) :- 
    cliente(Cliente),
    findall(Costo, costoProductoComprado(Cliente, Costo), Costos),
    sumlist(Costos, TotalAPagar).

costoProductoComprado(Cliente, Costo) :- 
    compro(Cliente, Producto, Cantidad),
    precioSegun(Producto, Cantidad, Costo).

costoSegun(Producto, Cantidad, Costo) :- 
    precioUnitario(Producto, Precio),
    Costo is Precio * Cantidad.

costoSegun(Producto, Cantidad, Costo) :-
    precioUnitario(Producto, Precio),
    descuento(Producto, Descuento),
    Costo is Precio - (Precio * Descuento).

% 4:
/* BASE DE CONOCIMIENTO EXTRA */
dueño(laSerenisima, gandara).
dueño(gandara, vacalín).

% clienteFiel(Cliente, Marca).
clienteFiel(Cliente, Marca) :-
    cliente(Cliente),
    marcaProducto(_, Marca),
    forall(compro(Cliente, Producto,_), marcaProducto(Producto, Marca)).

% 5:
% provee(Empresa, ListaDeCosasQueProvee/ EmpresaACargo).
provee(Empresa, EmpresaACargo) :-
    dueño(Empresa, EmpresaACargo).

provee(Empresa, EmpresaACargo) :-
    dueño(Empresa, OtraEmpresa),
    provee(OtraEmpresa, EmpresaACargo).

provee(Empresa, ListaDeCosasQueProvee) :-
    empresa(Empresa),
    forall(member(Producto, ListaDeCosasQueProvee), marcaProducto(Producto, Empresa)).

empresa(E) :-  dueño(E, _).
