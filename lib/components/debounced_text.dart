import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

/// Custom Flutter Hook for a debounced TextEditingController.
TextEditingController useDebouncedTextController(
    void Function(String) onDebounce) {
  // Create a TextEditingController for capturing text input.
  final textController = useTextEditingController();

  // useEffect is used to subscribe and unsubscribe to the debounced stream.
  useEffect(() {
    // Create a BehaviorSubject to handle the debouncing logic.
    final behaviorSubject = BehaviorSubject<String>();
    StreamSubscription? streamSubscription;

    // Add a listener to the TextEditingController.
    textController.addListener(() {
      // Add the current text value to the BehaviorSubject.
      behaviorSubject.add(textController.text);
    });

    // Subscribe to the debounced stream.
    streamSubscription = behaviorSubject
        .where((event) =>
            event.length >= 3) // Adjust the minimum length as needed.
        .debounceTime(const Duration(
            milliseconds: 500)) // Adjust the debounce time as needed.
        .distinct()
        .listen((event) {
      // Perform the desired action when debounced text changes.
      onDebounce(event);
    });

    // Cleanup: Cancel the stream subscription and close the BehaviorSubject.
    return () {
      streamSubscription?.cancel();
      behaviorSubject.close();
    };
  }, [textController]); // Re-run the effect when the textController changes.

  // Return the debounced TextEditingController.
  return textController;
}
