import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instagram_reel/features/feed/data/models/reel.dart';

class ReelOverlay extends StatefulWidget {
  final Reel reel;

  const ReelOverlay({super.key, required this.reel});

  @override
  State<ReelOverlay> createState() => _ReelOverlayState();
}

class _ReelOverlayState extends State<ReelOverlay> {
  bool expanded = false;
  bool inCart = false;
  bool loading = false;

  Future<void> _addToCart() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
      inCart = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final success = Random().nextBool();

    if (!mounted) {
      return;
    }

    if (!success) {
      setState(() {
        inCart = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add to cart failed. Rolled back.')),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.reel.reelItems.first;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reel.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '₹${item.price}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${widget.reel.viewCount} views',
                      style: const TextStyle(color: Colors.white70),
                    ),

                    if (expanded) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Product ID: ${item.itemId}\n'
                        'Display Order: ${item.displayOrder}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        child: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(inCart ? 'Added To Cart' : 'Add To Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
