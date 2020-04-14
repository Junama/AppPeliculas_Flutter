//Se va a trabajar con todos objetos relacionados con las peliculas

class PeliculasContenedor{
  
  List <Peliculas> items = new List();

  PeliculasContenedor();

  //Contructor que permite recibir el Mapa de todas las peliculas y respuestas
  PeliculasContenedor.fromJsonList( List<dynamic> jsonList ){

    if ( jsonList == null ) return;

    //For para recorrer la lista de item de la pelicula
    //Sirve para tener todas las peliculas mapeadas
    for ( var item in jsonList ){
      //Enviamos y recorremos todos los item para guardarnos en nuestro contructor JsonMap
      final pelicula = new Peliculas.fromJsonMap(item);
      //Esa instancia de pelicula, la vamos a almacenar en
      items.add(pelicula);
    }
  }
}
//Buscamos por CTR+MAYUS+P y colocamos >Paste Json as Code y luego enter
//Luego volvemos a ir al atajo, y colocamos Respuesta y te arroja el codigo, lo que te retorne la pagina de peliculas
//Recibimos una lista de todas las peliculas
class Peliculas {

  String uniqueId;

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Peliculas({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  //Es una funcion que voy a llamar, cuando quiero generar una instancia de pelicula que viene de un Mapa que viene un formato Json
  Peliculas.fromJsonMap ( Map<String,dynamic> json ){ //El mapa recibe un String que es el nombre de la pelicula, y un dynamic porque recibe todo tipo de archivos como int, double
  
    popularity       = json ["popularity"] / 1; //Se divide un 1 pq devuelve un double. Si da 5.0 daria error
    voteCount        = json ["vote_count"]; 
    video            = json ["video"];
    posterPath       = json ["poster_path"];
    id               = json ["id"];
    adult            = json ["adult"];
    backdropPath     = json ["backdrop_path"];
    originalLanguage = json ["original_language"];
    originalTitle    = json ["original_title"];
    genreIds         = json ["genre_ids"].cast<int>(); //Se castea a un entero int()
    title            = json ["title"];
    voteAverage      = json ["vote_average"] / 1; //Se divide un 1 pq devuelve un double. Si da 5.0 daria error
    overview         = json ["overview"];
    releaseDate      = json ["release_date"];

  }

  getPosterImg(){

    if ( posterPath == null){
      return "https://i1.wp.com/www.musicapopular.cult.cu/wp-content/uploads/2017/12/imagen-no-disponible.png?fit=600%2C450";
    }else{
    return "https://image.tmdb.org/t/p/w500/$posterPath";
    }
  }
  
  getBackgroundImg(){

    if ( posterPath == null){
      return "https://i1.wp.com/www.musicapopular.cult.cu/wp-content/uploads/2017/12/imagen-no-disponible.png?fit=600%2C450";
    }else{
    return "https://image.tmdb.org/t/p/w500/$backdropPath";
    }
  }
}
