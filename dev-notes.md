# Developer's notes

## Setup local develop environment

### Clone repo

```sh
git clone https://github.com/sap-labs-france/ev-server.git
```

### Install dependencies

For AWS Linux, need to install yum packages

```sh
yum install gcc-c++ make
```

Install [nvm](https://github.com/nvm-sh/nvm#install--update-script)

### Install MongoDB

Install MongoDB on [MacOS](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/), [Ubuntu](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/) or [Amazon Linux](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-amazon/)

### Initiate MongoDB database

Initiate MongoDB database as [instructed here](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/). This includes updating the Configuration file to add replica set, turn on authorization and [configure replica encryption key](https://www.mongodb.com/docs/manual/tutorial/enforce-keyfile-access-control-in-existing-replica-set/).

_Note_: the key file for mongo replica encryption/authentication needs to have proper permission and ownership.

```sh
sudo chown mongo: my_key_file
sudo chmod 400 my_key_file
```

### Start mongodb service and add initial users

Start service of MongoDB

* MacOS:

  ```sh
  brew service start mongodb-community@4.4
  ```

* Ubuntu

  ```sh
  systemctl start mongodb-cummunity@4.4
  ```

* AmazonLinux2

  ```sh
  sudo systemctl start mongod
  sudo systemctl status mongod
  ```

## MongoDB and schemas

This section describe the mongo db design.

### root level collections

```txt
default.carcatalogimages
default.carcatalogs
default.eulas
default.locks
default.logs
default.migrations
default.performances
default.tenantlogos
default.tenants
default.users
```

### Tenant collections

```txt
6476cc8e8a61ccff3271c4a1.cars
6476cc8e8a61ccff3271c4a1.chargingstations
6476cc8e8a61ccff3271c4a1.companies
6476cc8e8a61ccff3271c4a1.connections
6476cc8e8a61ccff3271c4a1.consumptions
6476cc8e8a61ccff3271c4a1.eulas
6476cc8e8a61ccff3271c4a1.importedtags
6476cc8e8a61ccff3271c4a1.importedusers
6476cc8e8a61ccff3271c4a1.invoices
6476cc8e8a61ccff3271c4a1.logs
6476cc8e8a61ccff3271c4a1.metervalues
6476cc8e8a61ccff3271c4a1.rawmetervalues
6476cc8e8a61ccff3271c4a1.rawnotifications
6476cc8e8a61ccff3271c4a1.settings
6476cc8e8a61ccff3271c4a1.siteareas
6476cc8e8a61ccff3271c4a1.sites
6476cc8e8a61ccff3271c4a1.siteusers
6476cc8e8a61ccff3271c4a1.statusnotifications
6476cc8e8a61ccff3271c4a1.tags
6476cc8e8a61ccff3271c4a1.transactions
6476cc8e8a61ccff3271c4a1.users
```

Table and access methods

Table | Model | Method
------|-------|--------
cars                | [`Car`](./src/types/Car.ts#L4) |
chargingstations    | [`ChargingStation`](./src/types/ChargingStation.ts#L15) |
companies           | [`Company`](./src/types/Company.ts#L8) |
connections         | [`Connection`](./src/types/Connection.ts#L2) |
consumptions        | [`Consumption`](./src/types/Consumption.ts#L49) |
eulas               | [`Eula`](./src/types/Eula.ts#L1) |
importedtags
importedusers
invoices            | [`BillingInvoice`](./src/types/Billing.ts#L64) |
logs                | [`Log`](./src/types/Log.ts#L7) |
metervalues
rawmetervalues
rawnotifications
settings            | [`PricingSettings`](./src/types/Setting.ts#L82) [`IntegrationSettings`](./src/types/Setting.ts#L11) |
siteareas           | [`SiteArea`](./src/types/SiteArea.ts#L29) |
sites               | [`Site`](./src/types/Site.ts#L12) |
siteusers
statusnotifications
tags                | [`Tag`](./src/types/Tag.ts#L7) |
transactions        | [`Transaction`](./src/types/Transaction.ts#L80) |
users               | [`User`](./src/types/User.ts#L9) | [UserStorage.getUsers](./src/storage/mongodb/UserStorage.ts#L529)

Commands to drop collections of a tenant

```txt
db.getCollection('6475b7b8ab869dab5e6b4873.cars').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.chargingstations').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.companies').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.connections').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.consumptions').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.eulas').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.importedtags').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.importedusers').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.invoices').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.logs').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.metervalues').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.rawmetervalues').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.rawnotifications').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.settings').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.siteareas').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.sites').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.siteusers').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.statusnotifications').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.tags').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.transactions').drop()
db.getCollection('6475b7b8ab869dab5e6b4873.users').drop()
```

### Provision data

Add a tenant

```txt
db.getCollection('default.tenants').insertOne({
  subdomain: 'ev-dashboard'
})
```

Update tenant

```txt
db.getCollection('default.tenants').updateOne(
  { subdomain: "ev-dashboard" }, // Filter to match the document to be updated
  { $set: {
      "address": {
        "address1": "",
        "address2": "",
        "postalCode": "",
        "city": "",
        "department": "",
        "region": "",
        "country": "",
        "coordinates": ["", ""]
      },
      "components": {
        "ocpi": { "active": true, "type": "" },
        "oicp": { "active": false, "type": "" },
        "refund": { "active": true, "type": "concur" },
        "pricing": { "active": true, "type": "simple" },
        "organization": { "active": false },
        "statistics": { "active": false },
        "analytics": { "active": false, "type": "" },
        "billing": { "active": false, "type": "" },
        "billingPlatform": { "active": false },
        "asset": { "active": false },
        "smartCharging": { "active": false, "type": "" },
        "car": { "active": false },
        "carConnector": { "active": false }
      },
    } 
  } // Specify the update operation using $set to update the "age" field
)
```

### Tables added later

Following tables will be added as more charge points connected

```txt
bootnotifications
configurations
eulas
heartbeats
```

### MongoDB cheat sheet

Commands:

```txt
rs0:PRIMARY> help
	db.help()                    help on db methods
	db.mycoll.help()             help on collection methods
	sh.help()                    sharding helpers
	rs.help()                    replica set helpers
	help admin                   administrative help
	help connect                 connecting to a db help
	help keys                    key shortcuts
	help misc                    misc things to know
	help mr                      mapreduce

	show dbs                     show database names
	show collections             show collections in current database
	show users                   show users in current database
	show profile                 show most recent system.profile entries with time >= 1ms
	show logs                    show the accessible logger names
	show log [name]              prints out the last segment of log in memory, 'global' is default
	use <db_name>                set current database
	db.mycoll.find()             list objects in collection mycoll
	db.mycoll.find( { a : 1 } )  list objects in mycoll where a == 1
	it                           result of the last line evaluated; use to further iterate
	DBQuery.shellBatchSize = x   set default number of items to display on shell
	exit                         quit the mongo shell
```

Database methods:

```txt
rs0:PRIMARY> db.help()
DB methods:
	db.adminCommand(nameOrDocument) - switches to 'admin' db, and runs command [just calls db.runCommand(...)]
	db.aggregate([pipeline], {options}) - performs a collectionless aggregation on this database; returns a cursor
	db.auth(username, password)
	db.cloneDatabase(fromhost) - will only function with MongoDB 4.0 and below
	db.commandHelp(name) returns the help for the command
	db.copyDatabase(fromdb, todb, fromhost) - will only function with MongoDB 4.0 and below
	db.createCollection(name, {size: ..., capped: ..., max: ...})
	db.createUser(userDocument)
	db.createView(name, viewOn, [{$operator: {...}}, ...], {viewOptions})
	db.currentOp() displays currently executing operations in the db
	db.dropDatabase(writeConcern)
	db.dropUser(username)
	db.eval() - deprecated
	db.fsyncLock() flush data to disk and lock server for backups
	db.fsyncUnlock() unlocks server following a db.fsyncLock()
	db.getCollection(cname) same as db['cname'] or db.cname
	db.getCollectionInfos([filter]) - returns a list that contains the names and options of the db's collections
	db.getCollectionNames()
	db.getLastError() - just returns the err msg string
	db.getLastErrorObj() - return full status object
	db.getLogComponents()
	db.getMongo() get the server connection object
	db.getMongo().setSecondaryOk() allow queries on a replication secondary server
	db.getName()
	db.getProfilingLevel() - deprecated
	db.getProfilingStatus() - returns if profiling is on and slow threshold
	db.getReplicationInfo()
	db.getSiblingDB(name) get the db at the same server as this one
	db.getWriteConcern() - returns the write concern used for any operations on this db, inherited from server object if set
	db.hostInfo() get details about the server's host
	db.isMaster() check replica primary status
	db.hello() check replica primary status
	db.killOp(opid) kills the current operation in the db
	db.listCommands() lists all the db commands
	db.loadServerScripts() loads all the scripts in db.system.js
	db.logout()
	db.printCollectionStats()
	db.printReplicationInfo()
	db.printShardingStatus()
	db.printSecondaryReplicationInfo()
	db.resetError()
	db.runCommand(cmdObj) run a database command.  if cmdObj is a string, turns it into {cmdObj: 1}
	db.serverStatus()
	db.setLogLevel(level,<component>)
	db.setProfilingLevel(level,slowms) 0=off 1=slow 2=all
	db.setVerboseShell(flag) display extra information in shell output
	db.setWriteConcern(<write concern doc>) - sets the write concern for writes to the db
	db.shutdownServer()
	db.stats()
	db.unsetWriteConcern(<write concern doc>) - unsets the write concern for writes to the db
	db.version() current version of the server
	db.watch() - opens a change stream cursor for a database to report on all  changes to its non-system collections.
rs0:PRIMARY> 
```

Collection Methods:

```txt
```

## Host in the cloud

1. create s3 bucket named after the real domain name (otherwise s3 won't be able to find the bucket)
2. update bucket policy and enable static web hosting
3. copy dashboard files into s3 bucket with config.json
4. update [dns](https://domains.google.com/registrar/cubic-g.com/dns) to add CNAME that maps to the domain name used by s3 bucket hosting

## Functionality Analysis

### Central systems

Talks to charger

Soap server uses port `8000`, this handles OCPP communication using SOAP
WS server sues port `8010`, this handles OCPP communication using JSON

```txt
5/13/2023, 7:05:56 PM - Async Task manager is starting...
5/13/2023, 7:05:56 PM - Rest Server listening on 'http://127.0.0.1:8080'
5/13/2023, 7:05:56 PM - Soap Server listening on 'http://127.0.0.1:8000'
5/13/2023, 7:05:56 PM - Ocpi Server listening on 'http://127.0.0.1:9090'
5/13/2023, 7:05:56 PM - Oicp Server listening on 'http://127.0.0.1:9080'
```

### OCPI server

uses port `9090`

### Oicp server

uses port `9080`

### Front end server (REST API)

Talks to web browser dashboard

Interface <1> `CentralSystemServer`

The api specification is available at: [`./src/assets/server/rest/v1/docs/e-mobility-oas.json`](./src/assets/server/rest/v1/docs/e-mobility-oas.json).

## Source Code analysis

### main entrance of the program

This main entrance is in `src/start.ts`. It invokes `Bootstrap.start()` to start the program.

REST API is provided in `src/server/rest/RestServer.ts` and `RestServerService.ts`.

Authentication related endpoints are defined in `src/server/rest/v1/service/AuthService`.

* `/v1/auth/signin` -> `AuthService.handlerLogIn`

* `/v1/auth/signon` -> `AuthService.handleRegisterUser`

  Create new user in collection `<tenantId>.users`.

  input: req

  ```json
  {
    "tenant": {
      "id": "xxx"
    }
  }
  ```

  user:

  ```json
  {
    "email": "xx",
    "name": "",
    "firstName": "",
    "locale": "",
    "mobile": "",
    "createdOn": "",
    "verificationToken": "xx",
    ""
  }
  ```

* encrypt password -> `Utils.hashPasswordBcrypt`

  use package [bcryptjs](https://www.npmjs.com/package/bcrypt)
  generate a 10-char salt
  salt will be used to calculate hash of password. salt can be worked out from hash
  use bcrypt.compare to check

### Configuration

The ev-server's configuration is provided in `./src/assets/config.json`. There is a utility class defined in `./src/utils/Configurations.ts` that provide access to the configured settings.

Here is a list of sections found in the configuration file:

No. | Section | Purpose | References
----|---------|---------|------------
1   | EVDatabase     |
2   | Crypto         |
3*  | CentralSystems | This controls the implementation of the Central System defined in the OCPP protocol, should be a list of implemented interfaces  | [`Configuration.getCentralSystemsConfig()`](./src/utils/Configuration.ts#L90) [`CentralSystemConfiguration`](./src/types/configuration/CentralSystemConfiguration.ts#L8)
4*  | CentralSystemRestService | How the ev-server backend exposes its service | [`Configuration.getCentralSystemRestServiceConfig()`](./src/utils/Configuration.ts#L111) [`CentralSystemRestServiceConfiguration`](./src/types/configuration/CentralSystemRestServiceConfiguration.ts#L3)
5   | CentralSystemFrontEnd |
6*  | OCPIService | Configures the basics of central system service for OCPI, host, port, protocol, logging level, etc. | [`Configuration.getOCPIServiceConfig()`](./src/utils/Configuration.ts#L128) [`OCPIServiceConfiguration`](./src/types/configuration/OCPIServiceConfiguration.ts#L3)
7*  | OICPService | Configures the basics of central system service for OICP, host, port, protocol, logging level, etc. | [`Configuration.getOICPServiceConfig()`](./src/utils/Configuration.ts#L135) [`OICPServiceConfiguration`](./src/types/configuration/OICPServiceConfiguration.ts)
8   | CentralSystemServer |
9*  | ODataService | Configures the basic of central system service for OData, host, port, protocol, logging level, etc. | [`Configuration.getODataServiceConfig()`](./src/utils/Configuration.ts#L142) [`ODataServiceConfiguration`](./src/types/configuration/ODataServiceConfiguration.ts#L3)
10  | WSDLEndpoint | | [`Configuration.getWSDLEndpointConfig()`](./src/utils/Configuration.ts#L156) [Utils.buildOCPPServerSecureURL()](./src/utils/Utils.ts#L933)
11  | JsonEndpoint | | [`Configuration.getJsonEndpointConfig()`](./src/utils/Configuration.ts#L163) [`Configuration.getWSDLEndpointConfig()`](./src/utils/Configuration.ts#L156) [Utils.buildOCPPServerSecureURL()](./src/utils/Utils.ts#L936)
12  | OCPIEndpoint | | [`Configuration.getOCPIEndpointConfig()`](./src/utils/Configuration.ts#L173) [`OCPIUtils.buildOcpiCredentialObject`](./src/server/ocpi/OCPIUtils.ts#L57) [`OCPIClient.getLocalEndpointUrl()`](./src/client/ocpi/OCPIClient.ts#L248)
13* | AsyncTask | | [`Configuration.getAsyncTaskConfig()`](./src/utils/Configuration.ts#L65) [`AsyncTaskConfiguration`](./src/types/configuration/AsyncTaskConfiguration.ts#L1)
14* | Storage | How to connect to MongoDB | [`Configuration.getStorageConfig()`](./src/utils/Configuration.ts#L208) [`StorageConfiguration`](./src/types/configuration/StorageConfiguration.ts#L1)
15  | Notification
16  | Firebase
17  | Axios
18  | Email | How to send emails | [`EMailNotificationTasks`](./src/notification/email/EMailNotificationTask.ts#L25)
19  | Authorization | | [`Configuration.getAuthorizationConfig()`](./src/utils/Configuration.ts#L104) [`Authorizations.getConfiguration()`](./src/authorization/Authorizations.ts#L963)
20* | ChargingStation | Controls how the central system should interact with charge point as defined in the OCPP protocol| [`Configuration.getChargingStationConfig()`](./src/utils/Configuration.ts#L215) [`ChargingStationConfiguration`](./src/types/configuration/ChargingStationConfiguration.ts#L1)
21* | Migration | | [`Configuration.getSchedulerConfig()`](./src/utils/Configuration.ts#L58) [`MigrationConfiguration`](./src/types/configuration/MigrationConfiguration.ts#L1)
22* | Scheduler | | [`Configuration.getMigrationConfig()`](./src/utils/Configuration.ts#L242) [`SchedulerConfiguration`](./src/types/configuration/SchedulerConfiguration.ts#L1)
23  | Trace | | [`Configuration.getTraceConfig()`](./src/utils/Configuration.ts#L265) [`Logging.getTraceConfiguration()`](./src/utils/Logging.ts#L44)
24  | Logging | control logging level | [`Configuration.getLogConfig()`](./src/utils/Configuration.ts#L235) [`Logging.getConfiguration()`](./src/utils/Logging.ts#L37)

*Note*: sections marked with `*` are the ones read during system bootstrap process.

*Note*: section `Monitoring` and `Cache` seem missing from current config. They are both mentioned in [`Bootstrap.start()`](./src/start.ts#L83)

### QR code generation

Charge Point (Charging station) has one or more connectors that are sequentially numbered starting from one. Each connector has a unique QR code that uniquely identifies this connector. When decoded, the QR code represents following JSON data.

```json
{
    "chargingStationID": "CS-ABB-00001",
    "connectorID": 1,
    "endpoint": "https://auto1.example.com",
    "tenantName": "auto1",
    "tenantSubDomain": "auto1"
}
```

The endpoint to initiate a charging session of the given connector is retrieved by calling [`Utils.getChargingStationEndpoint()`](./src/utils/Utils.ts#L1214)

The e-server mobile app can decode this data and initiate a charging session using the information provided.

### Transactions

* Swagger Tag: Transactions
* api prefix: `/api/transactions`
* Service: [`TransactionService`](./src/server/rest/v1/service/TransactionService.ts#L48)

List of methods:

request  | handler | methods | description
---------|---------|---------|-------------
GET /api/transactions | [`TransactionService.handleGetTransactions`](./src/server/rest/v1/service/TransactionService.ts#L49) |  [`TransactionService.getTransactions`](./src/server/rest/v1/service/TransactionService.ts#L743) | list transactions from `<tenantId>.transactions` table.
PUT /api/transactions/start | [`TransactionService.handleTransactionStart`](./src/server/rest/v1/service/TransactionService.ts#L265) | [`ChargingStationService.handleOcppAction`](./src/server/rest/v1/service/ChargingStationService.ts#L741) [`ChargingStationService.handleOcpiAction`](./src/server/rest/v1/service/ChargingStationService.ts#L685) | Invoke proper handler based on Charge Point settings

### Billing

* Swagger Tag: Billing
* api prefix `/api/billing`
* Service: [`BillingService`](./src/server/rest/v1/service/BillingService.ts#L31)

List of methods:

request  | handler | methods | description
---------|---------|---------|-------------
GET /api/users/{id}/payment-methods | [`BillingService.handleBillingGetPaymentMethods`](./src/server/rest/v1/service/BillingService.ts#L272)

### Utility functions

* [`Utils.isComponentActiveFromToken`](./src/utils/Utils.ts#429)

  Decode user token and check if the specified component is included in the `activeComponents`. The possible components are defined in [`enum TenantComponents`](./src/types/Tenant.ts#L44)

* [`UtilsService.assertComponentIsActiveFromToken`](./src/server/rest/v1/service/UtilsService.ts#L1209)

  Invoke Utils method to check if the operation can be performed.

* [`UtilsService.checkAndGetChargingStationAuthorization`](./src/server/rest/v1/service/UtilsService.ts#L119)

  If user pass authorization check, return the ChargingStation pertain to this request.

* [`UtilsService.assertIdIsProvided`](./src/server/rest/v1/service/UtilsService.ts#L1150)

  Ensure an `Id` is provided in the input. Only Id is checked, other parameters are used for logging.

* [`AuthorizationService.checkAndGetChargingStationAuthorizations`](./src/server/rest/v1/service/AuthorizationService.ts#L726)

  Invoke `checkAndGetEntityAuthorizations` to validate permission and return the [`AuthorizationFilter`](./src/types/Authorization.ts#L49) to be used. The returned AuthorizationFilter will be used in db retrieval later.

* [`AuthorizationService.checkAndGetEntityAuthorizations`](./src/server/rest/v1/service/AuthorizationService.ts#L1663)

  Check if user (represented by [token](./src/types/UserToken.ts#L3)) can perform the specified [action](./src/types/Authorization.ts#L118) on the specified [entity](./src/types/Authorization.ts#L77) of the specified [tenant](./src/types/Tenant.ts#L4), dynamic filters will also be used if present.

* [`Authorizations.can`](./src/authorization/Authorizations.ts#L693)

  Check if current user (represented by token) can perform specified action on the specified entity within given context by invoking `AuthorizationsManager.canPerformAction`.

* [`AuthorizationsManager.canPerformAction`](./src/authorization/AuthorizationsManager.ts#L85)

  Use [`role-acl`](https://npmjs.com/package/role-acl) to perform check and cache result for future reference.

### OCPPServer

The [OCPP Server](./src/server/ocpp/OCPPServer.tsL#6) is responsible to communicate with charge point using OCPP protocol.

It uses [`CentralSystemConfiguration`](./src/assets/config.json#L10) and [`ChargingStationConfiguration`](./src/assets/config.json#L128).

```json
{
  "ChargingStation": {
    "heartbeatIntervalOCPPSSecs": 60,
    "heartbeatIntervalOCPPJSecs": 3600,
    "pingIntervalOCPPJSecs": 60,
    "monitoringIntervalOCPPJSecs": 600,
    "notifBeforeEndOfChargeEnabled": true,
    "notifBeforeEndOfChargePercent": 85,
    "notifEndOfChargeEnabled": true,
    "notifStopTransactionAndUnlockConnector": false,
    "maxLastSeenIntervalSecs": 540
  }
}
```

`pingIntervalOCPPJSecs` controls JsonOCPPSever's behavior. Setting value to `60` requires ws connection to be checked and cleaned up every 60 seconds.

`OCPPServer` is an abstract class. It has two implementations: [`JsonOCPPServer`](./src/server/ocpp/json/JsonOCPPServer.ts#L28) and [`SoapOCPPServer`](./src/server/ocpp/soap/SoapOCPPServer.ts#L22)

[`WSConnection`](./src/server/ocpp/json/web-socket/WSConnection.ts#L16) is the programming model for the WS connection between Central System and the Charge Point. It provides methods to send/receive messages. [`JsonWSConnection`](./src/server/ocpp/json/web-socket/JsonWSConnection.ts#L23) is a subclass of `WSConnection`. It uses [`JsonChargingStationService`](./src/server/ocpp/json/services/JsonChargingStationService.ts#L15) to provide OCPP operations. [`WSWrapper`](./src/server/ocpp/json/web-socket/WSWrapper.ts#L10) is the programming model of [WebSocket](https://github.com/uNetworking/uWebSockets.js). One can send messages, ping or close web socket using its wrapper. WebSocket of `uWebSockets.js` already handles auto-respond to ping/pong. `WSConnection` gets notified on ping/pong events, `JsonWSConnection` uses this chance to update charing station's `lastSeen` attribute.

`WSConnection` has a member `ID` that uniquely identifies itself. The format is `<tenantId>~<chargingStationId>`, see [`getID()`](./src/server/ocpp/json/web-socket/WSConnection.ts#L312). Every valid WSConnection belongs to one specific charging station of a tenant.

## Notes of web sockets

Client first send handshake request to the server

```txt
GET / HTTP/1.1
Host: ws.example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==
Sec-WebSocket-Version: 13
Origin: http://example.com
```

The `sec-websocket-key` tells the server the key uses for this client and `sec-websocket-version` tells the server which web socket version that the client prefers.

The server then reply the handshake response:

```txt
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=
```

Note that 101 indicates protocol switch. The value of `sec-websocket-accept` is calculated based on client provided `sec-websocket-key` and [a magic string `258EAFA5-E914-47DA-95CA-C5AB0DC85B11`](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers#server_handshake_response).

## References

### Resources

* [Open Charge Point Interface](https://evroaming.org)
* [Open Charge Point Protocol](https://en.wikipedia.org/wiki/Open_Charge_Point_Protocol)
* [Open InterCharge Protocol](https://github.com/hubject/oicp)

### Deployed Trial

item | value
-----------|----------------------|------------
Site       | http://qingmaiche.cn |
superadmin | super.admin@ev.com   | Slf.admin00
Admin      | slf.admin@ev.com     | Slf.admin00
Basic      | basic@ev.com         | Slf.admin00
Demo       | demo@ev.com          | Slf.admin00

### Information

* [VIN](https://en.wikipedia.org/wiki/Vehicle_identification_number)
* [RFID](https://en.wikipedia.org/wiki/Radio-frequency_identification)

* [Read websocket response with curl](https://stackoverflow.com/questions/47860689/how-to-read-a-websocket-response-with-curl)
* [Writing Websocket server](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers)
* [Writing WebSocket client application](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_client_applications)
* [Rfc 6455 The WebSocket Protocol](https://datatracker.ietf.org/doc/html/rfc6455)
* [wscat](https://github.com/websockets/wscat)
