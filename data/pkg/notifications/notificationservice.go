package notifications

import (
	"github.com/niggelgame/co2-sensor/data/pkg/datastore"
	"log"
	"time"
)

type NotificationService interface {
	Start()

	Stop()
}

type DeviceNotificationService struct {
	handler  *NotificationHandler
	store    datastore.DataStore
	stopChan  chan struct{}
	warnLevel int
}

func (d *DeviceNotificationService) Start() {
	devices, err := d.store.GetNotificationDevices()
	if err != nil {
		log.Println("Failed to get Notification devices!")
		return
	}

	for i := 0; i < len(devices); i++ {
		err = d.handler.SendNotification(devices[i].MessagingToken, "Hello", "Test")
		if err != nil {
			log.Println("Error:", err)
		}
	}

	ticker := time.NewTicker(15 * time.Second)
	for {
		select {
		case <-ticker.C:
			{
				log.Println("Would send messages now if cumulated value is too big")
			}
		case <-d.stopChan:
			{
				ticker.Stop()
				return
			}
		}
	}
}

func (d *DeviceNotificationService) Stop() {
	close(d.stopChan)
}

func CreateDeviceNotificationService(handler *NotificationHandler, store datastore.DataStore, warnLevel int) *DeviceNotificationService {
	return &DeviceNotificationService{
		handler:   handler,
		store:     store,
		stopChan:  make(chan struct{}),
		warnLevel: warnLevel,
	}
}
