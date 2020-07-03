import os
import threading
from time import sleep
from subprocess import call
from gpiozero import Button, LED
from signal import pause

dir_path = os.path.dirname(os.path.realpath(__file__))
buttonPin = 5
ledPin6 = 6
ledPin4 = 4

button = Button(buttonPin, hold_time=5)
led6 = LED(ledPin6)
led4 = LED(ledPin4)

startApFile = f'{dir_path}/scripts/start_ap_default.sh'
print("[Info] Reset to ap mode service started...")

def led_blink():
    for num in range(5):
        led6.toggle()
        led4.toggle()
        sleep(0.1)
        led6.toggle()
        led4.toggle()
        sleep(0.1)
        led6.toggle()
        led4.toggle()
        sleep(0.1)
        led6.toggle()
        led4.toggle()
        sleep(0.7)

def exec_wifi():
    print("[Info] reset wifi to access point mode.")
    t = threading.Thread(target=led_blink)
    t.start()
    call(["sudo", "sh", startApFile])

def onButtonPressed():
    print('[Info] Button is pressed.')
    led6.on()
    led4.on()

def onButtonRelease():
    print('[Info] Button is pressed.')
    led6.off()
    led4.off()

button.when_held = exec_wifi
button.when_pressed = onButtonPressed
button.when_released = onButtonRelease

pause()
