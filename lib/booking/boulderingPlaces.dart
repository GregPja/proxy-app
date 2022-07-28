import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxyfoxyapp/booking/bookingDto.dart';
import 'package:proxyfoxyapp/booking/slotsView.dart';

class BoulderingPlaces extends StatelessWidget {
  final Map<String, List<SlotInfoDTO>> mapSlots;
  final DateTime chosenDay;

  const BoulderingPlaces(this.mapSlots, this.chosenDay, {Key? key})
      : super(key: key);

  Widget _renderView(BuildContext context) {
    var buttons = mapSlots.entries
        .where((element) => element.value.isNotEmpty)
        .map((entry) => Container(
            margin: const EdgeInsets.only(left: 10.0, top: 5, right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SlotsView(
                              gymName: entry.key,
                              slots: entry.value,
                              choseDate: chosenDay,
                            )))
              },
              child: Text("${entry.key} | ${entry.value.length}"),
            )))
        .toList();
    if (buttons.isNotEmpty) {
      return Center(
          child: Column(
        children: buttons,
      ));
    }
    return const Center(
        child: Text("Sorry, no free slots for the selected day :("));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Available slots - ${DateFormat("E dd MMM").format(chosenDay)}'),
        ),
        body: _renderView(context));
  }
}
