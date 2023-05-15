import 'package:car_dealership/presentation/core/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/application.dart';
import '../../../../domain/domain.dart';
import '../../../core/widgets/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: const Profile(),
    );
  }
}

class Profile extends ConsumerWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileUiState = ref.watch(profileStateNotifierProvider);

    if (profileUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (profileUiState.currentState == ViewState.error) {
      return switch (profileUiState.error) {
        MessageException(:final exception) => Center(child: Text('An error occurred: ${exception.toString()}')),
        AuthRequiredException() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  const AuthRequiredException().toString(),
                ),
                const SizedBox(height: Constants.verticalGutter),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Log in'),
                ),
              ],
            ),
          ),
        _ => const SizedBox.shrink(),
      };
    }

    if (profileUiState.currentState == ViewState.success) {
      return const Center(
        child: Text('Logged In successfully'),
      );
    }

    return const SizedBox.shrink();
  }
}
