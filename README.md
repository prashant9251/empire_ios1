# storage_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# steps

flutter create storage_app
cd storage_app
amplify configure

- enter
- ap-south-1
- enter
- <Access Key>
- <Secret Access Key>
- <Key Profile Name>

amplify init

- storageapp
- y
- AWS Profile
  - <Key Profile Name>
- Y

amplify add storage

- content
- Y (auth)
- default config
- email
- no, i am done
- s3download
- s3download
- aws users only
- create/update read
- N (lambda)

amplify push

- Y

flutter run
