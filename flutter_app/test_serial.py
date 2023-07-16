import serial
import time

ser = serial.Serial('/dev/cu.usbserial-10', 9600)

while True:
    print(ser.read())
    time.sleep(1)

