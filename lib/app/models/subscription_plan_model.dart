// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/app/models/subscription_feature_model.dart';
import 'package:flutter/material.dart';

class SubscriptionPlan {
  final int id;
  final String planName;
  final String description;
  final String price;
  final List<SubscriptionFeature> features;

  final Color planColor;
  final String priceId;
  final String buttonText;

  SubscriptionPlan({
    required this.id,
    required this.planName,
    required this.description,
    required this.price,
    required this.features,
    required this.planColor,
    required this.priceId,
    required this.buttonText,
  });

  factory SubscriptionPlan.fromJson(
    Map<String, dynamic> json, {
    required Color planColor,
    required String priceId,
    required String buttonText,
  }) {
    
    int idVal = 0;
    try {
      if (json['id'] is int) {
        idVal = json['id'];
      } else if (json['id'] is String) {
        idVal = int.tryParse(json['id']) ?? 0;
      }
    } catch (_) {
      idVal = 0;
    }

    
    String planName =
        (json['user_plan'] ??
                json['plan_name'] ??
                json['name'] ??
                json['plan'] ??
                '')
            .toString();

    final description = (json['description'] ?? json['desc'] ?? '').toString();

    
    double priceNum = 0;
    try {
      final p = json['price'];
      if (p is num) {
        priceNum = p.toDouble();
      } else if (p is String) {
        
        final cleaned = p
            .replaceAll(RegExp(r'[^0-9\.,]'), '')
            .replaceAll(',', '.');
        priceNum = double.tryParse(cleaned) ?? 0;
      }
    } catch (_) {
      priceNum = 0;
    }

    final priceStr =
        '\$${priceNum.toStringAsFixed(priceNum.truncateToDouble() == priceNum ? 0 : 2)}/mo';

    
    List<dynamic> featuresList = [];
    if (json['features'] is List) {
      featuresList = json['features'];
    } else if (json['items'] is List) {
      featuresList = json['items'];
    }

    List<SubscriptionFeature> parsedFeatures = featuresList
        .map((featureJson) {
          try {
            return SubscriptionFeature.fromJson(featureJson);
          } catch (_) {
            return SubscriptionFeature(
              name: featureJson.toString(),
              enabled: true,
            );
          }
        })
        .cast<SubscriptionFeature>()
        .toList();

    return SubscriptionPlan(
      id: idVal,
      planName: planName,
      description: description,
      price: priceStr,
      features: parsedFeatures,
      planColor: planColor,
      priceId: priceId,
      buttonText: buttonText,
    );
  }
}
