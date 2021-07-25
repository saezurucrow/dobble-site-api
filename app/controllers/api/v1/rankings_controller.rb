class Api::V1::RankingsController < ApplicationController
  def index
    rankings = Ranking.all.order(:score).limit(30)
    render json: {status: 'SUCCESS', data: rankings}, status: :ok
  end
 
  def create
    ranking = Ranking.new(ranking_params)
    rank = 0

    if ranking.save
      rankings = Ranking.all.order(:score)
      rankings.each_with_index do |n, idx|
        if ranking.id === n.id
          rank = idx + 1
          break
        end
      end

      render json: {status: 'SUCCESS', message: 'Saved ranking', data: ranking, rankingLength: rankings.length, rank: rank}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Ranking not saved', data: ranking.errors}, status: :unprocessable_entity
    end
  end

  private

  def ranking_params
    params.permit(:name, :score)
  end
end
