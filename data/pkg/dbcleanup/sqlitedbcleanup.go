package dbcleanup

import (
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"gorm.io/gorm"
	"time"
)

type SqliteDbCleanup struct {
	database     *gorm.DB
	stopChan     chan struct{}
	maxAgeInDays int
}

func (s *SqliteDbCleanup) Cleanup() {
	ticker := time.NewTicker(5 * time.Minute)
	for {
		select {
		case <-ticker.C:
			{
				println("Cleaning up...")
				now := time.Now().UnixNano()

				oldestTs := now - ((time.Hour * 24 ).Nanoseconds() * int64(s.maxAgeInDays))
				s.database.Where("timestamp < ?", oldestTs).Delete(&models.Entry{})
			}
		case <-s.stopChan:
			{
				ticker.Stop()
				return
			}
		}
	}
}

func (s *SqliteDbCleanup) StopCleanup() {
	close(s.stopChan)
}

func CreateSqliteDbCleanup(db *gorm.DB, maxAgeInDays int) *SqliteDbCleanup {
	return &SqliteDbCleanup{
		database:     db,
		stopChan:     make(chan struct{}),
		maxAgeInDays: maxAgeInDays,
	}
}
