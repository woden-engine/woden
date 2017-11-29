actions
doUnhighlight: element
	(element hasAttribute: self attributeIdentificator)
		ifFalse: [ ^ self ].
	(element attributeAt: self attributeIdentificator) 
		do: [ :el | self doUnhighlightElement: el ].
	element removeAttributeAt: self attributeIdentificator.