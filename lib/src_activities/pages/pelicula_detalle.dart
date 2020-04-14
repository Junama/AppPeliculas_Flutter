import 'package:flutter/material.dart';
import 'package:peliculas/src_activities/models/actores_model.dart';
import 'package:peliculas/src_activities/models/pelicula_model.dart';
import 'package:peliculas/src_activities/providers/peliculas_providers.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Peliculas peliculas = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body:CustomScrollView(
          slivers: <Widget>[//Son iguales a los child
            _crearAppBar( peliculas ),
            SliverList(//Es igual al ListView
              delegate: SliverChildListDelegate(//Son iguales a los children
                [
                  SizedBox( height: 10.0),
                  _posterTitulo( context, peliculas ),
                  _descripcion( peliculas ),
                  _crearCasting( peliculas ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _crearAppBar( Peliculas peliculas){

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,//Se mantiene visible mienstras hacemos el scroll
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          peliculas.title,
          style: TextStyle( color:Colors.white, fontSize: 16.0 ),
        ),
        background: FadeInImage( 
          image: NetworkImage(peliculas.getBackgroundImg()),
          placeholder: AssetImage("assets/img/loading.gif"),
          fadeInDuration: Duration(milliseconds: 250),
          fit: BoxFit.cover,
          ),
      ),//Recibe un widget, y se adpata en la caja del AppBar
    );
  }
  
  Widget _posterTitulo ( BuildContext context, Peliculas peliculas ){

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: peliculas.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                   image : NetworkImage( peliculas.getPosterImg()),
                   height: 150.0,
                  ),
              ),
            ),

            SizedBox(width: 20.0),
            Flexible(
              child: Column(//Para el titulo y subtitulo
                crossAxisAlignment: CrossAxisAlignment.start,//Sirve para que el titulo tenga la misma tabulacion que el subtitulo
                children: <Widget>[
                  Text(peliculas.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis), 
                  //overflow: sirve por si el titulo es muy largo
                  Text(peliculas.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star_border),
                      Text( peliculas.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                    ],
                  )
                ],
              ),
            )//Sirve para abarcar el resto del espacio de la pantalla y queda al lado del poster
          ],

        )
      );
  }

  Widget _descripcion ( Peliculas peliculas ){

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 10.0, vertical: 10.0 ),
      child: Text( 
        peliculas.overview,
        textAlign: TextAlign.justify,
      ), 
    );
  }

  Widget _crearCasting( Peliculas peliculas ){

    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
        future : peliProvider.getCast(peliculas.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if ( snapshot.hasData ){
          return _crearActoresPagesView( snapshot.data );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPagesView( List<Actor> actores ){

      return SizedBox(
        height: 200.0,
        child: PageView.builder(
          pageSnapping: false,
          controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
          ),
          itemCount: actores.length,
          itemBuilder: ( context, i ) => _actorTarjeta( actores[i] ),
        ),
      );
  }

  Widget _actorTarjeta( Actor actor){

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              height: 150.0,
              fit: BoxFit.cover,
              image: NetworkImage( actor.getFoto() )
            ),
          ),
          Text( 
            actor.name,
            overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}