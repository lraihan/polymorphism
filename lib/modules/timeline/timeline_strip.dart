import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/models/career_event.dart';
import 'package:polymorphism/modules/timeline/timeline_controller.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

class TimelineStrip extends StatefulWidget {
  const TimelineStrip({super.key, this.enableAnimations = true, this.scrollController});
  final bool enableAnimations;
  final ScrollController? scrollController;

  @override
  State<TimelineStrip> createState() => _TimelineStripState();
}

class _TimelineStripState extends State<TimelineStrip> {
  late TimelineController _timelineController;
  double _timelineProgress = 0;
  final List<GlobalKey> _itemKeys = [];
  final GlobalKey _timelineKey = GlobalKey();
  Timer? _scrollDelayTimer;

  @override
  void initState() {
    super.initState();
    _timelineController = Get.put(TimelineController());
    for (var i = 0; i < _timelineController.eventCount; i++) {
      _itemKeys.add(GlobalKey());
    }
    widget.scrollController?.addListener(_updateTimelineProgress);
  }

  @override
  void dispose() {
    _scrollDelayTimer?.cancel();
    widget.scrollController?.removeListener(_updateTimelineProgress);
    super.dispose();
  }

  void _updateTimelineProgress() {
    if (widget.scrollController?.hasClients != true) {
      return;
    }

    final viewportHeight = widget.scrollController!.position.viewportDimension;
    final viewportTrigger = viewportHeight * 0.75;

    var activeItems = 0;

    for (var i = 0; i < _itemKeys.length; i++) {
      final itemContext = _itemKeys[i].currentContext;
      if (itemContext != null) {
        final itemBox = itemContext.findRenderObject()! as RenderBox;
        final itemPosition = itemBox.localToGlobal(Offset.zero);
        final itemCenter = itemPosition.dy + (itemBox.size.height / 2);

        if (itemCenter <= viewportTrigger) {
          activeItems = i + 1;
        }
      }
    }

    _scrollDelayTimer?.cancel();

    _scrollDelayTimer = Timer(Duration.zero, () {
      if (mounted) {
        final newProgress = _timelineController.eventCount > 0 ? activeItems / _timelineController.eventCount : 0.0;
        setState(() {
          _timelineProgress = newProgress.clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    key: _timelineKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _timelineController.eventCount,
        itemBuilder:
            (context, index) => Column(
              children: [
                if (index > 0) _buildConnectingLine(index - 1),
                Container(
                  key: _itemKeys[index],
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child:
                      widget.enableAnimations
                          ? ScrollReveal(
                            child: _TimelineTile(
                              event: _timelineController.events[index],
                              index: index,
                              isActive: _timelineProgress >= ((index + 1) / _timelineController.eventCount),
                              isLeft: index % 2 == 0,
                            ),
                          )
                          : _TimelineTile(
                            event: _timelineController.events[index],
                            index: index,
                            isActive: _timelineProgress >= ((index + 1) / _timelineController.eventCount),
                            isLeft: index % 2 == 0,
                          ),
                ),
              ],
            ),
      ),
    ),
  );

  Widget _buildConnectingLine(int previousIndex) {

    final currentItemIndex = previousIndex + 1; // The dot this line connects TO
    final currentItemProgress = (currentItemIndex + 1) / _timelineController.eventCount;

    var lineProgress = 0.0;

    if (_timelineProgress >= currentItemProgress) {
      lineProgress = 1.0; // Fully active - the dot this line connects to is active
    }

    return Container(
      height: 90,
      width: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 2,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: lineProgress > 0 ? 3 : 2,
            height: 80 * lineProgress,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(1.5),
              boxShadow:
                  lineProgress > 0
                      ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1)]
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}

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
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: isLeft ? _buildTileContent(context, Alignment.centerRight) : const SizedBox()),

          SizedBox(
            child: Column(
              children: [
                Container(
                  width: isActive ? 24 : 16,
                  height: isActive ? 24 : 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    boxShadow:
                        isActive
                            ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.6),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                              BoxShadow(color: AppColors.accent.withValues(alpha: 0.8), blurRadius: 6, spreadRadius: 1),
                            ]
                            : [
                              BoxShadow(
                                color: AppColors.textPrimary.withValues(alpha: 0.2),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                  ),
                  child: Center(
                    child: Container(
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.white : AppColors.textPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${event.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: _getResponsiveFontSize(context, 12),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: !isLeft ? _buildTileContent(context, Alignment.centerLeft) : const SizedBox()),
        ],
      ),
    ),
  );

  Widget _buildTileContent(BuildContext context, Alignment alignment) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final horizontalMargin = isMobile ? AppSpacing.sm : AppSpacing.md;
    final contentPadding = isMobile ? AppSpacing.sm : AppSpacing.md;

    return Align(
      alignment: alignment,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.all(contentPadding),
        margin: EdgeInsets.only(left: isLeft ? 0 : horizontalMargin, right: isLeft ? horizontalMargin : 0),
        constraints: BoxConstraints(
          maxWidth: isMobile ? screenWidth * 0.75 : screenWidth * .35, // Responsive max width
        ),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLeft) ...[
                  Icon(
                    event.icon,
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    size: _getResponsiveIconSize(context),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isActive ? AppColors.accent : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: _getResponsiveFontSize(context, 14),
                    ),
                    textAlign: isLeft ? TextAlign.right : TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLeft) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    event.icon,
                    color: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.6),
                    size: _getResponsiveIconSize(context),
                  ),
                ],
              ],
            ),

            SizedBox(height: isMobile ? 4 : 6),

            if (event.company != null) ...[
              Text(
                '${event.company}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: _getResponsiveFontSize(context, 12),
                ),
                textAlign: isLeft ? TextAlign.right : TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (event.location != null) ...[
                const SizedBox(height: 2),
                Text(
                  event.location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                    fontSize: _getResponsiveFontSize(context, 11),
                  ),
                  textAlign: isLeft ? TextAlign.right : TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],

            SizedBox(height: isMobile ? 6 : 8),

            Text(
              event.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                height: 1.5, // Increased line height for better readability
                fontSize: _getResponsiveFontSize(context, 11),
              ),
              textAlign: isLeft ? TextAlign.right : TextAlign.left,
              softWrap: true, // Ensure text wraps properly
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseFontSize * 0.85; // Mobile - slightly smaller
    } else if (screenWidth < 1024) {
      return baseFontSize * 0.95; // Tablet - slightly smaller
    }
    return baseFontSize; // Desktop - full size
  }

  double _getResponsiveIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 16; // Mobile - smaller icons
    } else if (screenWidth < 1024) {
      return 17; // Tablet - medium icons
    }
    return 18; // Desktop - full size icons
  }
}
