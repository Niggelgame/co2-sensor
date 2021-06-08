package datastore

import "github.com/niggelgame/co2-sensor/data/pkg/models"

type DataStore interface {
	InsertNewEntry(entry *models.Entry) bool

	GetLastEntry() *models.Entry

	GetEntriesSince(unixTimestamp int) []*models.Entry

	GetAllEntries() []*models.Entry

	Close()
}