#  Creative Portion

## Homepage of suggested/popular movies

- When the app first launches, the default page is the movie search tab. The screen will autoload with a query of the current most popular movies. 
    - This requires a separate call to the API for a different endpoint. The steps of checking that data is retrieved properly follows the same logic as searching for a movie. The movieData and imageCache are both cleared before fetching this data just in case as well. The loading animation is also included before this first fetch and DispatchQueue is used to load asynchronously.
    - Having a homepage allows the user something to look at instead of a blank screen when the first launch the app. In addition, it allows them to explore new movies, similarly to how streaming services like Netflix or Hulu set up their site pages. You have a higher chance of the user staying on your app or site for longer and keeping their interest. These "discover" movies can also be added or deleted in favorites just like a "searched" movie.

## Additional Actions for "Favorites"

- Users can drag to rearrange their favorites or clear all using the button on the top right
    - Reordering required additional functions in FavoriteViewController to be able to recognize drag and drop actions. Within the FavoriteViewController, the canMoveRowAt and moveRowAt methods identify and allow the object being selected by the touch, then they re-display the actual cells within the TableView. An edit button allows the user to enter the editingMode and toggles between "Done" or "Edit" and sits in the top left corner of the navigation bar. If the user is done editing/rearranging, the UserDefaults will then be updated so that the ordering will remain after the user leaves the page.
    - The clear all functionality required a button within the navigation tab and creating a function to reset the local array in the FavoriteViewController, update the tableView, and remove all movies from the UserDefaults.
    -The functions allow the user to customize their experience and add simplicity to their use of the app. They may have a grouping of movies they want to place their favorites in or rearrange using their own system to keep track of all their favorite movies. In addition, the "clear all" functionality can be extremely helpful if a person has a long list of movies that would take forever to delete one-by-one.
    
- An alert will be shown to users if the movie they try to add to their favorites has already been favorited and is in their Favorites list already
    - This required an extra logical condition check after accessing the list of favorited movies in the UserDefaults, then a method to display the alert.
    - This function helps users know if a movie is successfully added to their favorites or not without having to constantly switch between tabs and potentially search through a long list of favorited movies themselves. In this case, it also acts as a shortcut for searching through your favorited list of movies (a user can search a movie if they aren't sure whether it is in their favorites or not and try to add to favorites).
    
## Additional Search Features

- In the movie search view, an option was added to cancel in the middle of typing brings down the keyboard without changing a user's previous results. The keyboard was also changed to hide automatically after a user presses "enter" to allow them to see the full screen of their results.
    - This required additional functions for the searchBarDelegate to display a "cancel" button if the user began typing and to hide the keyboard if the user cancelled or pressed enter (utilizing .resignFirstResponder()).
    - By allowing the user to cancel a search, they aren't forced to change their current results if they change their mind or go through the extra step of re-searching their past result. Having the keyboard come down after searching allows the user to see the whole screen which is much better than only seeing 2 rows at a time.
    
- If a search returns no results, an alert will appear telling the user there were no results found for their search.
    - This required creating an alert but making sure to place it correctly when using DispatchQueue asynch calls. The status of whether a search returns any viable results or not is stored in a global variable. Then once the asynch calls return to main, if no results are found, the UI can then display an alert asking the user to try again.
    - This functionality allows the user to know whether a search has terminated and simply has no results or if the call is still fetching. Without this, a user might be unsure of how long to wait for a result to populate the CollectionView. 

# Extra Credit

- Created a context menu for the movies in the Movie tab. A 3D touch brings up the option to either add the movie to your favorites if the movie is not already added or remove the movie from your favorites if the movie has been added previously. The favorites tab will update as you click from this menu so that when you switch to your favorites, any/all movies you added/removed will be updated when the tab displays.
- 

#  Design Choices

- For movies that don't have an associated poster, a default "no image found" png will appear instead
- Search query to API begins after user presses "enter"
- Movie titles longer than 2 lines are scrollable
