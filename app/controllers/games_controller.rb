require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = generate_grid(9)
    @start_time = Time.now

  end

  def score
     start_time = params[:start_time]
    @end_time = Time.now
    @attempt = params[:attempt].downcase!
    @grid = params[:grid]
    @result = run_game(@attempt, @grid, Time.parse(start_time.to_s), Time.parse(@end_time.to_s))
  end

  private
  def generate_grid(grid_size)
    game_grid = []
    grid = [*"A".."Z"]
    10.times { game_grid.push(grid.sample) }
  return game_grid
  end

  def run_game(attempt, grid, start_time, end_time)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  attempt_passed = open(url).read
  attempt_data = JSON.parse(attempt_passed)
  true_or_false = attempt_data["found"]
  answer_time = end_time - start_time
  if in_grid?(grid.split(" "), attempt) == false
    player_score = 0
    { score: player_score, message: 'not in the grid', time: answer_time }
  elsif true_or_false == false
    player_score = 0
    { score: player_score, message: 'not an English word', time: answer_time }
  else
    player_score = attempt.length / answer_time
    { score: player_score, message: 'well done', time: answer_time }
  end
end

  def in_grid?(grid, attempt)
    attempt_array = attempt.upcase!.split("")
    p attempt_array
    in_grid = true
    attempt_array.each do |letter|
      if attempt_array.count(letter) > grid.count(letter)
        in_grid = false
        break
      end
    end
    return in_grid
  end

end
