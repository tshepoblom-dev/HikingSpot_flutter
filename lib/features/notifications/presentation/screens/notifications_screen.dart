// lib/features/notifications/presentation/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/signalr/app_hub_service.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Re-sync the badge count from the server when the screen opens.
    // The hub keeps it up-to-date in real time, but a fresh fetch here
    // ensures correctness after app resumes, reconnect gaps, etc.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appHubServiceProvider.notifier).syncBadgeCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifAsync = ref.watch(notificationsVMProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(notificationsVMProvider.notifier)
                  .markAllAsRead();
              // The server pushes UnreadCountChanged(0) via the hub, which
              // sets unreadBadgeCountProvider to 0 automatically.
              // We also set it directly here for instant local feedback.
              ref.read(unreadBadgeCountProvider.notifier).state = 0;
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notifAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(
          message: e.toString(),
          onRetry: () => ref.refresh(notificationsVMProvider),
        ),
        data: (notifications) => notifications.isEmpty
            ? const HsEmptyState(
                icon: Icons.notifications_none_outlined,
                title: 'All caught up!',
                subtitle: 'You have no notifications.',
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(notificationsVMProvider.notifier)
                      .refresh();
                  // Re-sync badge after manual refresh
                  ref.read(appHubServiceProvider.notifier).syncBadgeCount();
                },
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final n = notifications[i];
                    return Dismissible(
                      key: Key('notif_${n.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: AppColors.primary,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.done_all, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        // Hub will push UnreadCountChanged — badge updates
                        // automatically. No manual invalidation needed.
                        await ref
                            .read(notificationsVMProvider.notifier)
                            .markAsRead(n.id);
                      },
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: n.isRead
                                ? AppColors.background
                                : AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            n.isRead
                                ? Icons.notifications_none
                                : Icons.notifications_active,
                            color: n.isRead
                                ? AppColors.textSecondary
                                : AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          n.title,
                          style: TextStyle(
                            fontWeight: n.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.messageText,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              timeago.format(n.createdAt),
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textHint),
                            ),
                          ],
                        ),
                        tileColor: n.isRead
                            ? null
                            : AppColors.primary.withOpacity(0.03),
                        onTap: n.isRead
                            ? null
                            : () async {
                                await ref
                                    .read(notificationsVMProvider.notifier)
                                    .markAsRead(n.id);
                                // Hub pushes UnreadCountChanged — badge auto-
                                // updates. No explicit set needed here.
                              },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
