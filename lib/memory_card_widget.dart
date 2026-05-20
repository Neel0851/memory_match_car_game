import 'dart:math';
import 'package:flutter/material.dart';
import 'card_model.dart';

class MemoryCardWidget extends StatelessWidget {
  final CarCardModel card;
  final VoidCallback onTap;

  const MemoryCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, fixedChild) {
              final isBack = (ValueKey(card.isFlipped) != child.key);
              final value = isBack ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // 3D depth perspective
                  ..rotateY(value),
                alignment: Alignment.center,
                child: fixedChild,
              );
            },
          );
        },
        child: card.isFlipped || card.isMatched
            ? _buildFrontFace(context)
            : _buildBackFace(),
      ),
    );
  }

  // Enforces exact same sizing layout constraints for all front car images
  Widget _buildFrontFace(BuildContext context) {
    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F26), // Solid layout theme color
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withOpacity(0.8), width: 2), // Grid frame alignment
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14), // Prevents image edges from bleeding outside border
        child: SizedBox.expand( // Forces the image container to perfectly match matching grid proportions
          child: Image.asset(
            card.imagePath,
            fit: BoxFit.cover, // Crops from center and keeps size completely identical across all 16 items
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF1D1135),
                alignment: Alignment.center,
                child: Text(
                  card.carName.substring(0, min(3, card.carName.length)).toUpperCase(),
                  style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackFace() {
    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox.expand( // Matches dimensions exactly with the front face layout setup
          child: Image.asset(
            'assets/images/card_back.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.directions_car, color: Colors.purpleAccent, size: 40),
              );
            },
          ),
        ),
      ),
    );
  }
}