// Flutter imports:
import 'package:flutter/material.dart';

Widget centeredLinearProgress(BuildContext context) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: const LinearProgressIndicator(),
    ),
  );
}

Widget centeredCircularProgress() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
