require 'rspec'
require 'pry'
require_relative '../lib/golf2'

describe Holelayout do
	describe "while importing CSV" do
		it 'imports an array into HoleLayout instance' do
			course_layout=Holelayout.import
			expect(course_layout).to be_instance_of(Array)
		end

		it 'while importing CSV retreives an array with 18 elements' do
			course_layout=Holelayout.import
			expect(course_layout.length).to eql(18)
		end

		it 'total par for a golf course = 72 strokes' do
			course_layout=Holelayout.import
			sum = 0
			course_layout.each {|par| sum+= par.to_i}
			expect(sum).to eql(72)
 		end
 	end
end

describe ScoreCard do
  describe 'while importing CSV with players_strokes_data' do
    it 'retreives player and stroke info from CSV, puts into hash and checks first record' do
      players_and_strokes_data = ScoreCard.import_players_and_strokes
      players = players_and_strokes_data.keys
      expect(players[0]).to eql("Woods,Tiger")
      strokes = players_and_strokes_data.values
      expect(strokes[0].length).to eql(18)
    end

  describe 'while calculating score'
    it 'can compare a player\'s individual stroke to pars' do
      #Test file has a 1st hole score of 7 and a par of 4
      get_test_file
      scores = ScoreCard.calculate_score_for_round(@course_layout,@strokes_data)
      expect(scores[0]).to eql(3)
    end

    it 'can get right lingo for each indiviual score' do
      expect(ScoreCard.lingo(-2)).to eql('eagle')
      expect(ScoreCard.lingo(-1)).to eql('birdie')
      expect(ScoreCard.lingo(0)).to eql('par')
      expect(ScoreCard.lingo(1)).to eql('bogey')
      expect(ScoreCard.lingo(2)).to eql('double bogey')
      expect(ScoreCard.lingo(3)).to eql('3')
    end

     it 'outputs the # of hole, score and match between lingo and score for first golfer' do
       get_test_file
       scores = ScoreCard.calculate_score_for_round(@course_layout,@strokes_data)
       # expect(ScoreCard.output(@golfer,@course_layout,@strokes_data)).to eql('2')
    end

    it 'can calculate total strokes' do
      get_test_file
      expect(ScoreCard.total_strokes(@strokes_data)).to eql(70)
    end

    it 'can compare the total strokes to par' do
      get_test_file
      expect(ScoreCard.total_score(@course_layout,@strokes_data)).to eql(-2)
    end
  end
end

describe LeaderBoard do
  describe 'after calculations' do
    it "results can be packaged into a golfer standing" do
      get_full_test_file
      olfer_stats_hash = LeaderBoard.package_individual_golfer_standing_and_put_into_array(@course_layout,@golfer,@strokes_data)
      expect(olfer_stats_hash.length).to eql(@golfer.length)
      expect(olfer_stats_hash[0][:name]).to eql('Woods,Tiger')
    end
  end


  describe 'after packaging' do
    it "can be sorted and show the lowest score" do
      get_full_test_file
      golfer_stats_hash = LeaderBoard.package_individual_golfer_standing_and_put_into_array(@course_layout,@golfer,@strokes_data)
      standings = LeaderBoard.sort_standings(golfer_stats_hash)
      puts standings
      expect(standings[0][:total_score] < standings[1][:total_score]).to be_true
    end
  end
end


def get_test_file
      @course_layout=Holelayout.import
      @strokes_data = ScoreCard.import_players_and_strokes.values[0]
      @golfer = ScoreCard.import_players_and_strokes.keys[0]
end

def get_full_test_file
      @course_layout=Holelayout.import
      @golfer = ScoreCard.import_players_and_strokes.keys
      @strokes_data = ScoreCard.import_players_and_strokes.values
end


