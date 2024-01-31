import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final String label;
  final String info;
  const DetailWidget({super.key, required this.label, required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Text(
            info,
            maxLines: 3,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
