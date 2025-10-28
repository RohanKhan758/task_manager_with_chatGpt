import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_controller.dart';
import 'steps/step_welcome.dart';
import 'steps/step_profile_prefs.dart';
import 'steps/step_done.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);

    final steps = [
      const StepWelcome(),
      StepProfilePrefs(
        initialName: state.displayName ?? '',
        initialEmailTips: state.emailTipsEnabled,
        onNameChanged: ctrl.setDisplayName,
        onEmailTipsChanged: ctrl.setEmailTips,
      ),
      const StepDone(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        automaticallyImplyLeading: false,
        actions: [
          if (state.step > 0 && state.step < 2)
            TextButton(
              onPressed: ctrl.complete,
              child: const Text('Skip'),
            )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinearProgressIndicator(value: (state.step + 1) / 3),
                  const SizedBox(height: 16),
                  Expanded(child: steps[state.step]),
                  if (state.error != null && state.error!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (state.step > 0 && state.step < 2)
                        TextButton.icon(
                          onPressed: ctrl.back,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () async {
                          if (state.step == 1) {
                            await ctrl.complete();
                          } else {
                            ctrl.next();
                          }
                        },
                        icon: Icon(state.step == 1 ? Icons.check_circle : Icons.arrow_forward),
                        label: Text(state.step == 1 ? 'Finish' : 'Next'),
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
}
