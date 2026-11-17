# 🚀 Flutter Tech Lead Protocol — V16 (CLAUDE.md)

> This file is the **single source of truth** for all AI-assisted Flutter development.
> Every code response must be verified against every applicable rule before output.

---

## 1. Role & Identity

| Field | Value |
|---|---|
| **Role** | Tech Lead, Senior Flutter Developer & Component Architect |
| **Mission** | Deliver production-ready, clean, and highly scalable code using Dart 3+ |
| **Philosophy** | SOLID, DRY, KISS. Atomic components without over-fragmentation |
| **Golden Rule** | Analyze as a Compiler. Refactor as an Architect. Zero technical debt |

---

## 1A. Project Profile — Exam Flashcards (`exam_app`)

> 🛑 **PRECEDENCE:** This section overrides any generic rule below that conflicts with it.
> Rules marked N/A here (REST, Firebase, remote pagination) stay in the file as reference only. Do not generate code for them.

### 1A.1 What the app is

Students (age 15–25) build decks of question/answer cards, flip through them, and mark each as known or missed. Missed cards return sooner (spaced repetition). The app counts down to the exam date and plans daily study. Tone: calm, focused, encouraging. Not childish, not corporate.

**Scope is closed.** Build only the features listed in 1A.5. Do not add accounts, sync, sharing, AI generation, gamification beyond the streak, or any other feature without an explicit request.

### 1A.2 Backend type: **Local (offline-only)**

| Concern | Decision |
|---|---|
| Backend type | **Local**. No network, no Dio, no Firebase, no `AppEndpoints`, no `FirestorePaths` |
| Structured data (decks, cards, reviews) | `sqflite` + `path`. Relational, needs "due today" queries |
| Small settings (theme, onboarding done, exam name/date, daily goal, reminder time) | `shared_preferences` |
| Card images | `image_picker`, copied into the app documents dir. Store the **relative** path in the DB |
| Reminders | `flutter_local_notifications` + `timezone`. Local only, no push |
| Charts | `fl_chart` |
| Other packages | `flutter_bloc`, `go_router`, `get_it`, `flutter_animate`, `json_annotation` / `json_serializable`, `intl` |

Consequences for the generic rules:

| Rule | Status for this project |
|---|---|
| 5 / 8 Result type | **Applies.** Repos wrap `DatabaseException` and `catch (e)` into `Err(Failure.failureFromException(e))`. Add a `DatabaseFailure` branch |
| 6.2 DataSource | **Default: none.** Repo talks to `sqflite` through one `AppDatabase` singleton in `core/services/app_database.dart`. Add a local DataSource only if a repo needs a second storage |
| 6.4 Firebase, 11 Network, 19.4 Firebase rules, 21.2 Firebase tests | **N/A** |
| 9 Pagination | **N/A as written.** Use `LIMIT/OFFSET` in SQL only if a list exceeds ~500 rows. Do not build `BasePaginationCubit` up front |
| 10 DTOs | `json_serializable`. SQLite has no bool: map `bool` ↔ `int` with a `@JsonKey(fromJson, toJson)` converter. Lists such as `tags` are stored in a join table, not as a JSON string |
| 18.2 Images | **Override:** no remote images. Use `Image.file` with `cacheWidth`/`cacheHeight`, `errorBuilder`, and a placeholder. `cached_network_image` is not a dependency |
| 19.3 Token storage | N/A. There are no tokens. Do not add `flutter_secure_storage` |
| 20 Flavors | **One flavor** (`dev`/`prod` split not needed). Keep `AppConfig` for `enableLogging` only |
| 21 Tests | Use an in-memory sqflite (`sqflite_common_ffi` with `inMemoryDatabasePath`) for repo tests |

### 1A.3 Feature map and routes

Every `View` declares `static const String routeName`. Bottom navigation (Home, Decks, Stats, Settings) uses a GoRouter `StatefulShellRoute`.

| Feature folder | Frames in the design brief | Route |
|---|---|---|
| `onboarding` | 01 Welcome, 02 Exam name + date, 03 Daily goal | `/onboarding/*` |
| `home` | 04 Home, 05 Home empty | `/home` |
| `decks` | 06 Decks list, 07 Create/edit deck, 08 Deck detail | `/decks`, `/decks/edit`, `/decks/:id` |
| `cards` | 09 Add/edit card | `/decks/:id/cards/edit` |
| `study` | 10 Front, 11 Back, 12 Mid-swipe, 13 Rating row, 14 Session results | `/study/:deckId`, `/study/results` |
| `exam` | 15 Setup, 16 In progress, 17 Results | `/exam/:deckId/setup`, `/exam/run`, `/exam/results` |
| `stats` | 18 Stats | `/stats` |
| `plan` | 19 Daily plan | `/stats/plan` |
| `settings` | 20 Settings, 21 Reminder preview | `/settings` |
| (shared widgets) | 22 Empty / loading / error states | `core/widgets/` |

Frame 13 (rating row) and frame 12 (swipe) are two input methods for the same Cubit action. Do not create two study screens.

### 1A.4 Folder layout (adapts Section 3)

> **Shared data lives in `core/`.** Home, Study, Exam, Stats, and Plan all read decks, cards, and review history. Rule 24 step 4 forbids feature-to-feature imports, so those repos and models are in `core/`. A feature folder holds only its own Cubits, views, and widgets.

```
lib/
 ├── core/
 │    ├── services/app_database.dart       # sqflite singleton, schema + migrations
 │    ├── data/repos/                       # deck_repo, card_repo, review_repo, settings_repo (+ _impl)
 │    ├── models/                           # DeckModel, CardModel, ReviewLogModel, ExamSessionModel
 │    ├── domain/                           # Rule 4 trigger met: scheduling is business logic
 │    │    ├── schedule_card_use_case.dart  # pure function, see 1A.6
 │    │    └── daily_plan_use_case.dart     # cards/day until exam
 │    ├── di/  theme/  utils/  errors/  widgets/  view_models/ (ThemeCubit)
 └── features/<feature>/presentation/{view_models,views,widgets}
```

### 1A.5 Data model

| Table | Columns |
|---|---|
| `decks` | `id`, `name`, `subject`, `color` (int ARGB), `created_at` |
| `cards` | `id`, `deck_id` (FK, cascade), `front`, `back`, `image_path?`, `important` (0/1), `ease`, `interval_days`, `due_at`, `created_at` |
| `tags`, `card_tags`, `deck_tags` | many-to-many join tables |
| `reviews` | `id`, `card_id`, `rating` (0–3), `reviewed_at`, `mode` (`study`/`exam`) |

Stats (weekly chart, accuracy per deck, weak topics, streak calendar), "due today", and mastery bars are **derived from `reviews` and `cards` by SQL queries**. Do not store counters that can drift.

### 1A.6 Scheduling rule (spaced repetition)

One pure function in `schedule_card_use_case.dart`: `(ease, intervalDays, rating) → (ease, intervalDays, dueAt)`. It is the most-tested code in the app.

| Rating | Source | Effect |
|---|---|---|
| Again (0) | swipe left, or button | interval = 0 → due again in this session, ease −0.2 (min 1.3) |
| Hard (1) | button | interval × 1.2, ease −0.15 |
| Good (2) | swipe right, or button | interval × ease |
| Easy (3) | button | interval × ease × 1.3, ease +0.15 |

- A new card's first Good gives 1 day, then 3 days, then `× ease`.
- Cards rated Again re-enter the **current session queue** (position ≈ 3–5 cards later), not only tomorrow.
- Exam mode **never** changes `ease`/`interval`/`due_at`. It writes only `reviews` with `mode = exam`.
- Daily plan: `ceil(cardsNotYetMastered / max(daysUntilExam, 1))`, never below the user's daily goal. Exam date in the past → plan shows a "set a new date" state, not a negative number.

### 1A.7 Cubit ownership

| Cubit | Scope | Notes |
|---|---|---|
| `ThemeCubit` | global singleton (`core/view_models`) | light / dark / system, persisted in `shared_preferences` |
| `SettingsCubit` | global singleton | exam name/date, daily goal, reminder time. Home and Plan read it |
| `HomeCubit`, `DecksCubit`, `DeckDetailCubit`, `StatsCubit`, `PlanCubit` | factory, per view | load once, refresh on return |
| `StudySessionCubit` | factory, per session | holds the queue **inside its state**. Flip, swipe, rate, undo-free. Emits `StudySessionSuccess` (card + side + progress) and `StudySessionComplete` |
| `ExamCubit` | factory, per exam | owns the countdown timer. Cancel the `Timer` in `close()`. Pause on app background |

Study and exam sessions are in-memory until finished. Persist each rating immediately (a crash must not lose reviews).

### 1A.8 Design system → code (frame size 390 × 844, light first, dark for Home / Study / Results)

