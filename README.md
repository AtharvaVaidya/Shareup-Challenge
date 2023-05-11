# iOS Engineering Challenge

### Design


The design I came up with is basically the standard Wordle design. Some small improvements I made over the existing design was changing the fonts, text colors etc. I added a guesses count label so users can see how many guesses it took for them to guess the word.

I also embedded the view controller in a navigation controller, which makes the view a bit more iOS-y, and allows us to add a search bar/filtering ability in the future.

I struggled to think quickly on how to fill the blank space on the right of all the cells. One option was to just fill up the entire width, but that would mean that our font size remains fixed regardless of the user's dynamic type preferences.

###If I had more time
- I'd implement a search/filter/sort functionality so users are able to find the result they're looking for quickly.
- I'm not sure how other Wordle apps handle this, but showing the user the word after they've exhausted their guesses would also be pretty nice.
- Also, CRUD capabilites to interact with the server. So adding the ability to delete, and create new Wordle plays.
- Something that would've also been nice is a custom animation when the user taps to show the letters like a magic wand appearing over the boxes.

###The Algorithm

How I've implemented the algorithm is pretty simple:

It iterates over the guess word's characters, and

1. Checks if the given letter was guesses at the right position: if yes, we return `.correct`
2. Checks if the given letter exists at all in the entire string: if yes we return `.wrongPosition`
3. If both conditions above are not satisfied, then we just return `.wrong`
