require 'rails_helper'

RSpec.describe "Admin::Schedules", type: :request do
  describe "GET /resource" do
    it "returns http success" do
      get "/admin/schedule/resource"
      expect(response).to have_http_status(:success)
    end
  end

end
