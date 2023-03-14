# flutter_demo_apps

This is a repo to showcase some basic demo apps I've done and the published apps I've worked on as a Flutter developer.

## Published apps I've worked on:
### Evenito check-in app
https://play.google.com/store/apps/details?id=com.evenito.checkin

https://apps.apple.com/sa/app/check-in-guestlist-evenito/id1572822238

### Binaris 1001
https://play.google.com/store/apps/details?id=com.mjk.rigy.binary

https://apps.apple.com/us/app/binaris-1001/id1512633108

### Ozonvicc
https://play.google.com/store/apps/details?id=com.mjk.rigy.jokes&hl=en&gl=US

https://apps.apple.com/ro/app/%C3%B6z%C3%B6nvicc/id1479397425

For this one I had to come up with a new design. Here are some samples

<img src="https://user-images.githubusercontent.com/56998879/224573471-890a2e55-16d6-40d7-84b3-fc4aa48005dd.jpg">
<img src="https://user-images.githubusercontent.com/56998879/224573472-eb964326-6f48-499e-b4f9-424ba5461c00.jpg">


# Can't build the project?
If you don't have the environment to run the code, here is a video and some screenshots of what it looks like:

## Video
https://youtu.be/nHoCVeA95nU


### Screenshots
<img src="https://user-images.githubusercontent.com/56998879/224572026-f9db761b-0e2f-4374-aa02-6b4bc5e88092.jpg" width="300">


<img src="https://user-images.githubusercontent.com/56998879/224572027-a025e0be-2b25-4cf8-84c9-30ff04ae3779.jpg" width="300"><img src="https://user-images.githubusercontent.com/56998879/224572028-5e46e511-9d5c-40c5-988d-652d9c333a2e.jpg" width="300"><img src="https://user-images.githubusercontent.com/56998879/224572029-063c9e95-0892-4b3d-97ea-c64fd9fb751e.jpg" width="300">


<img src="https://user-images.githubusercontent.com/56998879/224572031-f5856246-3615-4d83-8e27-641b4f195fe3.jpg" width="300"><img src="https://user-images.githubusercontent.com/56998879/224574204-07051ac3-f7eb-4b21-b964-ee7df7ca0f2b.jpg" width="300"><img src="https://user-images.githubusercontent.com/56998879/224572032-3aa3dad0-99ab-4ad4-bef1-351bfbb687a2.jpg" width="300">

## Things I've done in Flutter
- state management (provider, riverpod, bloc)
- navigaion with GoRouter
- localization (multiple languages for same app)
- basic animations and complex layouts
- testing (mocking, integration tests, UI test)
- rest API, GraphQl, Protobuf with gRPC, pub-sub with mqtt and stomp
- QR code scanner
- Firebase authentication (phone with SMS verification code, Google, Apple, email and pass)
- Google Maps API
- payment method integration (Stripe)
- local DB storage (SQLite)
- publish apps to Google Play and App Store

### Evenito check-in guests app
- add support for offline functionality by storing the data locally in SQLite
- improve performance to prolong battery life

### Binaris puzzle game
- fixed restore purchases
- added support for cloud progress sync to Firestore with account login (Google, Apple or e-mail), register and reset password

### Hyve personal finance app
- built a lot of complex screens and features from scratch with GraphQL integration, Riverpod state management, a lot of forms, pie chrats etc.

### Spare food delivery app
- client (login, profile, adding cards, address, looking through menus, search bars with live update)
- restaurant (add drivers, receive orders, accept/decline them, assign drivers to deliver them)

### dating app
- login with phone and SMS code verification
- user profile with picture, description etc.
- finding friends with live search bar
- sending friend requests, accepting them with pub - sub
- live chat messaging with timestamps and read receipts.
