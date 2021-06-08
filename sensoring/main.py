import time
import RPi.GPIO as GPIO


# exception
class GPIO_Edge_Timeout(Exception):
  pass

def read_from_pwm(gpio=12, range=5000):
  CYCLE_START_HIGHT_TIME = 2
  TIMEOUT = 2000 # must be larger than PWM cycle time.

  GPIO.setmode(GPIO.BCM)
  GPIO.setup(gpio,GPIO.IN)

  # wait falling ¯¯|_ to see end of last cycle
  channel = GPIO.wait_for_edge(gpio, GPIO.FALLING, timeout=TIMEOUT)
  if channel is None:
    raise GPIO_Edge_Timeout("gpio {} edge timeout".format(gpio))

  # wait rising __|¯ to catch the start of this cycle
  channel = GPIO.wait_for_edge(gpio,GPIO.RISING, timeout=TIMEOUT)
  if channel is None:
    raise GPIO_Edge_Timeout("gpio {} edge timeout".format(gpio))
  else:
    rising = time.time() * 1000

  # wait falling ¯¯|_ again to catch the end of TH duration
  channel = GPIO.wait_for_edge(gpio, GPIO.FALLING, timeout=TIMEOUT)
  if channel is None:
    raise GPIO_Edge_Timeout("gpio {} edge timeout".format(gpio))
  else:
    falling = time.time() * 1000

  return {'co2': int(falling -rising - CYCLE_START_HIGHT_TIME) / 2 *(range/500)}


if __name__ == "__main__":
    while True:
        print("Reading PWM")
        read_from_pwm()