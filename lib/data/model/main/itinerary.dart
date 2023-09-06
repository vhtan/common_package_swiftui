abstract class Itinerary {
  late String title;
  late String buttonTitle;
}

class PickUpItinerary implements Itinerary {
  PickUpItinerary({
    required this.title,
    required this.buttonTitle,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  String title;
  @override
  String buttonTitle;
  final String name;
  final String address;
  final String phone;
}

class RequestFormItinerary implements Itinerary {
  RequestFormItinerary({
    required this.title,
    required this.buttonTitle,
    required this.requestFormId,
    required this.totalAmount,
    required this.type,
  });

  @override
  String title;
  @override
  String buttonTitle;
  final String requestFormId;
  final String totalAmount;
  final String type;
}
