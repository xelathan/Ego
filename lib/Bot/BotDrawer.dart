import 'package:ego/Bot/BotController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BotController _controller = BotController();

class BotDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      // Add this block
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      top: 0.0,
      bottom: 0.0,
      left: _controller.isDrawerOpen
          ? 0.0
          : -(MediaQuery.of(context).size.width / 3) * 2,
      child: Container(
        width: (MediaQuery.of(context).size.width / 3) * 2,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Text("Threads",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                    future: _controller.getThreads(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoContextMenu(
                                      actions: [
                                        CupertinoContextMenuAction(
                                          onPressed: () {
                                            _controller.showRenameOption(
                                                context,
                                                snapshot.data?[index]
                                                    ['thread_id']);
                                          },
                                          trailingIcon: CupertinoIcons.pencil,
                                          child: const Text('Rename'),
                                        ),
                                        CupertinoContextMenuAction(
                                          onPressed: () async {
                                            await _controller.deleteThread(
                                                snapshot.data?[index]
                                                    ['thread_id'],
                                                context);
                                          },
                                          trailingIcon: CupertinoIcons.trash,
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: CupertinoColors
                                                    .destructiveRed),
                                          ),
                                          isDefaultAction: true,
                                        ),
                                      ],
                                      child: Container(
                                        color: CupertinoColors.white,
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              300.0, // Set your desired maximum width
                                        ),
                                        child: CupertinoListTile(
                                          title: Text(
                                              snapshot.data?[index]['name']),
                                          onTap: () async {
                                            await _controller.loadThread(
                                                context,
                                                snapshot.data?[index]
                                                    ['thread_id']);
                                            _controller.scrollToBottom();
                                            _controller.triggerBotState();
                                          },
                                          trailing: Icon(
                                              CupertinoIcons.chevron_right),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: Container(
                                        color: CupertinoColors.systemGrey5),
                                  )
                                ],
                              );
                            },
                            itemCount: snapshot.data!.length);
                      } else {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
