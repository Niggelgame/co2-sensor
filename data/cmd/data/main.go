package main

import (
	"github.com/niggelgame/co2-sensor/data/pkg/config"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"github.com/niggelgame/co2-sensor/data/pkg/dbcleanup"
	http_server "github.com/niggelgame/co2-sensor/data/pkg/http-server"
	"log"
)

func main() {
	cfg := config.LoadConfig()

	fbCfg := config.LoadFirebaseConfig()

	var store datastore.DataStore = datastore.CreateSqliteDataStore(cfg.SqlitePath)
	defer store.Close()

	err := store.CreateNonExistingTables()


	if err != nil {
		log.Fatal("cannot create new tables: ", err)
	}

	cleanup := dbcleanup.CreateSqliteDbCleanup(store.GetGormDB(), cfg.MaxEntryAgeDays)

	// Create Goroutine deleting values older than cfg.MaxEntryAgeDays days
	go cleanup.Cleanup()
	defer cleanup.StopCleanup()

	// Disable notifications for now
	/*
	notificationHandler := notifications.CreateNotificationHandler(cfg.FirebaseCredentialsPath)
	
	notificationService := notifications.CreateDeviceNotificationService(notificationHandler, store, cfg.FatalTriggerLevel)

	go notificationService.Start()
	defer notificationService.Stop()*/

	server := http_server.CreateServer(&store, notificationHandler, fbCfg)

	server.Start(cfg.BindAddress)
}