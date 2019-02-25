require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    verif = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read)
    grid = params[:letters].split
    verif_letters = params[:word].upcase.split("").map { |l| grid.include?(l) ? grid.delete_at(grid.index(l)) : "false" }
    session[:score] ||= 0
    if verif_letters.include?("false")
      @message = "Sorry but #{params[:word]} can't be built out of #{params[:letters]}"
      session[:score] += 0
      @score = session[:score]
    elsif verif["found"] == false
      @message = "Sorry but #{params[:word]} doesn't seem to be an english word"
      session[:score] += 0
      @score = session[:score]
    else
      @message = "Congratulations! #{params[:word]} is an English valid word!"
      session[:score] += params[:word].length
      @score = session[:score]
    end
  end
end
