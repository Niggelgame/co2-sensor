package http_server

import (
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"github.com/niggelgame/co2-sensor/data/pkg/notifications"
	"log"
	"time"
)

type Server struct {
	store    *datastore.DataStore
	notifier *notifications.NotificationHandler
}

func (s *Server) AddEntry(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	var insertEntry models.InsertEntry
	err = json.Unmarshal(c.Body(), &insertEntry)
	if err != nil {
		c.Status(400)
		log.Println("error while parsing json: ", err)
		return err
	}

	entry := models.New(insertEntry.Value, time.Now().UnixNano())
	err = (*s.store).InsertNewEntry(entry)
	if err != nil {
		c.Status(500)
		return err
	}
	ent, err := json.Marshal(entry)

	if err != nil {
		c.Status(500)
		return err
	}
	err = c.Send(ent)

	return err
}

func (s *Server) GetLastEntry(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	return err
}

func (s *Server) GetEntriesSince(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	return err
}

func (s *Server) GetAll(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	return err
}

func (s *Server) Start(address string) {
	app := fiber.New()

	app.Post("/add", s.AddEntry)
	app.Get("/last", s.GetLastEntry)
	app.Get("/since/:timestamp", s.GetEntriesSince)
	app.Get("all", s.GetAll)

	err := app.Listen(address)

	if err != nil {
		log.Fatal("cannot server server: ", err)
	}
}

func CreateServer(store *datastore.DataStore, notificationHandler *notifications.NotificationHandler) *Server {
	return &Server{store: store, notifier: notificationHandler}
}
