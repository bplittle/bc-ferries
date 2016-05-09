class ConditionsController < ApplicationController
  def index
    # @conditions = Condition.where(:created_at => [Date.today.beginning_of_day..Date.today.end_of_day]).order(:sailing_time, :created_at)
  end

  def date
    date = params[:date].to_date
    if params[:route]
      @conditions = Condition.where(:created_at => [date.beginning_of_day..date.end_of_day], :route_origin => params[:route]).order(:sailing_time, :created_at)
    else
      @conditions = Condition.where(:created_at => [date.beginning_of_day..date.end_of_day]).order(:sailing_time, :created_at)
    end
    render :json => {conditions: @conditions}
  end

end
