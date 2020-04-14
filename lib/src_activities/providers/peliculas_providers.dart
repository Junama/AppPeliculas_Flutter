import 'dart:async';
import 'dart:convert';

import "package:http/http.dart" as http;//El as se usa para colocarle un nombre al paquete
import 'package:peliculas/src_activities/models/actores_model.dart';

import 'package:peliculas/src_activities/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey     = "81527821221a96aefe3e89e4fedbd66b";
  String _url        = "api.themoviedb.org";
  String _language   = "es-ES";
  //Sirve para ver todas las peliculas populares, y no solamente la pagina 1
  int _popularesPage = 0;
  //Cuando se instancia PeliculasProvider, voy a decir que es igual a false
  bool _cargando     = false;

  List<Peliculas> _populares = new List();

  //Creando STREAM. La tuberia donde pasa la informacion
  final _popularesControllerStream = StreamController<List<Peliculas>>.broadcast();
  //El Stream recibe una lista de peliculas, y el broadcast, es para que varios pueden escuchar el Stream

  //Ahora definimos dos Getters, uno para insertar la informacion, y otro para que la emita
  //El SINK es para agregar informacion
  Function(List<Peliculas>) get popularesSink => _popularesControllerStream.sink.add;//Va sin los parentesis, y la funcion es agregar peliculas

  //El Stream es para que emita la informacion
  Stream<List<Peliculas>> get popularesStream => _popularesControllerStream.stream;

  //Se tiene que cerrar siempre el Stream, por mas que sea una pagina
  void disposeStream(){
    _popularesControllerStream?.close();
    //El signo de pregunta(?) se usa para pregunta si tiene algun valor o no, es decir que si tiene valor se cierra, sino tiene no
  }

  Future <List<Peliculas>> _procesarPeliculas(Uri url) async{

      //Petición HTTP. Hay que instalarlo en las depencias. Colocar en google Flutter HTTP para que te de las dependencias
      //import "package:http/http.dart"
      final resp = await http.get( url );//El AWAIT se coloca porque solo queremos la direccion URL, la que pasa por parametro

      //Creamos esta variable pq solo nos interesa la data. 
      //Importamos dart.convert
      final decodedData = json.decode(resp.body);//El body es donde estan todos los datos, y los transforma el decode en un Mapa

      //Usamos esta variable para transformor todo el listado grande de item en peliculas
      //El contructor fromJsonList, se encarga de barrer toda la lista que guardamos en decodedData, y va a almacenar solo los resultados
      final peliculas = new PeliculasContenedor.fromJsonList( decodedData["results"]);

      return peliculas.items;
  }

  //Sirve para llamar a un end point 3/movie/now_playing
  Future <List<Peliculas>> getEnCines() async{
      
      //Es igual a que hiciéramos String url = "pagina web con toda su ruta"
      final url = Uri.https(_url, "3/movie/now_playing", {

          "api_key"  : _apikey,
          "language" : _language
      });
      return await _procesarPeliculas(url);
  }

  
  //Sirve para llamar a un end point 3/movie/popular
  Future <List<Peliculas>> getPopulares() async{
      //Si estoy cargando datos, regresa un listado vacio, y regresamos un true en _cargando
      if ( _cargando ) return [];
      _cargando = true;

      _popularesPage++;

      final url = Uri.https(_url, "3/movie/popular", {

          "api_key"  : _apikey,
          "language" : _language,
          "page"     : _popularesPage.toString(),
      });
      //Hace una lista de peliculas
      final resp = await _procesarPeliculas(url);
      //Stream. Enviamos todas las listas de peliculas a _populares, que es nuestro Stream
      _populares.addAll(resp);
      //Sink. Necesita la lista de peliculas para que emita las listas
      popularesSink( _populares );
      //Ahora que se carga la respuesta, lo volvemos a colocar como false
      _cargando = false;
      return resp;
  }

  Future <List<Actor>> getCast( String peliId) async{

     final url = Uri.https(_url, "3/movie/$peliId/credits",{
        "api_key"  : _apikey,
        "language" : _language,
     });

     final resp = await http.get(url);
     final decoredData = json.decode(resp.body);//Trasnforma ese body con la toda la informacion en un mapa

     final cast = new Cast.fromJsonList(decoredData["cast"]);

     return cast.actores;
  }

  Future<List<Peliculas>> buscarPeliculas( String query ) async{
      
      //Es igual a que hiciéramos String url = "pagina web con toda su ruta"
      final url = Uri.https(_url, "3/search/movie", {

          "api_key"  : _apikey,
          "language" : _language,
          "query"    : query
      });

      return await _procesarPeliculas(url);
  }
}