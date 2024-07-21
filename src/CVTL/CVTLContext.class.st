Class {
	#name : #CVTLContext,
	#superclass : #Object,
	#instVars : [
		'pos'
	],
	#category : #'CVTL-Core'
}

{ #category : #accessing }
CVTLContext class >> pos: anInteger [

	^ self new
		  pos: anInteger;
		  yourself
]

{ #category : #accessing }
CVTLContext >> decrementPos [

	pos := pos - 1
]

{ #category : #accessing }
CVTLContext >> incrementPos [

	pos := pos + 1
]

{ #category : #accessing }
CVTLContext >> pos [

	^ pos
]

{ #category : #accessing }
CVTLContext >> pos: anObject [

	pos := anObject
]
