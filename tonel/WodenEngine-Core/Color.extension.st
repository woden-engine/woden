Extension { #name : #Color }

{ #category : #'*WodenEngine-Core' }
Color >> asVisualizationColor [
	^ self
]

{ #category : #'*WodenEngine-Core' }
Color class >> forSplattingElements: elements [
	| sum |
	sum := elements sum.
	^ Color r: elements second / sum g: elements third / sum b: elements fourth / sum alpha: elements fifth / sum
]

{ #category : #'*WodenEngine-Core' }
Color >> linearRampMultiply: factor [
	^ Color
		r: self red * factor
		g: self green * factor
		b: self blue * factor
		alpha: self alpha * factor
]

{ #category : #'*WodenEngine-Core' }
Color >> resultForLinearInterpolation [
	^ Color r: self red encodeSRGBComponent g: self green encodeSRGBComponent b: self blue encodeSRGBComponent alpha: self alpha
]

{ #category : #'*WodenEngine-Core' }
Color >> valueForLinearInterpolation [
	^ Color r: self red decodeSRGBComponent g: self green decodeSRGBComponent b: self blue decodeSRGBComponent alpha: self alpha
]
