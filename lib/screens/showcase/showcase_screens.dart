import 'package:flutter/material.dart';

import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../data/mock/sample_data.dart';
import '../../data/models/models.dart';

class ShowcaseGalleryScreen extends StatelessWidget {
  const ShowcaseGalleryScreen({super.key});

  static final List<_ShowcaseDestination> _destinations = [
    _ShowcaseDestination(
      title: 'Discover',
      subtitle: 'Browse featured professionals and categories',
      icon: Icons.explore_rounded,
      gradient: AppColors.primaryGradient,
      builder: (_) => const DiscoverShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Events',
      subtitle: 'Upcoming bookings, meetups, and schedules',
      icon: Icons.event_rounded,
      gradient: AppColors.secondaryGradient,
      builder: (_) => const EventsShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Messages',
      subtitle: 'Direct conversations and quick replies',
      icon: Icons.chat_bubble_rounded,
      gradient: AppColors.freelanceGradient,
      builder: (_) => const ChatShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Challenges',
      subtitle: 'Progress cards and goal tracking',
      icon: Icons.emoji_events_rounded,
      gradient: AppColors.tradeGradient,
      builder: (_) => const ChallengeShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Saved',
      subtitle: 'Shortlist the professionals you like',
      icon: Icons.bookmark_rounded,
      gradient: AppColors.primaryGradient,
      builder: (_) => const SavedShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Profile',
      subtitle: 'Identity, skills, and portfolio summary',
      icon: Icons.person_rounded,
      gradient: AppColors.freelanceGradient,
      builder: (_) => const ProfileOverviewShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Analytics',
      subtitle: 'Performance cards and compact charts',
      icon: Icons.insights_rounded,
      gradient: AppColors.secondaryGradient,
      builder: (_) => const AnalyticsShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Notifications',
      subtitle: 'Activity feed and alert states',
      icon: Icons.notifications_rounded,
      gradient: AppColors.tradeGradient,
      builder: (_) => const NotificationsShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Settings',
      subtitle: 'Preferences, toggles, and account controls',
      icon: Icons.settings_rounded,
      gradient: AppColors.primaryGradient,
      builder: (_) => const SettingsShowcaseScreen(),
    ),
    _ShowcaseDestination(
      title: 'Community',
      subtitle: 'Feed cards and social proof content blocks',
      icon: Icons.groups_rounded,
      gradient: AppColors.freelanceGradient,
      builder: (_) => const CommunityShowcaseScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          gradient: isDark ? AppColors.darkGradient : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screen.horizontalPadding,
              screen.spacing(16),
              screen.horizontalPadding,
              screen.safeBottom + screen.spacing(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Screen Gallery',
                            style: TextStyle(
                              fontSize: screen.fontSize(24),
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap any card to open one of the 10 new responsive screens.',
                            style: TextStyle(
                              fontSize: screen.fontSize(13),
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _IconCircleButton(
                      icon: isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      onTap: () {},
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: _destinations.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screen.gridColumns(
                        mobileCount: 1,
                        tabletCount: 2,
                        desktopCount: 3,
                      ),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: screen.isMobile ? 1.55 : 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final destination = _destinations[index];
                      return _GalleryTile(
                        destination: destination,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: destination.builder,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoverShowcaseScreen extends StatelessWidget {
  const DiscoverShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Discover',
      subtitle: 'Find the right professional for every task',
      gradient: AppColors.primaryGradient,
      icon: Icons.explore_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Nearby', value: '28'),
        ShowcaseMetric(label: 'Top rated', value: '4.9+'),
        ShowcaseMetric(label: 'Open now', value: '16'),
      ],
      child: _ProfessionalDiscoveryBody(screen: screen),
    );
  }
}

class EventsShowcaseScreen extends StatelessWidget {
  const EventsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Events',
      subtitle: 'Upcoming bookings and community meetups',
      gradient: AppColors.secondaryGradient,
      icon: Icons.event_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Today', value: '4'),
        ShowcaseMetric(label: 'This week', value: '11'),
        ShowcaseMetric(label: 'Confirmed', value: '8'),
      ],
      child: _EventScheduleBody(screen: screen),
    );
  }
}

class ChatShowcaseScreen extends StatelessWidget {
  const ChatShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Messages',
      subtitle: 'Quick conversations with active professionals',
      gradient: AppColors.freelanceGradient,
      icon: Icons.chat_bubble_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Unread', value: '12'),
        ShowcaseMetric(label: 'Replies', value: '3m'),
        ShowcaseMetric(label: 'Active', value: '9'),
      ],
      child: _ChatBody(screen: screen),
    );
  }
}

