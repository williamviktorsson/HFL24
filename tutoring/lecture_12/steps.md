- firebase konto (valfritt google konto)
- create project (valfritt namn, förslagsvis samma som appens projektnamn)
- disable analytics (går att slå på sen, vi behöver inte för något)
- ni bör vara på "no cost Spark plan" och det ska inte behövas något kreditkort osv.

- install firebase cli
- firebase login
- dart pub global activate flutterfire_cli
- skapa flutter projekt för firebase repositories (era repositories projekt är dart only medans firebase paket kräver flutter projekt)
- flutter create --template=package flutter_repositories
- cd flutter_repositories
- flutter pub add firebase_core



- flutterfire configure (gör detta både i din admin_app och user_app)

- välj alla platformar du vill använda så sköter CLI konfigureringen :-D (välj endast iOS/macOS om du faktiskt har en mac-dator så du kan öppna projekten och konfigurera saker i Xcode)
- android application id hittar du i android/app/build.gradle under android.namespace (t.ex. com.example.parking-admin), du kan lägga till din parking-admin också senare.
- ios bundle ID hittar du genom att öppna ios mappen av projektet i Xcode och gå in under general i project navigator och skriv in det som står under Bundle Identifier(t.ex. com.example.parking-admin)
-