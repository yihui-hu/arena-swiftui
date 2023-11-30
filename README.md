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
    
Fetching paginated data:

```swift
ScrollView {
    LazyVStack {
        ForEach(...) {
            // more code here...
        }
        .onAppear {
            if item.id == items.last.id { fetchMoreData() }
        }
    }
}
```

    - Wrap your list of items in a lazy view (LazyVGrid, LazyHGrid, etc.)
    - Wrap each item in a NavigationLink if you want
    - Attach .onAppear modifier to each item, and call loadMore() function when last item is in view (i.e. its ID matches last item in current list of items)
    
## Architecture

### MVVM

This project utilizes the MVVM (Model, View, ViewModel) architecture for orchestrating flow of data and maintaining lifecycle of screens.

Most of the data fetching logic can be found in the Data folder, with "data fetcher" classes for each important component used in the app (Are.na channels, blocks, etc.)
    
## Are.na specific resources

- [Are.na Multiplexer](https://github.com/mguidetti/are.na-multiplexer/blob/09ebb35f35ab3e33c4abd45530d0944cb38c4d0f/src/components/ChannelLoader.tsx) - referenced API calls and organization

## Resources

### Honestly this is just a running documentation of the basic / slightly more complex things I have to look up to achieve a certain function for the app

- [Preserve tab bar background when navigating between views](https://stackoverflow.com/questions/70867033/ios-tabview-in-swiftui-loses-background-when-content-of-the-navigationview-is)
- [onChange deprecations and updates in iOS 17](https://useyourloaf.com/blog/swiftui-onchange-deprecation/)
- [Infinite Scrollview with paginated API](https://www.youtube.com/watch?v=M3nflHaayok)
- [Swift API Calls 1](https://www.youtube.com/watch?v=ERr0GXqILgc)
- [Swift API Calls 2](https://www.youtube.com/watch?v=ZHK5TwKwcE4&t=905s)
- [LazyVStack, VStack and List Performance](https://www.youtube.com/watch?v=yrly21IFQdY)
- [Programmatic toolbar](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toolbar-and-add-buttons-to-it)
- [Using TabViews](https://www.youtube.com/watch?v=DLj9yM-zLyc&t=5s)
- [Debouncing search manually](https://medium.com/@anselmus.pavel/debouncing-user-input-in-swiftui-10dda5231bdf)
- [Debouncing search with a library](https://github.com/Tunous/DebouncedOnChange)
- [Custom search input style](https://www.codecademy.com/resources/docs/swiftui/viewmodifier/textFieldStyle)
- [Optimizing work in iOS runtime](https://itnext.io/optimizing-work-in-ios-runtime-b2afc10ec775)
- [Change background of View](https://stackoverflow.com/questions/56437036/swiftui-how-do-i-change-the-background-color-of-a-view)
- [Dismiss keyboard on scroll](https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-when-the-user-scrolls)
- [Supporting different view size (iPad, iPhone, split screen, etc.)](https://stackoverflow.com/questions/57652242/how-to-detect-whether-targetenvironment-is-ipados-in-swiftui)
- [Perform action when view is within viewport, not naively using `.onAppear`](https://stackoverflow.com/questions/60595900/how-to-check-if-a-view-is-displayed-on-the-screen-swift-5-and-swiftui)
- [Vertically center content in ScrollView](https://stackoverflow.com/questions/58122998/swiftui-vertical-centering-content-inside-scrollview)
- [Show duplicate items in ForEach, needed because Are.na API block search could return duplicates](https://stackoverflow.com/questions/59295206/how-do-you-use-enumerated-with-foreach-in-swiftui)
- [Custom clip shapes](https://sarunw.com/posts/how-to-draw-custom-paths-and-shapes-in-swiftui/)
- [Implementing haptics](https://www.hackingwithswift.com/books/ios-swiftui/adding-haptic-effects)
