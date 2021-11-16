package http_server

import (
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"github.com/niggelgame/co2-sensor/data/pkg/config"
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"github.com/niggelgame/co2-sensor/data/pkg/models"
	"github.com/niggelgame/co2-sensor/data/pkg/notifications"
	"log"
	"strconv"
	"time"
)

type Server struct {
	store    *datastore.DataStore
	notifier *notifications.NotificationHandler
	fbCfg    *config.FirebaseConfig
}

func (s *Server) AddEntry(c *fiber.Ctx) (err error) {
	var insertEntry models.InsertEntry
	err = json.Unmarshal(c.Body(), &insertEntry)
	if err != nil {
		c.Status(400)
		log.Println("error while parsing json: ", err)
		return err
	}

	entry := models.NewEntry(insertEntry.Value, time.Now().UnixNano())
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
	entry, err := (*s.store).GetLastEntry()
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

func (s *Server) GetCumulatedEntry(c *fiber.Ctx) (err error) {
	entry, err := (*s.store).GetCumulatedEntry()
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

func (s *Server) GetLastSince(c *fiber.Ctx) (err error) {
	cnt := c.Params("count")
	count, err := strconv.ParseInt(cnt, 10, 64)
	if err != nil {
		c.Status(400)
		return err
	}
	entries, err := (*s.store).GetLastEntries(count)
	if err != nil {
		c.Status(500)
		return err
	}

	ent, err := json.Marshal(entries)
	if err != nil {
		c.Status(500)
		return err
	}
	err = c.Send(ent)

	return err
}

func (s *Server) GetEntriesSince(c *fiber.Ctx) (err error) {
	ts := c.Params("timestamp")
	timestamp, err := strconv.ParseInt(ts, 10, 64)
	if err != nil {
		c.Status(400)
		return err
	}
	entries, err := (*s.store).GetEntriesSince(timestamp)
	if err != nil {
		c.Status(500)
		return err
	}

	ent, err := json.Marshal(entries)
	if err != nil {
		c.Status(500)
		return err
	}
	err = c.Send(ent)

	return err
}

func (s *Server) GetAll(c *fiber.Ctx) (err error) {
	entries, err := (*s.store).GetAllEntries()
	if err != nil {
		c.Status(500)
		return err
	}

	ent, err := json.Marshal(entries)
	if err != nil {
		c.Status(500)
		return err
	}
	err = c.Send(ent)

	return err
}

func (s *Server) GetAndroidClientConfig(c *fiber.Ctx) (err error) {
	if s.fbCfg == nil {
		c.Status(404)
		return err
	}
	if s.fbCfg.AppIdAndroid != "" {
		err = c.JSON(config.ReturnFirebaseConfig{
			ApiKey:            s.fbCfg.ApiKey,
			AppId:             s.fbCfg.AppIdAndroid,
			MessagingSenderId: s.fbCfg.MessagingSenderId,
			ProjectId:         s.fbCfg.ProjectId,
		})
	} else {
		c.Status(404)
	}

	return err
}

func (s *Server) GetIosClientConfig(c *fiber.Ctx) (err error) {
	if s.fbCfg == nil {
		c.Status(404)
		return err
	}

	if s.fbCfg.AppIdiOS != "" {
		err = c.JSON(config.ReturnFirebaseConfig{
			ApiKey:            s.fbCfg.ApiKey,
			AppId:             s.fbCfg.AppIdiOS,
			MessagingSenderId: s.fbCfg.MessagingSenderId,
			ProjectId:         s.fbCfg.ProjectId,
		})
	} else {
		c.Status(404)
	}

	return err
}

func (s *Server) GetWebClientConfig(c *fiber.Ctx) (err error) {
	if s.fbCfg == nil {
		c.Status(404)
		return err
	}

	if s.fbCfg.AppIdWeb != "" {
		err = c.JSON(config.ReturnFirebaseConfig{
			ApiKey:            s.fbCfg.ApiKey,
			AppId:             s.fbCfg.AppIdWeb,
			MessagingSenderId: s.fbCfg.MessagingSenderId,
			ProjectId:         s.fbCfg.ProjectId,
		})
	} else {
		c.Status(404)
	}

	return err
}

func (s *Server) RegisterMessagingClient(c *fiber.Ctx) (err error) {
	var insertNotification models.NotificationsDevice
	err = json.Unmarshal(c.Body(), &insertNotification)
	if err != nil {
		c.Status(400)
		log.Println("error while parsing json: ", err)
		return err
	}

	err = (*s.store).RegisterMessaging(&insertNotification)
	if err != nil {
		c.Status(500)
		return err
	}

	return err
}

func (s *Server) UnregisterMessagingClient(c *fiber.Ctx) (err error) {
	var insertNotification models.NotificationsDevice
	err = json.Unmarshal(c.Body(), &insertNotification)
	if err != nil {
		c.Status(400)
		log.Println("error while parsing json: ", err)
		return err
	}

	err = (*s.store).UnregisterMessaging(&insertNotification)
	if err != nil {
		c.Status(500)
		return err
	}

	return err
}

func (s *Server) Start(address string) {
	app := fiber.New()

	app.Post("/add", s.AddEntry)
	app.Get("/last", s.GetLastEntry)
	app.Get("/last/:count", s.GetLastSince)
	app.Get("/cumulated", s.GetCumulatedEntry)
	app.Get("/since/:timestamp", s.GetEntriesSince)
	app.Get("all", s.GetAll)

	messagingApi := app.Group("/messaging")
	messagingConfigApi := messagingApi.Group("/config")
	messagingConfigApi.Get("/android", s.GetAndroidClientConfig)
	messagingConfigApi.Get("/ios", s.GetIosClientConfig)
	messagingConfigApi.Get("/web", s.GetWebClientConfig)
	messagingApi.Post("/register", s.RegisterMessagingClient)
	messagingApi.Post("/unregister", s.UnregisterMessagingClient)

	err := app.Listen(address)

	if err != nil {
		log.Fatal("cannot server server: ", err)
	}
}

func CreateServer(store *datastore.DataStore, notificationHandler *notifications.NotificationHandler, fbCfg *config.FirebaseConfig) *Server {
	return &Server{store: store, notifier: notificationHandler, fbCfg: fbCfg}
}
