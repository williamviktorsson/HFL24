- heads up:
    - Går ej att köra "Run" i Visual Studio Code
    - Kör från terminalen! (open in integrated terminal: dart .\main.dart )

- Nytt flutter projekt, vad är vad? hur starta nytt projekt, hur strukturera projekt?
    - Bra att separera till mappen models(person,vehicle,parking,spot) och repository, samt en main.dart som är ert CLI.
    - Diskussion om hur man hade kunnat komma igång med uppgiften, vad göra vad.
    - Kort om initiera git repo.

- Vi kollade på hur man kan hantera id:n på klasser (Uuid().v4() t.ex.)

- Hur läsa/skriva till fil (finns i dart:io, t.ex. File.open() eller Directory.current)

- Bokrekommendation? Återkommer!

- Flutter create/dart create?
    - undvik flutter create just nu innan kursen kommit igång
    - ni kan absolut använda dart create för att skapa ett nytt dart projekt. Då landar er main fil i bin/[projektnamn].dart, detta är fördelaktigt om ni planerar att använda några externa paket från t.ex. [pub.dev](https://pub.dev)
    - ni kan också bara göra en fil t.ex. main.dart eller cli.dart och köra därifrån.

