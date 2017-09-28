session management
initialize
	super initialize.
	nullState := WTVRSensorState new
		orientation: WMQuaternionF identity;
		translation: WMVector3F new.