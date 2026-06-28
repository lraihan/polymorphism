import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/data/portfolio_data.dart';

void main() {
  group('PortfolioData.projects', () {
    test('contains exactly 7 projects', () {
      expect(PortfolioData.projects, hasLength(7));
    });

    test('ids are unique and slug-safe', () {
      final ids = PortfolioData.projects.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'project ids must be unique');
      final slug = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
      for (final id in ids) {
        expect(slug.hasMatch(id), isTrue, reason: '"$id" must be a lowercase slug without spaces');
      }
    });

    test('every project ships its gallery under assets/works/_gallery/', () {
      for (final project in PortfolioData.projects) {
        expect(project.images, isNotEmpty, reason: '${project.name} must have screenshots');
        expect(project.images.length, greaterThanOrEqualTo(3), reason: '${project.name} needs ≥3 shots');
        for (final image in project.images) {
          expect(image, startsWith('assets/works/_gallery/'), reason: '${project.name} image path');
        }
      }
    });

    test('every project lists a non-empty tech stack', () {
      for (final project in PortfolioData.projects) {
        expect(project.tech, isNotEmpty, reason: '${project.name} must list its tech');
      }
    });

    test('exactly 2 projects are featured', () {
      final featured = PortfolioData.projects.where((p) => p.isFeatured);
      expect(featured, hasLength(2));
    });

    test('projectById returns the matching project', () {
      final project = PortfolioData.projectById('roast-pos');
      expect(project, isNotNull);
      expect(project?.name, 'ROAST POS');
      expect(project?.id, 'roast-pos');
    });

    test('projectById returns null for unknown ids', () {
      expect(PortfolioData.projectById('not-a-project'), isNull);
      expect(PortfolioData.projectById(''), isNull);
    });
  });

  group('PortfolioData.careerEvents', () {
    test('are ordered oldest → most recent', () {
      const events = PortfolioData.careerEvents;
      expect(events, isNotEmpty);
      for (var i = 0; i < events.length - 1; i++) {
        expect(
          events[i].year,
          lessThanOrEqualTo(events[i + 1].year),
          reason: 'careerEvents must read oldest-first',
        );
      }
    });

    test('every entry carries hover highlights', () {
      for (final event in PortfolioData.careerEvents) {
        expect(event.highlights, isNotEmpty, reason: '${event.title} needs highlights');
      }
    });
  });

  group('PortfolioData.toolkitPillars', () {
    test('has exactly 3 pillars, each complete', () {
      expect(PortfolioData.toolkitPillars, hasLength(3));
      for (final pillar in PortfolioData.toolkitPillars) {
        expect(pillar.name, isNotEmpty);
        expect(pillar.tagline, isNotEmpty);
        expect(pillar.level, isNotEmpty);
        expect(pillar.skills, isNotEmpty, reason: '${pillar.name} must list its tools');
      }
    });

    test('toolkit stays focused (no engineering-noise entries)', () {
      final labels = PortfolioData.toolkitPillars.expand((p) => p.skills).map((s) => s.label).toSet();
      for (final noisy in const ['Java', 'SQL', 'Material 3', 'GetX', 'Git', 'CI / CD', 'Vercel', 'Testing']) {
        expect(labels, isNot(contains(noisy)), reason: '$noisy should be cut for a visual-specialist kit');
      }
    });
  });

  group('PortfolioData socials', () {
    test('every social link uses https', () {
      expect(PortfolioData.socials, isNotEmpty);
      for (final social in PortfolioData.socials) {
        expect(social.label, isNotEmpty);
        expect(social.url, startsWith('https://'), reason: '${social.label} url must use https');
      }
    });

    test('direct urls use https', () {
      expect(PortfolioData.githubUrl, startsWith('https://'));
      expect(PortfolioData.linkedInUrl, startsWith('https://'));
    });
  });

  group('AppAssets', () {
    test('preload is first-two-screens: logo, 6 fragments, 6 project heroes', () {
      final preload = AppAssets.preload;
      // The heavy 4 MB hero background and the deeper gallery shots are
      // intentionally NOT preloaded — they load lazily.
      expect(preload, hasLength(13));
      expect(preload, contains(AppAssets.logo));
      expect(preload, isNot(contains(AppAssets.heroBackground)));
      for (final fragment in AppAssets.fragments) {
        expect(preload, contains(fragment));
      }
      final heroes = preload.where((path) => path.startsWith('assets/works/_gallery/'));
      expect(heroes, hasLength(6));
      for (final gallery in [
        AppAssets.roast,
        AppAssets.feTouch,
        AppAssets.elssa,
        AppAssets.profund,
        AppAssets.fitx,
        AppAssets.sigap,
      ]) {
        expect(preload, contains(gallery.first), reason: 'each preloaded gallery contributes its hero shot');
      }
    });
  });
}
