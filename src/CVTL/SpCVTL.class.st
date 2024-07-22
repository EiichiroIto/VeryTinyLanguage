Class {
	#name : #SpCVTL,
	#superclass : #SpPresenter,
	#instVars : [
		'cvtl',
		'menu',
		'buttonBreak',
		'buttonSave',
		'labelStatus',
		'ui',
		'output',
		'buttonLoad',
		'process',
		'inputQueue'
	],
	#category : #'CVTL-UI'
}

{ #category : #'world menu' }
SpCVTL class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'CVTL')
		parent: #Tools;
		order: 900;
		target: self;
		action: [ self new open ]
]

{ #category : #'instance creation' }
SpCVTL class >> open [

	<script>
	self new open
]

{ #category : #constants }
SpCVTL >> appName [

	^ 'Very Tiny Language'
]

{ #category : #constants }
SpCVTL >> appText [

	^ self appName , ' ' , self appVersion , String cr , String cr
	  , 'Copyright © 2024 Eiichiro Ito (EiichiroIto@gmail.com)'
	  , String cr , 'All rights reserved.'
]

{ #category : #constants }
SpCVTL >> appVersion [

	^ '0.0.1'
]

{ #category : #process }
SpCVTL >> breakProcess [

	
]

{ #category : #initialization }
SpCVTL >> connectPresenters [

	buttonBreak action: [ self breakProcess ].
	buttonLoad action: [ self loadFile ].
	buttonSave action: [ self saveFile ].
	output morph whenKeyPressed: [ :c | self keyPressed: c ]
]

{ #category : #accessing }
SpCVTL >> cvtl [

	^ cvtl
]

{ #category : #accessing }
SpCVTL >> cvtl: anObject [

	cvtl := anObject
]

{ #category : #layout }
SpCVTL >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #menu expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: #buttonLoad;
				   add: #buttonSave;
				   add: #buttonBreak;
				   yourself)
		  withConstraints: [ :c | c height: self class buttonHeight ];
		  add: #output;
		  add: (SpBoxLayout newHorizontal
				   "add: #timer width: 5;"
				   add: #labelStatus;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #constants }
SpCVTL >> defaultRandomSeed [

	^ 12345
]

{ #category : #process }
SpCVTL >> executionLoop [

	[ 
	cvtl doOneCycle.
	(Delay forMilliseconds: 100) wait ] repeat
]

{ #category : #initialization }
SpCVTL >> fileMenu [

	| m |
	m := self newMenu.
	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'Load';
					action: [ self loadFile ] ];
			addItem: [ :item | 
				item
					name: 'Save';
					action: [ self saveFile ] ].
		grp
			addItem: [ :item | 
				item
					name: 'Close';
					action: [ application closeAllWindows ] ];
			addItem: [ :item | 
				item
					name: 'Quit';
					action: [ application quit ] ] ].
	^ m
]

{ #category : #accessing }
SpCVTL >> getAsciiValue [

	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	process ifNil: [ ^ nil ].
	process suspend.
	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	self error
]

{ #category : #initialization }
SpCVTL >> helpMenu [

	^ self newMenu
		  addItem: [ :item | 
			  item
				  name: 'About ' , self appName;
				  action: [ owner window showAbout ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect';
				  action: [ self inspect ] ];
		  yourself
]

{ #category : #constants }
SpCVTL >> initialExtent [

	^ 660 @ 500
]

{ #category : #initialization }
SpCVTL >> initialize [

	cvtl := self newCVTL.
	self setupFor: cvtl.
	inputQueue := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
SpCVTL >> initializePresenters [

	menu := self newMenuBar.
	buttonLoad := self newButton
		              help: 'Load program';
		              label: 'Load';
		              icon: (self iconNamed: #glamorousOpen);
		              yourself.
	buttonSave := self newButton
		              help: 'Save program';
		              label: 'Save';
		              icon: (self iconNamed: #glamorousSave);
		              yourself.
	buttonBreak := self newButton
		               help: 'Stop program';
		               label: 'Stop';
		               icon: (self iconNamed: #stop);
		               yourself.
	output := self newMorph
		          morph: self newConsoleMorph;
		          yourself.
	labelStatus := self newLabel
		               label: 'Status';
		               yourself.
	self setupMenu
]

{ #category : #initialization }
SpCVTL >> initializeWindow: aWindow [

	aWindow
		whenClosedDo: [ self stopProcess ];
		whenOpenedDo: [ 
			output takeKeyboardFocus.
			self startProcess ];
		initialExtent: self initialExtent;
		title: self appName;
		aboutText: self appText
]

{ #category : #accessing }
SpCVTL >> inputQueue [

	^ inputQueue
]

{ #category : #accessing }
SpCVTL >> inputQueue: anObject [

	inputQueue := anObject
]

{ #category : #process }
SpCVTL >> keyPressed: anInteger [

	anInteger = 0 ifTrue: [ ^ self ].
	inputQueue add: anInteger.
	process ifNil: [ ^ self ].
	process isSuspended ifFalse: [ ^ self ].
	process resume
]

{ #category : #'menu actions' }
SpCVTL >> loadFile [

	self shouldBeImplemented
]

{ #category : #constants }
SpCVTL >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
SpCVTL >> newCVTL [

	^ CVTL new
]

{ #category : #'instance creation' }
SpCVTL >> newConsoleMorph [

	^ CVTLConsoleMorph new
]

{ #category : #'instance creation' }
SpCVTL >> newMemory: anInteger [

	^ CVTLMemory new
		  allocate: anInteger;
		  yourself
]

{ #category : #accessing }
SpCVTL >> output [

	^ output
]

{ #category : #accessing }
SpCVTL >> output: anObject [

	output := anObject
]

{ #category : #accessing }
SpCVTL >> process [

	^ process
]

{ #category : #accessing }
SpCVTL >> process: anObject [

	process := anObject
]

{ #category : #accessing }
SpCVTL >> putAsciiValue: anInteger [

	output morph putAsciiValue: anInteger
]

{ #category : #'menu actions' }
SpCVTL >> saveFile [

	self shouldBeImplemented
]

{ #category : #initialization }
SpCVTL >> setupFor: aCVTL [

	| memory |
	memory := self newMemory: self memorySize.
	aCVTL memory: memory.
	aCVTL memoryLimit: self memorySize.
	aCVTL boundary: aCVTL programAddress.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed.
	aCVTL ui: self
]

{ #category : #initialization }
SpCVTL >> setupMenu [

	menu
		addItem: [ :item | 
			item
				name: 'File';
				subMenu: self fileMenu ];
		addItem: [ :item | 
			item
				name: 'Help';
				subMenu: self helpMenu ]
]

{ #category : #process }
SpCVTL >> startProcess [

	self stopProcess.
	process := [ 
	           self executionLoop.
	           process := nil ] fork
]

{ #category : #process }
SpCVTL >> stopProcess [

	process ifNil: [ ^ self ].
	process terminate.
	process := nil
]
