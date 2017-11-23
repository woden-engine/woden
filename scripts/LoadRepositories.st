"Load Lowtalk"
Metacello new
  baseline: 'Lowtalk';
  repository: 'filetree://lowtalk/filetree';
  load.

"Load Woden 2"
"FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
  baseline: 'Woden2';
  repository: 'filetree://filetree';
  load.
"

"Save the image"
(Smalltalk saveAs: 'woden2')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
