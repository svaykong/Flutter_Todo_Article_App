import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../article/update_article_argument.dart';
import '../../utils/logger.dart';
import '../../providers/export_provider.dart';
import '../../models/article_model.dart';

class UpdateArticlePage extends StatefulWidget {
  const UpdateArticlePage({super.key});

  static const routeId = '/update-article-page';

  @override
  State<UpdateArticlePage> createState() => _UpdateArticlePageState();
}

class _UpdateArticlePageState extends State<UpdateArticlePage> {
  bool _showLoading = false;
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtr;
  late final TextEditingController _descCtr;
  late final FocusNode _titleFocusNode;
  late final FocusNode _descFocusNode;
  late final ArticleProvider _articleProvider;
  Article? _updateArticle;

  @override
  void initState() {
    super.initState();

    _articleProvider = context.read<ArticleProvider>();
    _articleProvider.addListener(onArticleChange);

    _titleFocusNode = FocusNode();
    _descFocusNode = FocusNode();

    _titleCtr = TextEditingController();
    _descCtr = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Extract the arguments from the current ModalRoute
      // settings and cast them as UpdateArticleArgument.
      final args = ModalRoute.of(context)!.settings.arguments as UpdateArticleArgument;
      _updateArticle = args.article;
      _titleCtr.text = _updateArticle?.title ?? '';
      _descCtr.text = _updateArticle?.description ?? '';
    });
  }

  @override
  void dispose() {
    _titleCtr.dispose();
    _descCtr.dispose();
    _articleProvider.removeListener(onArticleChange);
    super.dispose();
  }

  void onArticleChange() async {
    '[Update Article Page] on article change::'.log();

    if (_articleProvider.errorMsg.isNotEmpty) {
      return;
    } else if (_articleProvider.isLoading) {
      setState(() {
        _showLoading = true;
      });
    } else {
      setState(() {
        _showLoading = false;
      });
    }
  }

  Future<void> onUpdate() async {
    if (_updateFormKey.currentState!.validate()) {
      var postData = Article.toMap(_titleCtr.text, _descCtr.text);
      await _articleProvider.onUpdateArticle(_updateArticle!.id, postData).then((_) => Navigator.of(context).pop(true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Article'),
      ),
      body: SafeArea(
        child: _showLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _updateFormKey,
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
                          await onUpdate();
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
                      onPressed: () async => await onUpdate(),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
