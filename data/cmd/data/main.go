package main

import (
	"github.com/niggelgame/co2-sensor/data/pkg/config"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"github.com/niggelgame/co2-sensor/data/pkg/dbcleanup"
	http_server "github.com/niggelgame/co2-sensor/data/pkg/http-server"
	"github.com/niggelgame/co2-sensor/data/pkg/notifications"
	"log"
)

func main() {
	cfg := config.LoadConfig()

	fbCfg := config.LoadFirebaseConfig()

	var store datastore.DataStore = datastore.CreateSqliteDataStore(cfg.SqlitePath)

	err := store.CreateNonExistingTables()

	if err != nil {
		log.Fatal("cannot create new tables: ", err)
	}

	cleanup := dbcleanup.CreateSqliteDbCleanup(store.GetGormDB(), cfg.MaxEntryAgeDays)

	// Create Goroutine deleting values older than cfg.MaxEntryAgeDays days
	go cleanup.Cleanup()

	defer cleanup.StopCleanup()

	defer store.Close()

	notificationHandler := notifications.CreateNotificationHandler(cfg.FirebaseCredentialsPath)

	server := http_server.CreateServer(&store, notificationHandler, fbCfg)

	server.Start(cfg.BindAddress)
}