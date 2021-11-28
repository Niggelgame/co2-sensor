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
	lastWasWarn bool
}

func (d *DeviceNotificationService) Start() {
	d.sendWarnToAll()

	ticker := time.NewTicker(15 * time.Second)
	for {
		select {
		case <-ticker.C:
			{
				entry, err := d.store.GetCumulatedEntry()
				if err != nil {
					continue
				}
				if entry.Value >= d.warnLevel {
					if d.lastWasWarn {
						continue
					}
					d.lastWasWarn = true
					d.sendWarnToAll()
				} else {
					d.lastWasWarn = false
				}
			}
		case <-d.stopChan:
			{
				ticker.Stop()
				return
			}
		}
	}
}

func (d *DeviceNotificationService) sendWarnToAll()  {
	devices, err := d.store.GetNotificationDevices()
	if err != nil {
		log.Println("Failed to get Notification devices!")
		return
	}

	for i := 0; i < len(devices); i++ {
		err = d.handler.SendNotification(devices[i].MessagingToken, "⚠️ CO2 Warning! ⚠️", "Your CO2 Sensor measured critical values. Please check the room.")
		if err != nil {
			log.Println("Error:", err)
			if err.Error() == "Requested entity was not found." {
				log.Println("Remove now unregistered token from DB")
				err = d.store.UnregisterMessaging(devices[i])
			}
			if err != nil {
				log.Println("Failed to delete device from list.")
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
