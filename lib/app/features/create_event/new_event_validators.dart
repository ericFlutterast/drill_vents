import 'package:flutter/material.dart';

abstract interface class ValidationObservable {
  void validateSubscribers();
}

class EventValidation extends ValidationObservable {
  EventValidation(this.validators);

  final Map<String, Validator> validators;

  bool _isValid = false;
  bool get isValidate {
    validateSubscribers();
    return _isValid;
  }

  @override
  void validateSubscribers() {
    for (final validator in validators.values) {
      validator.validate(validator.value);
    }
    for (final validator in validators.values) {
      if (validator.hasError.value == true) {
        _isValid = false;
        return;
      }
    }
    _isValid = true;
  }
}

abstract class Validator<T> {
  Validator([this._value]);

  T? _value;
  ValueNotifier<bool?> hasError = ValueNotifier(null);
  T? get value => _value;

  set value(T? newValue) {
    if (newValue == _value) return;
    _value = newValue;
    hasError.value = _value == null;
  }

  void validate(T? value) {
    if (_value case Iterable value) {
      hasError.value = _value == null || value.isEmpty;
      return;
    }
    if (_value case String value) {
      hasError.value = _value == null || value.isEmpty;
      return;
    }
    hasError.value = _value == null;
  }
}

final class DateTimeModel {
  DateTime? startTime;
  DateTime? startDate;
  DateTime? endTime;
}

class DateTimeValidator extends Validator<DateTimeModel> {
  DateTimeValidator() : super(DateTimeModel());

  @override
  void validate(DateTimeModel? value) {
    if (value?.startTime == null || value?.startDate == null) {
      hasError.value = true;
      return;
    }
    hasError.value = false;
  }
}

class TitleValidator extends Validator<String> {
  TitleValidator();
}

class DescriptionValidator extends Validator<String> {
  DescriptionValidator();
}

class CapacityValidator extends Validator<int> {
  CapacityValidator();
}

class SpotIdValidator extends Validator<String> {
  SpotIdValidator();
}
