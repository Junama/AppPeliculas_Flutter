import 'package:flutter/material.dart';
import 'package:peliculas/src_activities/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Peliculas> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  //Hacemos un listener para escuchar todos los cambios en el Page Controller
  //Sirve para mostrar 3 peliculas en el scroll horizontal
  final _pageController = new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {

    //Sirve para determinal el tamaño de la tarjeta
    final _screenSize = MediaQuery.of(context).size;

    //Para tener infinited scroll de las peliculas
    //Quiero obtener la posicion en pixeles de ese _pageController. Se va a disparar cada vez q se mueva el scroll
    _pageController.addListener( (){

      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
          siguientePagina();
      }
    });

      return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(//Sirve para crear las tarjetas cuando son necesarias
          pageSnapping: false, //El movimiento de scroll es mas natural
          controller  : _pageController, //Sirve para mostrar 3 peliculas en el scroll horizontal
          itemCount: peliculas.length,
          itemBuilder :  (context, i){
              return _crearTarjeta(context, peliculas[i]);
          },
      ),
    );
  }

  Widget _crearTarjeta (BuildContext context, Peliculas pelicula){

    pelicula.uniqueId = "${ pelicula.id }-poster";

    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage("assets/img/no-image.jpg"), 
                  image      : NetworkImage(pelicula.getPosterImg()),
                  fit        : BoxFit.cover,
                  height     : 95.0),
               ),
             ),
             SizedBox(height: 5.0),
              Text(
                   pelicula.title,
                   overflow: TextOverflow.ellipsis,
                   style: Theme.of(context).textTheme.caption
                  ),
               ],
            ),
        );

    return GestureDetector(
      child: tarjeta, 
      onTap: (){
        Navigator.pushNamed(context, "detalle",arguments: pelicula);//Sirve para ir de un activity a otro, y los arguments son los argumentos
      },
      
    );//643862
  }//30972610
}