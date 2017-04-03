class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        @data = DATABASE.select{|d| d[:title].to_s.downcase.include?(params[:term].downcase) }.first(30).sort_by{ |x| x[:title].length }
      end
    end
  end

end
