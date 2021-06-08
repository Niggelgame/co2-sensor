package config

import (
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"log"
)

type Config struct {
	Dev         bool   `default:"false"`
	BindAddress string `default:":8000" envconfig:"BIND_ADDRESS"`
	SqlitePath  string `default:"data.db" envconfig:"SQLITE_PATH"`
}

func LoadConfig() *Config {
	_ = godotenv.Load()
	var cfg Config
	err := envconfig.Process("DATA", &cfg)
	if err != nil {
		log.Fatal("failed to laod config: ", err)
	}
	return &cfg
}
