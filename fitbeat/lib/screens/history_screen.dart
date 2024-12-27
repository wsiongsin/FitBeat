import 'package:flutter/cupertino.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Exercises',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('New'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