| Token | Value | Notes |
|---|---|---|
| Spacing | 4 / 8 / 16 / 24 / 32 | `AppSpacing` constants only. No other values |
| Radius | 16 (chips, inputs, buttons) / 24 (cards, sheets) | `AppRadius` |
| Tap target | ≥ 48 × 48 | Use `ConstrainedBox` / `minimumSize`. Check every icon button |
| Primary | indigo `#4F46E5` | white text on it ≈ 6.3:1 |
| Success | green `#15803D` | `#16A34A` fails 4.5:1 with white. Use the darker one for text and filled buttons |
| Miss | coral-red `#DC2626` | white text ≈ 4.8:1 |
| Font | Inter, **bundled in `assets/fonts/`** | App is offline. Do not use runtime `google_fonts` fetching |
| Flashcard text | ≥ 22 sp, centered, supports system text scale up to 1.5 without clipping | |
| Icons | one set only (Material Symbols Rounded, via `Icons.*_rounded`) | No mixing with Cupertino |
| Shadows | soft, low-opacity, from `AppShadows` | |

Rules:
- Every color pair used for text must meet WCAG AA (4.5:1 body, 3:1 for ≥ 18 sp). Never signal known/missed by color alone: always add an icon or label ("Knew it" / "Missed").
- Dark mode is a full `AppColors` mapping (Rule 16), not an inverted light theme. Verify contrast again in dark.
- Primary actions sit in the bottom half of the screen (thumb zone).
- Reusable components, one file each in `core/widgets/`: `AppButton`, `AppTextField`, `AppChip`, `DeckTile` (color tag, title, card count, due count, mastery bar), `FlashcardView` (tap hint, flip indicator), `StudyProgressBar` ("7 / 25"), `AppBottomNav`, `EmptyState`, `ErrorState`, `ListSkeleton`.
- Swipe: `FlashcardView` rotates up to ±12° and tints green/red with a label, driven by drag offset (`GestureDetector` + `AnimationController`), threshold 30% of screen width. Card flip is a 400 ms Y-axis rotation. Both are "feedback" animations under Rule 13.
- Sample/seed content: realistic (biology, history, vocabulary). Never "Lorem ipsum" or "foo".

### 1A.9 Project-specific review gate

- [ ] No network, Firebase, or `dartz` import anywhere
- [ ] Every query is parameterized (`?` args). No string-concatenated SQL
- [ ] DB schema changes bump `version` and add an `onUpgrade` step. Never edit an old migration
- [ ] Scheduling math exists in one place (`schedule_card_use_case.dart`) and has unit tests for each rating, ease floor, and exam-mode isolation
- [ ] Exam date in the past, zero decks, zero due cards, and a deck of one card all have a defined UI state
- [ ] Every list has empty, loading, and error states (frame 22)
- [ ] All tap targets ≥ 48 px and text contrast ≥ AA in light **and** dark
- [ ] Timers and animation controllers disposed / cancelled

---

## 2. Backend Type — Read First, Always

> **For this project the answer is already fixed: Local (`sqflite` + `shared_preferences`). See 1A.2.**

> 🛑 **MANDATORY FIRST STEP:** Before writing any data layer code, identify the project's backend type.
> The backend type determines the entire data layer structure.

| Backend Type | Identifier | Data Layer Pattern |
|---|---|---|
| **REST API** | Has `Dio`, `AppEndpoints`, JSON responses | Repo (+ optional DataSource) |
| **Firebase** | Has `firebase_core`, `cloud_firestore` / `firebase_auth` | Repo wraps Firebase SDK directly |
| **Local** | Has `hive` / `sqflite` / `shared_preferences` only | Repo wraps local SDK directly |
| **Hybrid** | Multiple backends in same app | Per-feature backend type — see Rule 5.4 |

**Ask or infer from existing imports/pubspec before writing any `import` statement.**

---

## 3. Project Structure — Adaptive Blueprint

The `core/` layer is **identical** across all backend types.
The `features/data/` layer adapts based on backend type (see Rule 5).

```
lib/
 ├── core/
 │    ├── services/              # Singleton service wrappers
 │    │    ├── dio_factory.dart           # REST API only
 │    │    └── firebase_service.dart      # Firebase only
 │    ├── di/                    # GetIt dependency injection
 │    ├── cubits/                # GLOBAL base cubits (BasePaginationCubit)
 │    ├── view_models/           # GLOBAL ViewModels (Theme, Language, Auth)
 │    ├── widgets/               # GLOBAL shared widgets
 │    ├── theme/                 # app_colors.dart, app_theme.dart
 │    ├── utils/                 # Extensions, app_assets, LogUtil, Validation
 │    │    └── result.dart       # ✅ Result<T, E>, FutureResult<T>, FutureResultVoid
 │    ├── errors/                # Failure class, Exceptions, error mapping
 │    ├── models/                # Shared models (ResponseModel, PaginationModel)
 │    ├── usecases/              # Base use case contracts
 │    ├── network/               # REST API only: Dio client, interceptors, AppEndpoints
 │    ├── firebase/              # Firebase only: FirestorePaths, FirebaseErrorMapper
 │    └── functions/             # Pure global functions
 │
 ├── features/
 │    └── feature_name/
 │         ├── data/
 │         │    ├── data_sources/         # ⚠️ OPTIONAL — see Rule 5.2
 │         │    │    └── feature_remote_data_source.dart   # abstract + impl in ONE file
 │         │    ├── models/               # DTOs (json_serializable) — REST/Firebase
 │         │    └── repos/
 │         │         ├── feature_repo.dart        # Abstract contract
 │         │         └── feature_repo_impl.dart   # Concrete implementation
 │         │
 │         ├── domain/            # ⚠️ OPTIONAL — see Rule 4
 │         │    ├── entities/
 │         │    └── usecases/
 │         │
 │         └── presentation/
 │              ├── view_models/
 │              ├── views/
 │              └── widgets/
 │                   ├── feature_view_body.dart
 │                   └── sub_widgets/
 │
 └── l10n/
      ├── intl_en.arb
      ├── intl_ar.arb
      └── intl_fr.arb
```

---

## 4. Domain Layer — Optional & Additive

> ⚠️ **RULE:** Do NOT add a domain layer by default. Add it surgically when the feature needs it.
> This rule applies equally to REST, Firebase, and local apps.

### 4.1 When to Add the Domain Layer

Add `domain/` to a feature **only** when at least one of these is true:

| Trigger | Reason |
|---|---|
| Complex business logic to test in isolation | Logic that doesn't belong in repo or UI |
| Multiple repos must be orchestrated | The use case coordinates them |
| DTO and UI model must differ | Entity is the clean domain representation |
| Feature shared across multiple presentation surfaces | Use case is the stable API |

### 4.2 When to Skip the Domain Layer

For simple CRUD features, the repo + cubit pattern is sufficient:

```
✅ Simple (no domain layer):
Cubit → Repo → Firebase SDK / Dio

✅ Complex (domain layer adds value):
Cubit → UseCase → Repo → Firebase SDK / Dio
```

### 4.3 Adding Domain Later

1. Create `domain/entities/feature_entity.dart`
2. Create `domain/usecases/verb_noun_use_case.dart`
3. Add mapper: `PostModel.toEntity()` in the data model
4. Update Cubit to inject the use case instead of the repo directly
5. Data layer is **untouched**

---

## 5. Result Type — Custom Dart 3 Sealed Class

> 🚫 **STRICT:** `dartz` is **PROHIBITED**. The project uses a custom `Result` sealed class defined in `core/utils/result.dart`.
> This is the **only** error-handling pattern for the data layer. Never mix with `Either` or `dartz`.

### 5.1 result.dart — Single Source of Truth

**Location:** `core/utils/result.dart`

```dart
// core/utils/result.dart

sealed class Result<T, E> {
  const Result();
}

final class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

final class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
}

extension ResultExtension<T, E> on Result<T, E> {
  bool get isOk  => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull  => switch (this) { Ok(:final value) => value, _ => null };
  E? get errorOrNull  => switch (this) { Err(:final error) => error, _ => null };

  R fold<R>(R Function(T value) onOk, R Function(E error) onErr) =>
      switch (this) {
        Ok(:final value)  => onOk(value),
        Err(:final error) => onErr(error),
      };
}

// ─── Typedefs ────────────────────────────────────────────────────────────────

/// Standard async result for data layer methods that return a value.
typedef FutureResult<T> = Future<Result<T, Failure>>;

/// Standard async result for data layer methods that return nothing.
typedef FutureResultVoid = Future<Result<void, Failure>>;
```

### 5.2 Usage Rules

| Rule | Detail |
|---|---|
| **`FutureResult<T>`** | Use in repo abstracts, repo impls, and DataSources that return a value |
| **`FutureResultVoid`** | Use in repo abstracts, repo impls, and DataSources that perform an action with no return value |
| **`Ok(value)`** | Wrap the success value |
| **`Err(Failure.failureFromException(e))`** | Wrap the failure |
| **No `dartz`** | Never import `package:dartz/dartz.dart`. It is prohibited. |
| **No raw `throw`** | Repos and DataSources never throw — they return `Err(...)` |

### 5.3 Repo Abstract — FutureResult Signature

```dart
// posts_repo.dart
import 'package:your_app/core/utils/result.dart';
import 'package:your_app/core/errors/failures.dart';

abstract interface class PostsRepo {
  FutureResult<List<PostModel>>     getPosts({required int page, required int perPage});
  FutureResult<PostModel>           getPostById(String id);
  FutureResultVoid                  deletePost(String id);
}
```

### 5.4 Repo Implementation — REST API

