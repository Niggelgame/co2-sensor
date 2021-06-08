package main

import (
	"fmt"
	"github.com/niggelgame/co2-sensor/data/pkg/config"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	http_server "github.com/niggelgame/co2-sensor/data/pkg/http-server"
)

func main() {
	fmt.Println("Hello")

	cfg := config.LoadConfig()

	fmt.Println("SQLite File: ", cfg.SqlitePath)

	var store datastore.DataStore = datastore.CreateSqliteDataStore(cfg.SqlitePath)

	defer store.Close()

	server := http_server.CreateServer(&store)

	server.Start(cfg.BindAddress)
}