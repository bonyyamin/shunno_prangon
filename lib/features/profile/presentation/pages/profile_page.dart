// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.userId});
  final String? userId;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditMode = false;
  final TextEditingController _nameController = TextEditingController(
    text: 'ড. আকাশ গাঙ্গুলী',
  );
  final TextEditingController _bioController = TextEditingController(
    text:
        'জ্যোতিঃপদার্থবিজ্ঞানী এবং মহাকাশ গবেষক। বিজ্ঞানের জটিল বিষয়গুলো সহজভাবে উপস্থাপনায় আগ্রহী।',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(authProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (user) => CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProfileHeader(context),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildStatsSection(context),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildTabSection(context),
                  const SizedBox(height: AppConstants.extraLargePadding),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: context.cosmic.nightSkyGradient),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: StarsPainter())),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isEditMode ? Icons.save : Icons.edit),
          onPressed: () {
            setState(() {
              _isEditMode = !_isEditMode;
            });
            if (!_isEditMode) {
              // Save profile changes
              _saveProfile();
            }
          },
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('সেটিংস'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'privacy',
              child: ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('গোপনীয়তা'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: ListTile(
                leading: Icon(Icons.help),
                title: Text('সাহায্য'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('লগ আউট'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final cosmic = context.cosmic;
    final authState = ref.watch(authProvider);

    // Get user data from auth state
    final user = authState.maybeWhen(data: (user) => user, orElse: () => null);

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: cosmic.cosmicGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                if (_isEditMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        iconSize: 20,
                        onPressed: () {
                          // Change profile picture
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _isEditMode
                ? TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'আপনার নাম',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    user?.displayName ?? _nameController.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: AppConstants.smallPadding),
            // Show user email
            if (user?.email != null)
              Text(
                user!.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: AppConstants.smallPadding),
            _isEditMode
                ? TextField(
                    controller: _bioController,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'আপনার সম্পর্কে লিখুন',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    _bioController.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(context, Icons.language, 'ওয়েবসাইট', () {}),
                _buildSocialButton(context, Icons.email, 'ইমেইল', () {}),
                _buildSocialButton(context, Icons.share, 'শেয়ার', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(context, '২৩', 'প্রবন্ধ'),
            _buildDivider(context),
            _buildStatItem(context, '১.২k', 'পাঠক'),
            _buildDivider(context),
            _buildStatItem(context, '৮৯', 'পছন্দ'),
            _buildDivider(context),
            _buildStatItem(context, '৪৫', 'অনুসরণ'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).dividerColor,
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
            isScrollable: true,
            tabs: const [
              Tab(text: 'প্রবন্ধসমূহ'),
              Tab(text: 'খসড়া'),
              Tab(text: 'পছন্দের'),
              Tab(text: 'কার্যকলাপ'),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildArticlesTab(context),
                _buildDraftsTab(context),
                _buildLikedTab(context),
                _buildActivityTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesTab(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 5,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return _buildMyArticleCard(context, index);
      },
    );
  }

  Widget _buildMyArticleCard(BuildContext context, int index) {
    final cosmic = context.cosmic;
    final categories = AppConstants.categories;
    final category = categories[index % categories.length];
    final categoryName = AppConstants.categoriesInBengali[category] ?? category;
    final categoryColor =
        cosmic.categoryColors[category] ??
        Theme.of(context).colorScheme.primary;

    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to article detail
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallBorderRadius,
                  ),
                ),
                child: Icon(_getCategoryIcon(category), color: categoryColor),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'আমার প্রবন্ধ ${index + 1}: $categoryNameর গভীর বিশ্লেষণ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(index + 1) * 250} দর্শন',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Icon(
                          Icons.thumb_up,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(index + 1) * 15}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleArticleAction(value, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('সম্পাদনা')),
                  const PopupMenuItem(value: 'share', child: Text('শেয়ার')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('মুছে ফেলুন'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraftsTab(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 3,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return Card(
          elevation: AppConstants.cardElevation,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  AppConstants.smallBorderRadius,
                ),
              ),
              child: const Icon(Icons.drafts, color: Colors.orange),
            ),
            title: Text('খসড়া প্রবন্ধ ${index + 1}'),
            subtitle: Text('সর্বশেষ সম্পাদিত: ${index + 1} দিন আগে'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleDraftAction(value, index),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'continue',
                  child: Text('চালিয়ে যান'),
                ),
                const PopupMenuItem(
                  value: 'publish',
                  child: Text('প্রকাশ করুন'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('মুছে ফেলুন')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLikedTab(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 4,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return Card(
          elevation: AppConstants.cardElevation,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  AppConstants.smallBorderRadius,
                ),
              ),
              child: const Icon(Icons.favorite, color: Colors.red),
            ),
            title: Text('পছন্দের প্রবন্ধ ${index + 1}'),
            subtitle: Text('লেখক: ড. বিজ্ঞানী ${index + 1}'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to article
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 6,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return _buildActivityItem(context, index);
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, int index) {
    final activities = [
      {
        'icon': Icons.create,
        'text': 'নতুন প্রবন্ধ প্রকাশ করেছেন',
        'time': '২ ঘন্টা আগে',
      },
      {
        'icon': Icons.thumb_up,
        'text': 'একটি প্রবন্ধ পছন্দ করেছেন',
        'time': '৫ ঘন্টা আগে',
      },
      {
        'icon': Icons.comment,
        'text': 'একটি মন্তব্য করেছেন',
        'time': '১ দিন আগে',
      },
      {
        'icon': Icons.bookmark,
        'text': 'একটি প্রবন্ধ সংরক্ষণ করেছেন',
        'time': '২ দিন আগে',
      },
      {
        'icon': Icons.person_add,
        'text': 'নতুন অনুসরণকারী পেয়েছেন',
        'time': '৩ দিন আগে',
      },
      {
        'icon': Icons.share,
        'text': 'একটি প্রবন্ধ শেয়ার করেছেন',
        'time': '১ সপ্তাহ আগে',
      },
    ];

    final activity = activities[index % activities.length];

    return Card(
      elevation: AppConstants.cardElevation,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            activity['icon'] as IconData,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(activity['text'] as String),
        subtitle: Text(activity['time'] as String),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'astronomy':
        return Icons.star_border;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.biotech;
      case 'space_exploration':
        return Icons.rocket_launch;
      case 'cosmology':
        return Icons.public;
      case 'astrophysics':
        return Icons.star;
      case 'particle_physics':
        return Icons.scatter_plot;
      case 'quantum_mechanics':
        return Icons.psychology;
      case 'general_science':
        return Icons.school;
      default:
        return Icons.article;
    }
  }

  void _saveProfile() {
    // Save profile changes to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('প্রোফাইল সংরক্ষণ করা হয়েছে')),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'settings':
        // Navigate to settings
        break;
      case 'privacy':
        // Navigate to privacy settings
        break;
      case 'help':
        // Navigate to help
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _handleArticleAction(String action, int index) {
    switch (action) {
      case 'edit':
        // Navigate to edit article
        break;
      case 'share':
        // Share article
        break;
      case 'delete':
        _showDeleteConfirmationDialog('প্রবন্ধ', () {
          // Delete article
        });
        break;
    }
  }

  void _handleDraftAction(String action, int index) {
    switch (action) {
      case 'continue':
        // Navigate to continue editing
        break;
      case 'publish':
        // Publish draft
        break;
      case 'delete':
        _showDeleteConfirmationDialog('খসড়া', () {
          // Delete draft
        });
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('লগ আউট'),
        content: const Text('আপনি কি নিশ্চিত যে আপনি লগ আউট করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleLogout();
            },
            child: const Text('লগ আউট'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      print('🚪 Logout: Starting logout process...');

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Get auth notifier and sign out
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.signOut();

      print('✅ Logout: Logout successful!');

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('সফলভাবে লগ আউট করা হয়েছে'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Navigate to login page
      if (mounted) {
        context.go(RouteNames.login);
      }
    } catch (error) {
      print('❌ Logout: Failed - $error');

      // Close loading dialog if it's open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('লগ আউটে সমস্যা: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String itemType, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$itemType মুছে ফেলুন'),
        content: Text('আপনি কি নিশ্চিত যে আপনি এই $itemType মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
  }
}

// Reusing the StarsPainter from home_page.dart
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Draw stars at random positions
    final stars = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.4),
      Offset(size.width * 0.2, size.height * 0.9),
    ];

    for (final star in stars) {
      canvas.drawCircle(star, 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