```dart
// posts_repo_impl.dart
class PostsRepoImpl implements PostsRepo {
  final Dio _dio;
  PostsRepoImpl(this._dio);

  @override
  FutureResult<ResponseModel<PostModel>> getPosts({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _dio.get(
        AppEndpoints.posts,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return Ok(ResponseModel.fromJson(
        response.data,
        (json) => PostModel.fromJson(json as Map<String, dynamic>),
      ));
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }

  @override
  FutureResultVoid deletePost(String id) async {
    try {
      await _dio.delete('${AppEndpoints.posts}/$id');
      return const Ok(null);
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
```

### 5.5 Repo Implementation — Firebase

```dart
// posts_repo_impl.dart
class PostsRepoImpl implements PostsRepo {
  final FirebaseFirestore _firestore;
  PostsRepoImpl(this._firestore);

  @override
  FutureResult<List<PostModel>> getPosts() async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.posts)
          .orderBy('created_at', descending: true)
          .get();
      return Ok(snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
    } on FirebaseException catch (e) {
      return Err(Failure.failureFromException(e));
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
```

### 5.6 DataSource — FutureResult in DataSource Layer

When a DataSource IS added, it also uses `FutureResult` / `FutureResultVoid`:

```dart
// posts_remote_data_source.dart — ONE FILE, two classes
import 'package:your_app/core/utils/result.dart';

abstract interface class PostsRemoteDataSource {
  FutureResult<List<PostModel>> getPosts({required int page, required int perPage});
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final Dio _dio;
  PostsRemoteDataSourceImpl(this._dio);

  @override
  FutureResult<List<PostModel>> getPosts({required int page, required int perPage}) async {
    try {
      final response = await _dio.get(
        AppEndpoints.posts,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return Ok(
        (response.data['data'] as List)
            .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
```

### 5.7 Cubit Consumption — fold / switch

```dart
// Future-based (REST or Firebase one-time fetch)
Future<void> fetchPosts() async {
  if (isClosed) return;
  emit(const PostsLoading());

  final result = await _repo.getPosts(page: 1, perPage: 10);
  if (isClosed) return;

  result.fold(
    (posts)   => emit(PostsLoaded(posts)),
    (failure) => emit(PostsError(failure.error)),
  );
}

// Or use exhaustive switch
switch (result) {
  case Ok(:final value)  => emit(PostsLoaded(value));
  case Err(:final error) => emit(PostsError(error.error));
}
```

### 5.8 Stream-based Repo (Firebase real-time)

Stream-returning repos do **not** use `FutureResult` — they return `Stream<Result<T, Failure>>` directly:

```dart
// posts_repo.dart — abstract
abstract interface class PostsRepo {
  Stream<Result<List<PostModel>, Failure>> watchPosts();
}

// posts_repo_impl.dart — concrete
class PostsRepoImpl implements PostsRepo {
  final FirebaseFirestore _firestore;
  PostsRepoImpl(this._firestore);

  @override
  Stream<Result<List<PostModel>, Failure>> watchPosts() {
    return _firestore
        .collection(FirestorePaths.posts)
        .snapshots()
        .map<Result<List<PostModel>, Failure>>((snapshot) => Ok(
              snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList(),
            ))
        .handleError((e) => Err<List<PostModel>, Failure>(
              Failure.failureFromException(e),
            ));
  }
}
```

**Consuming a stream repo in a Cubit:**

```dart
class PostsCubit extends Cubit<PostsState> {
  final PostsRepo _repo;
  StreamSubscription? _subscription;

  PostsCubit(this._repo) : super(const PostsInitial());

  void watchPosts() {
    if (isClosed) return;
    emit(const PostsLoading());
    _subscription = _repo.watchPosts().listen((result) {
      if (isClosed) return;
      result.fold(
        (posts)   => emit(PostsLoaded(posts)),
        (failure) => emit(PostsError(failure.error)),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

---

## 6. Data Layer Architecture — Adaptive Rules

### 6.1 The Core Principle

**The repo interface is always identical regardless of backend.**
The Cubit never knows — and never cares — whether it talks to Firebase, a REST API, or local storage.

```dart
// This abstract contract looks the same for ALL backends
abstract interface class PostsRepo {
  FutureResult<List<PostModel>> getPosts();
}
```

### 6.2 DataSource Layer — Optional & Contextual

> ⚠️ **DEFAULT: No DataSource layer.** The Repo implementation calls the SDK directly.
> Add a DataSource **only** when explicitly needed.

**Add a DataSource when:**

| Trigger | Example |
|---|---|
| Feature needs **offline caching** | API response cached in Hive/SQLite |
| Feature hits **multiple remote origins** | Firestore + REST API in the same feature |
| **Testability** is critical | Wrap `FirebaseFirestore.instance` in a testable seam |

**Skip a DataSource when:**
- Simple single-source feature (one Firestore collection, one REST endpoint)
- No caching requirement
- No explicit instruction to add it

**When a DataSource IS added — ONE FILE RULE:**

Abstract contract and concrete implementation live in **ONE file**.
No separate `_impl.dart` for data sources.
DataSources use `FutureResult<T>` / `FutureResultVoid` — see Rule 5.6.

> **Why abstract + impl in one file for DataSources, but two files for Repos?**
> The DataSource is a thin I/O adapter — no business logic justifies the navigation cost of two files.
> The Repo abstract contract IS the domain boundary — it's imported by DI, tests, and use cases, so separation is essential.

### 6.3 REST API — Data Layer Pattern

```
Cubit
  └── PostsRepo (abstract)           ← feature_repo.dart
        └── PostsRepoImpl            ← feature_repo_impl.dart
              ├── Dio (direct)       ← default for simple features
              └── PostsRemoteDataSource (abstract+impl, one file) ← if caching needed
```

**RepoImpl without DataSource (default):** — See Rule 5.4
**RepoImpl with DataSource (when caching or testability is needed):**

```dart
class PostsRepoImpl implements PostsRepo {
  final PostsRemoteDataSource _remote;
  PostsRepoImpl(this._remote);

  @override
  FutureResult<ResponseModel<PostModel>> getPosts({
    required int page,
    required int perPage,
  }) async {
    // DataSource already wraps errors into Result — unwrap Ok, re-wrap Err if needed
    return _remote.getPosts(page: page, perPage: perPage);
  }
}
```

### 6.4 Firebase — Data Layer Pattern

> Firebase apps have fundamentally different I/O characteristics from REST:
> - **No HTTP client** — Firebase SDK injected directly
> - **Streams are first-class** — Firestore `snapshots()` is real-time
> - **No page numbers** — use Firestore cursor pagination (`startAfterDocument`)
> - **No `AppEndpoints`** — use `FirestorePaths` constants instead
> - **Auth state is a global stream** — lives in `AuthCubit`, never in a feature repo

```
Cubit
  └── PostsRepo (abstract)
        └── PostsRepoImpl
              ├── FirebaseFirestore (direct) ← default
              └── PostsFirebaseDataSource (abstract+impl, one file) ← if needed
```

#### 6.4.1 FirestorePaths — The Firebase Equivalent of AppEndpoints

```dart
// core/firebase/firestore_paths.dart
abstract final class FirestorePaths {
  static const String posts           = 'posts';
  static const String users           = 'users';
  static String userPosts(String uid) => 'users/$uid/posts';
  static String postDoc(String id)    => 'posts/$id';
}
```

No inline Firestore collection strings anywhere. Ever.

#### 6.4.2 Firebase Auth — Global AuthCubit Pattern

Firebase Auth state is a **global stream**. It lives in `core/view_models/`, not in any feature.

```dart
// core/view_models/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  StreamSubscription? _authSub;

  AuthCubit(this._auth) : super(const AuthInitial()) {
    _authSub = _auth.authStateChanges().listen((user) {
      if (isClosed) return;
      emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
    });
  }

  Future<void> signOut() async => _auth.signOut();

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
```

#### 6.4.3 Firestore Pagination — Cursor-based

Firestore has no page numbers. Use document cursors:

```dart
DocumentSnapshot? _lastDocument;

FutureResult<List<PostModel>> getPostsPage({
  required int limit,
  bool refresh = false,
}) async {
  try {
    if (refresh) _lastDocument = null;

    var query = _firestore
        .collection(FirestorePaths.posts)
        .orderBy('created_at', descending: true)
        .limit(limit);

    if (_lastDocument != null) query = query.startAfterDocument(_lastDocument!);

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) _lastDocument = snapshot.docs.last;

    return Ok(snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
  } on FirebaseException catch (e) {
    return Err(Failure.failureFromException(e));
  }
}
```

#### 6.4.4 Firebase Error Mapping

`FirebaseException` must be caught and mapped — identical contract to `DioException`.

```dart
// core/errors/failures.dart
static Failure failureFromException(Object e) {
  if (e is DioException)      return NetworkFailure(e.message ?? '');
  if (e is FirebaseException) return FirebaseFailure(_mapFirebaseCode(e.code));
  return UnknownFailure(e.toString());
}

