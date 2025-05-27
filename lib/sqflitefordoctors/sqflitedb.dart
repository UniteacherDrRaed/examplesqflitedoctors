import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled33/model/doctor.dart';
class SqfliteDatabase{
  static Future<Database> databasedoctors() async{
    return await openDatabase(
      join(await getDatabasesPath(),"doctors_database.db"),
      version: 1,
      onCreate: (Database db, int version) async{
        return db.execute(
          '''
          create table doctors(
          id integer primary key autoincrement,
          name text not null,
          address text not null
          )
          '''
        );
      }
    );
  }
  static Future<int> addDoctor(Doctor doctor) async{
   final db= await SqfliteDatabase.databasedoctors();
    int id =await db.insert("doctors",
        doctor.toMap());
    return id;
  }

  static Future<int> updateDoctor(Doctor doctor) async{
    final db=await SqfliteDatabase.databasedoctors();
  int i=  await db.update("doctors", doctor.toMap(),
     where: 'id = ?',
    whereArgs: [doctor.id]);
   return i;
  }

static Future<void> deleteDoctor(int id) async{
    final db = await SqfliteDatabase.databasedoctors();
    await db.delete("doctors",
    where: 'id = ?',
    whereArgs: [id]);
}
  static Future<List<Doctor>> getAllDoctors() async{
    final db= await SqfliteDatabase.databasedoctors();
     List<Map<String,Object?>> doctorsInfo=
     await db.query("doctors");
     List<Doctor> allDoctors=[];
     for(var e in doctorsInfo){
       allDoctors.add(
           Doctor(id:e['id'] as int,
               name: e['name'] as String,
               address: e['address'] as String));
     }
     return allDoctors;
  }
}