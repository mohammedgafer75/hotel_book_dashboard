import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_book_dashboard/controller/room_controller.dart';

class RoomManagement extends StatelessWidget {
  const RoomManagement({Key? key}) : super(key: key);
  static const String id = "RoomManagement-screen";
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return GetX<RoomsController>(
      init: RoomsController(),
      autoRemove: false,
      builder: (logic) {
        return logic.loading.value
            ? SizedBox(
                height: data.size.height,
                width: data.size.width,
                child: Stack(children: [
                  logic.rooms.isEmpty
                      ? const Center(
                          child: Text('No Rooms founded'),
                        )
                      : ListView.builder(
                          itemCount: logic.rooms.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          '${logic.rooms[index].type} room'),
                                      leading: CircleAvatar(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.amber.shade700,
                                      ),
                                      subtitle: Text(
                                          'Number: ${logic.rooms[index].number} Price: ${logic.rooms[index].price}\$'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                logic.editRoom(
                                                    logic.rooms[index].id!,
                                                    context,
                                                    logic.rooms[index].type!,
                                                    logic.rooms[index].price!,
                                                    logic.rooms[index]
                                                        .description!);
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                            onPressed: () {
                                              logic.deleteRoom(
                                                  logic.rooms[index].id!);
                                            },
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: data.size.height / 1.3,
                        left: data.size.width / 3,
                        right: data.size.width / 3),
                    child: MaterialButton(
                      onPressed: () {
                        logic.addRoom(context);
                      },
                      child: const Text("Add Room"),
                      minWidth: double.infinity,
                      // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
                      height: 52,
                      elevation: 24,
                      color: Colors.amber.shade700,
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                ]),
              )
            : SizedBox(
                height: data.size.height,
                width: data.size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }
}
