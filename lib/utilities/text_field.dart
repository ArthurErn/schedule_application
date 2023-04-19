import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent{
  TextFormField build(TextEditingController controller, {int? maxLines = 1, TextInputType inputType = TextInputType.name, bool validate = true}){
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: inputType,
      validator: (value) {
        if(validate == true && (value == null || value.isEmpty)){
          return "Campo vazio";
        }
        return null;
      },
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 255, 255),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
    )));
  }
}