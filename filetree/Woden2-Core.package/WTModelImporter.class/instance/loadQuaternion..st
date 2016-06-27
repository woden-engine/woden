as yet unclassified
loadQuaternion: quaternionData
	^ WMQuaternionF 
		r: (quaternionData at: 1) asFloat
		i: (quaternionData at: 2) asFloat
		j: (quaternionData at: 3) asFloat
		k: (quaternionData at: 4) asFloat