package main

import (
	"github.com/niggelgame/co2-sensor/data/pkg/config"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	http_server "github.com/niggelgame/co2-sensor/data/pkg/http-server"
	"github.com/niggelgame/co2-sensor/data/pkg/notifications"
	"log"
)

func main() {
	cfg := config.LoadConfig()

	var store datastore.DataStore = datastore.CreateSqliteDataStore(cfg.SqlitePath)

	err := store.CreateNonExistingTables()

	if err != nil {
		log.Fatal("cannot create new tables: ", err)
	}

	defer store.Close()

	notificationHandler := notifications.CreateNotificationHandler(cfg.FirebaseCredentialsPath)

	server := http_server.CreateServer(&store, notificationHandler)

	// Create Goroutine deleting values older than 4 weeks
	server.Start(cfg.BindAddress)
}