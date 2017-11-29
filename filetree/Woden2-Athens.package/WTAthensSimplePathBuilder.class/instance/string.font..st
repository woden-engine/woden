path commands
string: aString font: aFont
	self addSegment: (WTAthensTextSegment new string: aString; font: aFont; endPoint: lastSegment endPoint)