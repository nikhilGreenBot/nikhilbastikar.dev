# Technical Prompt: iOS App Enhancement for App Store Approval (4.2.2 Minimum Functionality)

## Context
My iOS app was rejected from the App Store under guideline 4.2.2 (Design: Minimum Functionality) because Apple determined it lacks sufficient native functionality beyond a web wrapper. I need to enhance the app with native iOS features to demonstrate it provides substantial functionality beyond a basic web view.

## Technical Requirements

### Core Platform
- React Native with Expo (or native iOS if appropriate)
- Target iOS 13.0+
- Support iPhone and iPad (if applicable)

### Required Native Features

#### 1. Offline Reading Capability
- Implement local SQLite database (using `react-native-sqlite-storage` or `expo-sqlite`) or AsyncStorage for article storage
- Download articles with full content (not just URLs) for offline access
- Cache article content, images, and metadata locally
- Sync mechanism to update downloaded articles when online
- Storage management UI showing downloaded articles and storage usage
- Background download queue for batch article downloads
- Offline indicator/badge showing article availability status

#### 2. Native Reading UI with Customization
- **Adjustable Text Size**: Native iOS slider/stepper control to adjust article text size (minimum 12pt to maximum 24pt)
  - Store user preference in device storage
  - Apply immediately to all articles
  - Use native font scaling, not web zoom
- **Reading Themes**: Implement three native theme options
  - Light theme (white background, black text)
  - Dark theme (black background, white/light gray text)
  - Sepia theme (warm beige background, dark brown text)
  - Use native iOS color system (supports Dynamic Type and accessibility)
  - Smooth theme transition animations
- **Reader Mode**: Native article processing that:
  - Strips ads and non-content elements
  - Extracts clean article content using native parsing (not just CSS hiding)
  - Formats text with optimal line height and margins
  - Removes navigation, headers, footers, and sidebar content
  - Preserves images and formatting but optimizes for reading
  - Uses native WebKit reader view or custom native implementation

#### 3. Share Functionality with Custom Formatting
- Native iOS share sheet integration
- Custom share formatter that:
  - Includes article title, author, source, and formatted excerpt
  - Option to include article URL or full text
  - Custom formatting template (user configurable)
  - Export to PDF with custom styling
  - Share as formatted text, Markdown, or plain text
- Save articles to Files app with custom naming
- Share to Notes, Reminders, and other native iOS apps

#### 4. Reading Analytics and Streaks
- **Reading Streaks**: Track consecutive days with reading activity
  - Store streak data locally using CoreData or SQLite
  - Calculate streaks based on daily reading sessions
  - Visual streak calendar/view
  - Streak notifications and achievements
- **Reading Statistics**:
  - Total articles read
  - Total reading time (tracked in-app)
  - Average reading time per article
  - Most read categories/topics
  - Reading progress charts/graphs using native iOS Charts framework
  - Weekly/monthly reading goals with progress tracking

#### 5. Article Annotation and Highlighting
- Native text selection and highlighting system
  - Multiple highlight colors (yellow, green, blue, pink, etc.)
  - Highlight persistence (saved to local database)
  - View all highlights in a dedicated section
  - Export highlights with article context
- **Annotations**:
  - Add notes/annotations to specific article sections
  - Link annotations to text selections
  - Search annotations
  - Export annotations as a separate document
  - Support for rich text in annotations

#### 6. Native iOS Interactions

##### Pull-to-Refresh
- Custom pull-to-refresh implementation (not just default)
  - Custom animation (e.g., branded loading indicator)
  - Smooth spring physics-based animation
  - Haptic feedback on refresh trigger
  - Refresh state indicators

##### Haptic Feedback
- Implement `UIImpactFeedbackGenerator` for:
  - Article actions (save, share, like)
  - Navigation transitions
  - Pull-to-refresh
  - Button taps with appropriate intensity
  - Success/error state feedback
- Use `UINotificationFeedbackGenerator` for notifications/alerts

##### Custom Transitions and Animations
- Custom view controller transitions between screens
  - Smooth fade, slide, or custom transition animations
  - Parallax effects on scroll
  - Card-based navigation with gesture-driven transitions
  - Article list to detail view transition animations
- Use native iOS animation APIs (Core Animation, UIView animations)
- Ensure 60fps performance on animations
- Respect prefers-reduced-motion accessibility setting

#### 7. iOS Home Screen Widgets
- Implement WidgetKit-based home screen widgets
- **Widget Options**:
  - Today's featured articles widget
  - Reading streak widget
  - Daily reading stats widget
  - Quick access to saved articles
  - Widget sizes: Small, Medium, Large
- Widget configuration screen
- Update widgets via background tasks or timeline provider
- Deep linking from widgets to specific app content

### Additional Native Features to Consider
- **Biometric Authentication**: Face ID/Touch ID for secure article saving (if applicable)
- **Siri Shortcuts**: Voice commands to "Open my reading list" or "Read my saved articles"
- **Handoff**: Continue reading on other Apple devices
- **Universal Links**: Deep linking from external sources
- **Rich Notifications**: Article recommendations, reading reminders
- **Shortcuts App Integration**: Create custom shortcuts for common actions
- **Apple Watch App** (optional): Quick article access, reading stats

### Technical Implementation Notes
- Use native iOS frameworks where possible (UIKit, SwiftUI, WidgetKit, CoreData, etc.)
- Avoid relying heavily on WebViews - use native UI components
- Implement proper data persistence (not just in-memory state)
- Ensure smooth performance (60fps scrolling, fast transitions)
- Follow iOS Human Interface Guidelines
- Support Dynamic Type for accessibility
- Test on multiple iOS versions and device sizes
- Implement proper error handling and offline state management

### Deliverables
- Complete implementation with all features
- Code should be production-ready
- Include proper error handling
- Document key architectural decisions
- Ensure App Store compliance

## Expected Outcome
After implementation, the app should clearly demonstrate native iOS functionality that goes significantly beyond a web wrapper, addressing Apple's 4.2.2 rejection by providing substantial offline capabilities, native UI controls, device integration, and unique features not available in a web browser.

