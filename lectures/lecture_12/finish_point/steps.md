- [ x ] firebase konto (valfritt google konto)
- [ x ] create project (valfritt namn, förslagsvis samma som appens projektnamn)
- [ x ] disable analytics (går att slå på sen, vi behöver inte för något)
- [ x ] ni bör vara på "no cost Spark plan" och det ska inte behövas något kreditkort osv.
- [ x ] gå in på "Firestore Database" och välj "Create database"
- [ x ] välj eur3 som europeisk multi-region 
- [ x ] välj start in test mode (alla som har din firebase config kan läsa+skriva till databasen)
- [ x ] OBS: inte för produktion!

- [ x ] install firebase cli
- [ x ] firebase login
- [ x ] dart pub global activate flutterfire_cli
- [ x ] skapa flutter projekt för firebase repositories (era repositories projekt är dart only medans firebase paket kräver flutter projekt)
- [ x ] flutter create --template=package firebase_repositories
- [ x ] cd firebase_repositories
- [ x ] flutter pub add firebase_core
- [ x ] flutter pub add cloud_firestore

- [ x ] byt id från int till string om ni inte gjort de i modeller (för att id:n är strings i firebase)
- [ x ] byt ut http anrop till firestore anrop


- [  ] navigera till både din admin_app och user_app och utför följande i respektive:

      - [ x ] flutterfire configure (gör detta både i din admin_app och user_app)

      - [ x ] välj alla platformar du vill använda så sköter CLI konfigureringen :-D (välj endast iOS/macOS om du faktiskt har en mac-dator så du kan öppna projekten och konfigurera saker i Xcode)
      - [ x ] android application id hittar du i android/app/build.gradle under android.namespace (t.ex. com.example.parking-admin), du kan lägga till din parking-admin också senare.
      - [  ] ios bundle ID hittar du genom att öppna ios mappen av projektet i Xcode och gå in under general i project navigator och skriv in det som står under Bundle Identifier(t.ex. com.example.parking-admin)


      - [ x ] byt ut http_client_repos till firebase_repos
      - [ x ] flutter pub add firebase_core

      - [ x ] se till att firebase initialiseras när appen startats

      - [  ] profit


# i main

```dart

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

```