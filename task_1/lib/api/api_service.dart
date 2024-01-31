import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_1/model/dog_data_model.dart';

class ApiService {
  static String domain = "https://api.thedogapi.com/";

  static List<DogDataModel> listOfDog = <DogDataModel>[];

  static int pagesOfResponse = 1;

  static int pageNo = 1;

  static Future<bool> showNextPages() async {
    pageNo++;
    print("pageNo $pageNo");
    print("pagesOfResponse $pagesOfResponse");
    if (pageNo <= pagesOfResponse) {
      await getDogsData(pageNo: pageNo);
      return true;
    }

    return false;
  }

  static Future<List<DogDataModel>?> getDogsData({required int pageNo}) async {
    final url = domain + "/v1/breeds?limit=50&page=$pageNo";

    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    pagesOfResponse =
        (int.parse(response.headers['pagination-count']!) / 50).toInt();

    if (response.statusCode == 200) {
      try {
        print("response.headers ${response.headers}");
        var list = jsonDecode(response.body);

        print("${list.runtimeType}");

        for (int i = 0; i < list.length; i++) {
          listOfDog.add(DogDataModel(
              weight: list[i]["weight"] == null
                  ? null
                  : Weight.fromJson(list[i]["weight"]),
              height: list[i]["height"] == null
                  ? null
                  : Height.fromJson(list[i]["height"]),
              id: list[i]["id"],
              name: list[i]["name"],
              description: list[i]["description"],
              bredFor: list[i]["bred_for"],
              breedGroup: list[i]["breed_group"],
              lifeSpan: list[i]["life_span"],
              history: list[i]["history"],
              temperament: list[i]["temperament"],
              origin: list[i]["origin"],
              referenceImageId: list[i]["reference_image_id"]));
        }
        print("${listOfDog.length}");
        return listOfDog;
      } catch (e) {
        print("DECODE ERROR ${e.toString()}");
      }
    } else {
      return null;
    }
  }
}