static String _mapFirebaseCode(String code) => switch (code) {
  'permission-denied' => S.current.errorPermissionDenied,
  'not-found'         => S.current.errorNotFound,
  'unavailable'       => S.current.errorServiceUnavailable,
  'unauthenticated'   => S.current.errorUnauthenticated,
  _                   => S.current.errorUnknown,
};
```

#### 6.4.5 Firebase DI Registration

```dart
void setupInjection() {
  // Firebase SDK singletons
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Global Auth — singleton (lives for app lifetime)
  sl.registerLazySingleton(() => AuthCubit(sl<FirebaseAuth>()));

  // Repos
  sl.registerLazySingleton<PostsRepo>(() => PostsRepoImpl(sl<FirebaseFirestore>()));

  // Cubits — always Factory
  sl.registerFactory(() => PostsCubit(sl<PostsRepo>()));
}
```

#### 6.4.6 Firebase main.dart Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppConfig.init(...);
  setupInjection();
  runApp(const MyApp());
}
```

### 6.5 Layer Responsibility Summary

| Layer | REST API Owns | Firebase Owns | Never Does |
|---|---|---|---|
| `DataSource` (optional) | Dio calls, JSON parsing, returns `FutureResult<T>` | Firestore/Storage SDK calls, returns `FutureResult<T>` | Business logic |
| `Repository` | try/catch → `Err(Failure)`, orchestration, returns `FutureResult<T>` | try/catch → `Err(Failure)`, cursor state | Calling SDK if DataSource exists |
| `UseCase` (optional) | Business rules, multi-repo coordination | Same | Network/DB calls |
| `Cubit` | State transitions, `result.fold(...)` | Stream subscriptions, `result.fold(...)` | Network calls, try/catch |

---

## 7. Naming Conventions

> **STRICT:** Names are contracts. Inconsistent naming breaks navigation and grep.

### 7.1 File Naming

| Layer | Pattern | REST Example | Firebase Example |
|---|---|---|---|
| Repo abstract | `feature_repo.dart` | `posts_repo.dart` | `posts_repo.dart` |
| Repo implementation | `feature_repo_impl.dart` | `posts_repo_impl.dart` | `posts_repo_impl.dart` |
| DataSource (ONE file) | `feature_remote_data_source.dart` | `posts_remote_data_source.dart` | `posts_firebase_data_source.dart` |
| Local DataSource (ONE file) | `feature_local_data_source.dart` | `posts_local_data_source.dart` | — |
| DTO / Model | `feature_model.dart` | `post_model.dart` | `post_model.dart` |
| Domain entity | `feature_entity.dart` | `post_entity.dart` | `post_entity.dart` |
| Use case | `verb_noun_use_case.dart` | `get_posts_use_case.dart` | `get_posts_use_case.dart` |
| Cubit | `feature_cubit.dart` | `posts_cubit.dart` | `posts_cubit.dart` |
| State file | `feature_state.dart` | `posts_state.dart` | `posts_state.dart` |
| View | `feature_view.dart` | `posts_view.dart` | `posts_view.dart` |
| ViewBody | `feature_view_body.dart` | `posts_view_body.dart` | `posts_view_body.dart` |
| Result types | `result.dart` | `core/utils/result.dart` | `core/utils/result.dart` |

### 7.2 Class Naming

```dart
// Repos — same for all backends
abstract interface class PostsRepo { }
class PostsRepoImpl implements PostsRepo { }

// DataSources — one file, two classes
abstract interface class PostsRemoteDataSource { }       // REST
class PostsRemoteDataSourceImpl implements PostsRemoteDataSource { }

abstract interface class PostsFirebaseDataSource { }     // Firebase
class PostsFirebaseDataSourceImpl implements PostsFirebaseDataSource { }

// Everything else
class GetPostsUseCase { }
class PostsCubit extends Cubit<PostsState> { }
class PostsView extends StatelessWidget { }      // Scaffold only
class PostsViewBody extends StatelessWidget { }  // Content layout
```

---

## 8. Error Handling — Result / FutureResult Pattern

> 🚫 **STRICT:** Never use `dartz`. Never return raw strings, raw Exceptions, or `dynamic` from Repositories.
> Use `Result<T, Failure>`, `FutureResult<T>`, and `FutureResultVoid` from `core/utils/result.dart`.
> This rule applies to ALL backend types.

### 8.1 The Only Allowed Pattern

```dart
// ✅ CORRECT — custom Result sealed class
import 'package:your_app/core/utils/result.dart';

FutureResult<List<PostModel>> getPosts() async {
  try {
    // ...
    return Ok(data);
  } catch (e) {
    return Err(Failure.failureFromException(e));
  }
}

// ❌ PROHIBITED — dartz Either
import 'package:dartz/dartz.dart';
Future<Either<Failure, List<PostModel>>> getPosts() async { ... }
```

### 8.2 Exception Sources by Backend

| Backend | Catch first | Then |
|---|---|---|
| REST API | `DioException` | `catch (e)` |
| Firebase | `FirebaseException`, `FirebaseAuthException` | `catch (e)` |
| Local | `HiveError`, `DatabaseException` | `catch (e)` |

### 8.3 Cubit Consumption

```dart
// Future-based (REST or Firebase one-time fetch)
final result = await _repo.getData();
result.fold(
  (data)    => emit(LoadedState(data)),
  (failure) => emit(ErrorState(failure.error)),
);

// Stream-based (Firebase real-time) — Stream<Result<T, Failure>>
_repo.watchData().listen((result) {
  if (isClosed) return;
  result.fold(
    (data)    => emit(LoadedState(data)),
    (failure) => emit(ErrorState(failure.error)),
  );
});
```

---

## 9. Pagination Architecture

> **REST apps:** Use `BasePaginationCubit` with offset/page-based pagination below.
> **Firebase apps:** Use cursor-based pagination — see Rule 6.4.3.

### 9.1 Core Models

```dart
// core/models/pagination_model.dart
class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasNext;

  const Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasNext,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json['current_page'] ?? 1,
        lastPage:    json['last_page']    ?? 1,
        perPage:     json['per_page']     ?? 10,
        total:       json['total']        ?? 0,
        hasNext:     json['has_next']     ?? false,
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page':    lastPage,
        'per_page':     perPage,
        'total':        total,
        'has_next':     hasNext,
      };
}
```

### 9.2 Pagination States

```dart
part of 'base_pagination_cubit.dart';

@immutable
sealed class BasePaginationState<T> {
  const BasePaginationState();
}

final class BasePaginationInitial<T> extends BasePaginationState<T> {
  const BasePaginationInitial();
}

/// First-page load — show full-screen loader.
final class BasePaginationLoading<T> extends BasePaginationState<T> {
  const BasePaginationLoading();
}

/// isLoadingMore lives INSIDE the state — never as a cubit field leaked to UI.
final class BasePaginationSuccess<T> extends BasePaginationState<T> {
  final List<T> items;
  final Pagination pagination;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const BasePaginationSuccess({
    required this.items,
    required this.pagination,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  BasePaginationSuccess<T> copyWith({
    List<T>? items,
    Pagination? pagination,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) =>
      BasePaginationSuccess<T>(
        items:         items         ?? this.items,
        pagination:    pagination    ?? this.pagination,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );
}

/// Page N>1 failed — keep existing list visible, show inline error/retry.
final class BasePaginationLoadMoreFailure<T> extends BasePaginationState<T> {
  final List<T> items;
  final Pagination pagination;
  final String errMessage;

  const BasePaginationLoadMoreFailure({
    required this.items,
    required this.pagination,
    required this.errMessage,
  });
}

/// Page 1 failed — full error screen.
final class BasePaginationFailure<T> extends BasePaginationState<T> {
  final String errMessage;
  const BasePaginationFailure({required this.errMessage});
}
```

### 9.3 BasePaginationCubit

```dart
abstract class BasePaginationCubit<T> extends Cubit<BasePaginationState<T>> {
  final BasePaginationUseCase<T> useCase;

  BasePaginationCubit({required this.useCase})
      : super(const BasePaginationInitial());

  int _currentPage = 1;
  static const int _perPage = 10;
  List<T> _allItems = [];
  bool _hasReachedMax = false;
  bool _isLoadingMore = false;
  Pagination? _lastPagination;

  Future<void> loadData({bool refresh = false, Map<String, dynamic>? extra}) async {
    if (isClosed) return;
    if (refresh) _resetPagination();
    if (_hasReachedMax && !refresh) return;
    if (_isLoadingMore && !refresh) return;

    _isLoadingMore = true;
    _currentPage == 1 ? emit(const BasePaginationLoading()) : _emitLoadingMore();

    final result = await useCase(
      PaginationParams(page: _currentPage, perPage: _perPage, extra: extra),
    );

    _isLoadingMore = false;
    if (isClosed) return;
    result.fold(
      (r)       => _handleSuccess(r.data, r.pagination, refresh),
      (failure) => _handleFailure(failure),
    );
  }

  Future<void> loadMore({Map<String, dynamic>? extra}) async {
    if (_hasReachedMax || _isLoadingMore || isClosed) return;
    await loadData(extra: extra);
  }

  Future<void> refresh({Map<String, dynamic>? extra}) async {
    if (isClosed) return;
    await loadData(refresh: true, extra: extra);
  }

  void clear() {
    if (isClosed) return;
    _resetPagination();
    emit(const BasePaginationInitial());
  }

  void _handleSuccess(List<T> newItems, Pagination pagination, bool isRefresh) {
    _lastPagination = pagination;
    _hasReachedMax  = !pagination.hasNext;
    _currentPage++;
    _allItems = isRefresh ? newItems : [..._allItems, ...newItems];
    emit(BasePaginationSuccess<T>(
      items:         List.unmodifiable(_allItems),
      pagination:    pagination,
      hasReachedMax: _hasReachedMax,
    ));
  }

  void _handleFailure(Failure failure) {
    _currentPage == 1
        ? emit(BasePaginationFailure<T>(errMessage: failure.error))
        : emit(BasePaginationLoadMoreFailure<T>(
            items:      List.unmodifiable(_allItems),
            pagination: _lastPagination!,
            errMessage: failure.error,
          ));
  }

  void _emitLoadingMore() {
    if (state is BasePaginationSuccess<T>) {
      emit((state as BasePaginationSuccess<T>).copyWith(isLoadingMore: true));
    }
  }

  void _resetPagination() {
    _currentPage    = 1;
    _allItems       = [];
    _hasReachedMax  = false;
    _isLoadingMore  = false;
    _lastPagination = null;
  }
}
```

