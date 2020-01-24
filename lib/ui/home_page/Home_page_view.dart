import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sowe_app/ui/home_page/widgets/VideoListItem.dart';

import 'Home_page_viewModel.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomePageViewModel().constructList();

    List<VideoListItem> items = HomePageViewModel.items;

    return Scaffold(
      appBar: AppBar(
          title: Text("Sowe Apps"),
          centerTitle: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 10.0, 0),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: RaisedButton(
                  child: Text('Upload Video'),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/uploadVideo');
                  },
                ),
              ),
            )
          ]),
      body: (items == null || items == [])
          ? Container(
              child: Text("No video uploaded"),
            )
          : new ListView(
              children: items.map((item) {
                return new Container(
                  margin: new EdgeInsets.only(bottom: 20.0),
                  child: new Card(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Chewie(controller: item.controller),
                        Align(
                          alignment: Alignment.center,
                          child: FlatButton.icon(
                            label: Text('Delete Video'),
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              item.delete();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
