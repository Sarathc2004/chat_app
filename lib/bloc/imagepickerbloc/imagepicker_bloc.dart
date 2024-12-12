import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watsappchatscreen/bloc/imagepickerbloc/imagepicker_event.dart';
import 'package:watsappchatscreen/bloc/imagepickerbloc/imagepicker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<PickImageEvent>((event, emit) async {
      try {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          emit(ImagePickedState(pickedFile.path));
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    });
  }
}
