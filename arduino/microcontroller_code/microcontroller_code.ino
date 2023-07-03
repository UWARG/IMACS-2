#include <mavlink.h>

void setup() {
  Serial.begin(57600);
}

void loop() {
  // Create a MAVLink message buffer
  mavlink_message_t msg;
  uint8_t buf[MAVLINK_MAX_PACKET_LEN];

  // Create a MAVLink heartbeat message
  mavlink_msg_heartbeat_pack(1, 200, &msg, MAV_TYPE_GENERIC, MAV_AUTOPILOT_INVALID, 0, 0, 0);

  // Serialize the MAVLink message
  uint16_t len = mavlink_msg_to_send_buffer(buf, &msg);

  // Send the MAVLink message through the serial port
  for (uint16_t i = 0; i < len; i++) {
    Serial.write(buf[i]);
  }
  // Wait for a second
  delay(1000);
}





// const int analogPin = A0; 

// void setup() {
//   Serial.begin(9600);
// }

// void loop() {
//   int sensorValue = analogRead(analogPin);

//   Serial.println(sensorValue);  
//   delay(20);
// }
