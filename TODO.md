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

## Features

- [ ] [Are.na neighbours](https://www.are.na/block/22017787) displayed as an [infinite list](https://stackoverflow.com/questions/65614647/infinite-vertical-scrollview-both-ways-add-items-dynamically-at-top-bottom-tha)
- [ ] Sort channel contents by random, ascending, descending, most connections, least connections, etc. 
