import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/models/career_event.dart';
import 'package:polymorphism/modules/timeline/timeline_controller.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// Career timeline strip widget with snap-scroll functionality
class TimelineStrip extends StatefulWidget {

  const TimelineStrip({super.key, this.enableAnimations = true});
  final bool enableAnimations;

  @override
  State<TimelineStrip> createState() => _TimelineStripState();
}

class _TimelineStripState extends State<TimelineStrip> {
  late ScrollController _scrollController;
  late TimelineController _timelineController;

  @override
  void initState() {
    super.initState();
    _timelineController = Get.put(TimelineController());
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController..removeListener(_onScroll)
    ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _timelineController.setScrolling(true);

      // Calculate which item is in the center
      const itemHeight = 156.0; // Approximate height per timeline item (140 + margins)
      final centerOffset = _scrollController.offset + (600 / 2); // 600 is container height
      final centerIndex = (centerOffset / itemHeight).round();

      _timelineController.updateActiveIndex(centerIndex);

      // Reset scrolling state after a delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _timelineController.setScrolling(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 600,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Stack(
          children: [
            // Central dotted line
            Positioned(left: 0, right: 0, top: 0, bottom: 0, child: CustomPaint(painter: _DottedLinePainter())),

            // Timeline list
            ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              itemCount: _timelineController.eventCount,
              itemBuilder: (context, index) {
                final tile = Obx(
                  () => _TimelineTile(
                    event: _timelineController.events[index],
                    index: index,
                    isActive: _timelineController.activeIndex.value == index,
                    isLeft: index % 2 == 0,
                  ),
                );

                return widget.enableAnimations
                    ? ScrollReveal(delay: Duration(milliseconds: index * 100), child: tile)
                    : tile;
              },
            ),
          ],
        ),
      ),
    );
}

/// Individual timeline tile widget
class _TimelineTile extends StatelessWidget {

  const _TimelineTile({required this.event, required this.index, required this.isActive, required this.isLeft});
  final CareerEvent event;
  final int index;
  final bool isActive;
  final bool isLeft;

  @override
  Widget build(BuildContext context) => Semantics(
      label: '${event.year}: ${event.title}',
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            // Left content (even indices)
            Expanded(child: isLeft ? _buildTileContent(context, Alignment.centerRight) : const SizedBox()),

            // Center timeline indicator
            SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Timeline dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 20 : 12,
                    height: isActive ? 20 : 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                      boxShadow:
                          isActive
                              ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                              : null,
                    ),
                  ),

                  // Year label
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${event.year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Right content (odd indices)
            Expanded(child: !isLeft ? _buildTileContent(context, Alignment.centerLeft) : const SizedBox()),
          ],
        ),
      ),
    );

  Widget _buildTileContent(BuildContext context, Alignment alignment) => Align(
      alignment: alignment,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: EdgeInsets.only(left: isLeft ? 0 : AppSpacing.md, right: isLeft ? AppSpacing.md : 0),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: isActive ? AppColors.accent.withValues(alpha: 0.3) : AppColors.textPrimary.withValues(alpha: 0.1),
            width: isActive ? 2 : 1,
          ),
          boxShadow:
              isActive
                  ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.1), blurRadius: 12, spreadRadius: 2)]
                  : null,
        ),
        child: Column(
          crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and title row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLeft) ...[
                  Icon(
                    event.icon,
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isActive ? AppColors.accent : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    textAlign: isLeft ? TextAlign.right : TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLeft) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    event.icon,
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            // Company and location
            if (event.company != null) ...[
              Text(
                '${event.company}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: isLeft ? TextAlign.right : TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
              if (event.location != null) ...[
                const SizedBox(height: 1),
                Text(
                  event.location!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.6), fontSize: 10),
                  textAlign: isLeft ? TextAlign.right : TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],

            const SizedBox(height: 4),

            // Description
            Flexible(
              child: Text(
                event.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.8),
                  height: 1.2,
                  fontSize: 10,
                ),
                textAlign: isLeft ? TextAlign.right : TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
}

/// Custom painter for the central dotted line
class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.textPrimary.withValues(alpha: 0.3)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    const dashHeight = 8.0;
    const dashSpace = 6.0;
    double startY = 0;

    // Draw dotted line down the center
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
