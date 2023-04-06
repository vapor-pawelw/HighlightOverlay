# HighlightOverlay

Puts a darker background over your SwiftUI Views with a mask that 
cuts out a hole for your currently selected view.  
  
Selected view can be chosen by specifying an identifier for your view via modifier.  
It is then passed to withHighlightOverlay as a binding.  
  
The view coordinates are then tracked using PreferenceKey to maintain correct
position for the cutout.
