accessing
color: aValueOrASymbolOrAOneArgBlock
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self colorElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]