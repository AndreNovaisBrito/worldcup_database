#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Check if it's the column name
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert winner
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      echo $TEAM_ID $WINNER
    fi
  fi
  #Check if it's the column name
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert opponent
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      echo $TEAM_ID $OPPONENT
    fi
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#Check if it's the column name
  if [[ $YEAR != "year" ]]
  then
    #get game_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo WINNER_ID $WINNER_ID;
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo OPPONENT_ID $OPPONENT_ID
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WINNER_GOALS AND opponent_goals=$OPPONENT_GOALS AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")
    #if not found
    if [[ -z $GAME_ID ]]
    then
      #insert game
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $WINNER_ID $OPPONENT_ID
      fi
      #get new game_id
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WINNER_GOALS AND opponent_goals=$OPPONENT_GOALS AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID ")
      echo GAME_ID $GAME_ID
    fi
  fi
done
