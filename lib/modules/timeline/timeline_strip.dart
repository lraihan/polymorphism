import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/models/career_event.dart';
import 'package:polymorphism/modules/timeline/timeline_controller.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// Career timeline strip widget
class TimelineStrip extends StatefulWidget {
  const TimelineStrip({super.key, this.enableAnimations = true, this.scrollController});
  final bool enableAnimations;
  final ScrollController? scrollController;

  @override
  State<TimelineStrip> createState() => _TimelineStripState();
}

class _TimelineStripState extends State<TimelineStrip> {
  late TimelineController _timelineController;
  double _timelineProgress = 0.0;
  final List<GlobalKey> _itemKeys = [];
  final GlobalKey _timelineKey = GlobalKey();
  Timer? _scrollDelayTimer;

  @override
  void initState() {
    super.initState();
    _timelineController = Get.put(TimelineController());
    // Initialize keys for each timeline item
    for (int i = 0; i < _timelineController.eventCount; i++) {
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
    if (widget.scrollController?.hasClients != true) return;

    final viewportHeight = widget.scrollController!.position.viewportDimension;
    final viewportCenter = viewportHeight / 2;

    int activeItems = 0;

    // Check each timeline item to see if it has passed the center of the screen
    for (int i = 0; i < _itemKeys.length; i++) {
      final itemContext = _itemKeys[i].currentContext;
      if (itemContext != null) {
        final RenderBox itemBox = itemContext.findRenderObject() as RenderBox;
        final itemPosition = itemBox.localToGlobal(Offset.zero);
        final itemCenter = itemPosition.dy + (itemBox.size.height / 2);

        // Item is considered "passed" when its center has gone above the viewport center
        if (itemCenter <= viewportCenter) {
          activeItems = i + 1;
        }
      }
    }

    // Cancel any existing timer to avoid multiple rapid updates
    _scrollDelayTimer?.cancel();

    // Add enhanced experiential delay before updating progress
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
                // Timeline item
                Container(
                  key: _itemKeys[index],
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child:
                      widget.enableAnimations
                          ? ScrollReveal(
                            duration: const Duration(milliseconds: 800),
                            child: _TimelineTile(
                              event: _timelineController.events[index],
                              index: index,
                              isActive: _timelineProgress > (index / _timelineController.eventCount),
                              isLeft: index % 2 == 0,
                            ),
                          )
                          : _TimelineTile(
                            event: _timelineController.events[index],
                            index: index,
                            isActive: _timelineProgress > (index / _timelineController.eventCount),
                            isLeft: index % 2 == 0,
                          ),
                ),
                // Dynamic connecting line (except for the last item)
                if (index < _timelineController.eventCount - 1) _buildConnectingLine(index),
              ],
            ),
      ),
    ),
  );

  Widget _buildConnectingLine(int index) {
    final currentItemProgress = index / _timelineController.eventCount;
    final nextItemProgress = (index + 1) / _timelineController.eventCount;

    // Calculate how much of this connecting line should be glowing
    double lineProgress = 0.0;
    if (_timelineProgress > currentItemProgress) {
      if (_timelineProgress >= nextItemProgress) {
        lineProgress = 1.0; // Fully active
      } else {
        // Partially active based on progress between items
        final progressBetweenItems =
            (_timelineProgress - currentItemProgress) / (nextItemProgress - currentItemProgress);
        lineProgress = progressBetweenItems.clamp(0.0, 1.0);
      }
    }

    return Container(
      height: 40,
      width: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background line
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          // Progressive glow line
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: lineProgress > 0 ? 3 : 2,
            height: 40 * lineProgress,
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
                // Timeline dot with enhanced glow
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
