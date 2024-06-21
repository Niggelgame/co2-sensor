# Notes during development

https://github.com/Lomray-Software/homebridge-co2-level#readme


`./volumes/homebridge/config.json`

```json
{
    "accessories": [
        {
            "accessory": "co2-level",
            "name": "co2-spuele",
            "axiosConfig": {
                "url": "http://localhost:8000/last",
                "method": "GET",
                "timeout": 3000
            },
            "valuePath": "data.value",
            "calculate": "none",
            "interval": 20,
            "threshold": 1000
        }
    ]
}
```
## `chmod +x start.sh`
## Put `co2.service` to `/lib/systemd/system/`

```bash
sudo systemctl daemon-reload 
sudo systemctl enable co2.service 
sudo systemctl start co2.service 
# Info
sudo systemctl status co2.service 
```



# Raspi OS lite 32 bit
https://docs.docker.com/engine/install/raspberry-pi-os/

--> ssh-copy-id -i <file> pi@<ip>