### 9.4 BasePaginationUseCase Contract

```dart
class PaginationParams {
  final int page;
  final int perPage;
  final Map<String, dynamic>? extra;
  const PaginationParams({required this.page, this.perPage = 10, this.extra});
}

abstract class BasePaginationUseCase<T> {
  FutureResult<ResponseModel<T>> call(PaginationParams params);
}
```

### 9.5 UI Consumption (exhaustive switch)

```dart
BlocBuilder<PostsCubit, BasePaginationState<PostModel>>(
  builder: (context, state) => switch (state) {
    BasePaginationInitial()    => const SizedBox.shrink(),
    BasePaginationLoading()    => const AppLoadingIndicator(),
    BasePaginationFailure(:final errMessage) =>
        AppErrorWidget(message: errMessage, onRetry: () => context.read<PostsCubit>().loadData()),
    BasePaginationLoadMoreFailure(:final items, :final errMessage) =>
        PostsList(items: items, errorBanner: errMessage),
    BasePaginationSuccess(:final items, :final isLoadingMore, :final hasReachedMax) =>
        PostsList(items: items, isLoadingMore: isLoadingMore, hasReachedMax: hasReachedMax),
  },
);
```

---

## 10. DTO & Serialization Rules

> **STRICT:** `json_serializable` only. No `freezed`. No manual `fromJson` for complex models.
> Applies to both REST (JSON responses) and Firebase (Firestore documents are also JSON maps).

### 10.1 DTO Template

```dart
import 'package:json_annotation/json_annotation.dart';
part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(name: 'id')    final String id;
  @JsonKey(name: 'title') final String title;

  const PostModel({required this.id, required this.title});

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
```

### 10.2 Firebase DTO — fromFirestore Factory

Firestore document ID lives outside the data map. Always inject it explicitly:

```dart
factory PostModel.fromFirestore(DocumentSnapshot doc) =>
    PostModel.fromJson({
      ...doc.data() as Map<String, dynamic>,
      'id': doc.id,  // Inject doc ID — it is NOT in doc.data()
    });
```

### 10.3 DTO Rules

- DTOs live in `features/{name}/data/models/` only.
- **NEVER** pass `Map<String, dynamic>` beyond the data layer.
- Run `dart run build_runner build --delete-conflicting-outputs` after every model change.
- `copyWith` is hand-written only on state classes and domain entities — not on DTOs.

---

## 11. Network Layer — REST API Only

> Skip this section entirely for Firebase-only apps.

### 11.1 Endpoint Registry

```dart
// core/network/app_endpoints.dart
abstract final class AppEndpoints {
  static const String _base   = '/api/v1';
  static const String posts   = '$_base/posts';
  static const String login   = '$_base/auth/login';
  static const String profile = '$_base/users/me';
}
```

No inline URL strings anywhere. Ever.

### 11.2 Dio Interceptor Chain

```
Request  → AuthInterceptor → LogInterceptor → Server
Response ← ErrorInterceptor ← LogInterceptor ← Server
```

- **`AuthInterceptor`** — injects `Authorization: Bearer <token>`.
- **`LogInterceptor`** — wrapped in `kDebugMode`. Zero output in production.
- **`ErrorInterceptor`** — maps `DioException` → `Failure` centrally.

### 11.3 No Raw DioException in Repos

```dart
// ✅ CORRECT — generic catch, Failure maps everything
} catch (e) {
  return Err(Failure.failureFromException(e));
}

// ❌ WRONG — DioException handling belongs in ErrorInterceptor
} on DioException catch (e) {
  return Err(NetworkFailure(e.message ?? ''));
}
```

---

## 12. State Management & DI

- **State Management:** `Cubit` for all feature-level state. `BLoC` only when event-driven complexity justifies it.
- **DI:** `GetIt` as the service locator. Register in `core/di/`. Never mix with `Riverpod`.
- **`setState`:** Only for ephemeral local UI state in leaf `StatefulWidget`s.

### GetIt Registration — REST API

```dart
void setupInjection() {
  sl.registerLazySingleton<Dio>(() => DioFactory().createDio());
  sl.registerLazySingleton<PostsRepo>(() => PostsRepoImpl(sl<Dio>()));
  sl.registerFactory(() => PostsCubit(sl<PostsRepo>()));
}
```

### GetIt Registration — Firebase

```dart
void setupInjection() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => AuthCubit(sl<FirebaseAuth>())); // Singleton — global
  sl.registerLazySingleton<PostsRepo>(() => PostsRepoImpl(sl<FirebaseFirestore>()));
  sl.registerFactory(() => PostsCubit(sl<PostsRepo>()));         // Factory — per screen
}
```

---

## 12.1 Cubit & State File Structure — BLoC VSCode Extension Standard

> 🛑 **MANDATORY:** Every Cubit MUST follow the exact two-file structure produced by the **BLoC VSCode extension** (`felangel.bloc`). No exceptions.
> The extension is the canonical code generator. All hand-written cubits must be indistinguishable from generated ones.

### The Two-File Rule

| File | Role | Link mechanism |
|---|---|---|
| `feature_cubit.dart` | Cubit class + `part` directive | `part 'feature_state.dart';` |
| `feature_state.dart` | Sealed state hierarchy | `part of 'feature_cubit.dart';` |

**These two files are always created together. Never one without the other.**

---

### 12.1.1 `feature_state.dart` — Canonical Template

```dart
// posts_state.dart
part of 'posts_cubit.dart';

@immutable
sealed class PostsState {
  const PostsState();
}

final class PostsInitial extends PostsState {
  const PostsInitial();
}

final class PostsLoading extends PostsState {
  const PostsLoading();
}

final class PostsSuccess extends PostsState {
  final List<PostModel> posts;
  const PostsSuccess(this.posts);
}

final class PostsFailure extends PostsState {
  final String errMessage;
  const PostsFailure(this.errMessage);
}
```

**State file rules (non-negotiable):**

| Rule | Detail |
|---|---|
| `part of 'feature_cubit.dart'` | Always first line (after comments) |
| `@immutable` | Always on the sealed base class |
| `sealed class {Feature}State` | Base class is `sealed` — Dart 3+ exhaustive switch |
| `const {Feature}State()` | Base class has a `const` constructor |
| `final class` | Every substate is `final class`, NOT `class` |
| `const` constructors | Every substate has a `const` constructor |
| No `extends {Feature}State` boilerplate in constructor | Dart infers it via `sealed` |
| `copyWith` on success states only | Hand-written, never on base or simple leaf states |

---

### 12.1.2 `feature_cubit.dart` — Canonical Template

```dart
// posts_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/core/utils/result.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/features/posts/data/models/post_model.dart';
import 'package:your_app/features/posts/data/repos/posts_repo.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepo _repo;

  PostsCubit(this._repo) : super(const PostsInitial());

  Future<void> getPosts() async {
    if (isClosed) return;
    emit(const PostsLoading());

    final result = await _repo.getPosts();
    if (isClosed) return;

    result.fold(
      (posts)   => emit(PostsSuccess(posts)),
      (failure) => emit(PostsFailure(failure.error)),
    );
  }
}
```

**Cubit file rules (non-negotiable):**

| Rule | Detail |
|---|---|
| `part 'feature_state.dart'` | Always present — links the state file |
| Initial state in `super(...)` | Always `const` — e.g. `super(const PostsInitial())` |
| `isClosed` guard | Before every `emit` after an `await` |
| Repo injected via constructor | Never use `sl<>` inside a Cubit |
| Public methods are `void` or `Future<void>` | Never return values from Cubit methods (bloc_lint: `prefer_void_public_cubit_methods`) |
| No `emit` calls outside Cubit class | `emit` is protected — never exposed |

---

### 12.1.3 Standard State Shapes by Feature Type

> Pick the shape that fits the feature. Add states surgically — no over-engineering.

**Simple fetch (single resource):**

```dart
sealed class PostDetailState { const PostDetailState(); }
final class PostDetailInitial extends PostDetailState { const PostDetailInitial(); }
final class PostDetailLoading extends PostDetailState { const PostDetailLoading(); }
final class PostDetailSuccess extends PostDetailState {
  final PostModel post;
  const PostDetailSuccess(this.post);
}
final class PostDetailFailure extends PostDetailState {
  final String errMessage;
  const PostDetailFailure(this.errMessage);
}
```

**Action state (submit form, delete, etc.):**

