import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter/foundation.dart';
import '../Constants/posthog_events.dart';

class PostHogService {
  static PostHogService? _instance;
  static PostHogService get instance {
    _instance ??= PostHogService._();
    return _instance!;
  }

  PostHogService._();

  static final _posthog = Posthog();
  
  Future<void> initialize() async {
    try {
      final apiKey = dotenv.env['POSTHOG_API_KEY']??'';
      final config = PostHogConfig(apiKey);
      config.host = 'https://us.i.posthog.com';
      config.debug = true; //!kReleaseMode;
      config.captureApplicationLifecycleEvents = true;
      // check https://posthog.com/docs/session-replay/installation?tab=Flutter
      // for more config and to learn about how we capture sessions on mobile
      // and what to expect
      config.sessionReplay = true;
      // choose whether to mask images or text
      config.sessionReplayConfig.maskAllTexts = false;
      config.sessionReplayConfig.maskAllImages = false;
      // Setup PostHog with the given Context and Config
      await _posthog.setup(config);
      _posthog.identify(userId: FirebaseAuth.instance.currentUser!.uid);
      capture(PostHogEvents.appOpened);
    } catch ( e) {
      debugPrint('Failed to initialize PostHog: ${e.toString()}');
    }
  }
  
  void identify(String userId, {Map<String, Object>? userProperties}) {
    try {
      _posthog.identify(userId: userId, userProperties: userProperties);
    } catch (e) {
      debugPrint('Failed to identify user in PostHog: $e');
    }
  }
  
  void reset() {
    try {
      _posthog.reset();
    } catch (e) {
      debugPrint('Failed to reset PostHog: $e');
    }
  }
  
  void capture(String event, {Map<String, Object>? properties}) {
    try {
      _posthog.capture(eventName: event, properties: properties);
    } catch (e) {
      debugPrint('Failed to capture event in PostHog: $e');
    }
  }
  
  void captureError(String errorType, {
    String? errorMessage,
    String? stackTrace,
    String? location,
    Map<String, Object>? additionalProperties,
  }) {
    try {
      final properties = <String, Object>{
        'error_type': errorType,
        if (errorMessage != null) 'error_message': errorMessage,
        if (stackTrace != null) 'stack_trace': stackTrace,
        if (location != null) 'location': location,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalProperties,
      };
      
      capture(PostHogEvents.errorOccurred, properties: properties);
    } catch (e) {
      debugPrint('Failed to capture error in PostHog: $e');
    }
  }
  
  void captureClick(String elementName, {
    String? elementType,
    String? screenName,
    Map<String, Object>? additionalProperties,
  }) {
    try {
      final properties = <String, Object>{
        'element_name': elementName,
        if (elementType != null) 'element_type': elementType,
        if (screenName != null) 'screen_name': screenName,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalProperties,
      };
      
      capture(PostHogEvents.buttonClicked, properties: properties);
    } catch (e) {
      debugPrint('Failed to capture click in PostHog: $e');
    }
  }
  
  void captureScreenView(String screenName, {Map<String, Object>? properties}) {
    try {
      final screenProperties = <String, Object>{
        'screen_name': screenName,
        'timestamp': DateTime.now().toIso8601String(),
        ...properties ?? {},
      };
      
      _posthog.screen(screenName: screenName, properties: screenProperties);
    } catch (e) {
      debugPrint('Failed to capture screen view in PostHog: $e');
    }
  }
  
  void flush() {
    try {
      _posthog.flush();
    } catch (e) {
      debugPrint('Failed to flush PostHog: $e');
    }
  }
  
  void disable() {
    try {
      _posthog.disable();
    } catch (e) {
      debugPrint('Failed to disable PostHog: $e');
    }
  }
  
  void enable() {
    try {
      _posthog.enable();
    } catch (e) {
      debugPrint('Failed to enable PostHog: $e');
    }
  }
}