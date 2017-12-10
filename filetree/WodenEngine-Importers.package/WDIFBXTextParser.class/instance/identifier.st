accessing
identifier
	^ super identifier ==> [ :token | token inputValue asSymbol ]