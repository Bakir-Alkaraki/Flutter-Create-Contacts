import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(MyApp(),
  );

}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final List<Contact> contacts = [];


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mid-Term Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(object: contacts,),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key,required this.object}) : super(key: key);
  final List object;
  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {


  void _createcontact() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDisplay(object: widget.object,),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
      ),
      body: Center(
        child: widget.object.isEmpty ? Column(
          mainAxisAlignment: MainAxisAlignment.center,

            children: const <Widget>[
              Text("No Contacts Available", style: TextStyle(fontSize: 40),),
              ]
        )
            :
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: widget.object.length,
              itemBuilder: (context, index) {
                String firstLetter = widget.object[index].firstName;
                return GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading:  CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child: Text(firstLetter[0]),
                      ),
                      title: Text('${widget.object[index].firstName} ${widget.object[index].lastName}'),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ListDisplay(object: widget.object,),));
                        _showDiallog(context, index);
                      },
                    ),
                  ),
                );
              }
          ),
        )

        ),


      floatingActionButton: FloatingActionButton(
        onPressed: _createcontact,
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showDiallog(BuildContext context, int index)
  {
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("${widget.object[index].firstName} ${widget.object[index].lastName}",style: TextStyle(color: Colors.blue, fontSize: 25),),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Phone1: ${widget.object[index].phoneNum1}"),
                  Text("Phone2: ${widget.object[index].phoneNum2}"),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(object: widget.object, index: index,),));
                  },
                  child: Text("Edit")
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.object.removeAt(index);
                    });
                    Navigator.of(context).pop();

                  },
                  child: Text("Delete")
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close")
              )
            ],
          );
        },
        context: context,

    );

  }
}

class ListDisplay extends StatefulWidget{
  const ListDisplay({required this.object});
  final List object;

  @override
  ListDisplayState createState() {
    return ListDisplayState();
  }
}

class ListDisplayState extends State<ListDisplay>{

  List<TextEditingController> controller = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < 4; i++) {
      controller.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Page"),
      ),

      body: Column(
        children: [
          TextField(
            controller: controller[0],
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
          ),
          TextField(
            controller: controller[1],
            decoration: InputDecoration(
              labelText: 'Last Name',


            ),
          ),
          TextField(
            controller: controller[2],
            decoration: InputDecoration(
              labelText: 'Phone 1',
            ),
          ),
          TextField(
            controller: controller[3],
            decoration: InputDecoration(
              labelText: 'Phone 2',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 500,
                  child: ElevatedButton(

                    onPressed: () {
                      if (controller[0].text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter First Name",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            webPosition: "center"
                        );
                        return;
                      }
                      if (controller[2].text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Phone Number 1",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            webPosition: "center"
                        );
                        return;
                      }
                      widget.object.add(
                        Contact(
                          firstName: controller[0].text,
                          lastName: controller[1].text,
                          phoneNum1: controller[2].text,
                          phoneNum2: controller[3].text,

                        )
                      );
                      setState(() {

                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage(object: widget.object,)),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("Add Contact"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 500,
              child: ElevatedButton(

                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(object: widget.object,)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Cancel"),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class EditPage extends StatefulWidget{
  //const MyHomePage({Key? key, required this.title}) : super(key: key);
  const EditPage({required this.object, required this.index});
  final List object;
  final int index;

  @override
  EditPageState createState() {
    return EditPageState();
  }
}

class EditPageState extends State<EditPage>{

  List<TextEditingController> controller = [];
  late Contact conta;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < 4; i++)
      controller.add(TextEditingController());

    conta = widget.object[widget.index];

    controller[0] = TextEditingController(text: conta.firstName);
    controller[1] = TextEditingController(text: conta.lastName);
    controller[2] = TextEditingController(text: conta.phoneNum1);
    controller[3] = TextEditingController(text: conta.phoneNum2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Contact Page"),
      ),

      body: Column(
        children: [
          TextField(
            controller: controller[0],
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
          ),
          TextField(
            controller: controller[1],
            decoration: InputDecoration(
              labelText: 'Last Name',


            ),
          ),
          TextField(
            controller: controller[2],
            decoration: InputDecoration(
              labelText: 'Phone 1',
            ),
          ),
          TextField(
            controller: controller[3],
            decoration: InputDecoration(
              labelText: 'Phone 2',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 500,
                  child: ElevatedButton(

                    onPressed: () {
                      if (controller[0].text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter First Name",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            webPosition: "center"
                        );
                        return;
                      }
                      if (controller[2].text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Phone Number 1",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            webPosition: "center"
                        );
                        return;
                      }
                      conta.setFirstName(controller[0].text);
                      conta.setLastName(controller[1].text);
                      conta.setPhoneNum1(controller[2].text);
                      conta.setPhoneNum2(controller[3].text);

                      setState(() {

                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage(object: widget.object,)),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("Edit Contact"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 500,
              child: ElevatedButton(

                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(object: widget.object,)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Cancel"),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class Contact {

  String firstName;
  String? lastName;
  String phoneNum1;
  String? phoneNum2;

  String get getFirstName {
    return firstName;
  }
  void setFirstName(String name) {
    firstName = name;
  }
  void setLastName(String name) {
    lastName = name;
  }
  void setPhoneNum1(String name) {
    phoneNum1 = name;
  }
  void setPhoneNum2(String name) {
    phoneNum2 = name;
  }

  Contact({required this.firstName, this.lastName, required this.phoneNum1, this.phoneNum2});


}
