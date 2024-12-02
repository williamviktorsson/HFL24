import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChristmasTheme {
  // Base colors
  static const red = Color(0xFFC41E3A); // Traditional Christmas red
  static const green = Color(0xFF165B33); // Deep Christmas green
  static const gold = Color(0xFFFFD700); // Festive gold
  static const snow = Color(0xFFF8F9FA); // Snow white
  static const darkGreen = Color(0xFF146B3A); // Holly green
  static const lightRed = Color(0xFFFF6B6B); // Light festive red

  // New colors for list items
  static const selectedTile =
      Color(0xFF2F4F4F); // Darker blueGrey for selection
  static const selectedText =
      Color(0xFFFFB74D); // Warmer orange for selected text

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        // Core color scheme
        colorScheme: ColorScheme.light(
          primary: green,
          onPrimary: snow,
          primaryContainer: green.withOpacity(0.8),
          onPrimaryContainer: snow,
          secondary: red,
          onSecondary: snow,
          secondaryContainer: red.withOpacity(0.8),
          onSecondaryContainer: snow,
          tertiary: gold,
          onTertiary: green,
          tertiaryContainer: gold.withOpacity(0.8),
          onTertiaryContainer: green,
          surface: snow,
          onSurface: green,
          onSurfaceVariant: green,
          error: lightRed,
          onError: snow,
        ),
        fontFamily: GoogleFonts.mountainsOfChristmas().fontFamily,

        // Typography
        textTheme: GoogleFonts.mountainsOfChristmasTextTheme(TextTheme(
          displayLarge: GoogleFonts.mountainsOfChristmas(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          displayMedium: GoogleFonts.mountainsOfChristmas(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          displaySmall: GoogleFonts.mountainsOfChristmas(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          headlineLarge: GoogleFonts.mountainsOfChristmas(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          headlineMedium: GoogleFonts.mountainsOfChristmas(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          headlineSmall: GoogleFonts.mountainsOfChristmas(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: red,
          ),
          titleLarge: GoogleFonts.mountainsOfChristmas(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: green,
          ),
          titleMedium: GoogleFonts.mountainsOfChristmas(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: green,
          ),
          titleSmall: GoogleFonts.mountainsOfChristmas(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: green,
          ),
          bodyLarge: GoogleFonts.mountainsOfChristmas(
            fontSize: 16,
            color: green,
          ),
          bodyMedium: GoogleFonts.mountainsOfChristmas(
            fontSize: 14,
            color: green,
          ),
          bodySmall: GoogleFonts.mountainsOfChristmas(
            fontSize: 12,
            color: green,
          ),
          labelLarge: GoogleFonts.mountainsOfChristmas(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: snow,
          ),
        )),

        // Enhanced AppBar theme for hero animations
        appBarTheme: AppBarTheme(
          backgroundColor: selectedTile, // Matches your blueGrey
          foregroundColor: selectedText, // Matches your orangeAccent
          titleTextStyle: GoogleFonts.mountainsOfChristmas(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: selectedText,
          ),
          iconTheme: const IconThemeData(
            color: selectedText,
          ),
        ),

        // ListTile theme for consistent selection states
        listTileTheme: ListTileThemeData(
          selectedTileColor: selectedTile,
          selectedColor: selectedText,
          iconColor: green,
          textColor: green,
          titleTextStyle: GoogleFonts.mountainsOfChristmas(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selectedText,
          ),
          // Subtle hover effect
          mouseCursor: WidgetStateMouseCursor.clickable,
          tileColor: Colors.transparent,
          horizontalTitleGap: 16,
        ),

        // Card theme for Material wrapper
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.transparent,
        ),

        // Navigation Rail theme
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: green,
          selectedIconTheme: IconThemeData(color: gold),
          unselectedIconTheme: IconThemeData(color: snow.withOpacity(0.7)),
          selectedLabelTextStyle: GoogleFonts.mountainsOfChristmas(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelTextStyle: GoogleFonts.mountainsOfChristmas(
            color: snow.withOpacity(0.7),
          ),
        ),

        // Navigation Bar theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: green,
          indicatorColor: gold.withOpacity(0.3),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: gold);
            }
            return IconThemeData(color: snow.withOpacity(0.7));
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return GoogleFonts.mountainsOfChristmas(color: gold);
            }
            return GoogleFonts.mountainsOfChristmas(
                color: snow.withOpacity(0.7));
          }),
        ),

        // Input Decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: snow,
          prefixIconColor: green,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: green.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: green, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: green.withOpacity(0.3)),
          ),
          labelStyle:
              GoogleFonts.mountainsOfChristmas(color: green.withOpacity(0.7)),
        ),

        // Button themes
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return red.withOpacity(0.8);
              }
              return red;
            }),
            foregroundColor: WidgetStateProperty.all(snow),
            textStyle: WidgetStateProperty.all(
              GoogleFonts.mountainsOfChristmas(fontWeight: FontWeight.bold),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return green.withOpacity(0.8);
              }
              return green;
            }),
            foregroundColor: WidgetStateProperty.all(snow),
          ),
        ),

        // Icon theme
        iconTheme: IconThemeData(
          color: green,
        ),

        // Progress indicator theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: red,
          linearTrackColor: red.withOpacity(0.2),
          circularTrackColor: red.withOpacity(0.2),
        ),

        // Divider theme
        dividerTheme: DividerThemeData(
          color: green.withOpacity(0.2),
          thickness: 1,
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: gold,
          contentTextStyle: GoogleFonts.mountainsOfChristmas(color: red),
          actionTextColor: snow,
        ),
      );
}
