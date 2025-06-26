import 'package:go_router/go_router.dart';
import 'package:polymorphism/modules/case_studies/pages/case_studies_page.dart';
import 'package:polymorphism/modules/contact/pages/contact_page.dart';
import 'package:polymorphism/modules/gallery/pages/gallery_page.dart';
import 'package:polymorphism/modules/home/pages/home_page.dart';
import 'package:polymorphism/modules/playground/pages/playground_page.dart';
import 'package:polymorphism/modules/projects/pages/projects_page.dart';
import 'package:polymorphism/modules/timeline/pages/timeline_page.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: '/gallery',
        name: 'gallery',
        builder: (context, state) => const GalleryPage(),
      ),
      GoRoute(
        path: '/playground',
        name: 'playground',
        builder: (context, state) => const PlaygroundPage(),
      ),
      GoRoute(
        path: '/case-studies',
        name: 'case-studies',
        builder: (context, state) => const CaseStudiesPage(),
      ),
      GoRoute(
        path: '/timeline',
        name: 'timeline',
        builder: (context, state) => const TimelinePage(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
    ],
  );

  static GoRouter get instance => _router;
}
