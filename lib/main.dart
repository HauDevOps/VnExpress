import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vnexpress/model/items_model.dart';
import 'package:vnexpress/model/vn_express_model.dart';
import 'package:vnexpress/page/detail_page.dart';
import 'package:vnexpress/theme/theme.dart';
import 'package:vnexpress/utils.dart';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        );
      }
  }


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool _isOn = true;
typedef void BoolCallback(bool val);

class _MyHomePageState extends State<MyHomePage> {
  VnExpressEntity entity = new VnExpressEntity();

  Future<VnExpressEntity> getFromXML() async {
    String _title;
    List<Items> _items = [];

    var response =
    await Dio().get('https://vnexpress.net/rss/tin-moi-nhat.rss');
    if (response.statusCode != HttpStatus.ok) {
      return new Future.error(response.statusMessage);
    }

    print(response.data);

    final rss = xml.parse(response.data);

    rss.findAllElements('channel').forEach((element) {
      _title = element.findElements('title').single.text;
    });

    rss.findAllElements('item').forEach((element) {
      _items.add(Items(
          title: element.findElements('title').single.text,
          link: element.findElements('link').single.text,
          description: element.findElements('description').single.text));
    });

    entity.items = _items;
    entity.title = _title;

    setState(() {});

    print(_title);
  }

  // String chuoi = '<![CDATA[<a href="https://vnexpress.net/5-tinh-cach-pho-bien-ve-tien-bac-4271826.html"><img src="https://i1-kinhdoanh.vnecdn.net/2021/05/03/5-kieu-tinh-cach-trong-tien-ba-8758-2522-1620018901.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=2nHygatZIN88_Fckyz3RUg" ></a></br>Tiết kiệm thái quá, nô lệ cho tiền bạc hoặc nghiện chi tiêu... là những quan niệm mà chuyên gia Nhật cho rằng không nên theo đuổi bất cứ thái cực nào.]]>';

  // String _image(String description){
  //   int batdau = description.indexOf('src="');
  //   int ketthuc = description.indexOf('');
  //   print('image url : => ${description.substring(batdau + 5, ketthuc)}');
  //   return description.substring(batdau + 5, ketthuc);
  // }

  // String _content(String description){
  //   int batdau = description.indexOf('/a></br>');
  //   int ketthuc = description.indexOf('.]]>');
  //   print('image url : => ${description.substring(batdau, ketthuc)}');
  //   return description.substring(batdau, ketthuc);
  // }


  void toggle() {
    setState(() => _isOn = !_isOn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFromXML();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${entity.title}'),
        actions: [
          Switch(value: true, onChanged: (val){
            toggle();}, activeColor: Colors.grey,),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getFromXML,
        child: (entity.items != null)
            ? ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entity.items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${entity.items[index].title}', style: TextStyle(fontSize: 20),),
                  Image.network(Utils.getImageUrl(entity.items[index].description)),
                  Text(Utils.getContent(entity.items[index].description)),
                ],
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailPage(url: entity.items[index].link,)),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        )
            : Container(
          width: 0,
          height: 0,
        ),
      ),
    );
  }
}




