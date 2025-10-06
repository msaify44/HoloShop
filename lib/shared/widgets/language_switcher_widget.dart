import 'package:flutter/material.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';

class LanguageSwitcher extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const LanguageSwitcher({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageBottomSheet(context),
      child: const Icon(Icons.language, color: Colors.black),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.dp20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Dimensions.dp20),

              // Title
              Text(
                'Select Language',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: Dimensions.dp20),

              // Language options
              _LanguageOptions(
                languageName: 'English',
                languageCode: 'en',
                onLanguageChanged: onLanguageChanged,
              ),
              const SizedBox(height: Dimensions.dp12),
              _LanguageOptions(
                languageName: 'العربية',
                languageCode: 'ar',
                onLanguageChanged: onLanguageChanged,
              ),
              const SizedBox(height: Dimensions.dp20),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOptions extends StatelessWidget {
  final String languageName;
  final String languageCode;
  final Function(Locale) onLanguageChanged;

  const _LanguageOptions({
    super.key,
    required this.languageName,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        languageName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onLanguageChanged.call(Locale(languageCode));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.dp8),
      ),
      tileColor: Colors.grey[50],
    );
  }
}

