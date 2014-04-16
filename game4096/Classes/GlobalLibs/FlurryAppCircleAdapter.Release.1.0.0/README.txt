====================================================================
Flurry Ad Network Adapter for Google AdMob Ads Mediation SDK for iOS
====================================================================

This is an adapter to be used in conjunction with the Google AdMob 
Ads Mediation SDK for iOS.

Requirements:
- A Mediation ID
- Xcode 4.4.1 or later
- Runtime of iOS 3.0 or later
- Associated Ad Network SDK

Instructions:
- Add the included binary (libAdapterSDKFlurryAppCircle.a library) into your XCode project with 
its associated Flurry Ad Network SDKs: libFlurry.a and libFlurryAds.a from https://dev.flurry.com
- Configure ad spaces on you Flurry AppCircle account
- Enable the Flurry Ad network in the AdMob Ad Network Mediation UI with your Flurry Publisher ID and Ad Name Space that corresponds to AdMob ad placement
- Make ad requests normally using the AdMob SDK using the mediation ID for the placement. 

The latest documentation and code samples for the AdMob SDK are available at:
https://developers.google.com/mobile-ads-sdk/docs/

