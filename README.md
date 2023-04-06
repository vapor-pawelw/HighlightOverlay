# HighlightOverlay

Puts a darker background over your SwiftUI Views with a mask that 
cuts out a hole for your currently selected view.  
  
Selected view can be chosen by specifying an identifier for your view via modifier.  
It is then passed to withHighlightOverlay as a binding.  
  
The view coordinates are then tracked using PreferenceKey to maintain correct
position for the cutout.

Example:  

https://user-images.githubusercontent.com/47155744/230316325-8bf35bde-2a7b-42b3-b26f-bf113fb61661.mov

Black circle has an empty identifier which is used to remove the overlay.  
This example contains an animation for the highlight which can be easily removed if needed.  
