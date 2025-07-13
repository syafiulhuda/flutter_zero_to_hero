import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

ValueNotifier<bool> isLoading = ValueNotifier(false);

ValueNotifier<bool> isFirebaseInitialized = ValueNotifier(false);
