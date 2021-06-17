package models

import "gorm.io/gorm"

type Entry struct {
	gorm.Model
	Value     int   `json:"value"`
	Timestamp int64 `json:"timestamp"`
}

func NewEntry(value int, timestamp int64) *Entry {
	return &Entry{Value: value, Timestamp: timestamp}
}

type InsertEntry struct {
	Value int `json:"value"`
}
