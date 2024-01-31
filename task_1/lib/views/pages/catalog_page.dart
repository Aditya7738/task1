import 'package:flutter/material.dart';
import 'package:task_1/api/api_service.dart';
import 'package:task_1/constants/constants.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/dog_data_model.dart';
import 'package:badges/badges.dart' as badges;
import 'package:task_1/model/user_model.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/dog_details.dart';
import 'package:task_1/views/pages/login.dart';
import 'package:task_1/views/pages/wishlist_page.dart';
import 'package:provider/provider.dart';
import 'package:task_1/views/widgets/dog_list_item.dart';

class CatalogPage extends StatefulWidget {
  final UserModel userModel;
  const CatalogPage({super.key, required this.userModel});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late UserModel userModel;
  final ScrollController _scrollController = ScrollController();
  bool dataLoading = true;

  bool isLoading = false;

  bool isThereMoreDogs = false;

  Future<void> getData() async {
    ApiService.listOfDog.clear();
    await ApiService.getDogsData(pageNo: 1);
    setState(() {
      dataLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void loadMoreData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch more data (e.g., using ApiService)
    isThereMoreDogs = await ApiService.showNextPages();

    setState(() {
      isLoading = false;
    });
  }

  late DBHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    createWishListTable();

    userModel = widget.userModel;
    getData();
    _scrollController.addListener(() async {
      print(
          "CONDITION ${_scrollController.position.pixels == _scrollController.position.maxScrollExtent}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("REACHED END OF LIST");

        loadMoreData();
      }
    });
  }

  Future<void> createWishListTable() async {
    await dbHelper.createWishlistTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Catalog"),
          actions: [
            SizedBox(
              height: 40.0,
              width: 32.0,
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.purple),
                badgeContent: Consumer<WishlistProvider>(
                    builder: (context, value, child) {
                  print("LENGTH OF FAV: ${value.favDogIds}");
                  return Text(
                    value.favDogIds.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                }),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WishListPage()));
                  },
                  icon: const Icon(Icons.favorite_sharp, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            SizedBox(
              height: 40.0,
              width: 32.0,
              child: GestureDetector(
                onTap: () {
                  dbHelper.updateLogout(userModel.userId);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                child: Icon(
                  Icons.logout,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        body: dataLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Padding(
                padding: EdgeInsets.all(5.0),
                child: Scrollbar(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.64,
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 10.0),
                    itemCount: ApiService.listOfDog.length +
                        (isLoading || !isThereMoreDogs ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < ApiService.listOfDog.length) {
                        return DogListItem(
                          dogDataModel: ApiService.listOfDog[index],
                        );
                      } else if (!isThereMoreDogs) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Center(
                              child: Text(
                            "No more dogs are left",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black)),
                        );
                      }
                    },
                  ),
                ),
              ));
  }
}
