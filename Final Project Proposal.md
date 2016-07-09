# Proposal: Odysseus - A traveler's diary
## Author: Jiayu Huang, Zhengri Fan
### Introduction:
Our application is called Odysseus because we want to build a tool for our users to record their adventures like what Odysseus did. The application will be a travel diary that can record users location data along with their story. Our users are able to organize their diary not only on a timeline but also spatially, on a map. Also, they are able to view their diary either on a table or on a map. The highlight of our diary application is that it on one hand, save our stories like traditional diary according to time, but on the other hand, visualize our story spatially on a map. Our target users are those who love traveling and want to record their path.

### High Level Description:
See Our Design Graph

### iOS feature usage
- **Location manager**, to record users’ locations while they are taking notes
- **Mapkit**, to display a map for users such that they can view places that they have gone and can access their notes directly on the map.
- **Core data**, for storing user’s notes and locations, which may work together with cache to speed up the performance
- **TabView Controller**, to navigate the user through our main functionalities.
- TableView Controller, to display all the notes in lists and perform settings.
- Navigation Controller, to navigate from the collection of notes to the actual note taking views back and forth.
- TextView, for the user to take actual notes
- **Map Annotation**, to mark pins on the map indicating that the user had taken maps in that place.
- **Multimedia(partially optional)**, including recordings(AVFoundation), images and videos(UIImagePickerController) (optional), so that users can incorporate more than simple words
- **iCloud(optional)**, for which users can switch to different devices and having their notes and locations synchronized.
- **External visualization packages(optional)** (TBD), such that we could have some interesting facts about the traveler displayed by graphs.



### Targeted iOS devices:
Our targeted devices, so far, is all iOS devices that are currently supported by Apple. However, we do feel necessary that the old, 3.5-inch devices may not be included based on that fact that, only one 3.5-inch device is still supported by Apple, and its limited screen size do make it difficult for users to interact with our app, especially when we have a map on the screen. 

![High Level Description](./design.PNG) 


