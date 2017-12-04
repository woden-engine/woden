event handling
keySymbolFor: keyValue
	^ KeySymbolMap at: (self keyNameFor: keyValue ) ifAbsent: [ OSK_UNKNOWN ]