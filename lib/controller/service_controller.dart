import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_book_dashboard/widgets/custom_textfield.dart';

import '../model/service_model.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';

class ServicesController extends GetxController {
  RxList<Service> services = RxList<Service>([]);
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController name, price, number;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("service");
    price = TextEditingController();
    name = TextEditingController();
    number = TextEditingController();
    services.bindStream(getAllService());
    loading.value = true;
    super.onInit();
  }

  Stream<List<Service>> getAllService() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Service.fromMap(item)).toList());
  String? validate(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }

  void addService() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Get.defaultDialog(
        title: 'Add Service',
        content: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: name,
                validator: (value) {
                  return validate(value!);
                },
                lable: 'service name',
                icon: const Icon(Icons.bed),
                input: TextInputType.text,
                secure: false,
              ),
              CustomTextField(
                controller: price,
                validator: (value) {
                  return validate(value!);
                },
                lable: 'price',
                icon: const Icon(Icons.money),
                input: TextInputType.number,
                secure: false,
              ),
              MaterialButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      showdilog();
                      var data = <String, dynamic>{
                        "name": name.text,
                        "price": int.tryParse(price.text),
                      };
                      await collectionReference
                          .doc()
                          .set(data)
                          .whenComplete(() async {
                        update();
                        name.clear();
                        price.clear();
                        Get.back();
                        showbar('title', 'subtitle', 'service Added', true);
                      });
                    } catch (e) {
                      Get.back();
                      showbar('title', 'subtitle', e.toString(), false);
                    }
                  }
                },
                child: const Text("Add service"),
                minWidth: double.infinity,
                // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
                height: 52,
                elevation: 24,
                color: Colors.amber.shade700,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () async {
                  Get.back();
                },
                child: const Text("close"),
                minWidth: double.infinity,
                // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
                height: 52,
                elevation: 24,
                color: Colors.amber.shade700,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
            ],
          ),
        ));
  }

  void editService(String id, BuildContext context, String name1, int price1) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final data = MediaQuery.of(context);
    name.text = name1;
    price.text = price1.toString();
    Get.defaultDialog(
        // title: 'Add Room',
        content: SizedBox(
      height: data.size.height / 2,
      width: data.size.width / 2,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            CustomTextField(
              controller: name,
              validator: (value) {
                return validate(value!);
              },
              lable: 'service name',
              icon: const Icon(Icons.bed),
              input: TextInputType.text,
              secure: false,
            ),
            CustomTextField(
              controller: price,
              validator: (value) {
                return validate(value!);
              },
              lable: 'price',
              icon: const Icon(Icons.money),
              input: TextInputType.number,
              secure: false,
            ),
            MaterialButton(
              onPressed: () async {
                try {
                  showdilog();
                  var data = <String, dynamic>{
                    "name": name.text,
                    "price": int.tryParse(price.text),
                  };
                  await collectionReference
                      .doc(id)
                      .update(data)
                      .whenComplete(() async {
                    name.clear();
                    price.clear();
                    Get.back();
                    Get.back();
                    showbar('title', 'subtitle', 'Service Edited', true);
                    update();
                  });
                } catch (e) {
                  Get.back();
                  showbar('title', 'subtitle', e.toString(), false);
                }
              },
              child: const Text("Edit service"),
              // minWidth: double.infinity,
              // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
              height: 52,
              elevation: 24,
              color: Colors.amber.shade700,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
            const SizedBox(
              height: 5,
            ),
            MaterialButton(
              onPressed: () async {
                Get.back();
              },
              child: const Text("close"),
              // minWidth: double.infinity,
              // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
              height: 52,
              elevation: 24,
              color: Colors.amber.shade700,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
          ],
        ),
      ),
    ));
  }

  void deleteService(String id) {
    Get.dialog(AlertDialog(
      content: const Text('service delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await collectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete service', '', 'service Deleted', true);
              } catch (e) {
                showbar('Delete service ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }
}
