package datastore

import (
	"errors"
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
)

type SqliteDataStore struct {
	database *gorm.DB
}

func (s *SqliteDataStore) GetCumulatedEntry() (*models.Entry, error) {
	var entries []*models.Entry
	s.database.Order("timestamp DESC").Limit(5).Find(&entries)

	if len(entries) > 0 {
		cumulatedValue := 0
		for i := 0; i < len(entries); i++ {
			cumulatedValue = cumulatedValue + entries[i].Value
		}

		calculatedValue := int(cumulatedValue / len(entries))

		return models.NewEntry(calculatedValue, entries[0].Timestamp), nil
	}
	return nil, errors.New("no entries found")
}

func (s *SqliteDataStore) RegisterMessaging(device *models.NotificationsDevice) error {
	var notificationsDevices []*models.NotificationsDevice
	s.database.Where("messaging_token = ?", device.MessagingToken).Find(&notificationsDevices)

	if len(notificationsDevices) > 0 {
		return nil
	}

	s.database.Create(device)
	return nil
}

func (s *SqliteDataStore) UnregisterMessaging(device *models.NotificationsDevice) error {
	s.database.Where("messaging_token = ?", device.MessagingToken).Delete(device)
	return nil
}

func (s *SqliteDataStore) GetGormDB() *gorm.DB {
	return s.database
}

func (s *SqliteDataStore) CreateNonExistingTables() error {
	err := s.database.AutoMigrate(&models.Entry{})
	err = s.database.AutoMigrate(&models.NotificationsDevice{})
	return err
}

func (s *SqliteDataStore) InsertNewEntry(entry *models.Entry) error {
	s.database.Create(entry)
	return nil
}

func (s *SqliteDataStore) GetLastEntry() (*models.Entry, error) {
	var entries []*models.Entry
	s.database.Order("timestamp desc").Limit(1).Find(&entries)
	if len(entries) > 0 {
		return entries[0], nil
	} else {
		return nil, errors.New("no item found")
	}
}

func (s *SqliteDataStore) GetEntriesSince(unixTimestamp int64) ([]*models.Entry, error) {
	var entries []*models.Entry
	s.database.Where("timestamp >= ?", unixTimestamp).Find(&entries)

	return entries, nil
}

func (s *SqliteDataStore) GetAllEntries() ([]*models.Entry, error) {
	var entries []*models.Entry
	s.database.Find(&entries)
	return entries, nil
}

func (s *SqliteDataStore) Close() {
	sqlDB, err := s.database.DB()
	if err == nil {
		err = sqlDB.Close()
	}
	if err != nil {
		log.Println("did not close db correctly: ", err)
	}
}

func CreateSqliteDataStore(filepath string) *SqliteDataStore {
	db, err := gorm.Open(sqlite.Open(filepath))
	if err != nil {
		log.Fatal("could not open database file: ", err)
	}

	store := &SqliteDataStore{database: db}

	return store
}
