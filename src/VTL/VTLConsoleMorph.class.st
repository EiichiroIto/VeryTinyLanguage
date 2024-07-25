Class {
	#name : #VTLConsoleMorph,
	#superclass : #Morph,
	#instVars : [
		'font',
		'charExtent',
		'screen',
		'screenSize',
		'cursor',
		'whenKeyPressed'
	],
	#category : #'VTL-UI'
}

{ #category : #accessing }
VTLConsoleMorph >> charExtent [

	^ charExtent
]

{ #category : #accessing }
VTLConsoleMorph >> charExtent: anObject [

	charExtent := anObject
]

{ #category : #private }
VTLConsoleMorph >> characterAt: aPoint [

	| line |
	(self withinScreen: aPoint) ifFalse: [ ^ Character space ].
	line := screen at: aPoint y + 1.
	aPoint x >= line size ifTrue: [ ^ Character space ].
	^ line at: aPoint x + 1
]

{ #category : #private }
VTLConsoleMorph >> characterAt: aPoint put: aCharacter [

	| line |
	(self withinScreen: aPoint) ifFalse: [ ^ self ].
	line := screen at: aPoint y + 1.
	line := aPoint x >= line size
		        ifTrue: [ 
		        line , (String new: aPoint x - line size withAll: Character space)
		        , aCharacter asString ]
		        ifFalse: [ 
			        (line copyFrom: 1 to: aPoint x) , aCharacter asString
			        , (line copyFrom: aPoint x + 2 to: line size) ].
	screen at: aPoint y + 1 put: line
]

{ #category : #api }
VTLConsoleMorph >> clearScreen [

	screen := Array new: screenSize y withAll: ''.
	cursor := 0 @ 0
]

{ #category : #private }
VTLConsoleMorph >> currentLine [
	^ screen at: cursor y + 1
]

{ #category : #private }
VTLConsoleMorph >> currentLine: aString [
	screen at: cursor y + 1 put: aString
]

{ #category : #accessing }
VTLConsoleMorph >> cursor [

	^ cursor
]

{ #category : #accessing }
VTLConsoleMorph >> cursor: anObject [

	cursor := anObject
]

{ #category : #private }
VTLConsoleMorph >> defaultFont [
	^ StandardFonts codeFont
]

{ #category : #private }
VTLConsoleMorph >> defaultScreenSize [
	^ 80 @ 25
]

{ #category : #drawing }
VTLConsoleMorph >> drawCursorOn: aCanvas [

	| pos c |
	c := self characterAt: cursor.
	pos := self topLeft + (cursor * charExtent).
	aCanvas fillRectangle: (pos extent: charExtent) color: self textColor.
	aCanvas
		drawString: c asString
		at: pos
		font: font
		color: self color
]

{ #category : #drawing }
VTLConsoleMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	self drawScreenOn: aCanvas.
	self drawCursorOn: aCanvas
]

{ #category : #drawing }
VTLConsoleMorph >> drawScreenOn: aCanvas [

	| pos |
	pos := self topLeft.
	screen do: [ :each | 
		aCanvas
			drawString: each
			at: pos
			font: font
			color: self textColor.
		pos := pos x @ (pos y + charExtent y) ]
]

{ #category : #geometry }
VTLConsoleMorph >> extent: aPoint [

	| old |
	old := self extent.
	super extent: aPoint.
	aPoint = old ifTrue: [ ^ self ].
	screenSize := aPoint // charExtent.
	self clearScreen
]

{ #category : #accessing }
VTLConsoleMorph >> font [

	^ font
]

{ #category : #accessing }
VTLConsoleMorph >> font: anObject [

	font := anObject.
	self updateCharExtent.
	self updateExtent
]

{ #category : #api }
VTLConsoleMorph >> goto: aPoint [

	(self withinScreen: aPoint) ifFalse: [ ^ cursor := 0 @ 0 ].
	cursor := aPoint
]

{ #category : #'event handling' }
VTLConsoleMorph >> handlesKeyboard: evt [

	^ true
]

{ #category : #'event handling' }
VTLConsoleMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #initialization }
VTLConsoleMorph >> initialize [
	super initialize.
	self color: Color black.
	screenSize := self defaultScreenSize.
	self clearScreen.
	font := self defaultFont.
	self updateCharExtent.
	self updateExtent
]

{ #category : #'event handling' }
VTLConsoleMorph >> keyDown: event [

	| c |
	c := event keyCharacter asciiValue.
	(#( 8 13 ) includes: c) ifFalse: [ ^ self ].
	whenKeyPressed ifNotNil: [ 
		whenKeyPressed value: event keyCharacter asciiValue ]
]

{ #category : #'event handling' }
VTLConsoleMorph >> keyStroke: event [

	whenKeyPressed ifNotNil: [ 
		whenKeyPressed value: event keyCharacter asciiValue ]
]

{ #category : #'event handling' }
VTLConsoleMorph >> mouseDown: evt [

	self activeHand newKeyboardFocus: self
]

{ #category : #private }
VTLConsoleMorph >> newLine [

	| line |
	(self withinScreen: cursor) ifFalse: [ ^ self ].
	line := self currentLine.
	line := line copyFrom: 1 to: cursor x.
	self currentLine: line.
	cursor := 0 @ (cursor y + 1).
	cursor y < screenSize y ifTrue: [ ^ self ].
	self scroll: 1.
	cursor := 0 @ (screenSize y - 1)
]

{ #category : #api }
VTLConsoleMorph >> put: aString [

	aString do: [ :each | 
		(each = Character lf or: [ each = Character cr ])
			ifTrue: [ self newLine ]
			ifFalse: [ self putChar: each ] ]
]

{ #category : #api }
VTLConsoleMorph >> putAsciiValue: anInteger [

	anInteger = Character lf asciiValue ifTrue: [ ^ self ].
	anInteger = Character cr asciiValue ifTrue: [ 
		self newLine.
		^ self changed ].
	anInteger = Character backspace asciiValue ifTrue: [ 
		cursor x > 0 ifTrue: [ self goto: cursor x - 1 @ cursor y ].
		^ self changed ].
	self putChar: (Character value: anInteger).
	self changed
]

{ #category : #private }
VTLConsoleMorph >> putChar: aCharacter [

	self characterAt: cursor put: aCharacter.
	cursor := cursor + (1 @ 0).
	(self withinScreen: cursor) ifTrue: [ ^ self ].
	cursor x >= screenSize x ifTrue: [ cursor := 0 @ (cursor y + 1) ].
	cursor y < screenSize y ifTrue: [ ^ self ].
	self scroll: 1.
	cursor := 0 @ (screenSize y - 1)
]

{ #category : #accessing }
VTLConsoleMorph >> screen [

	^ screen
]

{ #category : #accessing }
VTLConsoleMorph >> screen: anObject [

	screen := anObject
]

{ #category : #accessing }
VTLConsoleMorph >> screenSize [

	^ screenSize
]

{ #category : #accessing }
VTLConsoleMorph >> screenSize: anObject [

	screenSize := anObject.
	self clearScreen.
	self updateExtent
]

{ #category : #private }
VTLConsoleMorph >> scroll: anInteger [

	anInteger >= screenSize y ifTrue: [ ^ self clearScreen ].
	screen := (screen
		           copyFrom: screen size - (screenSize y - anInteger - 1)
		           to: screen size) , (Array new: anInteger withAll: '')
]

{ #category : #private }
VTLConsoleMorph >> textColor [
	^ Color green
]

{ #category : #private }
VTLConsoleMorph >> updateCharExtent [
	charExtent := (font linearWidthOf: $M) @ font height
]

{ #category : #private }
VTLConsoleMorph >> updateExtent [

	super extent: screenSize * charExtent
]

{ #category : #accessing }
VTLConsoleMorph >> whenKeyPressed [

	^ whenKeyPressed
]

{ #category : #accessing }
VTLConsoleMorph >> whenKeyPressed: anObject [

	whenKeyPressed := anObject
]

{ #category : #testing }
VTLConsoleMorph >> withinScreen: aPoint [

	^ aPoint >= (0 @ 0) and: [ aPoint < screenSize ]
]
