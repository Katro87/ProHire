import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../providers/app_provider.dart';
import '../../data/models/professional_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/shimmer_widgets.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Activity',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Hired'),
            Tab(text: 'Services'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHiredTab(isDark),
          _buildServicesTab(isDark),
          _buildHistoryTab(isDark),
        ],
      ),
    );
  }

  Widget _buildHiredTab(bool isDark) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return ListView.builder(
            padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
            itemCount: 5,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: ShimmerListItem(),
            ),
          );
        }

        final hiredRequests = provider.hireHistory
            .where((h) => h.status != 'completed' && h.status != 'cancelled')
            .toList();

        if (hiredRequests.isEmpty) {
          return EmptyStateWidget(
            title: 'No Active Hires',
            subtitle: 'You haven\'t hired any professionals yet. Browse and find the perfect match for your needs.',
            icon: Icons.handshake_outlined,
            actionLabel: 'Browse Professionals',
            onAction: () {
              provider.setNavIndex(0);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadData(),
          child: ListView.builder(
            padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
            itemCount: hiredRequests.length,
            itemBuilder: (context, index) {
              final hire = hiredRequests[index];
              return _buildHireCard(hire, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildServicesTab(bool isDark) {
    return EmptyStateWidget(
      title: 'Coming Soon',
      subtitle: 'You\'ll be able to post and manage your own services here. This feature is under development.',
      icon: Icons.construction_rounded,
    );
  }

  Widget _buildHistoryTab(bool isDark) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return ListView.builder(
            padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
            itemCount: 5,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: ShimmerListItem(),
            ),
          );
        }

        final historyRequests = provider.hireHistory
            .where((h) => h.status == 'completed' || h.status == 'cancelled')
            .toList();

        if (historyRequests.isEmpty) {
          return EmptyStateWidget(
            title: 'No History',
            subtitle: 'Your completed and cancelled hire requests will appear here.',
            icon: Icons.history_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadData(),
          child: ListView.builder(
            padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
            itemCount: historyRequests.length,
            itemBuilder: (context, index) {
              final hire = historyRequests[index];
              return _buildHireCard(hire, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildHireCard(HireRequest hire, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showHireDetails(hire),
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            hire.professional.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hire.professional.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hire.professional.profession,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: hire.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildInfoItem(
                          Icons.calendar_today_rounded,
                          _formatDate(hire.hireDate),
                          isDark,
                        ),
                        const SizedBox(width: 24),
                        _buildInfoItem(
                          Icons.access_time_rounded,
                          _formatTime(hire.hireDate),
                          isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<AppProvider>().selectProfessional(
                                hire.professional);
                            Navigator.pushNamed(
                                context, '/professional-profile');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('View Profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showHireDetails(hire),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Details'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _showHireDetails(HireRequest hire) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hire Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Professional', hire.professional.name, isDark),
            _buildDetailRow('Service', hire.professional.profession, isDark),
            _buildDetailRow('Date', _formatFullDate(hire.hireDate), isDark),
            _buildDetailRow('Time', _formatTime(hire.hireDate), isDark),
            _buildDetailRow('Status', hire.status.toUpperCase(), isDark),
            if (hire.message.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Message',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hire.message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
