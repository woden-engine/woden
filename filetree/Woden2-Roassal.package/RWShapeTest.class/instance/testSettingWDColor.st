tests
testSettingWDColor

	cube color: Color black.
	self assert: (cube colorFor: element) class equals: Color