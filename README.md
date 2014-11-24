#NBA Informtion web Application
=============================
[ ![Codeship Status for seanyen0507/NBA_catcher](https://codeship.com/projects/f1a6f040-47e7-0132-a87c-56d6762cfdb8/status?branch=master)](https://codeship.com/projects/45738)
##Heroku service
Click the [link](https://NBA_catcher.herokuapp.com/) to use our service.
##Description
You can use our service to search the NBA player statistic you like, and also can search today's start lineup in each game.
##API Useage
Enter any players you want to search in (playername)

  https://NBA_catcher.herokuapp.com/api/v1/player/(playername).json
You also can use post to have the website data below.

  http://NBA_catcher.herokuapp.com/api/vi/check
You could have a "post" request to access the data with.

  curl -v -H "Accept:applicatiom/json" -H "Content-type: application/json" -X
  POST -d "{\"playernames\":[\"kobe\",\"wade\",\"anthony\"]}" http://heroku/api/v1/check
