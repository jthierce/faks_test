# frozen_string_literal: true

def pseudo_generator
  Enumerator.new do |yielder|
    current = "a"
    loop do
      yielder << current
      current = current.next
    end
  end
end

number_of_lines = ARGV.shift
file_structure = []

file_structure << ['Name', 'age', 'Elo'].join(',')
pseudo_enum = pseudo_generator

number_of_lines.to_i.times do |i|
  file_structure << [pseudo_enum.next, rand(3..109), rand(100..3800)].join(',')
end

file = File.open("players_files/#{Time.now}_generate_players_files.csv", 'w')
file.puts(file_structure.join("\n"))
file.close
