import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:polymorphism/core/constant.dart';

import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

class WorksSection extends StatefulWidget {
  const WorksSection({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  State<WorksSection> createState() => _WorksSectionState();
}

class _WorksSectionState extends State<WorksSection> {
  double _headerScrollOffset = 0;
  double _textWidth = 0;
  late final GlobalKey _worksKey;
  late final GlobalKey _textKey;

  @override
  void initState() {
    super.initState();
    _worksKey = GlobalKey();
    _textKey = GlobalKey();
    widget.scrollController?.addListener(_updateHeaderScroll);

    // Calculate text width after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
    });
  }

  @override
  void didUpdateWidget(WorksSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalculate text width when widget updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
    });
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_updateHeaderScroll);
    super.dispose();
  }

  void _calculateTextWidth() {
    final textContext = _textKey.currentContext;
    if (textContext != null) {
      final textBox = textContext.findRenderObject() as RenderBox?;
      if (textBox != null) {
        setState(() {
          _textWidth = textBox.size.width;
        });
      }
    }
  }

  void _updateHeaderScroll() {
    if (!mounted || widget.scrollController == null || !widget.scrollController!.hasClients) {
      return;
    }

    // Get the position of the works section
    final worksContext = _worksKey.currentContext;
    if (worksContext == null) {
      return;
    }

    final worksBox = worksContext.findRenderObject() as RenderBox?;
    if (worksBox == null) {
      return;
    }

    final worksPosition = worksBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollPosition = widget.scrollController!.offset;

    // Calculate when the works section is in view
    final worksTop = worksPosition.dy + scrollPosition;
    final worksBottom = worksTop + worksBox.size.height;

    // Start horizontal scroll when works section enters viewport
    final viewportTop = scrollPosition;
    final viewportBottom = scrollPosition + screenHeight;

    if (worksTop <= viewportBottom && worksBottom >= viewportTop) {
      // Section is in view - calculate scroll progress within section
      final sectionProgress = ((scrollPosition - (worksTop - screenHeight)) / (worksBox.size.height + screenHeight))
          .clamp(0.0, 1.0);

      // Convert to horizontal offset (scroll text from right to left to reveal full content)
      // Calculate maximum scroll distance: text width minus screen width + extra padding
      final maxScrollDistance =
          (_textWidth > screenWidth) ? (_textWidth - screenWidth + horizontalPadding(context) * 4) * 1.1 : 0.0;

      setState(() {
        _headerScrollOffset = sectionProgress * maxScrollDistance;
      });
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    key: _worksKey,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _workProject(context, 'Project 1', 'A brief description of Project 1', 'assets/images/works/project1-1.png'),
        _workProject(context, 'Project 2', 'A brief description of Project 2', 'assets/images/works/project2-1.png'),
        _workProject(context, 'Project 3', 'A brief description of Project 3', 'assets/images/works/project6-1.png'),
      ],
    ),
  );

  Widget _buildHeader(BuildContext context) => Container(
    width: double.maxFinite,
    height: screenHeight(context) * .7,
    decoration: const BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/images/paper.png'), fit: BoxFit.cover),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header text with horizontal scroll effect
        SizedBox(
          height: screenHeight(context) * .65,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Transform.translate(
              offset: Offset(-_headerScrollOffset, 0), // Apply horizontal scroll offset
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: horizontalPadding(context) * .3),
                height: screenHeight(context) * .65,
                child: Text(
                  key: _textKey,
                  'DESIGNED WITH LOGIC DESIGNED WITH LOGIC DESIGNED WITH LOGIC',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.bgDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 180,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth(context) * .15,
                  child: Text(
                    '(Works.)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.bgDark, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'This creation is a confession, written in dark and dart.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.bgDark, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: screenWidth(context) * .15),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _workProject(BuildContext context, String title, String description, String imagePath) => LayoutBuilder(
    builder:
        (context, constraints) => Container(
          height: screenHeight(context),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: verticalPadding(context), horizontal: horizontalPadding(context)),
          decoration: const BoxDecoration(
            color: AppColors.bgDark,
            image: DecorationImage(image: AssetImage('assets/images/workBg.png'), fit: BoxFit.cover),
          ),
          child: Row(
            children: [
              SizedBox(
                width: screenWidth(context) * .15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalPadding(context) * 2),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: AppColors.bgDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.bgDark, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth(context) * .03),
              ScrollReveal(
                child: Tilt(child: Image.asset(imagePath, fit: BoxFit.contain, width: screenWidth(context) * .7)),
              ),
            ],
          ),
        ),
  );
}
