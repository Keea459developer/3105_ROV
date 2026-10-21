# 3105 RoV-focused customization

This revision adapts the app's main navigation and landing page to the RoV-only layout requested from the reference video.

## Changes
- Main navigation now shows only **Home**, **New**, and **Sources**.
- Home is a RoV-focused dashboard with device/iOS information and compatibility status.
- The Home page no longer lists repository packages or unrelated games.
- New is intentionally clear of package listings.
- Settings includes language selection and toggles for the Home device card and compatibility card.
- Thai was added to the language choices. Existing English, Vietnamese, and Simplified Chinese choices remain.
- Existing Files, Installed, repository, and utility source files have been retained; they were not deleted.

## Important
- The RoV card is a UI/dashboard entry only. It does not launch, modify, inject into, or alter RoV.
- The project was syntax-parsed for changed Swift files in this environment. A full iOS build requires Xcode and the iOS SDK on macOS.
