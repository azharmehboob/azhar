import 'dart:convert';
import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetApi extends StatefulWidget {
  const GetApi({Key? key}) : super(key: key);

  @override
  State<GetApi> createState() => _GetApiState();
}

class _GetApiState extends State<GetApi> {
  // String statement = '';
  // String punchline = '';
  bool loading = false;
  // bool showPunch = false;
  bool networkError = false;
  List universityData = [];
  // String country = '';
  // String province = '';
  var data = [];
  int i = 0;

  getData() async {
    try {
      networkError = false;
      // showPunch = false;
      loading = true;
      log('api calling.....');
      setState(() {});
      var api = "http://universities.hipolabs.com/search?country=pakistan";

      var response = await http
          .get(
            Uri.parse(api),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        universityData = data.toList();

        // statement = data['setup'];
        // punchline = data['punchline'];
        if (kDebugMode) {
          print(response.statusCode);
          // print(universityName);
          // print(country);
          // print(province);
          // print(statement);
          // print(punchline);
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print('server error');
        }
      }
      loading = false;
      log('api end.....');
      setState(() {});
    } catch (error) {
      loading = false;
      networkError = true;
      debugPrint('Network Error');
      debugPrint(error.toString());
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.greenAccent,
                  Colors.white,
                  Colors.lightGreenAccent
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width*0.9,
              alignment: Alignment.center,
              // color: Colors.lime,
              child: networkError
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            'assets/lotti_files/network-error-super-hero.json',
                            height: 300),
                        const Text(
                          'Please check Your Internet Connection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            backgroundColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            getData();
                          },
                          child: loading
                              ? Lottie.asset('assets/lotti_files/loading.json',
                                  height: 70)
                              : const Text(
                                  'Refresh',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.9,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      childAspectRatio: 5/2.5,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: universityData.length,
                              itemBuilder: (BuildContext ctx, i) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: Text(universityData[i]["alpha_two_code"], textAlign: TextAlign.center,),
                                    ),
                                    title: Text(universityData[i]['name']),
                                  ),
                                );
                              }),
                        ),
                    //     OutlinedButton(
                    //       onPressed: () {
                    //         getData();
                    //       },
                    //       child: loading
                    //           ? Lottie.asset('assets/lotti_files/loading.json',
                    //               height: 70)
                    //           : const Text(
                    //               'Try New',
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 20,
                    //                   color: Colors.white),
                    //             ),
                    //     ),
                    //   ],
                    // ),
            ], ),
            ),

          )
        ],
      ),
    ));
  }
}
