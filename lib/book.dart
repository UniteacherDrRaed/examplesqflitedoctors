  import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database=await openDatabase(
    join(await getDatabasesPath(),
        "books_database.db"),
    version: 1,
    onCreate: (Database db,int version) async{
      return await db.execute(
        '''
        create table books(
        id integer primary key,
        title text not null,
        author text not null
        )
        '''
      );
    }
  );

  Future<int> addBook(Book book) async{
    final db=await database;
    int id=await db.insert("books",
        book.toMap());
    return id;
  }

  Future<List<Book>> getAllBooks() async{
    final db=await database;
    List<Map<String,Object?>> bookslist=await db.query("books");
    List<Book> x=[];
    for(var e in bookslist){
      x.add(Book(id: e['id'] as int,
          title: e['title'] as String,
          author: e['author'] as String));
    }
    return x;
  }

  Book algorithms=Book(id: 0, title: "Introduction to algorithms",
      author: "T.Cormen et al");
  int i=await addBook(algorithms);
  print(i);
  List<Book> allBooks= await getAllBooks();
  print(allBooks);
}

class Book{
  final int id;
  final String title;
  final String author;

  Book({required this.id, required this.title,
  required this. author});

  Map<String, Object?> toMap(){
    return {
      'id':id,
      'title':title,
      'author':author
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "($id,$title,$author)";
  }
}