import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SmartAccountApp());

class SmartAccountApp extends StatelessWidget {
  const SmartAccountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رسائل المحاسب الذكي',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0968C5)),
        fontFamily: 'Arial',
      ),
      home: const CustomerWebScreen(),
    );
  }
}

class CustomerWebScreen extends StatefulWidget {
  const CustomerWebScreen({super.key});

  @override
  State<CustomerWebScreen> createState() => _CustomerWebScreenState();
}

class _CustomerWebScreenState extends State<CustomerWebScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF3F6FA))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _loading = true),
        onPageFinished: (_) => setState(() => _loading = false),
        onNavigationRequest: (request) async {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          final scheme = uri.scheme.toLowerCase();
          if (scheme == 'https' || scheme == 'http' || scheme == 'file' || scheme == 'data' || scheme == 'about') {
            if ((scheme == 'https' || scheme == 'http') &&
                (uri.host == 'wa.me' || uri.host.endsWith('whatsapp.com'))) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          }
          if (scheme == 'sms' || scheme == 'smsto' || scheme == 'whatsapp' || scheme == 'tel') {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.prevent;
        },
      ));
    _loadLocalPage();
  }

  Future<void> _loadLocalPage() async {
    final html = await DefaultAssetBundle.of(context).loadString('assets/index.html');
    final encoded = Uri.dataFromString(html, mimeType: 'text/html', encoding: utf8);
    await _controller.loadRequest(encoded);
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(minHeight: 3),
              ),
          ]),
        ),
      ),
    );
  }
}