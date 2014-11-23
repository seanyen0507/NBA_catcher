#NBA Informtion web Application
=============================
[ ![Codeship Status for ChenLiZhan/MovieCrawler](https://codeship.com/projects/b23a7d90-4a4e-0132-e0ce-3a47b25aadbc/status)](http://codeship.com/project/)
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
