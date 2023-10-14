## Functionality

- [ ] Ability to add / pin favourite channels to main homepage (use AppStorage)
- [ ] Custom swipe actions on pinned channels

## Components

- [ ] Tab bar 
- [ ] Channel
- [ ] Content preview

## Screens

- [ ] Favourite / pinned channels
- [ ] Adding channels to favourite
- [ ] Viewing channel contents
- [ ] Onboarding flow (to retrieve Are.na id and token from user, save to storage)
- [ ] Settings page (to reset token / change user / delete account / restart onboarding flow etc.)

## Cleaning

- [ ] Clean up models and fetching logic

## Models

- [ ] Refactor Channel model (to work for both API endpoints; ownerId and ownerSlug are optional)
- [ ] Remodel Models (ArenaChannelPreview will be its own model, with very few fields – when user clicks into a channel, then it will fetch and populate the proper ArenaChannel model)
