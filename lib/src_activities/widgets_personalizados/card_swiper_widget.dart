import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src_activities/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Peliculas> peliculas;

  //Se inicializa la lista con el contructor, y el @required es que si o si necesita la lista de peliculas
  CardSwiper( { @required this.peliculas } );

  @override
  Widget build(BuildContext context) {

    //SIRVE para cambiar la dimension de las tarjetas dependiendo el celular que se este usando
    final _screenSize = MediaQuery.of(context).size;
    
    return Container(
      padding: EdgeInsets.only(top: 10.0),//separacion de los costados del celular
       
      child: Swiper(
            layout     : SwiperLayout.STACK, //diseño de las tarjetas
            itemWidth  : _screenSize.width * 0.7,//Significa que tiene el 70% de ancho el item
            itemHeight : _screenSize.height * 0.5,
            itemBuilder: (BuildContext context, int index){//retorna una image de internet por defecto
            
            //Creamos esta variable para crear un id único para que no se repita en el Widget Hero
            //Sino hacemos esto, la app se congela. Cambiamos el id por uniquedId
            peliculas[index].uniqueId = "${ peliculas[index].id }-tarjeta";

            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: ()=> Navigator.pushNamed(context, "detalle", arguments: peliculas[index]),
                  child: FadeInImage(
                        image: NetworkImage( peliculas[index].getPosterImg() ),
                        placeholder : AssetImage("assets/img/no-image.jpg"), 
                        fit: BoxFit.cover
                   ),
                )
                ),
            );
          },
            itemCount : peliculas.length,//cantidad de item
            //pagination: new SwiperPagination(),//Son los 3 puntitos debajos, que dicen cuantas paginas tiene
            //control   : new SwiperControl(),//Son las flechas de izquierda y derecha, que dicen cuantas paginas tiene
      ),
    );
  }
}