import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';

List<PurposeResponse> parsePurposeResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => PurposeResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}
