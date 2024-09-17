import 'dart:io';
import 'package:emarates_bd/app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/providers/api_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart' as dio;

class Yandex extends StatefulWidget {
  @override
  YandexState createState() => YandexState();
}

class YandexState extends State<Yandex> with ApiClient {
  late dio.Dio _httpClient;
  late dio.Options _optionsNetwork;
  late dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = new dio.Dio();
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

// Reference to webview controller
  WebViewController? _controller;

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://kakdoma.online/admin/login/yandex',
      javascriptMode: JavascriptMode.unrestricted,

      onWebViewCreated: (WebViewController webViewController) async {
        _controller = webViewController;
      },
      // onPageFinished: (String url) {
      //   print('Page finished loading: $url');
      //   // In the final result page we check the url to make sure  it is the last page.
      //   if (url.contains('/finalresponse.html')) {
      //  var ss=   _controller.evaluateJavascript("(function(){Flutter.postMessage(window.document.body.outerHTML)})();");
      //  print('ss');
      //  print(ss);
      //   }
      // },
      onPageFinished: (_) async {
        // String html = await _controller.evaluateJavascript("window.document.getElementsById('root');");

        // String html =await _controller.evaluateJavascript("document.documentElement.innerHTML");
      },
      navigationDelegate: (NavigationRequest request) async {
        if (request.url
            .startsWith('https://kakdoma.online/admin/login/yandex')) {
          //You can do anything

          //Prevent that url works
          return NavigationDecision.prevent;
        }
        if (request.url == ('https://kakdoma.online/admin/login')) {
          print('hj');
          Get.toNamed(Routes.LOGIN);
        }
        print('url');
        print(request.url);
        //Any other url works
        String html = await _controller!
            .evaluateJavascript("window.document.getElementById('test');");
// print('_controller.getTitle()');
// print(_controller.getTitle());
        // String html = _controller?.loadUrl(Uri.dataFromString(request.url, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString()).toString();
        // String html = await _controller.evaluateJavascript('document.documentElement.innerHTML') as String;
        // print(docu);
        // var dom = parse(html);
        // print(dom.getElementsByTagName('title')[0].innerHtml);
        print('html');
        print(html);
        // print('changed');
        // print(NavigationDecision.values);
        // print('url');
        // print(request.url);

        // Uri _uri = getApiBaseUri("slider");
        // Get.log(_uri.toString());
        // var response = await _httpClient.getUri(_uri, options: _optionsCache);
        // if (response.data['success'] == true) {
        //   // return response.data['data'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
        // } else {
        //   throw new Exception(response.data['message']);
        // }

        return NavigationDecision.navigate;
      },
    );
  }
}
