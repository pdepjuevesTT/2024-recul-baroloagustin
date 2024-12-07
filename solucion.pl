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
%punto 4 tasacion que props se puede comprar con una cantidad dada de plata y cuanto nos quedaria
%cotiza(Persona,Precio)
cotiza(juan,150000).
cotiza(nico,80000).
cotiza(alf,75000).
cotiza(julian,14000).
cotiza(vale,95000).
cotiza(fer,60000).

comprarProps(Plata, ListaProps):-
    findall((Persona, Precio, Cambio),(cotiza(Persona, Precio),Plata >= Precio,Cambio is Plata - Precio),ListaProps).
