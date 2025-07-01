import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/pages/not_found_page.dart';
import 'package:polymorphism/core/router/app_routes.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/case_studies/pages/case_studies_page.dart';
import 'package:polymorphism/modules/contact/pages/contact_page.dart';
import 'package:polymorphism/modules/gallery/gallery_lightbox.dart';
import 'package:polymorphism/modules/gallery/pages/gallery_page.dart';
import 'package:polymorphism/modules/home/pages/home_page.dart';
import 'package:polymorphism/modules/lab/pages/lab_page.dart';
import 'package:polymorphism/modules/playground/pages/playground_page.dart';
import 'package:polymorphism/modules/projects/pages/projects_page.dart';
import 'package:polymorphism/modules/timeline/pages/timeline_page.dart';
import 'package:polymorphism/shared/navbar/navbar.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.homePath,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      // Shell route that wraps all main pages with the navbar
      ShellRoute(
        builder:
            (context, state, child) => Scaffold(
              backgroundColor: AppColors.bgDark,
              body: Column(children: [const Navbar(), Expanded(child: child)]),
            ),
        routes: [
          // Main routes
          GoRoute(
            path: AppRoutes.homePath,
            name: AppRoutes.home,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  HomePage(section: state.uri.queryParameters[AppRoutes.sectionParam]),
                ),
          ),
          GoRoute(
            path: AppRoutes.projectsPath,
            name: AppRoutes.projects,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  ProjectsPage(
                    searchQuery: state.uri.queryParameters[AppRoutes.searchQuery],
                    category: state.uri.queryParameters[AppRoutes.categoryFilter],
                  ),
                ),
          ),
          GoRoute(
            path: AppRoutes.galleryPath,
            name: AppRoutes.gallery,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  GalleryPage(
                    searchQuery: state.uri.queryParameters[AppRoutes.searchQuery],
                    tag: state.uri.queryParameters[AppRoutes.tagFilter],
                  ),
                ),
          ),
          GoRoute(
            path: AppRoutes.playgroundPath,
            name: AppRoutes.playground,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  PlaygroundPage(
                    demo: state.uri.queryParameters[AppRoutes.demoParam],
                    category: state.uri.queryParameters[AppRoutes.categoryFilter],
                  ),
                ),
          ),
          GoRoute(
            path: AppRoutes.labPath,
            name: AppRoutes.lab,
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const LabPage()),
          ),
          GoRoute(
            path: AppRoutes.caseStudiesPath,
            name: AppRoutes.caseStudies,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  CaseStudiesPage(category: state.uri.queryParameters[AppRoutes.categoryFilter]),
                ),
          ),
          GoRoute(
            path: AppRoutes.timelinePath,
            name: AppRoutes.timeline,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  TimelinePage(
                    year: state.uri.queryParameters[AppRoutes.yearParam],
                    filter: state.uri.queryParameters[AppRoutes.filterParam],
                  ),
                ),
          ),
          GoRoute(
            path: AppRoutes.contactPath,
            name: AppRoutes.contact,
            pageBuilder:
                (context, state) => _buildPageWithTransition(
                  context,
                  state,
                  ContactPage(
                    subject: state.uri.queryParameters[AppRoutes.subjectParam],
                    message: state.uri.queryParameters[AppRoutes.messageParam],
                  ),
                ),
          ),
          // 404 Not Found route
          GoRoute(
            path: AppRoutes.notFoundPath,
            name: AppRoutes.notFound,
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const NotFoundPage()),
          ),
        ],
      ),

      // Gallery lightbox route (outside shell, no navbar)
      GoRoute(
        path: '/gallery/:index',
        name: 'gallery-lightbox',
        pageBuilder: (context, state) {
          final indexStr = state.pathParameters['index'];
          final index = int.tryParse(indexStr ?? '0') ?? 0;
          return CustomTransitionPage(
            key: state.pageKey,
            child: GalleryLightbox(initialIndex: index),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => FadeTransition(
                  opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
                  child: child,
                ),
          );
        },
      ),
    ],
  );

  static GoRouter get instance => _router;

  // Helper method to create page transitions
  static CustomTransitionPage _buildPageWithTransition(BuildContext context, GoRouterState state, Widget child) =>
      CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic), child: child),
      );
}
