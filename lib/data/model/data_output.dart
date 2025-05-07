import 'package:flutter/material.dart';

class DataOutput<T> {
  final int total;
  final List<T> modelList;
  final ExtraData? extraData;
  final int? page;

  DataOutput({
    required this.total,
    required this.modelList,
    this.extraData,
    this.page,
  });

  DataOutput<T> copyWith({
    int? total,
    List<T>? modelList,
    ExtraData? extraData,
    int? page,
  }) {
    return DataOutput<T>(
      total: total ?? this.total,
      modelList: modelList ?? this.modelList,
      extraData: extraData ?? this.extraData,
      page: page ?? this.page,
    );
  }
}

@protected
class ExtraData<T> {
  final T data;

  ExtraData({
    required this.data,
  });
}
