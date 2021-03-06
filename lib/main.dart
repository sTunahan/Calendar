import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  TextEditingController _dataController = TextEditingController();
  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  // -----------  Notes List ---------------
  late Map<DateTime, List> selectedDatas;
  @override
  void initState() {
    selectedDatas = {};
    super.initState();
  }

  List getDataFromDay(DateTime value) {
    return selectedDatas[value] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D2F41),
      ),
      body: Container(
          color: Color(0xFF2D2F41),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color(0xFF5FC6FF), Color(0xFF6448FE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2050),

                  startingDayOfWeek: StartingDayOfWeek.monday,

                  headerStyle: HeaderStyle(
                      titleTextStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      formatButtonVisible: false,
                      titleCentered: true),

                  daysOfWeekStyle: desingOfTheDays(),

                  // ------ Takvimde ??stenilen G??n?? Se??mek ????in -----
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  // ------   Design(Tasar??m) ----
                  calendarStyle: calendarDesign(),
                  //  -------   Point of Note -----------
                  eventLoader: getDataFromDay,
                ),
              ),
              //Text(selectedDatas[_selectedDay!].toString()),
              // ------------  NOTE L??ST  ---------
              /* ...getDataFromDay(_selectedDay!).map(
              (value) => ListTile(
                title: Text("saat: $_selectedDay" + "not:" + value),
              ),
            ),*/
              SizedBox(
                height: 10,
              ),
              ...getDataFromDay(_selectedDay!).map(
                (value) => noteBox(value),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple.shade800,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Note"),
                  content: TextFormField(
                    controller: _dataController,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    TextButton(
                      onPressed: () {
                        if (_dataController.text.isEmpty) {
                          print(
                              "Not g??rmeden Olusturmaya bast??n??z ... Ic?? Bo?? Not");
                          // olu??tur a bas??nca h??c b??rsey olm??yacak
                          Navigator.pop(context);
                          return;
                        } else {
                          // sec??len tar??hde daha once not olusturulduysa,yani sec??len tar??hde not varsa bo?? deg??lse buraya gir ve l??steye tekrardan not ekle

                          if (selectedDatas[_selectedDay] != null) {
                            selectedDatas[_selectedDay]!.add(_dataController
                                .text); // sec??len tar??h'e TextFormF??eld da yaz??lan?? ver , boylel??kle  Map olu??mus olsun
                            print("2.selectedData $selectedDatas");
                          }
                          // Sec??len Tar??hte ??lk defa not olusturulcaksa,daha ??nceden not olu??turulmad??ysa bu else girer.
                          else {
                            selectedDatas[_selectedDay!] = [
                              _dataController.text
                            ]; // S??yah Nokta c??kartmas??n??n b??r sebeb??de bu
                            print("1.selectedData $selectedDatas");
                          }
                          Navigator.pop(context);
                          _dataController.clear(); // controller?? tem??zled??k

                          setState(() {});
                        }
                        return;
                      },
                      child: Text("Create"),
                    )
                  ],
                );
              });
        },
        label: Text("Not ekle"),
        icon: Icon(Icons.add),
      ),
    );
  }

  Container noteBox(value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF6448FE), Color(0xFF6448FE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
    );
  }

  CalendarStyle calendarDesign() {
    return CalendarStyle(
      //  --------------  TextStyle   -----------
      defaultTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      weekendTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
      outsideTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black38),
      selectedTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      // ---------------  Colors  --------------
      todayDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(60, 9, 108, 1),
              Color.fromRGBO(157, 78, 221, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle),

      ///SelectedDay Color
      selectedDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(60, 9, 108, 1),
              Color.fromRGBO(193, 155, 255, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle),

      markerDecoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  DaysOfWeekStyle desingOfTheDays() {
    return DaysOfWeekStyle(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(60, 9, 108, 1),
            Color.fromRGBO(157, 78, 221, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      weekdayStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      weekendStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
    );
  }
}
