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

### Front end server

Talks to web browser dashboard

Interface <1> `CentralSystemServer`

## Source Code analysis

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
  