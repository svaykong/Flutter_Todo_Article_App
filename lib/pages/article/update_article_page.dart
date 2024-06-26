import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
    super.dispose();
  }

  Future<void> onUpdate(BuildContext context) async {
    if (_updateFormKey.currentState!.validate()) {
      var postData = Article.toMap(_titleCtr.text, _descCtr.text);

      setState(() {
        _showLoading = true;
      });

      try {
        await _articleProvider.onUpdateArticle(_updateArticle!.id, postData);

        setState(() {
          _showLoading = false;
        });

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update article successfully...'),
          ),
        );

        if (!context.mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        'onUpdate exception:: [$e]'.log();

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
        title: Text('Update Article'),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _showLoading,
          child: Form(
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
                      await onUpdate(context);
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
                  onPressed: () async => await onUpdate(context),
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
      ),
    );
  }
}
