class NewsArticle {
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String url;
  final DateTime publishedDate;
  final String author;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.url,
    required this.publishedDate,
    required this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title']['rendered'] ?? 'Sin título',
      summary: _extractSummary(json),
      content: json['content']['rendered'] ?? '',
      imageUrl: _extractImageUrl(json),
      url: json['link'] ?? '',
      publishedDate: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      author: json['_embedded']?['author']?[0]?['name'] ?? 'Autor desconocido',
    );
  }

  static String _extractSummary(Map<String, dynamic> json) {
    // Intentar obtener el excerpt primero, si no existe, crear un resumen del contenido
    if (json['excerpt']?['rendered'] != null) {
      final excerpt = json['excerpt']['rendered'];
      // Limpiar HTML tags
      return _stripHtmlTags(excerpt).trim();
    }
    
    // Si no hay excerpt, crear resumen del contenido
    final content = json['content']?['rendered'] ?? '';
    final cleanContent = _stripHtmlTags(content);
    return cleanContent.length > 150 
        ? '${cleanContent.substring(0, 150)}...' 
        : cleanContent;
  }

  static String _extractImageUrl(Map<String, dynamic> json) {
    // Intentar obtener la imagen destacada
    if (json['_embedded']?['wp:featuredmedia'] != null) {
      return json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';
    }
    
    // Si no hay imagen destacada, buscar la primera imagen en el contenido
    final content = json['content']?['rendered'] ?? '';
    final RegExp exp = RegExp(r'<img[^>]+src="([^">]+)"');
    final Match? match = exp.firstMatch(content);
    
    return match?.group(1) ?? 'assets/images/news_placeholder.png';
  }

  static String _stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  String getFormattedDate() {
    return '${publishedDate.day}/${publishedDate.month}/${publishedDate.year}';
  }
}