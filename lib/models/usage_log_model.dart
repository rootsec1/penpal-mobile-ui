/*
usageStatsEntries.add({
  "package_name": usageInfo.packageName,
  "total_time_in_foreground": usageInfo.totalTimeInForeground,
});
*/

class UsageLogModel {
  final String packageName;
  final int totalTimeInForeground;

  UsageLogModel({
    required this.packageName,
    required this.totalTimeInForeground,
  });

  Map<String, dynamic> toJson() {
    return {
      "package_name": packageName,
      "total_time_in_foreground": totalTimeInForeground,
    };
  }

  factory UsageLogModel.fromJson(Map<String, dynamic> json) {
    return UsageLogModel(
      packageName: json['package_name'],
      totalTimeInForeground: json['total_time_in_foreground'],
    );
  }
}
