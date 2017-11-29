accessing
width: aValueOrASymbolOrAOneArgBlock
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self widthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]