import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

import '../APIResponse.dart';

class GetReserveProcessor extends APIResponseProcessor<List<Reservation>>{
  const GetReserveProcessor();

  @override
  bool isKeyMatch(String key) => key == "get-reservation";

  @override
  Tuple2<List<Reservation>?,String> process(json) {
    json as Map<String,dynamic>;
    Map<String,dynamic> jsonMap = json;
    List<Reservation>? reservations = (jsonMap["reservations"] as List<dynamic>).map((e) => Reservation.fromJson(e)).toList();

    if(reservations == null){
      return const Tuple2(null, "予約の取得に失敗しました");
    }

    return Tuple2(reservations, "予約の取得に成功しました");
  }
}