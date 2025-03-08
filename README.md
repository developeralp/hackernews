# HackerNews

HackerNews is an open-source HN app.

## About
- 💙 **Written in Flutter**
- 📘 **Utilizes Riverpod for state management**
- 📱 **Tested on both Android and iOS**

## Packages Used
- 📦 **Riverpod**: For state management
- 📦 **Dio**: For network calls and caching
- 📦 **Flutter Widget from HTML**: For rendering HTML texts
- 📦 **URL Launcher**: To open URLs
- 📦 **Infinite Scroll Pagination**: For endless scrolling
- 📦 **Connectivity Plus**: To monitor network connectivity
- 📦 **Google Fonts**: For custom typography
- 📦 **Shimmer**: For loading indicators

## Features
The app has two main pages:
1. **Home Page**: Displays the top stories.
2. **User Page**: Shows a user’s posts.

## Navigation
- Clicking on the **user** part of a post redirects to the **User Page**.
- Tapping on a **post** opens the URL of the post.

## Common Challenges with the HN API
1. **Slow loading when fetching posts**:
    - Used Flutter’s `Future` for asynchronous calls. While this improved performance, it wasn’t perfect.
    - Implemented **endless scrolling** to load more posts as the user reaches the bottom of the page.

## See in action
![hacker_news_gif1](https://github.com/user-attachments/assets/3151691a-99ae-4221-81b0-77f83f4aff38)

## Building the project
```bash
mkdir hackernews
cd hackernews
git init && git pull https://github.com/developeralp/hackernews
flutter pub get
