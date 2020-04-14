import 'package:flutter/material.dart';
import 'package:peliculas/src_activities/models/pelicula_model.dart';
import 'package:peliculas/src_activities/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate{

  String seleccion = "";
  final peliculasProvider = new PeliculasProvider();

  final peliculas = ["Batman", "FFVII Advent Children", "Ironman", "The Lord of the Ring"];
  final peliculasRecientes = ["Batman", "Ironman"];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Son las acciones de nuestro AppBar, como el boton de x o el boton cancelar en una busqueda
    return [
      IconButton(
        icon: Icon( Icons.clear), 
        onPressed: (){
          query = "";//Borra lo que se escribe en la busqueda
        },
        )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar, como la flecha que regresa > o cualquier icono que va a la izquierda
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
        ), 
      onPressed: (){
        close( context, null);
      },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Intruccion que crea los resultados que vamos a mostrar
    return Center(
      child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.blueAccent,
      child: Text(seleccion),
     ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    //Sirve para retornar todas las peliculas que escriba en el search
   if ( query.isEmpty ){
     return Container();
   }

  return FutureBuilder(
    future: peliculasProvider.buscarPeliculas( query ),
    builder: (BuildContext context, AsyncSnapshot<List<Peliculas>> snapshot) {
      
      if ( snapshot.hasData ){
        
        final peliculas = snapshot.data;

        return ListView(
          children: peliculas.map((pelicula){
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage( pelicula.getPosterImg() ),
                placeholder: AssetImage("assets/img/no-image.jpg"),
                width: 50.0,
                fit: BoxFit.contain),

                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                    close( context, null );
                    pelicula.uniqueId = "";
                    Navigator.pushNamed(context, "detalle", arguments: pelicula);
                  },
                );
          }).toList(),
        );

      }else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
   );
  }

}