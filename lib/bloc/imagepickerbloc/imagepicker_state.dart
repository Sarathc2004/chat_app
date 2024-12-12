abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickedState extends ImagePickerState {
  final String imagePath;

  ImagePickedState(this.imagePath);
}
