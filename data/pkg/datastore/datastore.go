package datastore

import "github.com/niggelgame/co2-sensor/data/pkg/models"

type DataStore interface {
	InsertNewEntry(entry *models.Entry) error

	GetLastEntry() (*models.Entry, error)

	GetEntriesSince(unixTimestamp int) ([]*models.Entry, error)

	GetAllEntries() ([]*models.Entry, error)

	CreateNonExistingTables() error

	Close()
}