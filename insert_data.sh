#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# CLEAR TABLE VALUES 
echo "$($PSQL "TRUNCATE teams, games")"

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then 

  # get winner team_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found, make a new team id
    if [[ -z $WINNER_ID ]]
    then 
      INSERT_WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      if [[ $INSERT_WINNER_ID_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserting a new team: $WINNER"
      else
        echo "Failure to insert new team: $WINNER"
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

  # get opponent team_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found, make a new team id
    if [[ -z $OPPONENT_ID ]]
    then 
      INSERT_OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
      if [[ $INSERT_OPPONENT_ID_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserting a new team: $OPPONENT"
      else
        echo "Failure to insert new team: $OPPONENT"
      fi

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  # add a game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then
      echo "Inserting a new game: $YEAR, $WINNER vs $OPPONENT"
    else
      echo "Failure to insert new game: $YEAR, $WINNER vs $OPPONENT"
    fi


  fi
done