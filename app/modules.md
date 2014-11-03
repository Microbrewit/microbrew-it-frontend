Responsibilities:
- Directives 
	- Do calculations, and display results in the correct unit
	- Can be configured to update parent with results

- Controllers
	- Keep track of scope
	- MainController
		- Sets up initial scope (login user, etc)

Microbrewit/core:
- Providers
	- calculate (all formulas)
	- convert (all conversion)
	- api (all api)
	- messenger (native notifications + local notifications)
	- localStorage

- Directives
	- mbColourBox (create colour box)
	- mbAbv (inline abv)
	- mbColour (inline srm)
	- mbBitterness (inline ibu)
	- mbGravity (inline gravity points)
	- mbConvert (inline unit switching)
	- mbMessenger

- Controllers
	- MainController

- Templates
	- Grid
		- Hop
		- Fermentable
		- Yeast
		- Other
		- Beer
		- Brewer
	- List
		- Hop
		- Fermentable
		- Yeast
		- Other
		- Beer
		- Brewer

- SASS
	- main.scss

Microbrewit/beer:

Microbrewit/users:
- Providers
	- UserAPI

- Controllers
	- LoginController

Microbrewit/breweries:

Microbrewit/search:
