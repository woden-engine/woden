accessing
depth: aValueOrASymbolOrAOneArgBlock
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self depthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]