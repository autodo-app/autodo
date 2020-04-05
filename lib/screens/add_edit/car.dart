import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../generated/localization.dart';
import '../../models/models.dart';
import '../../theme.dart';
import '../../util.dart';

/// There are three states that this screen can take.
///
/// DETAILS is used when an existing car is displaying its contents, but editing
/// is not enabled. All text fields are static - not form fields. The
/// uneditable fields like fuel efficiency and distance rate are shown here.
/// ADD is used when a new car is being created, there is no attempt to show
/// the car's image and uneditable fields are not shown.
/// EDIT is used when an existing car is having its details changed. Uneditable
/// fields are not shown, but the car's image is.
enum CarDetailsMode { DETAILS, ADD, EDIT }

class _HeaderWithImage extends StatelessWidget {
  const _HeaderWithImage({this.carName, this.imageUrl});

  final String carName;
  final Future<String> imageUrl;

  @override
  Widget build(BuildContext context) => Hero(
    tag: carName ?? 'new_car',
    child: Stack(
      children: <Widget>[
        FutureBuilder(
              future: imageUrl,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                return CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: 150,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: snap.data,
                );
              }
            ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(carName ?? ''),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              Icon(Icons.delete)
            ],
          )
        )
      ],
    )
  );
}

class _HeaderNoImage extends StatelessWidget {
  const _HeaderNoImage({this.carName});

  final String carName;

  @override
  Widget build(BuildContext context) => Container(
    height: 120,
    width: double.infinity,
    padding: EdgeInsets.only(bottom: 5),
    child: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // add an upload feature here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                Text(
                  'Add a Photo',
                  style: Theme.of(context).primaryTextTheme.subtitle2
                ),
              ],
            ),
          ),
        ),
        // TODO: make this an editable field
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(carName ?? ''),
        ),
      ],
    )
  );
}

class _TwoPartTextField extends StatelessWidget {
  const _TwoPartTextField({this.initialValue, this.fieldName, this.units, this.node, this.nextNode, this.validator, this.onSaved});

  final String initialValue, fieldName, units;
  final FocusNode node, nextNode;
  final Function(String) validator, onSaved;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Text('$fieldName:'),
        ),
        Expanded(
          flex: 5,
          child: TextFormField(
            decoration: (units == null) ?
                defaultInputDecoration(units, '$fieldName ($units)') :
                defaultInputDecoration(units, '$fieldName'),
            initialValue: initialValue?.toString() ?? '',
            focusNode: node,
            style: Theme.of(context).primaryTextTheme.subtitle2,
            keyboardType: TextInputType.number,
            validator: doubleValidator,
            onSaved: onSaved,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => changeFocus(node, nextNode),
          ),
        ),
      ],
    )
  );
}

class _TwoPartNoEdit extends StatelessWidget {
  const _TwoPartNoEdit({this.fieldName, this.value});

  final String fieldName, value;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('$fieldName:'),
        Text(value ?? '')
      ],
    )
  );
}

/// Shows Car Details and can be put into edit mode
class CarAddEditScreen extends StatefulWidget {
  const CarAddEditScreen({this.car, this.onSave, this.isEditing});

  final Car car;
  final Function onSave;
  final bool isEditing;

  @override
  CarAddEditScreenState createState() => CarAddEditScreenState();
}

class CarAddEditScreenState extends State<CarAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _odomNode, _makeNode, _modelNode, _yearNode, _plateNode, _vinNode;
  double _odom;
  String _make, _model, _plate, _vin;
  int _year;
  CarDetailsMode mode;


  @override
  void initState() {
    _odomNode = FocusNode();
    _makeNode = FocusNode();
    _modelNode = FocusNode();
    _yearNode = FocusNode();
    _plateNode = FocusNode();
    _vinNode = FocusNode();
    if (widget.car != null && !widget.isEditing) {
      mode = CarDetailsMode.DETAILS;
    } else if (widget.car == null && !widget.isEditing) {
      mode = CarDetailsMode.ADD;
    } else if (widget.car != null && widget.isEditing) {
      mode = CarDetailsMode.EDIT;
    } else {
      throw Exception();
    }
    super.initState();
  }

  @override
  Widget build(context) => Scaffold(
    resizeToAvoidBottomPadding:
        false, // used to avoid overflow when keyboard is viewable
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      // title: Text(JsonIntl.of(context).get(IntlKeys.editCarList)),
    ),
    body: Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          children: <Widget>[
            (mode == CarDetailsMode.DETAILS || mode == CarDetailsMode.EDIT) ?
                _HeaderWithImage(
                  carName: widget.car?.name,
                  imageUrl: widget.car?.getImageDownloadUrl()) :
                _HeaderNoImage(
                  carName: widget.car?.name),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.mileage?.toString(),
                  fieldName: 'Odom',
                  units: 'mi',
                  node: _odomNode,
                  nextNode: _makeNode,
                  validator: doubleValidator,
                  onSaved: (val) {
                    _odom = double.tryParse(val);
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Odom',
                  value: widget.car?.mileage?.toString()
                ),
            (mode == CarDetailsMode.DETAILS) ?
                _TwoPartNoEdit(
                  fieldName: 'Driving Rate',
                  value: widget.car?.distanceRate?.toString()
                ) :
                Container(),
            (mode == CarDetailsMode.DETAILS) ?
                _TwoPartNoEdit(
                  fieldName: 'Fuel Efficiency',
                  value: widget.car?.averageEfficiency?.toString()
                ) :
                Container(),
            Divider(),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.make,
                  fieldName: 'Make',
                  units: '',
                  node: _makeNode,
                  nextNode: _modelNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _make = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Make',
                  value: widget.car?.make
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.model,
                  fieldName: 'Model',
                  units: '',
                  node: _modelNode,
                  nextNode: _yearNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _model = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Model',
                  value: widget.car?.model
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.year?.toString(),
                  fieldName: 'Year',
                  units: '',
                  node: _yearNode,
                  nextNode: _plateNode,
                  validator: intValidator,
                  onSaved: (val) {
                    _year = int.tryParse(val);
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Year',
                  value: widget.car?.year?.toString()
                ),
            Divider(),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.plate,
                  fieldName: 'Plate',
                  units: '',
                  node: _plateNode,
                  nextNode: _vinNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _plate = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Plate',
                  value: widget.car?.plate
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.vin,
                  fieldName: 'VIN',
                  units: '',
                  node: _vinNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _vin = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: 'Plate',
                  value: widget.car?.plate
                ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.onSave(_odom, _make, _model, _year, _plate, _vin);
                    Navigator.pop(context);
                  }
                },
              )
            )
          ],
        )
      ),
    ), // Todo: Add content here
  );
}
