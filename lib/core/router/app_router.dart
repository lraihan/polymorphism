import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/pages/not_found_page.dart';
import 'package:polymorphism/core/router/app_routes.dart';
import 'package:polymorphism/modules/case_studies/pages/case_studies_page.dart';
import 'package:polymorphism/modules/contact/pages/contact_page.dart';
import 'package:polymorphism/modules/gallery/pages/gallery_page.dart';
import 'package:polymorphism/modules/home/pages/home_page.dart';
import 'package:polymorphism/modules/playground/pages/playground_page.dart';
import 'package:polymorphism/modules/projects/pages/projects_page.dart';
import 'package:polymorphism/modules/timeline/pages/timeline_page.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.homePath,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      // Main routes
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => HomePage(section: state.uri.queryParameters[AppRoutes.sectionParam]),
      ),
      GoRoute(
        path: AppRoutes.projectsPath,
        name: AppRoutes.projects,
        builder:
            (context, state) => ProjectsPage(
              searchQuery: state.uri.queryParameters[AppRoutes.searchQuery],
              category: state.uri.queryParameters[AppRoutes.categoryFilter],
            ),
      ),
      GoRoute(
        path: AppRoutes.galleryPath,
        name: AppRoutes.gallery,
        builder:
            (context, state) => GalleryPage(
              searchQuery: state.uri.queryParameters[AppRoutes.searchQuery],
              tag: state.uri.queryParameters[AppRoutes.tagFilter],
            ),
      ),
      GoRoute(
        path: AppRoutes.playgroundPath,
        name: AppRoutes.playground,
        builder:
            (context, state) => PlaygroundPage(
              demo: state.uri.queryParameters[AppRoutes.demoParam],
              category: state.uri.queryParameters[AppRoutes.categoryFilter],
            ),
      ),
      GoRoute(
        path: AppRoutes.caseStudiesPath,
        name: AppRoutes.caseStudies,
        builder: (context, state) => CaseStudiesPage(category: state.uri.queryParameters[AppRoutes.categoryFilter]),
      ),
      GoRoute(
        path: AppRoutes.timelinePath,
        name: AppRoutes.timeline,
        builder:
            (context, state) => TimelinePage(
              year: state.uri.queryParameters[AppRoutes.yearParam],
              filter: state.uri.queryParameters[AppRoutes.filterParam],
            ),
      ),
      GoRoute(
        path: AppRoutes.contactPath,
        name: AppRoutes.contact,
        builder:
            (context, state) => ContactPage(
              subject: state.uri.queryParameters[AppRoutes.subjectParam],
              message: state.uri.queryParameters[AppRoutes.messageParam],
            ),
      ),

      // Future parameterized routes (scaffolded for easy addition)
      // GoRoute(
      //   path: AppRoutes.projectDetailPath,
      //   name: 'project-detail',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return ProjectDetailPage(projectId: id);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.caseStudyDetailPath,
      //   name: 'case-study-detail',
      //   builder: (context, state) {
      //     final slug = state.pathParameters['slug']!;
      //     return CaseStudyDetailPage(slug: slug);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.galleryItemPath,
      //   name: 'gallery-item',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return GalleryItemPage(itemId: id);
      //   },
      // ),

      // 404 Not Found route
      GoRoute(
        path: AppRoutes.notFoundPath,
        name: AppRoutes.notFound,
        builder: (context, state) => const NotFoundPage(),
      ),
    ],
  );

  static GoRouter get instance => _router;
}
