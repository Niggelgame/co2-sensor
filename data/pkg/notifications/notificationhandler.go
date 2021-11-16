package notifications

import (
	"context"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
	"log"
)

type NotificationHandler struct {
	client *messaging.Client
}

func (n *NotificationHandler) SendNotification(fcmToken string, title string, message string) error {
	send, err := n.client.Send(context.Background(), &messaging.Message{
		Notification: &messaging.Notification{
			Title: title,
			Body:  message,
		},
		Android: &messaging.AndroidConfig{Priority: "high"},
		Token:   fcmToken,
	})
	log.Println("Sent message ", send)
	return err
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
		client: msgClient,
	}
}
