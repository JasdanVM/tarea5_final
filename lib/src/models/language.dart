class Idioma {
  static final Map<String, String> idiomas = {
    'es': '&language=es-ES',
    'en': '',
  };
  late final String langCode;

  Idioma(String lang) {
    langCode = idiomas[lang] ?? '';
  }
    
}

