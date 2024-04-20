import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products/constants.dart';
import 'package:flutter_products/src/components/MLKitTextRecognizer.dart';
import 'package:flutter_products/src/objects/recognition_response.dart';
import 'package:flutter_products/src/settings/settings_view.dart';
import 'package:image_picker/image_picker.dart';

//import '../settings/settings_view.dart';
import '../src/interface/text_recognizer.dart';
import '../src/sample_feature/sample_item.dart';

/// Displays a list of SampleItems.
class AddProductView extends StatefulWidget {
  const AddProductView({
    super.key,
    this.products = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/addProduct';

  final List<SampleItem> products;

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  File? image;
  String? error;
  late ITextRecognizer _recognizer;
  RecognitionResponse? _response;
  bool enterManually = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _recognizer = MLKitTextRecognizer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_recognizer is MLKitTextRecognizer) {
      (_recognizer as MLKitTextRecognizer).dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            //_appTheme.toggleTheme(context);
          },
        ),
        title: Text('Add Product',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text("Please add picture of your receipt or order"),
            ),
            Center(
                child: ElevatedButton.icon(
              icon:
                  const Icon(Icons.photo_library_outlined, color: Colors.white),
              label: const Text("Gallery",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                pickImageGallery();
                //print(image);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                fixedSize: const Size(208, 43),
              ),
            )),
            Center(
              child: Platform.isAndroid || Platform.isIOS
                  ? ElevatedButton.icon(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                      label: const Text("Photo",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickImagePhoto();
                        //print(image);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(208, 43),
                      ),
                    )
                  : null,
            ),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
                label: const Text("Enter Manually",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  setEnterManually();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  fixedSize: const Size(208, 43),
                ),
              ),
            ),
            Center(
              child: image != null && error == null
                  ? Image.file(
                      image!,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Text(image == null && error == null
                      ? "no image selected"
                      : error!),
            ),
            Center(
                child: _response != null
                    ? Text(_response!.recognizedText.toString())
                    : null),
            Center(
                child: enterManually == true
                    ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //Email Input
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: _emailController,
                                cursorColor: Colors.black,
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Invalid e-mail';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Name Input
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: _nameController,
                                cursorColor: Colors.black,
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Password Input
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: _passwordController,
                                cursorColor: Colors.black,
                                obscureText: true,
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid password';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Confirm Password Input
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                cursorColor: Colors.black,
                                obscureText: true,
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty ||
                                      value != _passwordController.text) {
                                    return 'Passwords don\'t match';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: size.width,
                              height: 45,
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    //_register();
                                  }
                                },
                                color: Colors.black,
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Login',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : null),
          ],
          /*children: [
          Container(
            child: Text("Please add picture of your receipt or order"),
            child: ElevatedButton.icon(
              icon:
                  const Icon(Icons.photo_library_outlined, color: Colors.white),
              label: const Text("Gallery",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                pickImageGallery();
                print(image);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                fixedSize: const Size(208, 43),
              ),
            ),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
              label: const Text("Photo",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                pickImagePhoto();
                print(image);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                fixedSize: const Size(208, 43),
              ),
            ),*/

          /*MaterialButton(
                
                  color: kPrimaryColor,
                  child: const Text("Gallery",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  
                  onPressed: () {}),
              MaterialButton(
                  color: kPrimaryColor,
                  child: const Text("Camera",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {}),*/
          //],
        ),
      ),
    );
    /*ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = products[index];

          return ListTile(
              title: Text('SampleItem ${product.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  AddProductView.routeName,
                );
              });
        },
      ),*/
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      processImage(imageTemp.path);
      setState(() => this.image = imageTemp);
      //dispose();
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
      error = e.toString();
    }
  }

  Future pickImagePhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      processImage(imageTemp.path);
      setState(() => this.image = imageTemp);
      //dispose();
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
      error = e.toString();
    }
  }

  Future setEnterManually() async {
    try {
      if (!enterManually) {
        setState(() => enterManually = true);
      } else {
        setState(() => enterManually = false);
      }
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  void processImage(String imgPath) async {
    final recognizedText = await _recognizer.processImage(imgPath);
    setState(() {
      _response =
          RecognitionResponse(imgPath: imgPath, recognizedText: recognizedText);
    });
  }
}
