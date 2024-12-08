# faks_test
Faks technical test

# Usage
`ruby main.rb --help`

You can find file for test in the folder players_files

You can use the script in script/generate_players_files.rb to create players_files with many players line. ex: `ruby script/generate_players_files.rb 6000`

You can launch spec with `rspec spec/main.rb`

# The statement
tu as une liste de joueurs d'échecs avec leurs ages et scores (elo).

tu dois extraire de la liste les "champions"

un joueur est dit "champion" si et seulement si il n'y a personne d'autre dans la liste qui "l'élimine", c'est à dire:
 - personne d'autre n'est a la fois strictement plus fort et plus jeune ou même age
et
 - personne d'autre n'est à la fois strictement plus jeune et plus fort ou même score

ta mission: dans le language de ton choix, coder la fonction permettant de trouver les champions de la liste

On attachera une importance particulière aux points suivants:
- L'exactitude des resultats: Le(a) candidat(e) a t-il(elle) pensé(e) à la logique d'ensemble et aux cas particuliers ?
- La performance: Comment se comporte l'algorithme à mesure que le nombre de joueurs grandit ?
- La clarté et la lisibilité du code

# Approach Logic
After parsing the file to ensure there were no issues,

I sort the players first by age and then by ELO.

Next, I group the players by age.

This allows me to iterate over the array of players by age and retrieve the player with the highest ELO for each age group (I also check if multiple players have the same highest ELO and include all such players for their age group).
  
Finally, I print the result.
