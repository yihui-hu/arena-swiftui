## Arena SwiftUI App

## Notes

### Model / Retrieving JSON Logic

Priority of preview:
    - Title
        - title
        - generated_title
    - Description
        - description
    - Image
        - Image
        - Content
    - Source
        - source.url
        - source.title

Priority of block preview:
    - Image
    - Text Content (need custom view for this)
    - Attachment
    - Embed
    - Put title below block (like in Are.na)

## Resources

- [Preserve tab bar background when navigating between views](https://stackoverflow.com/questions/70867033/ios-tabview-in-swiftui-loses-background-when-content-of-the-navigationview-is)
- [onChange deprecations and updates in iOS 17](https://useyourloaf.com/blog/swiftui-onchange-deprecation/)
