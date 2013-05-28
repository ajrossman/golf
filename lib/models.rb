require 'CSV'
require 'pry'

class Holelayout

  def initialize
    @holes
  end

  def self.import
    @holes = []
    CSV.foreach(ENV['HOME']+'/code/Golf2/hole_layout.csv') do |row|
      @holes=row.collect{|i| i.to_i}
    end
    return @holes
  end
end

class ScoreCard

  def initialize
    @players_score_data={}
  end

  def self.import_players_and_strokes
    @players_strokes_data={}
    CSV.foreach(ENV['HOME']+'/code/Golf2/players_score_data.csv','r') do |row|
      last_name = row.shift.strip
      first_name = row.shift.strip
      strokes = row
      array = strokes.collect{|i| i.to_i}
      @players_strokes_data["#{last_name},#{first_name}"]=array
    end
  return @players_strokes_data
  end

  def self.calculate_score_for_round(par_array,strokes_array)
    scores = []
    scores = strokes_array.each_with_index.map { |n,i| n - par_array[i] }
    return scores
  end

  def self.lingo(score)
    if score==-2 then lingo='eagle'
    elsif score==-1 then lingo='birdie'
    elsif score==0 then lingo='par'
    elsif score==1 then lingo='bogey'
    elsif score==2 then lingo='double bogey'
    else lingo="#{score}"
    end
  end

  def self.output(golfer,par_array,strokes_array)
    puts "==#{golfer}"
    score = ScoreCard.calculate_score_for_round(par_array,strokes_array)
    score.each_with_index do |hole_score,index|
    puts "Hole #{index+1}: #{strokes_array[index]} - #{lingo(hole_score)}"
    end
    puts
    puts "Total strokes: #{ScoreCard.total_strokes(strokes_array)}"
    puts ScoreCard.total_score(par_array,strokes_array)
    puts "=="
    puts
  end

  def self.total_strokes(strokes_array)
    total_score=0
    strokes_array.each {|score| total_score += score}
    return total_score
  end

  def self.total_score(par_array,strokes_array)
    score_array = calculate_score_for_round(par_array,strokes_array)
    total_score=0
    score_array.each {|score| total_score += score}
    return total_score
  end
end


class LeaderBoard

  def initialize


  end

  def self.package_individual_golfer_standing_and_put_into_array(par_array,golfer,strokes_array)

    individual_standing = []
    index=0

    while index < golfer.length
      golfer_stats_hash={}
      golfer_stats_hash[:total_score] = ScoreCard.total_score(par_array,strokes_array[index])
      golfer_stats_hash[:total_strokes] = ScoreCard.total_strokes(strokes_array[index])
      golfer_stats_hash[:name] = golfer[index]
      individual_standing[index] = golfer_stats_hash
      index += 1
    end
    return individual_standing
  end


  def sort_golfer_standings(golfer_stats_hash)
      golfer_stats_hash[:total_score]
      sorted_golf_standings = golfer_stats_hash.sort_by {|k| k[:total_score]}
      puts sorted_golf_standings
  end


end

# par_for_course = Holelayout.import
# strokes = ScoreCard.import_players_and_strokes
# golfer = ScoreCard.import_players_and_strokes
# puts ScoreCard.output(golfer,par_for_course,strokes)



course_layout=Holelayout.import

strokes_data = ScoreCard.import_players_and_strokes.values[0]
golfer = ScoreCard.import_players_and_strokes.keys[0]
puts ScoreCard.output(golfer,course_layout,strokes_data)

strokes_data = ScoreCard.import_players_and_strokes.values[1]
golfer = ScoreCard.import_players_and_strokes.keys[1]
puts ScoreCard.output(golfer,course_layout,strokes_data)






