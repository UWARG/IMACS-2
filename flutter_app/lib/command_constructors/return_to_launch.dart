import 'package:dart_mavlink/dialects/common.dart';

// Construction of MissionItem
// targetSystem is the ID of the drone / vehicle (default is 1 for single drones) 
// targetComponent ngl no clue what this does
// seq is what order this command should be executed
// frame is something to do with its currentl cords 
// command is the command id of the return to launch (default is 20)
// current the 1 sets this task to the highest priority 
// autocontinous just sets this mission to automatically continue
// no clue what the params are
// x,y,z are the latitude, longitude, and altitude where the altitude is defaulted to 15
// missionType 0 means it is a normal mission


MissionItem returnToLaunch(int sequence, int systemID, int componentID,
    double latitude, double longitude,
    {double altitude = 15,
    double param1 = 0,
    double param2 = 0,
    double param3 = 0,
    double param4 = 0}) {
  var missionItem = MissionItem(
      targetSystem: systemID,
      targetComponent: componentID,
      seq: sequence,
      frame: mavFrameGlobalRelativeAlt,
      command: mavCmdNavReturnToLaunch,
      current: 1,
      autocontinue: 1,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      x: latitude,
      y: longitude,
      z: altitude,
      missionType: 0);
  return missionItem;
}
