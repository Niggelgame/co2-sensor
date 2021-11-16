package datastore

import (
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"gorm.io/gorm"
)

type DataStore interface {
	InsertNewEntry(entry *models.Entry) error

	GetLastEntry() (*models.Entry, error)

	GetLastEntries(count int64) ([]*models.Entry, error)

	GetEntriesSince(unixTimestamp int64) ([]*models.Entry, error)

	GetAllEntries() ([]*models.Entry, error)

	GetCumulatedEntry() (*models.Entry, error)

	RegisterMessaging(device *models.NotificationsDevice) error

	UnregisterMessaging(device *models.NotificationsDevice) error

	GetNotificationDevices() ([]*models.NotificationsDevice, error)

	CreateNonExistingTables() error

	GetGormDB() *gorm.DB

	Close()
}