// widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue[300]!,
      highlightColor: Colors.blue[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildShimmerCard(
              child: Column(
                children: [
                  _buildShimmerRow(),
                  const SizedBox(height: 16),
                  _buildShimmerRow(),
                  const SizedBox(height: 16),
                  _buildShimmerRow(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildShimmerCard(
              child: Column(
                children: [
                  _buildShimmerRow(),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildShimmerRow(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildShimmerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < 5; i++) ...[
                    _buildShimmerRow(),
                    if (i < 4) const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          height: 60,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
