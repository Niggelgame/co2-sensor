package notifications

import (
	"context"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
	"log"
)

type NotificationHandler struct {
	Client *messaging.Client
}

func (n *NotificationHandler) SendNotification() {

}

func CreateNotificationHandler(firebaseCredentialsPath string) *NotificationHandler {

	opt := option.WithCredentialsFile(firebaseCredentialsPath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Fatal("cannot create firebase app: ", err)
	}
	msgClient, err := app.Messaging(context.Background())
	if err != nil {
		log.Fatal("cannot create messaging client: ", err)
	}

	return &NotificationHandler{
		Client: msgClient,
	}
}
