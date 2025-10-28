class SubscriptionFeature {
  final String name;
  final bool enabled;

  SubscriptionFeature({required this.name, required this.enabled});

  factory SubscriptionFeature.fromJson(Map<String, dynamic> json) {
    return SubscriptionFeature(name: json['name'], enabled: json['enabled']);
  }
}