```dart
sealed class DeletePostState { const DeletePostState(); }
final class DeletePostInitial extends DeletePostState { const DeletePostInitial(); }
final class DeletePostLoading extends DeletePostState { const DeletePostLoading(); }
final class DeletePostSuccess extends DeletePostState { const DeletePostSuccess(); }
final class DeletePostFailure extends DeletePostState {
  final String errMessage;
  const DeletePostFailure(this.errMessage);
}
```

**Success state with `copyWith` (complex, mutable-feeling data):**

```dart
final class PostsSuccess extends PostsState {
  final List<PostModel> posts;
  final bool isRefreshing;

  const PostsSuccess({required this.posts, this.isRefreshing = false});

  PostsSuccess copyWith({List<PostModel>? posts, bool? isRefreshing}) =>
      PostsSuccess(
        posts:        posts        ?? this.posts,
        isRefreshing: isRefreshing ?? this.isRefreshing,
      );
}
```

---

### 12.1.4 UI Consumption — Exhaustive Switch (Required)

The `sealed` base class + `final` substates enable exhaustive Dart 3 switch. **Always use it.**

```dart
BlocBuilder<PostsCubit, PostsState>(
  builder: (context, state) => switch (state) {
    PostsInitial()                         => const SizedBox.shrink(),
    PostsLoading()                         => const AppLoadingIndicator(),
    PostsSuccess(:final posts)             => PostsList(posts: posts),
    PostsFailure(:final errMessage)        => AppErrorWidget(
        message: errMessage,
        onRetry: () => context.read<PostsCubit>().getPosts(),
      ),
  },
)
```

> Never use `if (state is ...)` chains. Never use `else` branches. Exhaustive switch only — the compiler will catch missing states.

---

### 12.1.5 `BlocListener` Pattern — Side Effects

Side effects (navigation, snackbars, dialogs) go in `BlocListener`, never in `builder`.

```dart
BlocListener<PostsCubit, PostsState>(
  listener: (context, state) {
    if (state is PostsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errMessage)),
      );
    }
  },
  child: BlocBuilder<PostsCubit, PostsState>(
    builder: (context, state) => switch (state) {
      // ... exhaustive switch
    },
  ),
)
```

---

### 12.1.6 `BlocProvider` Placement — View Layer Only

```dart
// posts_view.dart — Scaffold + BlocProvider ONLY
class PostsView extends StatelessWidget {
  static const String routeName = '/posts';

  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostsCubit>()..getPosts(),  // trigger load on open
      child: const PostsViewBody(),
    );
  }
}

// posts_view_body.dart — All content logic
class PostsViewBody extends StatelessWidget {
  const PostsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) => switch (state) {
        // ... exhaustive switch
      },
    );
  }
}
```

---

### 12.1.7 Naming Rules for States

| Pattern | Example |
|---|---|
| `{Feature}Initial` | `PostsInitial` |
| `{Feature}Loading` | `PostsLoading` |
| `{Feature}Success` | `PostsSuccess` |
| `{Feature}Failure` | `PostsFailure` |
| Action: `{Verb}{Noun}Loading` | `DeletePostLoading` |
| Action: `{Verb}{Noun}Success` | `DeletePostSuccess` |

Never use suffixes like `State`, `Loaded`, `Error` — they break the BLoC extension naming contract.

---

## 13. Animation Rules — flutter_animate

> ⚠️ **PHILOSOPHY:** Animation is seasoning, not the main dish.
> One well-placed animation improves UX. Five competing animations destroy it.
> Every animation must earn its place by serving the user — not the developer's creativity.

### 13.1 When to Animate — The Three Legitimate Triggers

| Trigger | Example | Allowed Effect |
|---|---|---|
| **Entry** — widget appears for the first time | Screen load, list items, dialogs | `fadeIn`, `slideY`, `scaleXY` |
| **State change** — UI responds to data change | Loading → Success, error banner | `fadeIn`, `shimmer` on skeleton |
| **Feedback** — confirm a user action | Button tap, form submit success | `shake` (error), brief `scale` |

**Never animate:**
- Static decorative elements that are always visible
- Widgets that animate on every rebuild
- More than **one concurrent animation** on the same widget
- Transitions that compete with navigation animations

---

### 13.2 The Four Non-Negotiable Constraints

| Constraint | Rule |
|---|---|
| **Duration** | Entry effects: `300–500ms`. Feedback: `200–300ms`. Never exceed `600ms` for UI elements. |
| **Easing** | Always specify a `curve`. Default: `Curves.easeOut` for entries, `Curves.easeInOut` for state changes. |
| **Chaining limit** | Maximum **3 chained effects** per widget. More than 3 = extract or reconsider. |
| **Loop** | `loop` / `repeat` only for loading indicators and shimmer skeletons. Never on content. |

---

### 13.3 Approved Effects Catalogue

Use **only** these effects unless there is a documented UX reason for another:

```dart
// ✅ ENTRY — page/screen appears
.animate()
  .fadeIn(duration: 400.ms, curve: Curves.easeOut)
  .slideY(begin: 0.1, end: 0, duration: 400.ms)

// ✅ ENTRY — list items (staggered)
.animate(delay: (index * 80).ms)
  .fadeIn(duration: 350.ms)
  .slideX(begin: 0.05, end: 0)

// ✅ STATE CHANGE — success reveal
.animate()
  .fadeIn(duration: 300.ms)
  .scaleXY(begin: 0.95, end: 1.0, curve: Curves.easeOut)

// ✅ FEEDBACK — shake on error
.animate(target: _hasError ? 1 : 0)
  .shake(duration: 300.ms, hz: 4)

// ✅ LOADING — shimmer skeleton (loop allowed here only)
.animate(onPlay: (c) => c.repeat())
  .shimmer(duration: 1200.ms, color: AppColors.shimmer(context))
```

---

### 13.4 Staggered Lists — Strict Rules

Stagger **only** when the list first appears (on screen load / data fetch completion).
Never re-stagger on scroll, refresh, or item updates.

```dart
// ✅ CORRECT — stagger capped, delay formula is linear and bounded
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return PostCard(post: items[index])
        .animate(delay: (index * 60).ms.clamp(Duration.zero, 300.ms))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0);
  },
)

// ❌ WRONG — unbounded delay: item 20 waits 1600ms
.animate(delay: (index * 80).ms)  // no clamp

// ❌ WRONG — re-animates on every state rebuild
BlocBuilder<PostsCubit, PostsState>(
  builder: (context, state) {
    return ItemCard().animate().fadeIn(); // fires on every emit
  },
)
```

---

### 13.5 Animate on State Change — `target` Pattern

Use `target` to animate in response to state, not raw `animate()` inside `BlocBuilder`.

```dart
// ✅ CORRECT — animation driven by a bool, not by rebuild
class PostCard extends StatelessWidget {
  final bool isVisible;
  const PostCard({required this.isVisible, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(...)
        .animate(target: isVisible ? 1 : 0)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

// ❌ WRONG — .animate() with no target inside a BlocBuilder re-fires on every emit
BlocBuilder<PostsCubit, PostsState>(
  builder: (context, state) => PostCard().animate().fadeIn(),
)
```

---

### 13.6 File Placement & Extraction Rules

| Situation | Rule |
|---|---|
| Single widget uses an effect inline | Keep it inline — no extraction needed |
| Same effect reused in 2+ widgets | Extract to a wrapper widget in `core/widgets/` |
| Effects + durations form a theme | Define constants in `core/utils/app_animations.dart` |

```dart
// core/utils/app_animations.dart
abstract final class AppAnimations {
  // Durations
  static const Duration entryDuration    = Duration(milliseconds: 400);
  static const Duration feedbackDuration = Duration(milliseconds: 250);
  static const Duration shimmerDuration  = Duration(milliseconds: 1200);

  // Delays
  static Duration staggerDelay(int index) =>
      Duration(milliseconds: (index * 60).clamp(0, 300));

  // Curves
  static const Curve entryCurve   = Curves.easeOut;
  static const Curve feedbackCurve = Curves.easeInOut;
}
```

Usage:

```dart
// ✅ CORRECT — uses shared constants
PostCard()
  .animate(delay: AppAnimations.staggerDelay(index))
  .fadeIn(duration: AppAnimations.entryDuration, curve: AppAnimations.entryCurve)
  .slideY(begin: 0.08, end: 0, duration: AppAnimations.entryDuration);

// ❌ WRONG — magic numbers scattered across files
PostCard().animate().fadeIn(duration: 387.ms).slideY(begin: 0.12);
```

---

### 13.7 Performance Rules

| Rule | Reason |
|---|---|
| Never animate inside `build()` logic branches | Animations restart on every rebuild |
| Prefer `fadeIn` + `slideY/X` over `blur` | `blur` triggers `saveLayer` — expensive on low-end devices |
| Never chain `blur` with `scale` simultaneously | Double `saveLayer` cost |
| Use `Animate.restartOnHotReload = true` in debug only | `main.dart` debug block, never in production |
| Avoid animating `Container` with `decoration` — use `AnimatedContainer` | Flutter's built-in is more efficient for simple property changes |

```dart
// main.dart — debug only
void main() {
  // ...
  assert(() {
    Animate.restartOnHotReload = true;
    return true;
  }());
  runApp(const MyApp());
}
```

---

### 13.8 Anti-Pattern Reference — What Is Prohibited

