package models

import "gorm.io/gorm"

type NotificationsDevice struct {
	gorm.Model
	MessagingToken string `json:"key"`
}

func NewNotificationsDevice(messagingToken string) *NotificationsDevice {
	return &NotificationsDevice{MessagingToken: messagingToken}
}