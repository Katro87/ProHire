import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors_v2.dart';
import '../core/theme/pro_theme_v2.dart';
import '../data/models/models.dart';

/// Premium Glass Card with blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 10,
    this.backgroundColor,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor ?? (isDark 
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.7)),
                borderRadius: BorderRadius.circular(borderRadius),
                border: border ?? Border.all(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium Button with gradient and animations
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? color;
  final double height;
  final double? width;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double borderRadius;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.color,
    this.height = 56,
    this.width,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.borderRadius = 14,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ProTheme.fastDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = widget.gradient ?? AppColors.primaryGradient;
    final effectiveColor = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: ProTheme.fastDuration,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isOutlined ? null : effectiveGradient,
            color: widget.isOutlined ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.isOutlined
                ? Border.all(color: effectiveColor, width: 2)
                : null,
            boxShadow: widget.isOutlined || _isPressed
                ? null
                : [
                    BoxShadow(
                      color: effectiveColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.isOutlined ? effectiveColor : Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.isOutlined ? effectiveColor : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.isOutlined ? effectiveColor : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Animated Professional Card
class ProfessionalCard extends StatefulWidget {
  final Professional professional;
  final VoidCallback onTap;
  final VoidCallback? onHire;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.onTap,
    this.onHire,
  });

  @override
  State<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends State<ProfessionalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pro = widget.professional;
    final isTrade = pro.isTrade;
    final accentColor = isTrade ? AppColors.trade : AppColors.freelance;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(ProTheme.radiusLg),
            boxShadow: isDark ? null : AppColors.softShadow,
            border: isDark
                ? Border.all(color: AppColors.borderDark, width: 1)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Avatar
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(ProTheme.radiusLg),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.1),
                            accentColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(ProTheme.radiusLg),
                        ),
                        child: Image.network(
                          pro.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: accentColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Badges
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        children: [
                          if (pro.isVerified)
                            _buildBadge(
                              icon: Icons.verified,
                              color: AppColors.primary,
                              isDark: isDark,
                            ),
                          if (pro.isTopRated) ...[
                            const SizedBox(width: 6),
                            _buildBadge(
                              icon: Icons.star,
                              color: AppColors.starFilled,
                              isDark: isDark,
                            ),
                          ],
                          const Spacer(),
                          if (!pro.isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black54
                                    : Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Busy',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textTertiaryLight,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Type Badge
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: isTrade
                              ? AppColors.tradeGradient
                              : AppColors.freelanceGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isTrade ? 'Trade' : 'Freelance',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Info Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        pro.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Profession
                      Text(
                        pro.profession,
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // Rating and Rate
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.starFilled,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            pro.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            ' (${pro.reviewCount})',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            pro.rateDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}

/// Category Chip with animation
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTrade = category.type == ProfessionalType.trade;
    final accentColor = isTrade ? AppColors.trade : AppColors.freelance;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ProTheme.normalDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? (isTrade ? AppColors.tradeGradient : AppColors.freelanceGradient)
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(ProTheme.radiusFull),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Search Bar with glass effect
class PremiumSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool autofocus;

  const PremiumSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onFilterTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search_rounded,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            Container(
              width: 1,
              height: 24,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rating Stars
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star_rounded;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(
          icon,
          size: size,
          color: rating >= starValue - 0.5
              ? (color ?? AppColors.starFilled)
              : AppColors.starEmpty,
        );
      }),
    );
  }
}

/// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsets? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionText!),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty State Widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              PremiumButton(
                text: actionText!,
                onPressed: onAction!,
                width: 200,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer Loading Effect
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: isDark
                  ? [
                      AppColors.cardDark,
                      AppColors.surfaceDark,
                      AppColors.cardDark,
                    ]
                  : [
                      AppColors.dividerLight,
                      Colors.white,
                      AppColors.dividerLight,
                    ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer Professional Card
class ShimmerProfessionalCard extends StatelessWidget {
  const ShimmerProfessionalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: ProTheme.radiusLg,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 100, height: 14, borderRadius: 4),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 70, height: 12, borderRadius: 4),
                  const Spacer(),
                  Row(
                    children: [
                      ShimmerBox(width: 60, height: 12, borderRadius: 4),
                      const Spacer(),
                      ShimmerBox(width: 50, height: 14, borderRadius: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
