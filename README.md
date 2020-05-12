# Tumbler

## Table of Contents
1. [Overview](#Overview)
2. [Product Specs](#Product-Specs)
3. [App Walkthrough](#App-Walkthrough)
4. [APIs Used](#APIs-Used)
5. [Open-Source libraries used](#Open-Source-libraries-used)
6. [Credits](#Credits)

## Overview
### Description

Tumbler is an app that will allow users to view posts from the [Humans of New York](https://www.humansofnewyork.com/) Tumblr blog.

## Product Specs
### User Stories

- [X] User shall be able to see an app icon on the home screen and a styled launch screen.
- [X] User shall be able to view and scroll through a list of posts from the [Humans of New York](https://www.humansofnewyork.com/) Tumblr blog.
- [X] User shall be able to tap a cell to see more details about the post.
- [X] User shall be able to infinitely scroll through to see more posts.
- [X] User shall be able to pull to refresh to fetch the latest posts.
- [X] User shall be able to zoom post photo by tapping the photo in the details view.

## App Walkthrough

Here's a GIF of how the app works:

<img src="https://user-images.githubusercontent.com/35745973/81741234-1690b480-9453-11ea-93e5-9bae0a7e25a0.gif" width=250><br>

## APIs Used

- [Tumblr API](https://www.tumblr.com/docs/en/api/v2) - Allows users to read and write Tumblr blog and post data, retrieve posts by tags, get user information, follow blogs and like posts. Data is formatted in JSON and support for JSONP is included.

## Open-source libraries used

- [Alamofire](https://github.com/Alamofire/Alamofire) - An HTTP networking library written in Swift.
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage) - An image component library for Alamofire.
- [Gesture Recognizer Closures](https://github.com/marcbaldwin/GestureRecognizerClosures) - Provides closure handlers for gesture recognizers, controls and bar button items.

## Credits

>This is a companion project to CodePath's Professional iOS Course, check out the full course at [www.codepath.org](https://codepath.org/)