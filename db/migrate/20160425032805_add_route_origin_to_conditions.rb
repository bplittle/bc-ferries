class AddRouteOriginToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :route_origin, :string
  end
end
