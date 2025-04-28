import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/custom_button_widget.dart';
import '../../../localization/language_constrants.dart';

import '../../../utill/dimensions.dart';
import '../../address/controllers/address_controller.dart';
import '../../address/screens/add_new_address_screen.dart';
import '../../search_product/screens/search_product_screen.dart';

void showDeliveryLocationBottomSheet(BuildContext context, int id) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DeliveryLocationBottomSheet(id: id.toString());
    },
  );
}

class DeliveryLocationBottomSheet extends StatefulWidget {
  String id;

  DeliveryLocationBottomSheet({super.key, this.id = ''});

  @override
  _DeliveryLocationBottomSheetState createState() =>
      _DeliveryLocationBottomSheetState();
}

class _DeliveryLocationBottomSheetState
    extends State<DeliveryLocationBottomSheet> {
  @override
  void initState() {
    Provider.of<AddressController>(context, listen: false)
        .getAddressList(all: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressController>(
      builder: (context, locationProvider, child) => Container(
          padding: const EdgeInsets.all(0.0),
          child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimensions.paddingSizeDefault),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withValues(alpha: .5),
                                  borderRadius: BorderRadius.circular(20)))),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "CHANGE DELIVERY LOCATION",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add_location_alt),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddNewAddressScreen(
                                              isBilling: false)));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Address Selection
                      Container(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: locationProvider.addressList?.length,
                            itemBuilder: (context, index) => Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: RadioListTile(
                                        value: locationProvider
                                            .addressList![index].id
                                            .toString(),
                                        groupValue: widget.id,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.id = value!;
                                          });
                                        },
                                        title: Text(
                                          "${getTranslated('address', context)} : ${locationProvider.addressList?[index].address}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            '${getTranslated('city', context)} : ${locationProvider.addressList?[index].city ?? ""} ${getTranslated('zip', context)} : ${locationProvider.addressList?[index].zip ?? ""}'),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )),
                      ),

                      // const SizedBox(height: 20),
                      const Divider(),
                      CustomButton(
                        isLoading: locationProvider.isAddressLoading,
                        onTap: () {
                          Provider.of<AddressController>(context, listen: false)
                              .upDateAdress(widget.id, nav: true);
                        },
                        buttonText: "Submit",
                      )

                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Provider.of<AddressController>(context,
                      //               listen: false)
                      //           .upDateAdress(widget.id, nav: true);
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //     child: const Text("SUBMIT",
                      //         style: TextStyle(color: Colors.white)),
                      //   ),
                      // ),
                    ],
                  )))

          // SingleChildScrollView(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Header Row
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Text(
          //             "CHANGE DELIVERY LOCATION",
          //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //           ),

          //           IconButton(
          //             icon: const Icon(Icons.close),
          //             onPressed: () => Navigator.pop(context),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 10),

          //       // Address Selection
          //       ListView.builder(
          //           shrinkWrap: true,
          //           itemCount: locationProvider.addressList?.length,
          //           itemBuilder: (context, index) => Column(
          //                 children: [
          //                   Container(
          //                     decoration: BoxDecoration(
          //                       border: Border.all(
          //                           color: Theme.of(context).primaryColor),
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                     child: ListTile(
          //                       leading: Radio<String>(
          //                         value: locationProvider.addressList![index].id
          //                             .toString(),
          //                         groupValue: widget.id,
          //                         activeColor: Theme.of(context).primaryColor,
          //                         onChanged: (value) {
          //                           setState(() {
          //                             widget.id = value!;
          //                           });
          //                         },
          //                       ),
          //                       title: Text(
          //                         "${getTranslated('address', context)} : ${locationProvider.addressList?[index].address}",
          //                         style: TextStyle(fontWeight: FontWeight.bold),
          //                       ),
          //                       subtitle: Text(
          //                           '${getTranslated('city', context)} : ${locationProvider.addressList?[index].city ?? ""} ${getTranslated('zip', context)} : ${locationProvider.addressList?[index].zip ?? ""}'),
          //                     ),
          //                   ),
          //                   const SizedBox(height: 20),
          //                 ],
          //               )),

          //       // const SizedBox(height: 20),
          //       const Divider(),

          //       SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: () {
          //           Provider.of<AddressController>(context, listen: false).  upDateAdress(widget.id, nav: true);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Theme.of(context).primaryColor,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //           child: const Text("SUBMIT",
          //               style: TextStyle(color: Colors.white)),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}

searchButton(context) {
  // final _mic = Get.put(BaseController());
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SearchScreen()));
        },
        icon: Icon(Icons.search)),
  );
}
