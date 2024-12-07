%casa(persona, metrosCuadrados)
casa(juan, 120).
casa(fer, 110).
%ambientes(persona,ambientes,banos)
ambientes(nico,3,2).
ambientes(alf,3,1).
ambientes(vale,4,1).
%viveEn(persona,barrio)
viveEn(juan,almargo).
viveEn(alf,almargo).
viveEn(nico,almargo).
viveEn(julian,almargo).
viveEn(vale,flores).
viveEn(fer,flores).
%desea(persona, metrosCuadrados)
desea(rocio,90).
%enLoft(Persona,AnoEnELQueSeConstruyo)
enLoft(julian,2000).

barrioCopado(Barrio):- 
    viveEn(Persona,Barrio),
    forall(viveEn(Persona,Barrio),propiedadCopada(Persona)).

propiedadCopada(Persona):- casaCopada(Persona).
propiedadCopada(Persona):- loftCopado(Persona).
propiedadCopada(Persona):- departamentoCopado(Persona).

loftCopado(Persona):-
    enLoft(Persona,Ano),
    Ano > 2015.
casaCopada(Persona):-
    casa(Persona,Metros),
    Metros > 100.

departamentoCopado(Persona):-
    ambientes(Persona,Ambientes,_),
    Ambientes > 3.
departamentoCopado(Persona):-
    ambientes(Persona,_,Banos),
    Banos > 1.
%Barrio caro. Tal vez. Barrio donde no hay casa barata
barrioCaro(Barrio):-
    viveEn(Persona,Barrio),
    forall(viveEn(Persona,Barrio),not(propBarata(Persona))).

propBarata(Persona):-
    enLoft(Persona,Ano),
    Ano < 2005.
propBarata(Persona):-
    ambientes(Persona,Ambientes,_),
    between(1, 2, Ambientes).
propBarata(Persona):-
    casa(Persona,Metros),
    Metros < 90.
%punto 4 saber que casas podriamos comprar con una determinada cantidad de plata y cuanta plata nos quedaria. Queresmo comprar al menos una propiedad 
%cotiza(Persona,Precio)
cotiza(juan,150000).
cotiza(nico,80000).
cotiza(alf,75000).
cotiza(julian,140000).
cotiza(vale,95000).
cotiza(fer,60000).

% comprarProps(Plata, MejorSublista, PlataRestante).
comprarProps(Plata, MejorSublista, PlataRestante):-
    sePuedeComprar(Plata, ListaProps),
    findall(Sublista, sublista(ListaProps, Sublista), TodasSublistas),
    filtrarSublistas(Plata, TodasSublistas, SublistasFiltradas),
    maximizarUso(Plata, SublistasFiltradas, MejorSublista, Suma),
    PlataRestante is Plata - Suma.


%sePuedeComprar(Plata, ListaProps).
sePuedeComprar(Plata, ListaProps):-
    findall((Persona, Precio), (cotiza(Persona, Precio), Plata >= Precio), ListaProps).

sublista([], []).
sublista([_|Cola], Sublista):-
    sublista(Cola, Sublista).
sublista([Cabeza|Cola], [Cabeza|Sublista]):-
    sublista(Cola, Sublista).

% Sumar los precios de una lista de propiedades
sumarPrecios([], 0).
sumarPrecios([(_, Precio)|Cola], Suma):-
    sumarPrecios(Cola, SumaCola),
    Suma is Precio + SumaCola.

% Filtrar las sublistas que se pueden comprar con el dinero disponible
filtrarSublistas(_, [], []).
filtrarSublistas(Plata, [Sublista|Colas], [Sublista|Filtradas]):-
    sumarPrecios(Sublista, Suma),
    Suma =< Plata,
    filtrarSublistas(Plata, Colas, Filtradas).
filtrarSublistas(Plata, [_|Colas], Filtradas):-
    filtrarSublistas(Plata, Colas, Filtradas).

% Encontrar la sublista que maximiza el uso del dinero disponible
maximizarUso(_, [], [], 0).
maximizarUso(Plata, [Sublista|Colas], MejorSublista, MejorSuma):-
    sumarPrecios(Sublista, Suma),
    maximizarUso(Plata, Colas, MejorSublistaColas, MejorSumaColas),
    (Suma > MejorSumaColas -> (MejorSublista = Sublista, MejorSuma = Suma) ; (MejorSublista = MejorSublistaColas, MejorSuma = MejorSumaColas)).



