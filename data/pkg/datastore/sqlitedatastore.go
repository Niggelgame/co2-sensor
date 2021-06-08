package datastore

import (
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"log"
)

type SqliteDataStore struct {
	database *sql.DB
}

func (s *SqliteDataStore) InsertNewEntry(entry *models.Entry) bool {
	panic("implement me")
}

func (s *SqliteDataStore) GetLastEntry() *models.Entry {
	panic("implement me")
}

func (s *SqliteDataStore) GetEntriesSince(unixTimestamp int) []*models.Entry {
	panic("implement me")
}

func (s *SqliteDataStore) GetAllEntries() []*models.Entry {
	panic("implement me")
}

func (s *SqliteDataStore) Close() {
	err := s.database.Close()
	if err != nil {
		log.Println("did not close db correctly: ", err)
	}
}

func CreateSqliteDataStore(filepath string) *SqliteDataStore {
	db, err := sql.Open("sqlite3", filepath)
	if err != nil {
		log.Fatal("could not open database file: ", err)
	}

	store := &SqliteDataStore{database: db}

	return store
}