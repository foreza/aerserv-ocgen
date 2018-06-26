# aerserv-ocgen

An example application in Swift using AerServ's IOS SDK.
This is a test application that serves as an example to propsective application developers and publishers that utilizes the latest features available in the IOS SDK.

Our latest SDK release can be always found here:
https://support.aerserv.com/hc/en-us/articles/204160170?_ga=2.21998267.1484224923.1529941710-96493196.1526683480


This application currently implements the following functions:

## Show an interstitial (tab 2)

On the 2nd tab of the application, we demonstrate how an interstitial is preloaded, and then shown.

## Show simple banner ad placement 

On the 1st tab and 4th tab of the application, a banner is shown with a sample placement.

## Show a 'rewarded' interstitial (tab 2) that can be used for in-app rewards/store implementations

On the 2nd tab, the interstitial that is loaded will additionally award virtual currency. This virtual currency is tracked in a singleton class that demonstrates an example of what you could do with it. 

## Show placements under heavy UI activity (drawing once per frame)

To emphasize how important leaving the main queue free is, the 4th tab implements a banner / interstitial along with a sample monster class that is implemented and then drawn on this view tav. If your implementation eats up a major portion of the queue, the sprite may freeze or drop frames, which indicates you need to delegate your functions to the background accordingly.

