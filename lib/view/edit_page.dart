import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_book/bloc/contactPage_bloc.dart';
import 'package:phone_book/model/contact_model.dart';
import 'package:phone_book/view/add_page.dart';
import 'package:phone_book/view/bottom_navigation_bar/contacts_page.dart';
import 'package:phone_book/view/contact_details.dart';

class EditedPage extends StatefulWidget {
  final Contact contact;
  EditedPage({this.contact});

  @override
  _EditedPageState createState() => _EditedPageState(this.contact);
}

class _EditedPageState extends State<EditedPage> {
  final Contact contact;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey= GlobalKey<FormState>();
  bool _userEdited = false;
  Contact _editedContact;
  bool valid = false;
  File imageFile;
  final imagePicker = ImagePicker();

  _EditedPageState(this.contact);

  @override
  void initState() {
    super.initState();

    _editedContact = Contact.fromMap(widget.contact.toMap());

    _nameController.text  = _editedContact.name;
    _lastNameController.text = _editedContact.lastName;
    _emailsController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
    _editedContact.latitude = contact.latitude;
    _editedContact.longitude = contact.longitude;
  }

  Future getFromCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      contact.imgPath = image.path;
    });
  }

  Future getFromGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      contact.imgPath = image.path;
    });
  }

  showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                          height: MediaQuery.of(context).size.height/4.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                              image: AssetImage('assets/images/header.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
                SizedBox(height:  MediaQuery.of(context).size.height/100 ,),
                buildExpanded(context)
              ],
            ),
            // Profile image
            Positioned(
              top: 150.0, // (background container size) - (circle height / 2)
              child: GestureDetector(
                    onTap: () {
                      showPicker(context);
                    },
                    child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: contact.imgPath == null
                            ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/User.png'),
                                  fit: BoxFit.fill)),
                        )
                            : Container(
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            radius: 20.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: MediaQuery.of(context).size.height / 2,
                                height: MediaQuery.of(context).size.height / 2,
                                child: Image.file(File(contact.imgPath),fit: BoxFit.fill,),
                              ),
                            ),
                          )
                        )
                      // Image.file(_image),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildExpanded(BuildContext context) {
    return Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[400].withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width/15,
                    right: MediaQuery.of(context).size.width/15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/6),
                      TextFieldClass(
                          formKey: _nameFormKey,
                          controller: _nameController,
                          hintText: 'Name',
                          alarmText: 'Name',
                          icon: Icons.person,),
                      SizedBox(height: MediaQuery.of(context).size.height/50),
                      TextFieldClass(
                        formKey: _lastNameFormKey,
                        controller: _lastNameController,
                        hintText: 'LastName',
                        alarmText: 'LastName',
                        icon: Icons.person,),
                      SizedBox(height: MediaQuery.of(context).size.height/50),
                      TextFieldClass(
                        controller: _emailsController,
                        hintText: 'Email',
                        alarmText: 'Email',
                        icon: Icons.email,),
                      SizedBox(height: MediaQuery.of(context).size.height/50),
                      TextFieldClass(
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        controller: _phoneController,
                        hintText: 'PhoneNumber',
                        alarmText: 'PhoneNumber',
                        icon: Icons.phone,),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.redAccent,
                                    child: Icon(Icons.delete)),
                                onTap: (){
                                  final contactBloc = BlocProvider.of<ContactBloc>(context);
                                  contactBloc.add(DeleteContactEvent(this.contact));
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new ContactPage()));
                                },
                              ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.save)),
                                  onTap: () {
                                    _editedContact.name = this._nameController.text;
                                    _editedContact.lastName = this._lastNameController.text;
                                    _editedContact.phone = this._phoneController.text;
                                    _editedContact.email = this._emailsController.text;
                                    _editedContact.imgPath = contact.imgPath ;
                                    _editedContact.latitude = contact.latitude;
                                    _editedContact.longitude = contact.longitude;
                                    final contactBloc = BlocProvider.of<ContactBloc>(context);
                                    contactBloc.add(EditContactEvent(_editedContact));
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => new ContactDetails(contact)));
                                  }
                              )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
          title: Text('Make a Choice: '),
          content : SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text('Gallery'),
                    onTap: (){
                      AddEditPageState().getFromCamera();
                    }
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                    child: Text('Camera'),
                    onTap: (){
                      AddEditPageState().getFromCamera();
                    }
                )
              ],
            ),
          )
      );
    }
    );
  }
}

class TextFieldClass extends StatefulWidget {

  final controller;
  final hintText;
  final alarmText;
  final image;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  const TextFieldClass({this.controller, this.hintText,
    this.alarmText, this.image, this.icon,
    this.formKey, this.maxLength,
    this.keyboardType, this.inputFormatters});

  @override
  _TextFieldClassState createState() =>
      _TextFieldClassState(controller, hintText, alarmText, image,
          icon, formKey, maxLength, keyboardType, inputFormatters);
}

class _TextFieldClassState extends State<TextFieldClass> {

  final controller;
  final hintText;
  final alarmText;
  final image;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  bool _userEdited = false;
  Contact _editedContact;

  _TextFieldClassState(this.controller, this.hintText,
      this.alarmText, this.image, this.icon,
      this.formKey, this.maxLength,
      this.keyboardType, this.inputFormatters);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height/2.5,
      child: Form(
        key: formKey,
        child: TextFormField(
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLength: maxLength,
          cursorColor: Colors.deepOrange,
          controller: controller,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter $alarmText';
            }
            return null;
          },
          autocorrect: false,
          decoration: InputDecoration(
            enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[850])),
            hintText: hintText,
            hintStyle: (TextStyle(color: Colors.grey[600])),
            icon: Icon(
              icon,
              color: Colors.grey[850],
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
          ),
        )
        ,
      ),
    );
  }
}

