from subprocess import call
from time import sleep
import os 
import threading
from time import sleep
import time

dir_path = os.path.dirname(os.path.realpath(__file__))
# Note that you have to specify path to script

from gpiozero import Button, LED
from signal import pause


button = Button(5, hold_time=5)
led = LED(4)

file_path = dir_path + "/access-point.js"
print file_path

def led_blink():
    while(True):
        led.toggle()
        sleep(0.2)
        
def exec_wifi():
    t = threading.Thread(target=led_blink)
    t.start()
    call(["node", file_path]) 

button.when_held = exec_wifi
button.when_pressed = led.on
button.when_released = led.off


pause()