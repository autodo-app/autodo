import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../blocs/blocs.dart';
import '../../generated/localization.dart';
import '../../models/models.dart';
import '../../theme.dart';
import '../../units/units.dart';
import '../../util.dart';

typedef CarAddEditOnSaveCallback = Function(
  String name,
  double odom,
  String make,
  String model,
  int year,
  String plate,
  String vin
);

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
  const _HeaderWithImage({this.carName, this.imageUrl, this.onEdit, this.onDelete});

  final String carName;
  final Future<String> imageUrl;
  final Function onEdit, onDelete;

  @override
  Widget build(BuildContext context) => Hero(
    tag: carName ?? 'new_car',
    child: Container(
      height: 150,
      padding: EdgeInsets.only(bottom: 5),
        child: ClipRect(
          child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                future: imageUrl,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return CircularProgressIndicator();
                  }
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(.2), BlendMode.srcOver),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: snap.data,
                    )
                  );
                }
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  carName ?? '',
                  style: Theme.of(context).primaryTextTheme.headline4
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme.fromButtonThemeData(
                    data: ButtonThemeData(minWidth: 0),
                    child: FlatButton(
                      child: Icon(Icons.edit),
                      onPressed: onEdit,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  ButtonTheme.fromButtonThemeData(
                    data: ButtonThemeData(minWidth: 0),
                    child: FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: onDelete,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              )
            ),
          ],
        )
      ),
    )
  );
}

class _HeaderNoImage extends StatelessWidget {
  const _HeaderNoImage({this.car, @required this.onSaved});

  final Car car;
  final Function onSaved;

  @override
  Widget build(BuildContext context) => Container(
    height: 120,
    width: double.infinity,
    padding: EdgeInsets.only(bottom: 5),
    child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            final image = await ImagePicker.pickImage(source: ImageSource.gallery);
            await (BlocProvider.of<DatabaseBloc>(context).state as DbLoaded).storageRepo.storeAsset(image);
            BlocProvider.of<CarsBloc>(context).add(UpdateCar(car.copyWith(imageName: basename(image.path))));
          }, // add an upload feature here
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                Text(
                  JsonIntl.of(context).get(IntlKeys.addAPhoto),
                  style: Theme.of(context).primaryTextTheme.subtitle2
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.all(5),
          child: TextFormField(
            decoration: defaultInputDecoration('', JsonIntl.of(context).get(IntlKeys.name)),
            initialValue: car?.name ?? '',
            style: Theme.of(context).primaryTextTheme.subtitle2,
            keyboardType: TextInputType.text,
            validator: requiredValidator,
            textInputAction: TextInputAction.next,
            onSaved: onSaved,
          ),
        )
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
            keyboardType: TextInputType.number, // change this
            validator: validator, // change this
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
  const CarAddEditScreen({this.car, @required this.onSave, this.isEditing = false});

  final Car car;
  final CarAddEditOnSaveCallback onSave;
  final bool isEditing;

  @override
  CarAddEditScreenState createState() => CarAddEditScreenState();
}

class CarAddEditScreenState extends State<CarAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _odomNode, _makeNode, _modelNode, _yearNode, _plateNode, _vinNode;
  double _odom;
  String _name, _make, _model, _plate, _vin;
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
      title: (mode == CarDetailsMode.ADD) ?
          Text(JsonIntl.of(context).get(IntlKeys.addCar)) :
          (mode == CarDetailsMode.EDIT) ?
          Text(JsonIntl.of(context).get(IntlKeys.editCar)) :
          Text(JsonIntl.of(context).get(IntlKeys.details)),
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
                  imageUrl: (BlocProvider.of<DatabaseBloc>(context).state as DbLoaded).storageRepo.getDownloadUrl(widget.car.imageName),
                  onEdit: () {
                    setState(() {
                      mode = CarDetailsMode.EDIT;
                    });
                  },
                  onDelete: () {
                    BlocProvider.of<CarsBloc>(context).add(DeleteCar(widget.car));
                    Navigator.pop(context);
                  },
                ) :
                _HeaderNoImage(
                  car: widget.car,
                  onSaved: (val) => _name = val
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.mileage?.toString(),
                  fieldName: JsonIntl.of(context).get(IntlKeys.odom),
                  units: Distance.of(context).unitString(context, short: true),
                  node: _odomNode,
                  nextNode: _makeNode,
                  validator: doubleValidator,
                  onSaved: (val) {
                    _odom = double.tryParse(val);
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.odom),
                  value: '${Distance.of(context).format(widget.car?.mileage)} ${Distance.of(context).unitString(context, short: true)}',
                ),
            (mode == CarDetailsMode.DETAILS) ?
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.drivingRate),
                  value: '${Distance.of(context).format(widget.car?.distanceRate)} ${Distance.of(context).unitString(context, short: true)}/${JsonIntl.of(context).get(IntlKeys.day)}'
                ) :
                Container(),
            (mode == CarDetailsMode.DETAILS) ?
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.fuelEfficiency),
                  value: ' ${Efficiency.of(context).format(widget.car?.averageEfficiency)} ${Efficiency.of(context).unitString(context, short: true)}'
                ) :
                Container(),
            Divider(),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.make,
                  fieldName: JsonIntl.of(context).get(IntlKeys.make),
                  units: '',
                  node: _makeNode,
                  nextNode: _modelNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _make = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.make),
                  value: widget.car?.make
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.model,
                  fieldName: JsonIntl.of(context).get(IntlKeys.model),
                  units: '',
                  node: _modelNode,
                  nextNode: _yearNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _model = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.model),
                  value: widget.car?.model
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.year?.toString(),
                  fieldName: JsonIntl.of(context).get(IntlKeys.year),
                  units: '',
                  node: _yearNode,
                  nextNode: _plateNode,
                  validator: intValidator,
                  onSaved: (val) {
                    _year = int.tryParse(val);
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.year),
                  value: widget.car?.year?.toString()
                ),
            Divider(),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.plate,
                  fieldName: JsonIntl.of(context).get(IntlKeys.plate),
                  units: '',
                  node: _plateNode,
                  nextNode: _vinNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _plate = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.plate),
                  value: widget.car?.plate
                ),
            (mode == CarDetailsMode.ADD || mode == CarDetailsMode.EDIT) ?
                _TwoPartTextField(
                  initialValue: widget.car?.vin,
                  fieldName: JsonIntl.of(context).get(IntlKeys.vin),
                  units: '',
                  node: _vinNode,
                  validator: requiredValidator,
                  onSaved: (val) {
                    _vin = val;
                  },
                ) :
                _TwoPartNoEdit(
                  fieldName: JsonIntl.of(context).get(IntlKeys.vin),
                  value: widget.car?.vin
                ),
            Container(
              height: 200 // provides enough of a buffer to scroll up past fab
            ),
          ],
        )
      ),
    ), // Todo: Add content here
    floatingActionButton: (mode == CarDetailsMode.EDIT || mode == CarDetailsMode.ADD) ?
        FloatingActionButton(
          tooltip: (mode == CarDetailsMode.EDIT)
              ? JsonIntl.of(context).get(IntlKeys.saveChanges)
              : JsonIntl.of(context).get(IntlKeys.addCar),
          child: Icon(mode == CarDetailsMode.EDIT ? Icons.check : Icons.add),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(_name, _odom, _make, _model, _year, _plate, _vin);
              Navigator.pop(context);
            }
          },
        ) :
        Container(),
  );
}
