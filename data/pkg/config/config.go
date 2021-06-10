package config

import (
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"log"
)

type Config struct {
	Dev                     bool   `default:"false"`
	BindAddress             string `default:":8000" envconfig:"BIND_ADDRESS"`
	SqlitePath              string `default:"data.db" envconfig:"SQLITE_PATH"`
	FirebaseCredentialsPath string `default:"serviceAccountKey.json" envconfig:"FIREBASE_CREDENTIALS_PATH"`
	WarnTriggerLevel        int    `default:"1200" envconfig:"WARN_TRIGGER_LEVEL"`
	FatalTriggerLevel       int    `default:"1500" envconfig:"FATAL_TRIGGER_LEVEL"`
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
