import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../utils/logger.dart';
import '../../providers/export_provider.dart';
import '../../models/article_model.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  static const routeId = '/add-article-page';

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  bool _showLoading = false;
  final GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtr;
  late final TextEditingController _descCtr;
  late final FocusNode _titleFocusNode;
  late final FocusNode _descFocusNode;
  late final ArticleProvider _articleProvider;

  @override
  void initState() {
    super.initState();
    _titleCtr = TextEditingController();
    _descCtr = TextEditingController();
    _titleFocusNode = FocusNode();
    _descFocusNode = FocusNode();
    _articleProvider = context.read<ArticleProvider>();
  }

  @override
  void dispose() {
    _titleCtr.dispose();
    _descCtr.dispose();
    super.dispose();
  }

  Future<void> onCreate(BuildContext context) async {
    if (_createFormKey.currentState!.validate()) {
      var postData = Article.toMap(_titleCtr.text, _descCtr.text);

      setState(() {
        _showLoading = true;
      });

      try {
        await _articleProvider.onCreateArticle(postData);

        setState(() {
          _showLoading = false;
        });

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Create article successfully...'),
          ),
        );

        if (!context.mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        'onCreate exception:: [$e]'.log();

        // un-expect error set _showLoading to false
        setState(() {
          _showLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Article'),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _showLoading,
          child: Form(
            key: _createFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    onTapOutside: (event) {
                      if (_titleFocusNode.hasFocus) {
                        _titleFocusNode.unfocus();
                      }
                    },
                    focusNode: _titleFocusNode,
                    controller: _titleCtr,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Input title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'title is required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTapOutside: (event) {
                      if (_descFocusNode.hasFocus) {
                        _descFocusNode.unfocus();
                      }
                    },
                    onFieldSubmitted: (event) async {
                      await onCreate(context);
                    },
                    focusNode: _descFocusNode,
                    controller: _descCtr,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Input description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'description is required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () async => await onCreate(context),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
