coloring
if: conditionBlock color: colorBlock
	| oldBlockOrValue |
	oldBlockOrValue := self color.
	^self color: [ :aModel | (conditionBlock rtValue: aModel)
									ifTrue: [ colorBlock rtValue: aModel ] 
									ifFalse: [ 
										oldBlockOrValue rtValue: (RTElement on: aModel) ]].
							
						