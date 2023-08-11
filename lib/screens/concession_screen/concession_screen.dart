import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/screens/concession_screen/widgets/concession_screen_appbar.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';

import '../../utils/image_pick.dart';
import '../../utils/themes.dart';

class ConcessionPage extends ConsumerStatefulWidget {
  const ConcessionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConcessionPage> createState() => _ConcessionPageState();
}

class _ConcessionPageState extends ConsumerState<ConcessionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _divController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _fromStationController = TextEditingController();
  final TextEditingController _toStationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  // final List<DropdownMenuEntry<String>> ticketClass = <DropdownMenuEntry<String>>['First', 'Second', "Third"];
  String? durationValue, classValue, lineValue;
  List<String> classItems = ['I', 'II'];
  List<String> lineItems = ['Central', 'Western', 'Harbour'];
  List<String> durationItems = ['Monthly', 'Quarterly'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(studentModelProvider);
    _nameController.text = data!.name;
    _branchController.text = data.branch.toUpperCase();
    _divController.text = data.div;
    _phoneNumController.text = data.phoneNum;
    return CustomScaffold(
      appBar: const ConcessionPageAppBar(title: "Concession"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneNumController,
                label: 'Phone Number',
              ),

              const SizedBox(height: 20),
              _textFieldDate(
                  label: "Select Date of Birth", controller: _dobController),
              const SizedBox(height: 20),
              _buildTextField(
                // TODO: dropdown
                controller: _yearController,
                label: 'Year',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _branchController,
                label: 'Branch',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _divController,
                label: 'Division',
              ),
              const SizedBox(height: 20),
              _dropDownButton(
                  value: durationValue,
                  hintText: "Select Duration",
                  items: durationItems,
                  onChanged: (newValue) {
                    setState(() {
                      durationValue = newValue;
                    });
                  }),
              const SizedBox(height: 20),
              _dropDownButton(
                  value: classValue,
                  hintText: "Select Class",
                  items: classItems,
                  onChanged: (newValue) {
                    setState(() {
                      classValue = newValue;
                    });
                  }),

              const SizedBox(height: 20),
              _dropDownButton(
                  value: lineValue,
                  hintText: "Select Line",
                  items: lineItems,
                  onChanged: (newValue) {
                    setState(() {
                      lineValue = newValue;
                    });
                  }),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _fromStationController,
                label: 'From Station',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _addressController,
                label: 'Resident Address',
              ),

              // ElevatedButton(
              //   onPressed: _editCount < 3 ? _saveChanges : null,
              //   child: const Text('Save Changes'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownButton({
    required String? value,
    required String hintText,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      // decoration: BoxDecoration(  // TODO: Give border
      //   border: Border.all(
      //     color: Colors.black87,
      //     width: 2.0,
      //   ),
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      child: DropdownButton(
          value: value,
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          isExpanded: true,
          hint: Text(hintText, style: const TextStyle(color: Colors.grey)),
          items: items.map((valueItem) {
            return DropdownMenuItem(
              child: Text(valueItem),
              value: valueItem,
            );
          }).toList(),
          onChanged: (newValue) {
            onChanged(newValue.toString());
          }),
    );
  }

  Widget _textFieldDate({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
        controller: controller,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1995),
            lastDate: DateTime.now(),
          );

          if (picked != null) {
            setState(() {
              controller.text = DateFormat('dd-MM-yyyy').format(picked);
            });
          }
        },
        readOnly: true,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[900] ?? Colors.grey),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          labelText: label,
          suffixIcon: const Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      enabled: true,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[900] ?? Colors.grey),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        labelText: label,
      ),
    );
  }

  void _editConcessionImage() async {
    // Add your implementation for editing the profile image here
    // This function will be called when the edit button is pressed for the profile image
    // You can use plugins like `image_picker` to implement image selection and updating logic

    // Uint8List image = await pickImage(ImageSource.gallery);

    // setState(() {
    //   _image = image;
    // });
  }

  // void _saveChanges() async {
  //   final user = ref.read(userProvider.notifier).state;
  //   final StudentModel? data = ref.read(studentModelProvider.notifier).state;

  //   // Create a reference to the user's document in Firebase Firestore
  //   final userDoc =
  //       FirebaseFirestore.instance.collection('Students').doc(user!.uid);

  //   // Update the fields with the new values from the text controllers
  //   final updatedData = {
  //     'Name': _nameController.text,
  //     'email': _emailController.text,
  //     'Batch': _batchController.text,
  //     'Branch': _branchController.text.toUpperCase(),
  //     'div': _divController.text,
  //     'gradyear': _gradyearController.text,
  //     'phoneNo': _phoneNumController.text,
  //   };

  //   try {
  //     // Update the user's document with the new data
  //     await userDoc.set(updatedData, SetOptions(merge: true));

  //     // Fetch the updated data from Firebase
  //     final updatedUserData = await userDoc.get();
  //     final updatedStudentData = StudentModel.fromJson(updatedUserData.data()!);

  //     // Update the data in the studentModelProvider
  //     ref.read(studentModelProvider.notifier).state = updatedStudentData;

  //     // Increment the edit count
  //     setState(() {
  //       _editCount++;
  //     });

  //     // Show a success message or perform any additional actions
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Profile updated successfully')),
  //     );
  //   } catch (e) {
  //     // Handle any errors that occurred during the update process
  //     print('Error updating profile: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('An error occurred. Please try again later.')),
  //     );
  //   }
  //}
}
