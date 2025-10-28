import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/subscription_card.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/subscription_controller.dart';
import 'package:ai_dream_interpretation/resources/widgets/feature_list_item.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransparentAppBar(),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.plans.isEmpty) {
                return const Center(child: Text('No plans available'));
              }

              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.plans.length,
                      itemBuilder: (context, index) {
                        final plan = controller.plans[index];

                        // Convert model features to widgets expected by SubscriptionCard
                        final featureWidgets = plan.features
                            .map<FeatureListItem>(
                              (f) => FeatureListItem(
                                text: f.name,
                                isIncluded: f.enabled,
                              ),
                            )
                            .toList();

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 20.h,
                          ),
                          child: Center(
                            child: SubscriptionCard(
                              planName: plan.planName,
                              planColor: plan.planColor,
                              price: plan.price,
                              description: plan.description,
                              features: featureWidgets,
                              buttonText: plan.buttonText,
                              onButtonPressed: () {
                                controller.initiatePayment(plan);
                                print('${plan.planName} selected');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.plans.length,
                      effect: WormEffect(
                        dotHeight: 8.5.h,
                        dotWidth: 10.w,
                        activeDotColor: AppColors.borderGrad1,
                        dotColor: Colors.white,
                      ),
                    ),
                  ),
                  
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
