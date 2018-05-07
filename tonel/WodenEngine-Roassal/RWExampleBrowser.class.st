Class {
	#name : #RWExampleBrowser,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-Examples'
}

{ #category : #menu }
RWExampleBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	((aBuilder item: #Roassal3d) icon: RTIcon smallRoassal)
	withSeparatorAfter;
	with: [
		(aBuilder item: #'Roassal 3D Examples')
			order: 0.1; 
			parent: #Roassal3d;
			label: 'Roassal 3D examples';
			icon: self smallRoassal;
			action: [ self new open ] ]
]

{ #category : #icon }
RWExampleBrowser class >> mimeDecodeToBytes: stream [
	^ Base64MimeConverter mimeDecodeToBytes: stream.
]

{ #category : #icon }
RWExampleBrowser class >> smallRoassal [
	"Private - Generated method"
	^  Form fromBinaryStream: (self mimeDecodeToBytes: self smallRoassalContents readStream)
]

{ #category : #menu }
RWExampleBrowser class >> smallRoassalContents [
	"Private - Method generated with the content of the file C:\Users\azazael\Documents\smalltalk\inti\moose\roassalWithTransparent.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAAAoAAAASCAYAAABit09LAAABLElEQVR4XmP4//8/w38iMFGK
aK1wWo/Z/8Tgiv86UhP+a0vX/9eRbvuvLbnyv57U1P8zek2givoFgArmAvFSoKKS/1N7pf5P
6xX7P7XHCaj4zv/EiEKIQh2pLqCgNxCHACX+/58xkQtuk7bkGaB4JYQztVfh//nzjECBnP/a
Umf+z+oTAooZ/teTbgA6J+//qaPSCDeePsYJFGwFmj7jv4F0E1DDrP9W8oX/Tx0TRfeMzn8d
yTVAT3j/15WqBiq8+j80lBnT11N7goHuOf1/2kTu//Nni/031egCalz1//Rx9v9XTjEiKwS6
T/ICmH3lCsP/7CQHoKlf/ieGRP/PCndCKNSRnAzE+1ACWk/GAyh28r+udAFC0EwvDBheYYRj
ZsEC5v+nTjENwtQDAHm03ZBoT2X8AAAAAElFTkSuQmCC'
]

{ #category : #'instance creation' }
RWExampleBrowser >> open [
	| pager |
	pager := GLMPager new.
	pager title: 'Roassal 3d examples browser'.
	pager showFirst: [ :a | a list format: #label ].
	pager show: [ :a :each |
			a title: [ GTInspector new printObjectAsAnItem: each ].
			a dynamicActions: [ :aPresentation | 
				each gtInspectorActions asOrderedCollection ].
			a dynamic 
				display: [ :x | 
					(GLMCompositePresentation new with: [:d | 
						each 
							gtInspectorPresentationsIn: d 
							inContext: pager ])
							startOn: x ] ].
	pager openOn: (RWAbstractExample allSubclasses collect: #new)
]
