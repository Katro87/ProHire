import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/services/request_service.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../data/models/request_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _requestService = RequestService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view requests.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'New Request'),
            Tab(text: 'Accepted'),
          ],
        ),
      ),
      body: StreamBuilder<List<RequestItem>>(
        stream: _requestService.watchRequestsForReceiver(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load requests right now.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!;
          final pending = requests.where((r) => r.status == 'pending').toList();
          final accepted = requests.where((r) => r.status == 'accepted').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRequestList(pending, user.uid, isDark),
              _buildRequestList(accepted, user.uid, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequestList(List<RequestItem> items, String uid, bool isDark) {
    if (items.isEmpty) {
      return const Center(child: Text('No requests found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildRequestCard(item, uid, isDark);
      },
    );
  }

  Widget _buildRequestCard(RequestItem request, String uid, bool isDark) {
    final isReceiver = request.receiverId == uid;
    final peerSnapshot = isReceiver ? request.senderSnapshot : request.receiverSnapshot;
    final peerName = peerSnapshot?['name'] as String? ?? 'User';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: peerSnapshot?['profileImageUrl'] != null
                      ? NetworkImage(peerSnapshot?['profileImageUrl'])
                      : null,
                  child: peerSnapshot?['profileImageUrl'] != null
                      ? null
                      : const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    peerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _statusChip(request.status),
              ],
            ),
            const SizedBox(height: 12),
            if (request.status == 'pending')
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'New Request',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            Text('Description: ${request.description}'),
            Text('Requirements: ${request.requirements}'),
            Text('Duration: ${request.duration}'),
            Text('Hourly Pay: ${request.hourlyPay.toStringAsFixed(0)}'),
            if (isReceiver && request.status == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _requestService.updateStatus(request.id, 'rejected'),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _requestService.updateStatus(request.id, 'accepted'),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'accepted':
        color = AppColors.success;
        break;
      case 'rejected':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