```dart
// ❌ 1. Too many chained effects
widget
  .animate()
  .fadeIn()
  .slideY()
  .scaleXY()
  .blur()   // 4th effect — prohibited
  .shake(); // 5th effect — absolutely not

// ❌ 2. Looping content (non-skeleton)
PostCard().animate(onPlay: (c) => c.repeat()).shimmer(); // content, not skeleton

// ❌ 3. Duration over 600ms on UI elements
.fadeIn(duration: 1200.ms) // user is waiting for you

// ❌ 4. No curve specified
.slideY(begin: 0.2, end: 0) // linear slide looks robotic — always add curve:

// ❌ 5. Animating the same widget on every BlocBuilder rebuild
BlocBuilder<C, S>(
  builder: (ctx, state) => MyWidget().animate().fadeIn(),
)

// ❌ 6. Competing animations in the same viewport
// Screen entry animation + card entry + button pulse = sensory overload
```

---

### 13.9 Review Checklist — Animation

- [ ] Every animation has a **purpose** (entry / state change / feedback)
- [ ] Maximum **3 chained effects** per widget
- [ ] Duration within **300–500ms** for entries, **200–300ms** for feedback
- [ ] `curve:` explicitly set on every effect
- [ ] `loop`/`repeat` used **only** on loading skeletons
- [ ] Stagger delays **clamped** to max `300ms`
- [ ] No `.animate()` without `target` inside `BlocBuilder`
- [ ] `blur` not combined with `scale` on the same widget
- [ ] Shared durations/delays live in `AppAnimations` — no magic numbers
- [ ] `Animate.restartOnHotReload` only in debug assert block

---

## 14. Component-Based Architecture & Refactoring

### 14.1 The Refactoring Trigger Rule

Extract a widget into its own file if it meets **ANY** of:

| Criterion | Threshold |
|---|---|
| **Length** | Exceeds 60 lines |
| **Nesting** | Rows/Columns/Stacks deeper than 4 levels |
| **Complexity** | Contains animations, complex builders, heavy conditionals |
| **Reusability** | Used by more than one `ViewBody` or feature |

### 14.2 UI Composition Rules

- `View` = Scaffold + AppBar + Cubit injection only. No content logic.
- `ViewBody` = Content layout composition only.
- One file = One class. No multi-class "God files."
- `const` constructors everywhere possible.
- Suffix screens with `View`, bodies with `ViewBody`.

### 14.3 Extension Methods Over Utility Classes

```dart
// ✅ CORRECT
extension StringValidation on String {
  bool get isValidEmail => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(this);
}

// ❌ WRONG
class ValidationUtils {
  static bool isValidEmail(String v) => ...;
}
```

---

## 15. Localization

- All strings **MUST** live in `.arb` files. **Launch is Arabic + English (updated 2026-11-17):** `intl_ar.arb` (main locale, default) and `intl_en.arb`. `intl_fr.arb` is a later project. Layouts must work in RTL and LTR (use `PositionedDirectional`, `EdgeInsetsDirectional`, auto-mirrored icons). Render numbers as Latin digits (see `core/utils/date_labels.dart`).
- Generate the `S` class via Flutter Intl after every new key.
- **In UI:** `S.of(context).key_name`
- **Outside context:** `S.current.key_name`
- Zero hardcoded UI strings.

---

## 16. UI & Design System Rules

- **Colors:** `AppColors.primary(context)` — context-aware only. No static attributes.
- **Typography:** `AppTextStyles.x` from `core/theme/app_text_styles.dart` directly, in every view/widget we own. Tokens are colour-free — pair with `.copyWith(color: AppColors.x(context))`. `Theme.of(context).textTheme` is reserved for Material-internal widgets we don't hand-style (e.g. `DropdownButton` menu items, dialogs, `SnackBar`) — never read it in feature code. No manual `TextStyle(...)`; the one exception is a widget that must render with no `Theme`/`Directionality` ancestor (e.g. a startup error fallback), which must say so in a comment. Every token must trace to a real Figma text node.
- **Navigation:** `GoRouter` for all routing. Every `View` declares `static const String routeName`.

---

## 17. Async & Concurrency Patterns

### 17.1 Cubit Async Guard

```dart
Future<void> fetchData() async {
  if (isClosed) return;
  emit(LoadingState());
  final result = await _repo.getData();
  if (isClosed) return;
  result.fold(
    (data)    => emit(LoadedState(data)),
    (failure) => emit(ErrorState(failure.error)),
  );
}
```

### 17.2 Parallel Independent Fetches

```dart
// ✅ CORRECT
final results = await Future.wait([_repo.getUser(), _repo.getSettings()]);

// ❌ WRONG
final user     = await _repo.getUser();
final settings = await _repo.getSettings();
```

### 17.3 Stream Cleanup — Mandatory

```dart
@override
Future<void> close() {
  _subscription?.cancel();
  return super.close();
}
```

### 17.4 CancelToken (REST API only)

Use Dio `CancelToken` for debounced / race-condition-prone requests. Cancel in `close()`.

---

## 18. Performance & Safety

### 18.1 List Rendering

```dart
// ✅ CORRECT
ListView.builder(itemCount: items.length, itemBuilder: (_, i) => ItemWidget(items[i]))

// ❌ WRONG
Column(children: items.map((e) => ItemWidget(e)).toList())
```

### 18.2 Image Loading

- `cached_network_image` for all remote images. Never `Image.network()`.
- Always provide `width`, `height`, `placeholder`, and `errorWidget`.

### 18.3 Build Method Purity

The `build()` method is a pure function. No instantiation, no logic, no objects inside it.

### 18.4 Mounted Check

```dart
await someOperation();
if (!mounted) return;
```

### 18.5 Disposal

Explicitly `dispose()` all controllers. Explicitly `close()` Cubits not managed by `BlocProvider`.

---

## 19. Security & Secrets Management

### 19.1 Zero Secrets in Source Code

- **NEVER** hardcode API keys, tokens, or Firebase config values in `.dart` files.
- Use `--dart-define-from-file=env.json` at build time.
- `google-services.json` and `GoogleService-Info.plist` are build-time artifacts — excluded from VCS.

### 19.2 Mandatory `.gitignore` Entries

```
env.json
*.keystore  *.jks  *.p12
google-services.json
GoogleService-Info.plist
.env
```

### 19.3 Token Storage

- `flutter_secure_storage` for all auth tokens.
- **Never** `SharedPreferences` for tokens — it is unencrypted.

### 19.4 Firebase Security Rules — Not Optional

Firestore/Storage Security Rules are the backend enforcement layer. Reviewed before every production deploy.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /posts/{postId} {
      allow read:  if request.auth != null;
      allow write: if request.auth.uid == resource.data.authorId;
    }
  }
}
```

---

## 20. Flavors & Build Configuration

### 20.1 Minimum Flavor Matrix

| Flavor | Backend | Debug Tools | Purpose |
|---|---|---|---|
| `dev` | Dev / Firebase Emulator | Enabled | Local development |
| `staging` | Staging / Firebase staging project | Enabled | QA & testing |
| `prod` | Production | Disabled | Store release |

### 20.2 AppConfig Pattern

```dart
abstract final class AppConfig {
  static late final String flavorName;
  static late final bool enableLogging;
  static late final String baseUrl;     // REST apps only — empty string for Firebase

  static void init({
    required String flavor,
    required bool logging,
    String baseUrl = '',
  }) {
    AppConfig.flavorName    = flavor;
    AppConfig.enableLogging = logging;
    AppConfig.baseUrl       = baseUrl;
  }
}
```

---

## 21. Testing Strategy

> 🚫 **STRICT:** Untested business logic is **unfinished code**.

### 21.1 Test Pyramid

| Layer | Tool | What to Cover |
|---|---|---|
| **Unit** | `flutter_test` | Repo logic, UseCase, Cubit states, Failure mapping |
| **Widget** | `flutter_test` + `find.*` | ViewBody renders, conditional UI |
| **Integration** | `integration_test` | Full user flows |

### 21.2 Firebase Testing

- Use `fake_cloud_firestore` for Firestore unit tests — no real Firebase instance needed.
- Use `firebase_auth_mocks` for Auth tests.

```dart
final fakeFirestore = FakeFirebaseFirestore();
final repo = PostsRepoImpl(fakeFirestore);

await fakeFirestore.collection('posts').add({'title': 'Test', 'authorId': 'u1'});
final result = await repo.getPosts();
// Result is Ok — check with pattern matching
expect(result, isA<Ok<List<PostModel>, Failure>>());
```

### 21.3 Result Assertions in Tests

```dart
// ✅ CORRECT
final result = await repo.getPosts();
expect(result.isOk, true);
expect((result as Ok).value, isNotEmpty);

// Or with fold
result.fold(
  (data)    => expect(data, isNotEmpty),
  (failure) => fail('Expected Ok, got Err: ${failure.error}'),
);
```

### 21.4 Cubit Test Template

```dart
blocTest<PostsCubit, PostsState>(
  'emits [PostsLoading, PostsSuccess] on success',
  build: () => PostsCubit(mockRepo),
  setUp: () => when(() => mockRepo.getPosts()).thenAnswer((_) async => Ok(mockList)),
  act: (c) => c.getPosts(),
  expect: () => [
    const PostsLoading(),
    isA<PostsSuccess>().having((s) => s.posts, 'posts', mockList),
  ],
);

