import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/itinerary.dart';

class ItineraryContainer extends StatelessWidget {
  const ItineraryContainer({
    Key? key,
    required this.itinerary,
    required this.onPressed,
  }) : super(key: key);

  final Itinerary itinerary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (itinerary is PickUpItinerary) {
      PickUpItinerary pickUp = itinerary as PickUpItinerary;
      return renderPickUpItinerary(pickUp);
    } else if (itinerary is RequestFormItinerary) {
      RequestFormItinerary request = itinerary as RequestFormItinerary;
      return renderRequestFormItinerary(request);
    } else {
      return const EmptyWidget(message: 'message');
    }
  }

  Widget renderPickUpItinerary(PickUpItinerary itinerary) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.map),
              const SizedBox(width: 10),
              Text(
                itinerary.address,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text(
                itinerary.phone,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButton(
            title: itinerary.buttonTitle,
            buttonHeight: 50,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget renderRequestFormItinerary(RequestFormItinerary itinerary) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.api_sharp),
              const SizedBox(width: 10),
              Text(
                itinerary.requestFormId,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.money_rounded),
              const SizedBox(width: 10),
              Text(
                itinerary.totalAmount,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.account_balance),
              const SizedBox(width: 10),
              Text(
                itinerary.type,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButton(
            title: itinerary.buttonTitle,
            buttonHeight: 50,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
