// class VnExpressApi{
//   Future<Items> getBanner() async{
//     var response = await Dio().get('https://api.tiki.vn/v2/home/banners/v2');
//     if (response.statusCode != HttpStatus.ok) {
//       return new Future.error(response.statusMessage);
//     }
//     return Items.fromJson(response.data);
//   }
// }