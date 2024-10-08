"
A CVTLNonInteractiveUITest is a test class for testing the behavior of CVTLNonInteractiveUI
"
Class {
	#name : #VTLNonInteractiveUITest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #'instance creation' }
VTLNonInteractiveUITest >> newObj [

	^ VTLNonInteractiveUI new
]

{ #category : #tests }
VTLNonInteractiveUITest >> testAddInput [

	| obj |
	obj := self newObj.
	self assert: obj input isCollection.
	self assert: obj input isEmpty.
	obj addInput: 'abc'.
	obj addInput: 'def'.
	self assert: obj input size equals: 2.
	self assert: obj input first equals: 'abc'.
	self assert: obj input second equals: 'def'
]

{ #category : #tests }
VTLNonInteractiveUITest >> testClear [

	| obj |
	obj := self newObj.
	obj putAsciiValue: $a asciiValue.
	obj putAsciiValue: $b asciiValue.
	obj putAsciiValue: $c asciiValue.
	self deny: obj output isEmpty.
	obj clear.
	self assert: obj output isEmpty
]

{ #category : #tests }
VTLNonInteractiveUITest >> testGetAsciiValue [

	| obj r |
	obj := self newObj.
	obj addInput: 'ab'.
	obj addInput: 'cd'.
	r := obj getAsciiValue.
	self assert: r equals: $a asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $b asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: Character cr asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $c asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $d asciiValue
]

{ #category : #tests }
VTLNonInteractiveUITest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	self assert: obj input isCollection.
	self assert: obj input isEmpty
]

{ #category : #tests }
VTLNonInteractiveUITest >> testInput [

	| obj arr |
	obj := self newObj.
	self assert: obj input isCollection.
	self assert: obj input isEmpty.
	arr := #( 1 2 3 ) asOrderedCollection.
	obj input: arr.
	self assert: obj input identicalTo: arr
]

{ #category : #tests }
VTLNonInteractiveUITest >> testOutput [

	| obj arr |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	arr := #( 1 2 3 ) asOrderedCollection.
	obj output: arr.
	self assert: obj output identicalTo: arr
]

{ #category : #tests }
VTLNonInteractiveUITest >> testOutputString [

	| obj |
	obj := self newObj.
	self assert: obj outputString isEmpty.
	obj putAsciiValue: $A asciiValue.
	obj putAsciiValue: $B asciiValue.
	obj putAsciiValue: $C asciiValue.
	obj putAsciiValue: Character cr asciiValue.
	obj putAsciiValue: Character lf asciiValue.
	obj putAsciiValue: $D asciiValue.
	obj putAsciiValue: $E asciiValue.
	obj putAsciiValue: $F asciiValue.
	self assert: obj outputString equals: 'ABC
DEF'
]

{ #category : #tests }
VTLNonInteractiveUITest >> testPutAsciiValue [

	| obj |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	obj putAsciiValue: $A asciiValue.
	obj putAsciiValue: $B asciiValue.
	obj putAsciiValue: $C asciiValue.
	self assert: obj output size equals: 3.
	self assert: obj output first equals: $A asciiValue.
	self assert: obj output second equals: $B asciiValue.
	self assert: obj output third equals: $C asciiValue
]

{ #category : #tests }
VTLNonInteractiveUITest >> testRefresh [

	| obj |
	obj := self newObj.
	obj addInput: 'abc'.
	self deny: obj input isEmpty.
	obj refresh.
	self assert: obj input isEmpty
]
