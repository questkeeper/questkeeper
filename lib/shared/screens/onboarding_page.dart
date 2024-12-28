import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: _titleWidget(
                "Welcome to QuestKeeper",
              ),
              image: buildLottieAnimation(
                'assets/lottie/tasks.lottie',
                size: 300,
              ),
              body:
                  "Transform your tasks into exciting quests and achieve more with gamified productivity.",
            ),
            PageViewModel(
              titleWidget: _titleWidget("Gamify Your Productivity"),
              body:
                  "Earn points and badges for completing tasks, and challenge friends to beat your scores.",
              image: buildLottieAnimation('assets/lottie/badge.lottie'),
            ),
            PageViewModel(
              titleWidget: _titleWidget("Customize your notifications"),
              body: "Personalize your notifications so you never fall behind.",
              image:
                  buildLottieAnimation('assets/lottie/bell.lottie', size: 175),
            ),
          ],
          onDone: () async {
            // Navigate to the main app
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool("onboarded", true);

            if (!context.mounted) return;
            Navigator.popAndPushNamed(context, "/");
          },
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Icon(LucideIcons.arrow_right),
          done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
            size: const Size(10, 10),
            activeSize: const Size(22, 10),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLottieAnimation(String assetPath, {double size = 200}) {
    return Center(
      child: DotLottieLoader.fromAsset(
        assetPath,
        frameBuilder: (ctx, dotlottie) {
          if (dotlottie != null) {
            return Lottie.memory(dotlottie.animations.values.single,
                width: size,
                height: size,
                fit: BoxFit.fill,
                onLoaded: (_) {}, imageProviderFactory: (asset) {
              return MemoryImage(dotlottie.images[asset.fileName]!);
            });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _titleWidget(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
