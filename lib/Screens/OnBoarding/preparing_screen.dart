import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';

class PreparingScreen extends StatefulWidget {
  const PreparingScreen({super.key});

  @override
  State<PreparingScreen> createState() => _PreparingScreenState();
}

class _PreparingScreenState extends State<PreparingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _dotController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  int _currentDotCount = 0;
  double _downloadProgress = 0.0;
  String _statusText = 'preparingSubtitle';
  bool _isDownloading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _dotController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentDotCount = (_currentDotCount + 1) % 4;
          });
          _dotController.reset();
          _dotController.forward();
        }
      });

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _dotController.forward();

    _initializeAndDownload();
  }

  Future<void> _initializeAndDownload() async {
    final motherTongue = globalController.userProfile.value.motherTongue;
    final downloadUrl = AppData.appLanguagesMap[motherTongue];

    if (downloadUrl != null && downloadUrl.isNotEmpty) {
      // Check if lessons are already downloaded
      final isAlreadyDownloaded = await _checkIfLessonsExist(motherTongue);
      if (!isAlreadyDownloaded) {
        setState(() {
          _isDownloading = true;
          _statusText = 'downloadingLessons';
        });
        await _downloadAndExtractLessons(downloadUrl, motherTongue);
      } else {
        // Lessons already exist, navigate after brief delay
        await Future.delayed(const Duration(milliseconds: 1500));
        _navigateToMainScreen();
      }
    } else {
      // No download needed for this language (e.g., English)
      await Future.delayed(const Duration(milliseconds: 2500));
      _navigateToMainScreen();
    }
  }

  Future<bool> _checkIfLessonsExist(String language) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final lessonsDir = Directory('${appDocDir.path}/lessons');
      if (!await lessonsDir.exists()) {
        return false;
      }
      // Check if A1 folder exists with at least one lesson file
      final a1Dir = Directory('${lessonsDir.path}/A1');
      if (!await a1Dir.exists()) {
        return false;
      }
      final lessonFile = File('${a1Dir.path}/1.json');
      return await lessonFile.exists();
    } catch (e) {
      debugPrint('Error checking lessons: $e');
      return false;
    }
  }

  Future<void> _downloadAndExtractLessons(String url, String language) async {
    try {
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final zipPath = '${appDocDir.path}/lessons.zip';
      final lessonsDir = appDocDir.path;

      // Download the zip file
      setState(() {
        _statusText = 'downloadingLessons';
      });

      await dio.download(
        url,
        zipPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = (received / total) * 0.7;
            });
          }
        },
      );

      // Extract the zip file
      setState(() {
        _statusText = 'extractingLessons';
        _downloadProgress = 0.7;
      });

      await _extractZipFile(zipPath, lessonsDir);

      // Clean up zip file
      final zipFile = File(zipPath);
      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      setState(() {
        _downloadProgress = 1.0;
        _statusText = 'preparingComplete';
      });

      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToMainScreen();
    } catch (e) {
      debugPrint('Error downloading lessons: $e');
      setState(() {
        _hasError = true;
        _isDownloading = false;
      });
    }
  }

  Future<void> _extractZipFile(String zipPath, String destinationPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final destDir = Directory(destinationPath);
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }

    final totalFiles = archive.files.length;
    var processedFiles = 0;

    for (final file in archive.files) {
      final filename = file.name;
      if (file.isFile) {
        final outputFile = File('$destinationPath/$filename');
        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(file.content as List<int>);
      }else{
        debugPrint('[extractZipFile] Skipping directory: $filename');
      }
      processedFiles++;
      setState(() {
        _downloadProgress = 0.7 + (processedFiles / totalFiles) * 0.3;
      });
    }
    for (var entity in Directory(destinationPath).listSync()) {
    debugPrint('[extractZipFile] ${entity.path}');
  }
  }

  void _navigateToMainScreen() {
    if (mounted) {
      Get.offAll(() => const TabBarScreen());
    }
  }



Future<void> renameFolder(String oldPath, String newPath) async {
  final dir = Directory(oldPath);

  if (!await dir.exists()) {
    throw Exception('Folder does not exist');
  }

  await dir.rename(newPath);
}


  void _retryDownload() {
    setState(() {
      _hasError = false;
      _downloadProgress = 0.0;
    });
    _initializeAndDownload();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  String _getDots() {
    return '.' * _currentDotCount;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              primaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Animated Lottie
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: Get.width * 0.6,
                        height: Get.width * 0.6,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Get.width * 0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Lottie.asset(
                            AppAssets.chatting,
                            decoder: globalController.customDecoder,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                // Main title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _hasError ? 'errorOccurred'.tr : 'preparingTitle'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w800,
                      color: _hasError
                          ? Colors.red
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle with animated dots
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: _hasError
                      ? Column(
                          children: [
                            Text(
                              'downloadError'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppStrings.nunitoFont,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _retryDownload,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'retry'.tr,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppStrings.nunitoFont,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _statusText.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppStrings.nunitoFont,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: Text(
                                _getDots(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppStrings.nunitoFont,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const Spacer(flex: 2),
                // Progress indicator
                if (!_hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: _isDownloading
                        ? Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: _downloadProgress,
                                  minHeight: 6,
                                  backgroundColor:
                                      primaryColor.withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${(_downloadProgress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppStrings.nunitoFont,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          )
                        : TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 2500),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: value,
                                      minHeight: 6,
                                      backgroundColor:
                                          primaryColor.withValues(alpha: 0.2),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${(value * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppStrings.nunitoFont,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
