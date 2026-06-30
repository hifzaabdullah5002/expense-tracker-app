import 'package:flutter/material.dart';
import 'package:hifza_expense_tracker/api_service.dart';
import 'package:hifza_expense_tracker/data/model/add_date.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}
class _Add_ScreenState extends State<Add_Screen> {
  final box = Hive.box<Add_data>('data');
  DateTime date = DateTime.now();

  String? selctedItem;
  String? selctedItemi;

  final TextEditingController expalin_C = TextEditingController();
  final TextEditingController amount_c = TextEditingController();

  FocusNode ex = FocusNode();
  FocusNode amount_ = FocusNode();


  List<String> _item = ['food', 'Transfer', 'Transportation', 'Education'];
  List<dynamic> _apiCategories = [];
  final List<String> _itemei = ['Income', 'Expand'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    ex.addListener(() { setState(() {}); });
    amount_.addListener(() { setState(() {}); });
  }

  Future<void> _loadCategories() async {
    final categories = await ApiService().fetchCategories();
    setState(() {
      _apiCategories = categories;
      // API response se dependencies filter kar k hamesha yahi 4 fixed choices chalen gi
      _item = ['food', 'Transfer', 'Transportation', 'Education'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: 120,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Adding',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.attach_file, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 550,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          name(),
          const SizedBox(height: 30),
          explain(),
          const SizedBox(height: 30),
          amount(),
          const SizedBox(height: 30),
          How(),
          const SizedBox(height: 30),
          date_time(),
          const Spacer(),
          save(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
  Padding name() {
    Map<String, String> iconMap = {
      'food': 'images/food.png',
      'Transfer': 'images/Transfer.png',
      'Transportation': 'images/Transportation.png',
      'Education': 'images/Education.png',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: DropdownButton<String>(
          value: selctedItem, // <-- Yahan comma ',' laga kar syntax error fix kar diya hai
          onChanged: ((value) {
            setState(() {
              selctedItem = value!;
            });
          }),
          items: _item.map((e) {
            String imagePath = iconMap[e] ?? 'images/food.png';
            return DropdownMenuItem(
              value: e,
              child: Row(
                children: [
                  Image.asset(imagePath, width: 26, height: 26),
                  const SizedBox(width: 15),
                  Text(e, style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return _item.map((e) {
              String imagePath = iconMap[e] ?? 'images/food.png';
              return Row(
                children: [
                  Image.asset(imagePath, width: 26, height: 26),
                  const SizedBox(width: 15),
                  Text(e, style: const TextStyle(fontSize: 18)),
                ],
              );
            }).toList();
          },
          hint: const Text('Name', style: TextStyle(color: Colors.grey)),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        focusNode: ex,
        controller: expalin_C,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'explain',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amount_,
        controller: amount_c,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
        ),
      ),
    );
  }

  Padding How() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: DropdownButton<String>(
          value: selctedItemi,
          onChanged: ((value) { setState(() { selctedItemi = value!; }); }),
          items: _itemei.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 18)))).toList(),
          selectedItemBuilder: (BuildContext context) => _itemei.map((e) => Row(children: [Text(e)])).toList(),
          hint: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text('How', style: TextStyle(color: Colors.grey)),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Widget date_time() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newDate == null) return;
          setState(() { date = newDate; });
        },
        child: Text(
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  GestureDetector save() {
    return GestureDetector(
      onTap: () async {
        if (selctedItemi == null || selctedItem == null || amount_c.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select all options and enter amount')),
          );
          return;
        }

        var add = Add_data(selctedItemi!, amount_c.text, date, expalin_C.text, selctedItem!);
        box.add(add);

        double parsingAmount = double.tryParse(amount_c.text) ?? 0.0;

        int calculatedCategoryId = 1;
        for (var cat in _apiCategories) {
          if (cat['name'] == selctedItem) {
            calculatedCategoryId = cat['id'];
            break;
          }
        }

        final prefs = await SharedPreferences.getInstance();
        int activeUserId = prefs.getInt('userId') ?? 1;

        await ApiService().addExpenseToApi(
          amount: parsingAmount,
          description: expalin_C.text,
          date: date.toIso8601String(),
          categoryId: calculatedCategoryId,
          userId: activeUserId,
          transactionType: selctedItemi!,
        );

        if (!mounted) return;
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: const Text(
          'Save',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
