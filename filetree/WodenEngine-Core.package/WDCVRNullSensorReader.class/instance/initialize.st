session management
initialize
	super initialize.
	nullState := WDCVRSensorState new
		orientation: WMQuaternionF identity;
		translation: WMVector3F new.