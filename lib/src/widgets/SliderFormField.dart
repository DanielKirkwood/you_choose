import 'package:flutter/material.dart';

class SliderFormField extends FormField<double> {
  SliderFormField(
      {Key? key,
      required FormFieldSetter<double> onSaved,
      required FormFieldValidator<double> validator,
      double initialValue = 1})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.always,
            builder: (FormFieldState<double> state) {
              return Slider(
                  label: "£" * state.value!.toInt(),
                  min: 1,
                  max: 4,
                  divisions: 3,
                  value: state.value!,
                  onChanged: (double newValue) {
                    state.didChange(newValue);
                  });
            });
}
