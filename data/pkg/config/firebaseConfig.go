package config

import (
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"log"
)

type FirebaseConfig struct {
	ApiKey            string `default:"" json:"api_key" envconfig:"API_KEY"`
	AppIdAndroid      string `default:"" json:"app_id_android" envconfig:"APP_ID_ANDROID"`
	AppIdiOS          string `default:"" json:"app_id_ios" envconfig:"APP_ID_IOS"`
	AppIdWeb          string `default:"" json:"app_id_web" envconfig:"APP_ID_WEB"`
	MessagingSenderId string `default:"" json:"messaging_sender_id" envconfig:"MESSAGING_SENDER_ID"`
	ProjectId         string `default:"" json:"project_id" envconfig:"PROJECT_ID"`
}

type ReturnFirebaseConfig struct {
	ApiKey            string `json:"api_key"`
	AppId             string `json:"app_id"`
	MessagingSenderId string `json:"messaging_sender_id"`
	ProjectId         string `json:"project_id"`
}

func (c FirebaseConfig) IsEmpty() bool {
	if c.ApiKey == "" || (c.AppIdAndroid == "" && c.AppIdiOS == "" && c.AppIdWeb == "") || c.MessagingSenderId == "" || c.ProjectId == "" {
		log.Println("Firebase config for devices is empty. No notifications will be received on device!")
		return true
	}
	return false
}

func LoadFirebaseConfig() *FirebaseConfig {
	_ = godotenv.Load()

	var cfg FirebaseConfig
	err := envconfig.Process("FIREBASE", &cfg)
	if err != nil {
		log.Fatal("failed to laod config: ", err)
	}

	if cfg.IsEmpty() {
		return nil
	}

	return &cfg
}
