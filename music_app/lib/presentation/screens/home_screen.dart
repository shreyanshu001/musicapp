import 'package:flutter/material.dart';
import 'package:music_app/presentation/providers/music_service_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/service_card.dart';
import 'service_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load services when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicServicesProvider>().loadMusicServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppConstants.homeTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<MusicServicesProvider>().retry();
            },
            icon: Icon(
              Icons.refresh,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Consumer<MusicServicesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState(theme);
          }

          if (provider.hasError) {
            return _buildErrorState(context, provider, theme);
          }

          if (provider.hasData) {
            return _buildServicesGrid(context, provider, theme);
          }

          return _buildEmptyState(theme);
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.loadingMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, MusicServicesProvider provider, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.errorMessage,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppConstants.retryButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(
      BuildContext context, MusicServicesProvider provider, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.gridCrossAxisCount,
          childAspectRatio: AppConstants.gridChildAspectRatio,
          crossAxisSpacing: AppConstants.gridSpacing,
          mainAxisSpacing: AppConstants.gridSpacing,
        ),
        itemCount: provider.services.length,
        itemBuilder: (context, index) {
          final service = provider.services[index];
          return ServiceCard(
            service: service,
            onTap: () => _navigateToServiceDetail(context, service.title),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 64,
            color: theme.colorScheme.onBackground.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.noServicesMessage,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToServiceDetail(BuildContext context, String serviceName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(serviceName: serviceName),
      ),
    );
  }
}
