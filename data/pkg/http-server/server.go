package http_server

import (
	"github.com/gofiber/fiber/v2"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"log"
)

type Server struct {
	store *datastore.DataStore
}

func (s *Server) AddEntry(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	return err
}

func (s *Server) GetLastEntry(c *fiber.Ctx) (err error) {
	err = c.SendString("Hello")

	return err
}

func (s *Server) Start(address string) {
	app := fiber.New()

	app.Post("/add", s.AddEntry)
	app.Get("/last", s.GetLastEntry)

	err := app.Listen(address)

	if err != nil {
		log.Fatal("cannot server server: ", err)
	}
}

func CreateServer(store *datastore.DataStore) *Server {
	return &Server{store: store}
}