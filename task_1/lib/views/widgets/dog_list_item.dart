import 'package:flutter/material.dart';
import 'package:task_1/constants/constants.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/dog_data_model.dart';
import 'package:task_1/model/dog_image_model.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/dog_details.dart';
import 'package:provider/provider.dart';

class DogListItem extends StatefulWidget {
  final DogDataModel dogDataModel;
  final String imageUrl;
  const DogListItem({
    super.key,
    required this.dogDataModel,
    required this.imageUrl,
  });

  @override
  State<DogListItem> createState() => _DogListItemState();
}

class _DogListItemState extends State<DogListItem> {
  //late DogImageModel dogImageModel;
  DogDataModel dogDataModel = DogDataModel();
  // String imageUrl = "";
  late DBHelper dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    dogDataModel = widget.dogDataModel;
    // imageUrl = widget.imageUrl;
    // if (widget.dogImageModel != null) {
    //   dogImageModel = widget.dogImageModel!;
    // }

    print(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishlistProvider>(context);
    print("list item url ${widget.imageUrl}");
      print("wishListProvider.favDogIds ${wishListProvider.favDogIds}");
      print("dogDataModel.id ${dogDataModel.id}");
      print("wishListProvider.favDogIds.contains(dogDataModel.id) ${wishListProvider.favDogIds.contains(dogDataModel.id)}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DogDetails(
                dogDataModel: dogDataModel,
                imageUrl: widget.imageUrl,
              ),
            ));
      },
      child: Card(
        child: Column(
          children: [
            Image.network(
              //"https://cdn2.thedogapi.com/images/BJcNbec4X_1280.jpg"
              widget.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) + 16.0,
                  height: (MediaQuery.of(context).size.width / 2) + 10.0,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              },
              width: (MediaQuery.of(context).size.width / 2) + 16.0,
              height: (MediaQuery.of(context).size.width / 2) + 5.0,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                    child: Text(
                      dogDataModel.name ?? "Dog",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                       
                        wishListProvider.favDogIds.contains(dogDataModel.id)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        print("PRESSED");
                        if (wishListProvider.favDogIds
                            .contains(dogDataModel.id)) {
                          await dbHelper
                              .deleteItemFromWishList(dogDataModel.id!);
                          wishListProvider.removeFromWishlist(dogDataModel.id!);
                          print(
                              "wishListProvider.favDogIds ${wishListProvider.favDogIds}");
                          print("Dog is removed from wishlist");
                        } else if (wishListProvider.favDogIds.length < 5) {
                          Map<String, dynamic> data = {
                            'userId': wishListProvider.userId,
                            'dogId': dogDataModel.id.toString(),
                            'name': dogDataModel.name!,
                            'imageUrl': widget.imageUrl
                          };

                          wishListProvider.addToWishlist(dogDataModel.id!);

                          await dbHelper.insertIntoWishlistTable(data);
                          print(
                              "wishListProvider.favDogIds ${wishListProvider.favDogIds}");

                          print("Dog is added to wishlist");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              padding: EdgeInsets.all(15.0),
                              backgroundColor: Colors.red,
                              content:
                                  Text("Wishlist can contain only 5 items.")));
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
