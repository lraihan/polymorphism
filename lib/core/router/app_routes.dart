/// Centralized route names and paths for type-safe navigation
class AppRoutes {
  // Route names
  static const String home = 'home';
  static const String projects = 'projects';
  static const String gallery = 'gallery';
  static const String playground = 'playground';
  static const String caseStudies = 'case-studies';
  static const String timeline = 'timeline';
  static const String contact = 'contact';
  static const String notFound = 'not-found';

  // Route paths
  static const String homePath = '/';
  static const String projectsPath = '/projects';
  static const String galleryPath = '/gallery';
  static const String playgroundPath = '/playground';
  static const String caseStudiesPath = '/case-studies';
  static const String timelinePath = '/timeline';
  static const String contactPath = '/contact';
  static const String notFoundPath = '/404';
  static const String fallbackPath = '*';

  // Parameterized route paths (for future use)
  static const String projectDetailPath = '/projects/:id';
  static const String caseStudyDetailPath = '/case-studies/:slug';
  static const String galleryItemPath = '/gallery/:id';

  // Helper methods for building parameterized routes
  static String buildProjectDetailPath(String id) => '/projects/$id';
  static String buildCaseStudyDetailPath(String slug) => '/case-studies/$slug';
  static String buildGalleryItemPath(String id) => '/gallery/$id';

  // Query parameter keys (for future use)
  static const String searchQuery = 'q';
  static const String categoryFilter = 'category';
  static const String tagFilter = 'tag';
  static const String sectionParam = 'section';
  static const String yearParam = 'year';
  static const String filterParam = 'filter';
  static const String demoParam = 'demo';
  static const String subjectParam = 'subject';
  static const String messageParam = 'message';
}
