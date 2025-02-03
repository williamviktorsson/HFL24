# Denna vecka

Deployments

- [  ] Testa obfuscera #1
- [  ] Testa deploya web #2

<!-- #1

flutter build appbundle --obfuscate --split-debug-info=/admin_app/debug_info

Fungerar på alla build targets utom web

Kräver de-obfuscering av stacktraces för debugging.

Görs med flutter symbolize -i <symbol fil från debug_info mappen>

 -->

 <!-- #2
 
 // cli förstår vad den ska göra beroende på framework
 // express/Next/angular/flutter
 firebase experiments:enable webframeworks 

 firebase init hosting

 firebase deploy
 
  -->

Sedan följer någorlunda liknande steg för samtliga plattformar:

- Generera app-ikon och specifiera sökväg till denna i plattformsspecifik konfig-fil. app-ikonen sparas som resurs i resurs-mapp per plattform.

- För alla plattformar utom linux & web behöver du signera applikationen. En säkerhetsåtgärd som säkerställer att applikationen är byggd av en "betrodd" utvecklare & används även för att verifiera att applikationen som byggts inte byggts om av någon annan sedan den först byggdes.

- På windows, macOS, iOS hanteras detta åt dig samtidigt som uppladdning till app store / microsoft windows app store, endast betrodda kan utföra uppladdningen. Går även att själv-signera lokalt och zippa en fil med inkluderad .exe fil för inkludering. Denna zip kan användas för att packetera en egen windows installer för distribuering. Läs mer här: https://docs.flutter.dev/platform-integration/windows/building#building-your-own-zip-file-for-windows  https://docs.flutter.dev/platform-integration/windows/building#additional-resources

- På android ställer du in i din app/build.gradle sökvägen till en fil som har signeringsnycklarna du hämtat från google play, så signeras applikationen sedan varje gång du bygger med --release flaggan.

- Går även att själv signera en macOS .dmg fil och distribuera denna för nedladdning utan apple developer konto.

- Så vitt jag vet är inte detta möjligt för att generera .ipa (mobilapp iOS)

- officiella guiden för linux är för att skapa en "snap" och ladda upp till "Snap Store" genom att skapa ett snapcraft konto https://snapcraft.io/ och ladda upp och hantera distribuering via snap store.

- Går även att generera .deb för Debian/Ubuntu eller .rpm för tex. Fedora.

- I nästan alla fall behöver konfig filerna dubbelkollas för respektive plattform att de innehåller korrekta app id:n / bundle identifier / app identifier, och motsvarar id:n så som de är registrerade i respektive "store" och i respektive tjänst/api som applikationen interagerar med.

- Uppdateras app id:t, måste detta uppdateras på samtliga tjänster och plattformar.

- På mobil (android/ios) behövs även omfattande beskrivningar av applikationerna laddas upp. Beskrivningar av applikationen, dess användning, vilka hårdvaru-api:er den använder/interagerar. Bilder på själva applikationerna (screenshots) kan också behövas i olika vyer också (landscape/portrait)

- Vid uppdateringar av applikationen skall versionsnummer uppdateras i pubspec.yaml i projektet. För vissa plattformar (t.ex. Linux & iOS) kan detta också behöva uppdateras på andra ställen (snapcraft.yaml eller i XCode)

- I stores går det att ha olika channels (beta/release/testing) och rulla ut olika versioner av applikationen till olika grupper. På både iOS och Android går det att ha uppe testing/beta kanaler innan applikationen faktiskt godkänts av den officiella review som godkänner applikationen innan den blir tillgänglig på appstores.

- För iOS behöver användare en annan app "Test Flight" för att komma åt applikationer i beta/testing. Inbjudningar sker så att användare kan komma åt applikationen i "Test Flight" för att ladda ned. Skilker sig från android där distribution av beta/testing appar sker via goggle play precis som vanliga appar.

- Microsoft Store verkar ha minst tydliga sätt hur detta hanteras. Istället för kanaler kallas det "package flight" och du kan definiera olika "flight group(s)" för att hantera vilka som får tillgång till vilken flight. 

- En app review kräver att en reviewer får exempel på inloggningsuppgifter och en beskrivning av hur den navigerar och anvädner applikationen.

- Var beredd på att både app store och google play kräver att du sammanställer dokument som beskriver hur er applikation hanterar krav från t.ex. GDPR(personuppgifter)/Schrems 2 (överföringar tredjeland).

- codemagic (väldigt populär tjänst för att hantera CI/CD, bygga + signera + deploya i molnet) erbjuder en del av sina verktyg för att underlätta deployments: https://github.com/codemagic-ci-cd/cli-tools

- Vill du rulla ditt eget CI/CD utan att betala (även om det finns free tiers på codemagic) kan du sätta upp "fastlane" att fungera med github actions: https://docs.fastlane.tools/ (referens: https://github.com/nabilnalakath/flutter-githubaction)

- Alla dessa exempel finns noggrant beskrivna i https://docs.flutter.dev/deployment och jag skulle inte själv kunna förbereda ett projekt för deployment utan att följa stegen där i, även om jag gjort det flera gånger och för flera plattformar.

- Bör kanske tilläggas att för windows specifik, likt hur det finns möjlighet att nyttja cupertino för iOS, så finns paketet https://pub.dev/packages/fluent_ui som ämnar replikera design guidelines för windows appar, samt https://pub.dev/packages/fluentui_system_icons för Microsoft ikoner.


- Här är en lista av filer som troligtvis kommer beröras för att deploya till olika targets:


Android Files:
1. `android/app/build.gradle`
   - Contains app version, build settings, signing configs
   - Used for configuring the Android build
   - Houses dependencies and SDK versions

2. `android/app/src/main/AndroidManifest.xml`
   - App permissions
   - App name
   - Internet access settings
   - Other app configurations

3. `[project]/android/key.properties` 
   - Stores keystore information
   - Password references
   - Keystore file location

4. `android/app/src/main/res/`
   - Contains app icons in different resolutions
   - Launcher icons
   - Other resources

iOS Files:
1. `ios/Runner.xcworkspace`
   - Main Xcode workspace file
   - Contains project settings
   - Build configurations

2. `ios/Runner/Info.plist`
   - App permissions
   - Basic app configurations
   - Display name

3. `ios/Flutter/AppframeworkInfo.plist`
   - Minimum OS version
   - Framework settings

4. `ios/Runner/Assets.xcassets`
   - App icons
   - Launch images

macOS Files:
1. `macos/Runner/Configs/AppInfo.xcconfig`
   - Product name
   - Bundle identifier
   - Copyright information

2. `macos/Runner.xcworkspace`
   - Project settings
   - Build configurations

3. `macos/Runner/Assets.xcassets`
   - App icons
   - Resources

Windows Files:
1. `windows/runner/Runner.rc`
   - App icon references
   - Version information

2. `windows/runner/resources/`
   - App icons (app_icon.ico)
   - Resource files

3. `pubspec.yaml` (for MSIX configuration)
   - MSIX packaging settings
   - Version information
   - Display name
   - Publisher information

Linux Files:
1. `snap/snapcraft.yaml`
   - Snap configuration
   - App metadata
   - Build instructions
   - Dependencies

2. `snap/gui/`
   - `.desktop` file for app launcher
   - App icon (PNG format)
   - Menu integration settings

Common File:
1. `pubspec.yaml`
   - Version number (affects all platforms)
   - Basic app information
   - Dependencies
   - Platform-specific configurations

This compilation represents the key files that typically need modification when preparing Flutter apps for deployment across different platforms. Each platform has its own specific requirements and file structures that need to be properly configured for successful deployment.