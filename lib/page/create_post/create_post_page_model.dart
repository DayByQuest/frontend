import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class CreatePostViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final PostRepository _postRepository;
  Status status = Status.loading;
  SelectedImagesDetails? images;
  final List<SelectedByte> selectedBytes;
  final SelectedImagesDetails details;
  String content = "";
  int questId = -1;
  String questTitle = "";

  CreatePostViewModel({
    required PostRepository postRepository,
    required this.details,
    required this.selectedBytes,
    required errorStatusProvider,
  })  : _postRepository = postRepository,
        _errorStatusProvider = errorStatusProvider;

  Future<void> selectUserImages(context) async {
    ImagePickerPlus picker = ImagePickerPlus(context);

    images = await picker.pickImage(
      source: ImageSource.gallery,
      galleryDisplaySettings: GalleryDisplaySettings(
        cropImage: true,
        maximumSelection: 5,
      ),
      multiImages: true,
    );

    return;
  }

  Future<void> createPost() async {
    try {
      debugPrint('createPost start');
      if (questId != -1) {
        debugPrint('createPost with quest');
        await _postRepository.postCreatePost(selectedBytes, content,
            questId: questId);
      } else {
        debugPrint('createPost without quest');
        await _postRepository.postCreatePost(
          selectedBytes,
          content,
        );
      }

      debugPrint('createPost end');
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('createPost error: ${e.toString()}');
    }
  }

  void setContent(String input) {
    content = input;
    notifyListeners();
  }

  void setQuest(int id, String title) {
    questId = id;
    questTitle = title;
    notifyListeners();
  }
}
