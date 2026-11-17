import 'package:exam_app/core/models/card_model.dart';
import 'package:exam_app/core/models/deck_model.dart';
import 'package:exam_app/core/models/review_log_model.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug-only sample data so Home can be seen before the Decks feature exists.
/// Runs once: [_flag] stops it from refilling after the user deletes decks.
abstract final class DevSeed {
  static const _flag = 'dev_seed_done';

  static Future<void> run(
    AppDatabase database,
    SharedPreferences prefs, {
    DateTime? now,
  }) async {
    if (prefs.getBool(_flag) ?? false) return;
    final db = database.db;
    final hasDecks = (await db.rawQuery('SELECT 1 FROM decks LIMIT 1')).isNotEmpty;
    if (hasDecks) return;

    final today = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    final base = now ?? today;
    DateTime day(int offset) => DateTime(base.year, base.month, base.day + offset);

    final studied = <int>[];
    for (final deck in _decks) {
      final deckId = await db.insert(
        'decks',
        DeckModel(
          name: deck.name,
          subject: deck.subject,
          color: deck.color,
          createdAt: day(-20),
        ).toJson(),
      );
      for (var i = 0; i < deck.cards.length; i++) {
        final (interval, dueOffset) = _schedule[i % _schedule.length];
        final cardId = await db.insert(
          'cards',
          CardModel(
            deckId: deckId,
            front: deck.cards[i].$1,
            back: deck.cards[i].$2,
            important: i % 6 == 0,
            ease: 2.3 + (i % 4) * 0.1,
            intervalDays: interval,
            dueAt: day(dueOffset),
            createdAt: day(-20),
          ).toJson(),
        );
        if (interval > 0) studied.add(cardId);
      }
    }

    // 12 consecutive study days ending yesterday: a 12-day streak, today pending.
    final batch = db.batch();
    for (var d = 1; d <= 12; d++) {
      batch.insert(
        'reviews',
        ReviewLogModel(
          cardId: studied[d % studied.length],
          rating: 2,
          reviewedAt: day(-d).add(const Duration(hours: 12)),
        ).toJson(),
      );
    }
    await batch.commit(noResult: true);
    await prefs.setBool(_flag, true);
  }

  /// (interval days, due offset in days from today). Offsets <= 0 are due.
  static const _schedule = <(int, int)>[
    (0, 0), (1, 0), (3, -1), (8, 5), (15, 9),
    (3, 2), (8, 0), (0, 0), (1, 1), (15, 12),
  ];

  static const _decks = <_SeedDeck>[
    _SeedDeck('Cell Biology', 'Biology', 0xFF4F46E5, [
      ('Which organelle produces most of the cell’s ATP?', 'The mitochondrion.'),
      ('What is the function of the rough endoplasmic reticulum?', 'Synthesising proteins, thanks to the ribosomes on its surface.'),
      ('What does the Golgi apparatus do?', 'Modifies, sorts and packages proteins and lipids for transport.'),
      ('What separates the cell from its surroundings?', 'The plasma membrane, a phospholipid bilayer.'),
      ('Which stage of cellular respiration produces the most ATP?', 'Oxidative phosphorylation, in the electron transport chain.'),
      ('Where does photosynthesis take place?', 'In the chloroplasts.'),
      ('What is osmosis?', 'The diffusion of water across a semi-permeable membrane toward higher solute concentration.'),
      ('Which phase of mitosis aligns chromosomes at the cell’s equator?', 'Metaphase.'),
      ('What is the role of lysosomes?', 'Digesting waste, worn-out organelles and engulfed particles with hydrolytic enzymes.'),
      ('What is the difference between prokaryotic and eukaryotic cells?', 'Eukaryotes have a nucleus and membrane-bound organelles; prokaryotes do not.'),
      ('What does the cytoskeleton do?', 'Gives the cell shape, anchors organelles and enables movement.'),
      ('What is active transport?', 'Moving molecules against their gradient using energy, usually ATP.'),
    ]),
    _SeedDeck('Genetics', 'Biology', 0xFF0F766E, [
      ('What are alleles?', 'Different versions of the same gene.'),
      ('State Mendel’s law of segregation.', 'Each parent passes on only one of its two alleles for a trait to each offspring.'),
      ('What is the genotype ratio of Aa × Aa?', '1 AA : 2 Aa : 1 aa.'),
      ('What is a codon?', 'A sequence of three nucleotides that codes for one amino acid.'),
      ('Which enzyme unwinds DNA during replication?', 'Helicase.'),
      ('What is the difference between genotype and phenotype?', 'Genotype is the genetic makeup; phenotype is the observable trait.'),
      ('What is a point mutation?', 'A change in a single nucleotide of the DNA sequence.'),
      ('Where does transcription occur in eukaryotic cells?', 'In the nucleus.'),
      ('What is codominance?', 'Both alleles are fully expressed in the heterozygote, as in AB blood type.'),
      ('How many chromosomes does a normal human somatic cell have?', '46, in 23 pairs.'),
    ]),
    _SeedDeck('WWI Causes', 'History', 0xFFB45309, [
      ('What event directly triggered the outbreak of World War I?', 'The assassination of Archduke Franz Ferdinand in Sarajevo, 28 June 1914.'),
      ('What does MAIN stand for in the long-term causes of WWI?', 'Militarism, Alliances, Imperialism, Nationalism.'),
      ('Which two alliance blocs faced each other in 1914?', 'The Triple Entente and the Triple Alliance.'),
      ('Why did Britain enter the war in August 1914?', 'Germany invaded neutral Belgium, whose neutrality Britain had guaranteed.'),
      ('What was the Schlieffen Plan?', 'Germany’s plan to defeat France quickly through Belgium, then turn east against Russia.'),
      ('How did the naval arms race affect Anglo-German relations?', 'Germany’s fleet expansion threatened British naval supremacy and fuelled mistrust.'),
      ('What was the “blank cheque” of 1914?', 'Germany’s unconditional support to Austria-Hungary against Serbia.'),
      ('Which empire’s decline created tension in the Balkans?', 'The Ottoman Empire.'),
      ('What role did nationalism play in Serbia’s ambitions?', 'Pan-Slavism and the wish to unite South Slavs clashed with Austria-Hungary’s rule.'),
      ('Which country mobilised first in July 1914 to support Serbia?', 'Russia.'),
    ]),
  ];
}

class _SeedDeck {
  final String name;
  final String subject;
  final int color;
  final List<(String, String)> cards;
  const _SeedDeck(this.name, this.subject, this.color, this.cards);
}
