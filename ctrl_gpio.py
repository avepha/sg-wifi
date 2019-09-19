import os
import threading
from time import sleep
from subprocess import call
from gpiozero import Button, LED
from signal import pause

dir_path = os.path.dirname(os.path.realpath(__file__))
buttonPin = 5
ledPin = 6

button = Button(buttonPin, hold_time=5)
led = LED(ledPin)

startApFile = f'{dir_path}/src/scripts/start_ap.sh'
print("[Info] Reset to ap mode service started...")

def led_blink():
    for num in range(5):
        led.toggle()
        sleep(0.1)
        led.toggle()
        sleep(0.1)
        led.toggle()
        sleep(0.1)
        led.toggle()
        sleep(0.7)

def exec_wifi():
    print("[Info] reset wifi to access point mode.")
    t = threading.Thread(target=led_blink)
    t.start()
    call(["sudo", "sh", startApFile])

def onButtonPressed():
    print('[Info] Button is pressed.')
    led.on()

def onButtonRelease():
    print('[Info] Button is pressed.')
    led.off()

button.when_held = exec_wifi
button.when_pressed = onButtonPressed
button.when_released = onButtonRelease

pause()
