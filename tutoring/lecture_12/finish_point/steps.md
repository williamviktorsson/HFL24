    - [  ] firebase konto (valfritt google konto)
    - [  ] create project (valfritt namn, förslagsvis samma som appens projektnamn)
    - [  ] disable analytics (går att slå på sen, vi behöver inte för något)
    - [  ] ni bör vara på "no cost Spark plan" och det ska inte behövas något kreditkort osv.
    - [  ] gå in på "Firestore Database" och välj "Create database"
    - [  ] välj eur3 som europeisk multi-region 
    - [  ] välj start in test mode (alla som har din firebase config kan läsa+skriva till databasen)
    - [  ] OBS: inte för produktion!

    - [  ] install firebase cli
    - [  ] firebase login
    - [  ] dart pub global activate flutterfire_cli
    - [  ] skapa flutter projekt för firebase repositories (era repositories projekt är dart only medans firebase paket kräver flutter projekt)
    - [  ] flutter create --template=package firebase_repositories
    - [  ] cd firebase_repositories
    - [  ] flutter pub add firebase_core
    - [  ] flutter pub add cloud_firestore

    - [  ] byt id från int till string om ni inte gjort de i modeller (för att id:n är strings i firebase)
    - [  ] byt ut http anrop till firestore anrop


    - [  ] navigera till både din admin_app och user_app och utför följande i respektive:

          - [  ] flutterfire configure (gör detta både i din admin_app och user_app)

          - [  ] välj alla platformar du vill använda så sköter CLI konfigureringen :-D (välj endast iOS/macOS om du faktiskt har en mac-dator så du kan öppna projekten och konfigurera saker i Xcode)
          - [  ] android application id hittar du i android/app/build.gradle under android.namespace (t.ex. com.example.parking-admin), du kan lägga till din parking-admin också senare.
          - [  ] ios bundle ID hittar du genom att öppna ios mappen av projektet i Xcode och gå in under general i project navigator och skriv in det som står under Bundle Identifier(t.ex. com.example.parking-admin)


      - [  ] byt ut http_client_repos till firebase_repos
      - [  ] flutter pub add firebase_core

      - [  ] se till att firebase initialiseras när appen startats

      - [  ] profit


# i main

```dart

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

```