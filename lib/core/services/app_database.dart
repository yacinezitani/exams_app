import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// The single SQLite connection. Schema changes bump [version] and add an
/// `onUpgrade` step; never edit an earlier migration.
class AppDatabase {
  final Database db;
  AppDatabase._(this.db);

  static const int version = 1;
  static const String _fileName = 'recall.db';

  /// [path] is overridable so tests can pass `inMemoryDatabasePath`.
  static Future<AppDatabase> open({String? path}) async {
    final resolved = path ?? p.join(await getDatabasesPath(), _fileName);
    final db = await openDatabase(
      resolved,
      version: version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, _) async {
        final batch = db.batch();
        for (final statement in _schemaV1) {
          batch.execute(statement);
        }
        await batch.commit(noResult: true);
      },
    );
    return AppDatabase._(db);
  }

  Future<void> close() => db.close();

  static const List<String> _schemaV1 = [
    '''
CREATE TABLE decks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  subject TEXT NOT NULL,
  color INTEGER NOT NULL,
  created_at INTEGER NOT NULL
)''',
    '''
CREATE TABLE cards (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  deck_id INTEGER NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  front TEXT NOT NULL,
  back TEXT NOT NULL,
  image_path TEXT,
  important INTEGER NOT NULL DEFAULT 0,
  ease REAL NOT NULL DEFAULT 2.5,
  interval_days INTEGER NOT NULL DEFAULT 0,
  due_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
)''',
    '''
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
)''',
    '''
CREATE TABLE card_tags (
  card_id INTEGER NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
  tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (card_id, tag_id)
)''',
    '''
CREATE TABLE deck_tags (
  deck_id INTEGER NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (deck_id, tag_id)
)''',
    '''
CREATE TABLE reviews (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  card_id INTEGER NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 0 AND 3),
  reviewed_at INTEGER NOT NULL,
  mode TEXT NOT NULL CHECK (mode IN ('study', 'exam'))
)''',
    'CREATE INDEX idx_cards_deck ON cards(deck_id)',
    'CREATE INDEX idx_cards_due ON cards(due_at)',
    'CREATE INDEX idx_reviews_card ON reviews(card_id)',
    'CREATE INDEX idx_reviews_at ON reviews(reviewed_at)',
  ];
}
