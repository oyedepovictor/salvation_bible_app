import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScripturesContainer extends StatelessWidget {
  final String scriptureIndex;
  final String scriptureVerse;
  final String scriptureNumberOfChapters;
  final String? badgeText;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const ScripturesContainer({
    super.key,
    required this.scriptureIndex,
    required this.scriptureVerse,
    required this.scriptureNumberOfChapters,
    this.badgeText,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor = isHighlighted
        ? scheme.primary.withValues(alpha: 0.08)
        : scheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted
                ? scheme.primary.withValues(alpha: 0.25)
                : scheme.primary.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Number Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: isHighlighted
                  ? scheme.primary.withValues(alpha: 0.2)
                  : scheme.primary.withValues(alpha: 0.1),
              child: Text(
                scriptureIndex,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Book Name and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          scriptureVerse,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9E4CB), // Soft peach badge
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText!,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF4A3E2C),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scriptureNumberOfChapters,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Right Chevron Arrow
            Icon(
              Icons.chevron_right,
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
