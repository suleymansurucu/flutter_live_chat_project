import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/common_widget/alert_dialog_response_for_platform.dart';
import 'package:flutter_chat_projects/common_widget/social_log_in_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodel/user_view_model.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController controllerUsername;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    Future.delayed(Duration.zero, () {
      final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
      setState(() {
        controllerUsername.text = _userViewModel.user?.userName ?? "";
      });
    });
  }

  @override
  void dispose() {
    controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.purple,
        actions: [
          TextButton(
            child: Text('Sign Out'),
            onPressed: () => _signOut(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple.shade400,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 220,
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('From Camera'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.browse_gallery),
                                title: Text('From Your Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.black87,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : NetworkImage(
                                _userViewModel.user?.profilePhotoUrl ?? "")
                            as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: TextEditingController(
                      text: _userViewModel.user?.email ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Your Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerUsername,
                  decoration: InputDecoration(
                    labelText: 'Username:',
                    hintText: 'Enter Your Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SocialLogInButton(
                  buttonText: 'Update',
                  buttonColor: Colors.purple,
                  textColor: Colors.white,
                  buttonIcon: Icon(Icons.add),
                  onPressed: () {
                    _usernameUpdate(context);
                  },
                ),
              ),
              if (_imageFile != null) // Eğer bir resim seçildiyse
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SocialLogInButton(
                    buttonText: 'Upload Profile Image',
                    buttonColor: Colors.blue,
                    textColor: Colors.white,
                    buttonIcon: Icon(Icons.upload),
                    onPressed: () {
                      uploadProfileImage(context);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    await _userModel.signOut();
  }

  Future<void> _usernameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userModel.user!.userName != controllerUsername.text) {
      var updateResult = await _userModel.updateUsername(
          _userModel.user!.userID, controllerUsername.text);
      if (updateResult == true) {
        _userModel.user!.userName = controllerUsername.text;
        AlertDialogResponseForPlatform(
          baslik: 'Successful',
          icerik: 'Your username has been changed.',
          anaButonYazisi: 'Okay',
          iptalButonYazisi: 'Cancel',
        ).goster(context);
      } else {
        AlertDialogResponseForPlatform(
          baslik: 'Error',
          icerik: 'This username is already in use.',
          anaButonYazisi: 'Okay',
          iptalButonYazisi: 'Cancel',
        ).goster(context);
      }
    } else {
      AlertDialogResponseForPlatform(
        baslik: 'Error',
        icerik: 'You did not change your username.',
        anaButonYazisi: 'Okay',
        iptalButonYazisi: 'Cancel',
      ).goster(context);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024, // Resize image to prevent large file issues
        maxHeight: 1024,
        imageQuality: 80, // Reduce image quality to avoid errors
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      AlertDialogResponseForPlatform(
        baslik: 'Error',
        icerik: 'Could not load the image. Please try again.',
        anaButonYazisi: 'Okay',
        iptalButonYazisi: 'Cancel',
      ).goster(context);
    }
  }

  Future<void> uploadProfileImage(BuildContext context) async {
    if (_imageFile == null) {
      print('foto yok');
      return;
    } else {
      final _userModel = Provider.of<UserViewModel>(context, listen: false);
      String userID = _userModel.user!.userID;
      String fileName = "profile$userID";

     var result = await _userModel.uploadFile(userID, fileName, _imageFile!);
     print(result);
      AlertDialogResponseForPlatform(
        baslik: 'Successful',
        icerik: 'Your profile picture has been changed.',
        anaButonYazisi: 'Okay',
        iptalButonYazisi: 'Cancel',
      ).goster(context);
    }
  }
}
