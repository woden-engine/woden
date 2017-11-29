as yet unclassified
doExecute: elements
	| angleIncrement angle rad center cos sin |

	elements isEmpty ifTrue: [ ^ self ].
	rad := self computeRadiusFor: elements.
	center := 0 @ 0.
	"center := Point x: rad y: rad."
	angleIncrement := self computeIncrementalAngleFor: elements.
	angle := self initialAngle.
	elements
		do: [ :each | 
			cos := angle cos.
			sin := angle sin.

			angle := angle + angleIncrement.
			each translateToX: rad*cos y: rad*sin z: 0.0 ]