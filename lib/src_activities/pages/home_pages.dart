import 'package:flutter/material.dart';
import 'package:peliculas/src_activities/providers/peliculas_providers.dart';
import 'package:peliculas/src_activities/search/search_delegate.dart';

import 'package:peliculas/src_activities/widgets_personalizados/card_swiper_widget.dart';
import 'package:peliculas/src_activities/widgets_personalizados/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle    : false,
        title          : Text("Películas en cine"),
        backgroundColor: Colors.indigoAccent,
        actions        : <Widget>[
          IconButton(
            icon: Icon( Icons.search ), 
            onPressed: (){
              showSearch(//Es el buscador de la app
                context: context, 
                delegate: DataSearch(),
              );
            }
            )
       ]
      ),
      /*SafeArea()Sirve para los celulares que tienen camara adelante
      body: SafeArea(
        child: Text("Hola Mundo!!!!!!!!!!!"))//Safe Area*/
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,//Centra las peliculas
          children: <Widget>[
            _swiperTarjetas(),
            _footerTarjetas(context)
          ],)
      )      
    );
  }
  //SWIPER: Son tarjetas con el diseño tipo cartas, que se van sacando una a una, pero se ven las demas detras
  Widget _swiperTarjetas(){
    
    return FutureBuilder(
        future : peliculasProvider.getEnCines(),//Regresa el Future, y tengo que utilizar el Future Builder, para enviar las peliculas a las tarjetas
       //initialData: InitialData, Lo sacamos pq no queremos mostrar una data inicial
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          
          if ( snapshot.hasData){
            return CardSwiper( peliculas: snapshot.data );

            }else{
              return Container(
                height: 350.0,
                child: Center(
                  child: CircularProgressIndicator()
                )
              );
            }
      },
    );
  }

  Widget _footerTarjetas(BuildContext context){

    return Container(
      width: double.infinity, //Abarca todo el espacio
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Populares", style: Theme.of(context).textTheme.subhead)
            ),
          SizedBox(height: 20.0),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if ( snapshot.hasData){
                 return MovieHorizontal( peliculas: snapshot.data, siguientePagina: peliculasProvider.getPopulares);
              }else{
                 return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}