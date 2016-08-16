tests
testSettingWDColor

	cube color: WDColor black.
	self assert: (cube colorFor: element) class equals: WDColor