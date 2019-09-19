import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';

class EditRepeatsScreen extends StatefulWidget {
  @override
  EditRepeatsScreenState createState() => EditRepeatsScreenState();
}

class EditRepeatsScreenState extends State<EditRepeatsScreen> {
  final _formKey = GlobalKey<FormState>();
  List<MapEntry<String, dynamic>> repeatList = [];
  
  @override
  void initState() {
    var repeats = RepeatingBLoC().orderedRepeats();

    // Populate the repeatList with the newest three items
    int i = 0;
    for (var task in repeats.entries) {
      if (i > 2) break;
      repeatList.add(task);
      i++;
    }
    super.initState();
  }

  Map<String, dynamic> editableRepeats; // since the values in repeatList are final

  Widget body() {
    return Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 24.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: "Action Name *",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      initialValue: repeatList[0].key,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      // maxLength: 20,
                      validator: (value) {},
                      onSaved: (val) => setState(() {
                        if (val != null && val != '')
                          editableRepeats[repeatList[0].key]= int.parse(val);
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(children: <Widget>[
                      new Expanded(
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            hintText: 'Optional if Mileage Entered',
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'Due Date',
                            contentPadding: EdgeInsets.only(
                                left: 16.0,
                                top: 20.0,
                                right: 16.0,
                                bottom: 5.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (val) {},
                          onSaved: (val) => setState(() {
                                if (val != null && val != '') {
                                  editableRepeats[repeatList[1].key] = int.parse(val);
                                }
                              }),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Optional if Due Date Entered',
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: "Due Mileage",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      initialValue: '',
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => setState(() {
                            if (val != null && val != '') {
                              editableRepeats[repeatList[2].key] = int.parse(val);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Repeated Tasks"),
      ),
      // body: Text('Content to come later'),
      body: body(),
    );
  }
}
