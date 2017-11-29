as yet unclassified
renderIn: aView
	self datasetComputeMinAndMax.
	self defineAxesIfNecessary.
	self homogenizeMinAndMax.
	self renderAxis.
"	self renderAllDecoratorsInFront."
	self renderDataSetsIn: aView.
"	self renderAllDecoratorsBehind"