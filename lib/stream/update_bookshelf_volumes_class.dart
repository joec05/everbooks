import 'dart:async';

class BookshelfVolumesStreamControllerClass{
  final int bookshelfID;

  BookshelfVolumesStreamControllerClass(
    this.bookshelfID,
  );
}

class UpdateBookshelfVolumesStreamClass {
  static final UpdateBookshelfVolumesStreamClass _instance = UpdateBookshelfVolumesStreamClass._internal();
  late StreamController<BookshelfVolumesStreamControllerClass> _updateBookshelfVolumesStreamController;

  factory UpdateBookshelfVolumesStreamClass(){
    return _instance;
  }

  UpdateBookshelfVolumesStreamClass._internal() {
    _updateBookshelfVolumesStreamController = StreamController<BookshelfVolumesStreamControllerClass>.broadcast();
  }

  Stream<BookshelfVolumesStreamControllerClass> get updateBookshelfStream => _updateBookshelfVolumesStreamController.stream;


  void removeListener(){
    _updateBookshelfVolumesStreamController.stream.drain();
  }

  void emitData(BookshelfVolumesStreamControllerClass data){
    if(!_updateBookshelfVolumesStreamController.isClosed){
      _updateBookshelfVolumesStreamController.add(data);
    }
  }

  void dispose(){
    _updateBookshelfVolumesStreamController.close();
  }
}