# Bidirectional Scroll Reveal Implementation

## Overview
The ScrollReveal widget has been enhanced to support bidirectional reveal and unreveal animations based on scroll direction. This creates a dynamic, interactive experience where content appears when scrolling down and disappears when scrolling back up.

## Key Features

### 1. Bidirectional Visibility
- **Reveal**: Content fades in and slides up when scrolling down and the widget becomes visible
- **Unreveal**: Content fades out and slides down when scrolling up and the widget becomes invisible
- **Memory**: The widget remembers if it has been revealed before, preventing premature unrevealing

### 2. Configurable Parameters
```dart
ScrollReveal(
  bidirectional: true,           // Enable bidirectional behavior (default: true)
  visibilityThreshold: 0.1,      // Fraction visible to trigger reveal (default: 0.1)
  duration: Duration(milliseconds: 800),  // Animation duration
  offset: 50.0,                  // Slide distance
  delay: Duration.zero,          // Delay before reveal
  addScrollDelay: true,          // Add experiential scroll delay
  child: YourWidget(),
)
```

### 3. Performance Optimizations
- **Faster Hide Animation**: Unrevealing uses 60% of the reveal duration for responsive feel
- **State Tracking**: Efficiently tracks visibility changes to prevent unnecessary animations
- **Timer Management**: Proper cleanup of delayed animations

### 4. Accessibility Support
- **Animation Disable**: Respects `MediaQuery.disableAnimations` for accessibility
- **Immediate State**: When animations are disabled, content immediately shows/hides

## Implementation Details

### State Management
- `_isVisible`: Tracks current visibility state
- `_hasBeenRevealed`: Prevents unrevealing content that hasn't been revealed yet
- `_controller`: AnimationController for smooth transitions

### Visibility Detection
- Uses `VisibilityDetector` to monitor widget visibility
- Configurable threshold (default 10% visible) to trigger animations
- Bidirectional state changes trigger appropriate animations

### Animation Timing
- **Reveal**: Full duration + optional delay + scroll delay
- **Unreveal**: 60% of reveal duration for snappy feel
- **Restoration**: Original duration restored after unreveal completes

## Usage Examples

### Default Bidirectional Behavior
```dart
ScrollReveal(
  child: Text('This content reveals and unreveals'),
)
```

### One-way Reveal Only (Legacy Behavior)
```dart
ScrollReveal(
  bidirectional: false,
  child: Text('This content only reveals once'),
)
```

### Custom Threshold and Timing
```dart
ScrollReveal(
  bidirectional: true,
  visibilityThreshold: 0.3,  // 30% visible before triggering
  duration: Duration(milliseconds: 1200),
  delay: Duration(milliseconds: 200),
  child: YourWidget(),
)
```

## Browser Testing
The implementation has been tested in Chrome and works smoothly with:
- Scroll wheel interactions
- Touch scrolling on mobile devices
- Keyboard navigation (Page Up/Down, Arrow keys)
- Different scroll speeds and directions

## Performance Considerations
- Minimal impact on scroll performance
- Efficient visibility detection
- Proper timer cleanup prevents memory leaks
- Respects system animation preferences