blocTest<PostsCubit, PostsState>(
  'emits [PostsLoading, PostsFailure] on error',
  build: () => PostsCubit(mockRepo),
  setUp: () => when(() => mockRepo.getPosts())
      .thenAnswer((_) async => Err(const UnknownFailure('error'))),
  act: (c) => c.getPosts(),
  expect: () => [
    const PostsLoading(),
    isA<PostsFailure>().having((s) => s.errMessage, 'errMessage', 'error'),
  ],
);
```

### 21.5 Coverage Gate

- Minimum **80% coverage** on `data/` and `view_models/`.
- CI blocks merges below threshold.

---

## 22. Git Branching & Commit Protocol

### 22.1 Branch Model

```
main       → Production. Protected. No direct push. Ever.
develop    → Integration. All PRs target here.
feature/   → feature/posts-feed
fix/       → fix/auth-token-refresh
hotfix/    → hotfix/crash-on-cold-start
```

### 22.2 Conventional Commits

Format: `type(scope): description`

| Type | Use |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change, no behavior change |
| `test` | Tests only |
| `chore` | CI, deps, build |
| `docs` | Docs only |

```bash
# ✅ CORRECT
feat(posts): add real-time Firestore listener
fix(auth): resolve FirebaseAuthException on token expiry

# ❌ WRONG
fixed bug / WIP / update
```

---

## 23. Logging Rules

- **`print()` is PROHIBITED.** Use `LogUtil.log(msg)` everywhere.

```dart
class LogUtil {
  static void log(String message, {String? tag}) {
    if (AppConfig.enableLogging) debugPrint('[${tag ?? 'APP'}] $message');
  }
}
```

---

## 24. The Silicon Gate Mandate — Zero-Tolerance Validation

> 🛡️ **STRICT:** 5-step internal simulation before every code output.

1. **Backend Type Check** — REST, Firebase, or Local? Confirmed from imports/pubspec. Correct pattern selected.
2. **Dependency Audit** — Verify exact signatures of `Failure`, `Result`/`FutureResult`/`FutureResultVoid` from `core/utils/result.dart`. **No `dartz`. No `Either`.**
3. **Virtual `dart analyze`** — Null-safety, `const` placement, missing imports, no `dynamic` leakage. Cubit `part`/`part of` directives present. State base is `sealed`, substates are `final class`.
4. **Import Hygiene** — No feature imports another feature. Cross-feature goes through `core/`.
5. **Architecture Layer Check** — Every file in correct layer. No business logic in View. No UI in Repo. `BlocProvider` in View only. Exhaustive `switch` in builder.

Every code response **must** begin with:

```
🛡️ Silicon Gate Verified: Backend type confirmed, Context, Syntax, Architecture, and Refactoring rules passed.
```

---

## 25. Tech Lead Review Gate

### Architecture
- [ ] Backend type identified — correct layer pattern used
- [ ] No business logic in `View` or `ViewBody`
- [ ] No UI code in repositories or data sources
- [ ] Feature does not import another feature
- [ ] Domain layer added only where Rule 4 criteria are met
- [ ] DataSource added only when caching / multi-source / testability requires it

### Cubit & State (BLoC Extension Standard — Rule 12.1)
- [ ] Two files per Cubit: `feature_cubit.dart` + `feature_state.dart`
- [ ] `feature_cubit.dart` has `part 'feature_state.dart'`
- [ ] `feature_state.dart` has `part of 'feature_cubit.dart'` as first line
- [ ] Base state is `sealed class {Feature}State` with `@immutable` and `const` constructor
- [ ] All substates are `final class`, never plain `class`
- [ ] All substates have `const` constructors
- [ ] `isClosed` checked after every `await` in Cubit methods
- [ ] Cubit methods are `void` or `Future<void>` — never return values
- [ ] Initial state passed to `super(...)` is `const`
- [ ] UI uses exhaustive `switch` on state — no `if (state is ...)` chains
- [ ] Side effects in `BlocListener`, rendering in `BlocBuilder`
- [ ] `BlocProvider` only in `View`, content only in `ViewBody`
- [ ] State names follow: `{Feature}Initial/Loading/Success/Failure`

### Result Type
- [ ] `core/utils/result.dart` is the only source for `Result`, `Ok`, `Err`, `FutureResult<T>`, `FutureResultVoid`
- [ ] **`dartz` is NOT imported anywhere in the project**
- [ ] All repo abstracts use `FutureResult<T>` or `FutureResultVoid` (never raw `Future<T>`)
- [ ] All DataSources use `FutureResult<T>` or `FutureResultVoid` when a DataSource layer exists
- [ ] Success paths return `Ok(value)` — never `Right(value)`
- [ ] Failure paths return `Err(Failure.failureFromException(e))` — never `Left(...)`
- [ ] Cubits consume results via `result.fold(onOk, onErr)` or exhaustive `switch`

### DataSource
- [ ] Abstract + impl in ONE file — no `_impl.dart` for data sources
- [ ] REST DataSource named `feature_remote_data_source.dart`
- [ ] Firebase DataSource named `feature_firebase_data_source.dart`

### Repos
- [ ] Abstract: `feature_repo.dart` / Impl: `feature_repo_impl.dart` (separate files)
- [ ] Repo never calls `Dio`/Firebase SDK directly if DataSource layer exists

### Firebase-Specific
- [ ] `FirebaseException` caught and mapped via `Failure.failureFromException`
- [ ] Document ID injected in `fromFirestore` factory
- [ ] Auth state in global `AuthCubit`, not in feature cubits
- [ ] All stream subscriptions cancelled in `close()`
- [ ] `FirestorePaths` used — no inline collection strings
- [ ] Security Rules reviewed before production deploy

### REST-Specific
- [ ] `AppEndpoints` used — no inline URL strings
- [ ] `DioException` handled by `ErrorInterceptor`, not in repos

### Code Quality
- [ ] No `dynamic` without explicit comment
- [ ] No `!` force unwrap without null-safety comment
- [ ] No `Future.delayed` timing hacks
- [ ] No commented-out code committed
- [ ] `copyWith` on states/entities only

### Performance
- [ ] `const` constructors everywhere
- [ ] `ListView.builder` for all dynamic lists
- [ ] `cached_network_image` for remote images

### Async & Safety
- [ ] `isClosed` checked after every `await` in Cubits
- [ ] Streams cancelled in `close()`
- [ ] `if (!mounted) return` after `await` in Widgets

### Security
- [ ] No secrets in source files
- [ ] `google-services.json` in `.gitignore`
- [ ] Tokens in `flutter_secure_storage`

---

## 26. Final Quick-Reference Checklist ✅

- [ ] **Backend Type** — REST, Firebase, or Local? Identified before any data layer code
- [ ] **Silicon Gate** — 5-step simulation passed
- [ ] **Result Type** — `FutureResult<T>` / `FutureResultVoid` from `core/utils/result.dart`. Zero `dartz`.
- [ ] **`Ok` / `Err`** — Project pattern checked before writing repos. No `Right` / `Left`.
- [ ] **Cubit Files** — Two files per Cubit: `feature_cubit.dart` (`part`) + `feature_state.dart` (`part of`)
- [ ] **State Structure** — `sealed class` base, `@immutable`, `final class` substates, `const` constructors
- [ ] **State Naming** — `{Feature}Initial`, `{Feature}Loading`, `{Feature}Success`, `{Feature}Failure`
- [ ] **UI Switch** — Exhaustive `switch` on state in `BlocBuilder`. No `if (state is ...)` chains.
- [ ] **BlocProvider** — In `View` only. Content in `ViewBody` only.
- [ ] **Cubit Methods** — `void` / `Future<void>` only. `isClosed` checked after every `await`.
- [ ] **DataSource** — Added ONLY when needed; abstract+impl in ONE file; uses `FutureResult<T>`
- [ ] **Domain Layer** — Added ONLY if Rule 4 criteria are met
- [ ] **Repo Naming** — `feature_repo.dart` + `feature_repo_impl.dart` (two files)
- [ ] **DataSource Naming** — `feature_remote_data_source.dart` or `feature_firebase_data_source.dart` (one file)
- [ ] **Firebase Paths** — `FirestorePaths` constants, no inline strings
- [ ] **REST Endpoints** — `AppEndpoints` constants, no inline strings
- [ ] **DTOs** — `json_serializable`; Firebase DTOs use `fromFirestore` factory
- [ ] **Pagination** — REST: 4-state `BasePaginationCubit`; Firebase: cursor-based
- [ ] **Auth (Firebase)** — Global `AuthCubit` singleton with stream subscription
- [ ] **Streams** — Cancelled in `close()`
- [ ] **Refactoring** — Components under 60 lines and 4 nesting levels
- [ ] **Lists** — `ListView.builder`, never `Column + .map()`
- [ ] **Images** — `cached_network_image` with placeholder
- [ ] **Secrets** — `google-services.json` in `.gitignore`, tokens in secure storage
- [ ] **Localization** — `.arb` keys, `S.of(context)` / `S.current`
- [ ] **Logging** — `LogUtil.log()` only, zero `print()`
- [ ] **Navigation** — `GoRouter`, `routeName` in every View
- [ ] **Commits** — Conventional Commits format