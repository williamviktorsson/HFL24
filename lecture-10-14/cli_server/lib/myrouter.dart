import 'package:cli_server/examplehandlers.dart';
import 'package:cli_server/itemshandlers.dart';
import 'package:shelf_router/shelf_router.dart';

/* 


Route	        HTTP-metod	Beskrivning	Repository-metod
/persons	GET	Hämta alla personer	getAll() 
/persons	POST	Skapa ny person	create()
/persons/<id>	GET	Hämta specifik person	getById() 
/persons/<id>	PUT	Uppdatera specifik person	update()
/persons/<id>	DELETE	Ta bort specifik person	delete()
/vehicles	GET	Hämta alla fordon	getAll()
/vehicles	POST	Skapa nytt fordon	create()
/vehicles/<id>	GET	Hämta specifikt fordon	getById()
/vehicles/<id>	PUT	Uppdatera specifikt fordon	update()
/vehicles/<id>	DELETE	Ta bort specifikt fordon	delete()
/parkingspaces	GET	Hämta alla parkeringsplatser	getAll()
/parkingspaces	POST	Skapa ny parkeringsplats	create()
/parkingspaces/<id>	GET	Hämta specifik parkeringsplats	getById()
/parkingspaces/<id>	PUT	Uppdatera parkeringsplats	update()
/parkingspaces/<id>	DELETE	Ta bort parkeringsplats	delete()
/parkings	GET	Hämta alla parkeringar	getAll()
/parkings	POST	Skapa ny parkering	create()
/parkings/<id>	GET	Hämta specifik parkering	getById()
/parkings/<id>	PUT	Uppdatera specifik parkering	update()
/parkings/<id>	DELETE	Ta bort specifik parkering	delete()


 */

Router initRouter() {
  // Configure routes.
  final router = Router();
  router.get('/', rootHandler);
  router.get('/echo/<message>', echoHandler);
  router.post('/items', postItemHandler);
  router.get('/items', getItemsHandler); // get all item
  router.get('/items/<id>', getItemHandler); // get only specific item
  router.put('/items/<id>', updateItemHandler); // get only specific item

  return router;
}
