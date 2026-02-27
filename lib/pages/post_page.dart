import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottombar.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Page")),
      bottomNavigationBar: const Bottombar(),
    );
  }
}
