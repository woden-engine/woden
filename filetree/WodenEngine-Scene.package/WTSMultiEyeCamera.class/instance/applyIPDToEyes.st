projections
applyIPDToEyes
	self assert: eyes size = 2.
	eyes first transform translation: (WMVector3F x: ipd * -0.5).
	eyes second transform translation: (WMVector3F x: ipd * 0.5)