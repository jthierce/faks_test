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

# Ways to improve the code
Remove CSV-specific references to make the code more generic. Create a helper to transform any data type into a generic format.

Initially, I used metaprogramming to create the valid_elo and valid_age methods in the Player class to avoid code duplication. However, I reverted this approach. Depending on future requirements, I might reintroduce these methods as metaprogrammed functions.

Removing CsvHelper.Validate means we'll need to manually check if the name property in the Player class is not empty.

Currently, my code only saves the age, elo, and name headers. It might be beneficial to store any additional data in the Player class.

# Approach Logic
After parsing the file to ensure there were no issues,

I sort the players first by age and then by ELO.

Next, I group the players by age.

This allows me to iterate over the array of players by age and retrieve the player with the highest ELO for each age group (I also check if multiple players have the same highest ELO and include all such players for their age group).
  
Finally, I print the result.

# Another logic

## 1
During data verification, I could have checked if the players were champions. d

This approach would have worked, but the issue is that each time I progress through the players list, if I find a younger and stronger player, I would have to loop through the temporary champions list again. 

To handle this, I could have used a hash with the age as the key and the maximum elo for that age as the value.

## 2
An alternative approach I considered was as follows:

1. **Identify the Maximum Elo per Age Group**: First, find the maximum Elo value for each age group in the player data. Once the highest Elo for a given age is determined, eliminate players who are older than the youngest player with that maximum Elo. These older players are no longer relevant for comparison and can be excluded from further checks.

2. **Sort Players by Age**: After filtering out the irrelevant players, sort the remaining players by age. 

3. **Iterate and Track the Maximum Elo**: Iterate over the players from the youngest to the oldest age. For each age group, compare the players and keep track of the highest Elo seen during each iteration.

4. **Identify Champions**: By maintaining a "buffer" of the maximum Elo value seen, it becomes easy to check if a player qualifies as a champion, without needing to recheck players from older age groups.

This approach reduces unnecessary comparisons and helps focus on the relevant subset of players, optimizing the process.
