class SheetsController < ApplicationController
  def index
    @sheetGroups = Sheet.order(column: :asc, row: :asc).group_by(&:row)
    render 'sheets/index'
  end
end
