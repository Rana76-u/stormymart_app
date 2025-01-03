import 'package:flutter/material.dart';

class ErrorsAndEmptyMessages {
  static Widget errorBody(String message) {
    return Center(
      child: Text(message),
    );
  }

  static Widget emptyMessage() {
    return const Center(
      child: Text('Empty'),
    );
  }

  static Widget nothingToShowMessage() {
    return const Center(
      child: Text(
          'NOTHING TO SHOW'
      ),
    );
  }
}