class ChallengeShowcaseScreen extends StatelessWidget {
  const ChallengeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Challenges',
      subtitle: 'Progress cards that stay readable on every size',
      gradient: AppColors.tradeGradient,
      icon: Icons.emoji_events_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Streak', value: '14d'),
        ShowcaseMetric(label: 'Level', value: '18'),
        ShowcaseMetric(label: 'Goal', value: '82%'),
      ],
      child: _ChallengeBody(screen: screen),
    );
  }
}

class SavedShowcaseScreen extends StatelessWidget {
  const SavedShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Saved',
      subtitle: 'Shortlist your preferred professionals',
      gradient: AppColors.primaryGradient,
      icon: Icons.bookmark_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Saved', value: '24'),
        ShowcaseMetric(label: 'Shortlist', value: '7'),
        ShowcaseMetric(label: 'Available', value: '19'),
      ],
      child: _SavedBody(screen: screen),
    );
  }
}

class ProfileOverviewShowcaseScreen extends StatelessWidget {
  const ProfileOverviewShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Profile',
      subtitle: 'Identity, skills, and portfolio highlights',
      gradient: AppColors.freelanceGradient,
      icon: Icons.person_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Rating', value: '4.9'),
        ShowcaseMetric(label: 'Jobs', value: '128'),
        ShowcaseMetric(label: 'Years', value: '6'),
      ],
      child: _ProfileOverviewBody(screen: screen),
    );
  }
}

class AnalyticsShowcaseScreen extends StatelessWidget {
  const AnalyticsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Analytics',
      subtitle: 'Compact KPI cards and responsive charts',
      gradient: AppColors.secondaryGradient,
      icon: Icons.insights_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Views', value: '3.2k'),
        ShowcaseMetric(label: 'Leads', value: '89'),
        ShowcaseMetric(label: 'Reply rate', value: '71%'),
      ],
      child: _AnalyticsBody(screen: screen),
    );
  }
}

class NotificationsShowcaseScreen extends StatelessWidget {
  const NotificationsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Notifications',
      subtitle: 'Unread alerts and updates in a compact feed',
      gradient: AppColors.tradeGradient,
      icon: Icons.notifications_rounded,
      metrics: const [
        ShowcaseMetric(label: 'New', value: '5'),
        ShowcaseMetric(label: 'Today', value: '12'),
        ShowcaseMetric(label: 'Priority', value: '3'),
      ],
      child: _NotificationsBody(screen: screen),
    );
  }
}

class SettingsShowcaseScreen extends StatelessWidget {
  const SettingsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Settings',
      subtitle: 'Responsive controls, toggles, and preferences',
      gradient: AppColors.primaryGradient,
      icon: Icons.settings_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Dark mode', value: 'On'),
        ShowcaseMetric(label: 'Alerts', value: 'Auto'),
        ShowcaseMetric(label: 'Privacy', value: 'High'),
      ],
      child: _SettingsBody(screen: screen),
    );
  }
}

class CommunityShowcaseScreen extends StatelessWidget {
  const CommunityShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    return ShowcaseShell(
      title: 'Community',
      subtitle: 'Feed cards and social proof content blocks',
      gradient: AppColors.freelanceGradient,
      icon: Icons.groups_rounded,
      metrics: const [
        ShowcaseMetric(label: 'Posts', value: '42'),
        ShowcaseMetric(label: 'Members', value: '1.8k'),
        ShowcaseMetric(label: 'Engagement', value: '93%'),
      ],
      child: _CommunityBody(screen: screen),
    );
  }
}

class ShowcaseShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final IconData icon;
  final List<ShowcaseMetric> metrics;
  final Widget child;

  const ShowcaseShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.metrics,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          gradient: isDark ? AppColors.darkGradient : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screen.horizontalPadding,
                  screen.spacing(14),
                  screen.horizontalPadding,
                  screen.spacing(10),
                ),
                child: Row(
                  children: [
                    _IconCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),
                    const Spacer(),
                    _IconCircleButton(
                      icon: Icons.share_outlined,
                      onTap: () {},
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screen.spacing(18)),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(ProTheme.radiusXl),
                    boxShadow: AppColors.primaryGlow(0.16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: screen.isMobile ? 54 : 64,
                        height: screen.isMobile ? 54 : 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, color: Colors.white, size: screen.iconSize(28)),
                      ),
                      SizedBox(width: screen.spacing(14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: screen.fontSize(24),
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: screen.fontSize(13),
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screen.horizontalPadding,
                  screen.spacing(14),
                  screen.horizontalPadding,
                  0,
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: metrics
                      .map(
                        (metric) => _MetricCard(
                          metric: metric,
                          screen: screen,
                          isDark: isDark,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    screen.horizontalPadding,
                    0,
                    screen.horizontalPadding,
                    screen.safeBottom + screen.spacing(12),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowcaseMetric {
  final String label;
  final String value;

  const ShowcaseMetric({required this.label, required this.value});
}

class _MetricCard extends StatelessWidget {
  final ShowcaseMetric metric;
  final ScreenInfo screen;
  final bool isDark;

  const _MetricCard({
    required this.metric,
    required this.screen,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen.isMobile ? (screen.safeWidth - 24) / 2 : 130,
      padding: EdgeInsets.symmetric(
        horizontal: screen.spacing(14),
        vertical: screen.spacing(12),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.value,
            style: TextStyle(
              fontSize: screen.fontSize(20),
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            style: TextStyle(
              fontSize: screen.fontSize(12),
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _IconCircleButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final _ShowcaseDestination destination;
  final bool isDark;
  final VoidCallback onTap;

  const _GalleryTile({
    required this.destination,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProTheme.radiusXl),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: isDark ? null : AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: destination.gradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppColors.primaryGlow(0.18),
                ),
                child: Icon(destination.icon, color: Colors.white),
              ),
              const Spacer(),
              Text(
                destination.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                destination.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowcaseDestination {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final WidgetBuilder builder;

  const _ShowcaseDestination({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.builder,
  });
}

class _ProfessionalDiscoveryBody extends StatelessWidget {
  final ScreenInfo screen;

  const _ProfessionalDiscoveryBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ...TradeCategories.all.take(3),
      ...FreelancerCategories.all.take(3),
    ];
    final professionals = MockData.featured.take(6).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories
                .map(
                  (category) => _Pill(
                    label: '${category.icon} ${category.name}',
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                )
                .toList(),
          ),
          SizedBox(height: screen.spacing(18)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: professionals.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screen.gridColumns(
                mobileCount: 1,
                tabletCount: 2,
                desktopCount: 2,
              ),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: screen.isMobile ? 1.08 : 1.16,
            ),
            itemBuilder: (context, index) {
              return _ProfessionalCard(professional: professionals[index], screen: screen);
            },
          ),
        ],
      ),
    );
  }
}

class _EventScheduleBody extends StatelessWidget {
  final ScreenInfo screen;

  const _EventScheduleBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final events = [
      ('Client briefing', 'Today 9:30 AM', 'Zoom link shared', AppColors.primary),
      ('Site inspection', 'Tomorrow 2:00 PM', 'Brooklyn, NY', AppColors.trade),
      ('Design review', 'Fri 4:30 PM', 'Remote call', AppColors.freelance),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: events.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.all(screen.spacing(18)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(ProTheme.radiusXl),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: AppColors.secondaryGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.calendar_month_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 upcoming events',
                        style: TextStyle(
                          fontSize: screen.fontSize(18),
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Everything stays aligned on compact and wide screens.',
                        style: TextStyle(
                          fontSize: screen.fontSize(13),
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final event = events[index - 1];
        return _SimpleInfoCard(
          title: event.$1,
          subtitle: event.$2,
          detail: event.$3,
          accent: event.$4,
          screen: screen,
        );
      },
    );
  }
}

class _ChatBody extends StatelessWidget {
  final ScreenInfo screen;

  const _ChatBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _ChatBubble(
                text: 'I can start the plumbing inspection at 10 AM.',
                isIncoming: true,
                isDark: isDark,
              ),
              _ChatBubble(
                text: 'Perfect. I will share the address and notes now.',
                isIncoming: false,
                isDark: isDark,
              ),
              _ChatBubble(
                text: 'Please include a photo if the issue is visible.',
                isIncoming: true,
                isDark: isDark,
              ),
              _ChatBubble(
                text: 'Done. I also added the preferred time window.',
                isIncoming: false,
                isDark: isDark,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(screen.spacing(12)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChallengeBody extends StatelessWidget {
  final ScreenInfo screen;

  const _ChallengeBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cards = [
      ('Daily response', '4 of 5 completed', 0.8, AppColors.primary),
      ('Profile boost', 'Reach 100% completeness', 0.6, AppColors.trade),
      ('Client follow-up', 'Due in 2 hours', 0.45, AppColors.freelance),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: cards.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.all(screen.spacing(18)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(ProTheme.radiusXl),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly progress',
                  style: TextStyle(
                    fontSize: screen.fontSize(18),
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    value: 0.82,
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        }

        final card = cards[index - 1];
        return _SimpleInfoCard(
          title: card.$1,
          subtitle: card.$2,
          detail: '${(card.$3 * 100).round()}% complete',
          accent: card.$4,
          screen: screen,
        );
      },
    );
  }
}

class _SavedBody extends StatelessWidget {
  final ScreenInfo screen;

  const _SavedBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final professionals = MockData.featured.take(4).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: professionals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final professional = professionals[index];
        return Container(
          padding: EdgeInsets.all(screen.spacing(14)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(
            children: [
              _NetworkAvatar(url: professional.avatarUrl, size: 56),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: TextStyle(
                        fontSize: screen.fontSize(16),
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professional.profession,
                      style: TextStyle(
                        fontSize: screen.fontSize(13),
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_rounded, color: AppColors.primary),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileOverviewBody extends StatelessWidget {
  final ScreenInfo screen;

  const _ProfileOverviewBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skills = ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'REST', 'Testing'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screen.spacing(18)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(ProTheme.radiusXl),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              children: [
                const _NetworkAvatar(
                  url: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                  size: 72,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emily Zhang',
                        style: TextStyle(
                          fontSize: screen.fontSize(18),
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Senior Flutter developer',
                        style: TextStyle(
                          fontSize: screen.fontSize(13),
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screen.spacing(16)),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.map((skill) => _Pill(label: skill, isDark: isDark)).toList(),
          ),
          SizedBox(height: screen.spacing(16)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: screen.gridColumns(mobileCount: 2, tabletCount: 3, desktopCount: 3),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.12,
            children: const [
              _MiniStatCard(title: 'Projects', value: '41'),
              _MiniStatCard(title: 'Reviews', value: '128'),
              _MiniStatCard(title: 'Response', value: '12m'),
              _MiniStatCard(title: 'Rate', value: '\$95/hr'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  final ScreenInfo screen;

  const _AnalyticsBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bars = [0.3, 0.55, 0.45, 0.8, 0.62, 0.92];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            padding: EdgeInsets.all(screen.spacing(18)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(ProTheme.radiusXl),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final value in bars) ...[
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: screen.spacing(16)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: screen.gridColumns(mobileCount: 2, tabletCount: 3, desktopCount: 3),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: const [
              _MiniStatCard(title: 'Reach', value: '8.6k'),
              _MiniStatCard(title: 'Clicks', value: '412'),
              _MiniStatCard(title: 'Calls', value: '74'),
              _MiniStatCard(title: 'Bookings', value: '23'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  final ScreenInfo screen;

  const _NotificationsBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = [
      ('New message from Marcus', 'Responded 2 minutes ago', Icons.chat_bubble_rounded, AppColors.primary),
      ('Booking confirmed', 'Tomorrow at 2:00 PM', Icons.check_circle_rounded, AppColors.success),
      ('Review received', '5 stars for recent work', Icons.star_rounded, AppColors.warning),
      ('Profile viewed', 'Your profile opened 18 times today', Icons.visibility_rounded, AppColors.freelance),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: EdgeInsets.all(screen.spacing(14)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.$4.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.$3, color: item.$4),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: screen.fontSize(15),
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: screen.fontSize(13),
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final ScreenInfo screen;

  const _SettingsBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _SettingsSection(
          title: 'Account',
          children: [
            _SettingsRow(icon: Icons.person_outline_rounded, title: 'Profile', subtitle: 'Edit personal details', screen: screen),
            _SettingsRow(icon: Icons.lock_outline_rounded, title: 'Security', subtitle: 'Password and biometric settings', screen: screen),
          ],
        ),
        const SizedBox(height: 14),
        _SettingsSection(
          title: 'Preferences',
          children: [
            _SwitchRow(icon: Icons.dark_mode_outlined, title: 'Dark mode', value: true, screen: screen),
            _SwitchRow(icon: Icons.notifications_none_rounded, title: 'Notifications', value: true, screen: screen),
            _SwitchRow(icon: Icons.language_rounded, title: 'Language', value: false, screen: screen),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: EdgeInsets.all(screen.spacing(16)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App theme',
                style: TextStyle(
                  fontSize: screen.fontSize(16),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _Pill(label: 'Purple', isDark: isDark),
                  _Pill(label: 'Teal', isDark: isDark),
                  _Pill(label: 'Gradient', isDark: isDark),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommunityBody extends StatelessWidget {
  final ScreenInfo screen;

  const _CommunityBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(screen.spacing(16)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusXl),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _NetworkAvatar(
                    url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                    size: 42,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community post ${index + 1}',
                          style: TextStyle(
                            fontSize: screen.fontSize(15),
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Shared 18 minutes ago',
                          style: TextStyle(
                            fontSize: screen.fontSize(12),
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screen.spacing(14)),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: index.isEven ? AppColors.primaryGradient : AppColors.freelanceGradient,
                  borderRadius: BorderRadius.circular(ProTheme.radiusLg),
                ),
                child: Center(
                  child: Icon(
                    index.isEven ? Icons.photo_library_rounded : Icons.forum_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A compact card layout that keeps text and media readable on small phones and larger tablets.',
                style: TextStyle(
                  fontSize: screen.fontSize(13),
                  height: 1.45,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SimpleInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detail;
  final Color accent;
  final ScreenInfo screen;

  const _SimpleInfoCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.accent,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(screen.spacing(16)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusXl),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.event_available_rounded, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screen.fontSize(15),
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screen.fontSize(13),
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: screen.fontSize(12),
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final Professional professional;
  final ScreenInfo screen;

  const _ProfessionalCard({required this.professional, required this.screen});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = professional.isTrade ? AppColors.trade : AppColors.freelance;

    return Container(
      padding: EdgeInsets.all(screen.spacing(14)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusXl),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _NetworkAvatar(url: professional.avatarUrl, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screen.fontSize(15),
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      professional.profession,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screen.fontSize(12),
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            professional.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screen.fontSize(13),
              height: 1.35,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: AppColors.starFilled),
              const SizedBox(width: 4),
              Text(
                professional.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: screen.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  professional.rateDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool isDark;

  const _Pill({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  final String url;
  final double size;

  const _NetworkAvatar({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            color: AppColors.primary.withValues(alpha: 0.12),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: size * 0.5,
            ),
          );
        },
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isIncoming;
  final bool isDark;

  const _ChatBubble({
    required this.text,
    required this.isIncoming,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final background = isIncoming
        ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
        : AppColors.primary.withValues(alpha: 0.12);

    return Align(
      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isIncoming ? 4 : 18),
            bottomRight: Radius.circular(isIncoming ? 18 : 4),
          ),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;

  const _MiniStatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusXl),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ScreenInfo screen;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: screen.iconSize(20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ScreenInfo screen;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.freelance.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.freelance, size: screen.iconSize(20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }
}

ScreenInfo _screenInfo(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final width = mediaQuery.size.width;
  final height = mediaQuery.size.height;

  DeviceType deviceType;
  if (width < 360) {
    deviceType = DeviceType.mobileSmall;
  } else if (width < 415) {
    deviceType = DeviceType.mobile;
  } else if (width < 600) {
    deviceType = DeviceType.mobileLarge;
  } else if (width < 900) {
    deviceType = DeviceType.tablet;
  } else if (width < 1200) {
    deviceType = DeviceType.tabletLarge;
  } else {
    deviceType = DeviceType.desktop;
  }

  return ScreenInfo(
    width: width,
    height: height,
    safeTop: mediaQuery.padding.top,
    safeBottom: mediaQuery.padding.bottom,
    safeLeft: mediaQuery.padding.left,
    safeRight: mediaQuery.padding.right,
    deviceType: deviceType,
    isLandscape: width > height,
    textScale: mediaQuery.textScaler.scale(1.0),
    pixelRatio: mediaQuery.devicePixelRatio,
  );
}