// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

class SubscriptionFeature {
  final String name;
  final bool enabled;

  SubscriptionFeature({required this.name, required this.enabled});

  factory SubscriptionFeature.fromJson(Map<String, dynamic> json) {
    return SubscriptionFeature(name: json['name'], enabled: json['enabled']);
  }
}
