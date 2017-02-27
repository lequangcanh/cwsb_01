require "rails_helper"

RSpec.describe Admin::StatisticsController, type: :controller do
  before {sign_in FactoryGirl.create :admin}

  describe "GET #index" do
    before {get :index}

    it {expect(response).to have_http_status :success}

    it "return default chart" do
      expected = ChartService.new(Settings.admin.new_statistics.users,
        Settings.admin.new_statistics.this_week).get_chart
      expect(assigns(:chart)).to eq expected
    end

    context "returns statistics of total" do
      it {expect(assigns(:total_user)).to eq User.count}
      it {expect(assigns(:total_venue)).to eq Venue.count}
      it {expect(assigns(:total_space)).to eq Space.count}
      it {expect(assigns(:total_booking)).to eq Booking.count}
    end
  end

  describe "POST #create" do
    context "returns chart if duration choosen type" do
      it "returns chart if correct params" do
        post :create, new_statistics: {choosen: Settings.admin.new_statistics.users,
          times: Settings.admin.new_statistics.duration,
          date_from: Date.today.to_s, date_to: Date.tomorrow.to_s}, format: :js
        expected = ChartService.new(Settings.admin.new_statistics.users,
          Settings.admin.new_statistics.duration, Date.today, Date.tomorrow).get_chart
        expect(assigns(:chart)).to eq expected
      end

      it "returns flash if date_from > date_to" do
        post :create, new_statistics: {choosen: Settings.admin.new_statistics.users,
          times: Settings.admin.new_statistics.duration,
          date_from: Date.tomorrow.to_s, date_to: Date.today.to_s}, format: :js
        expect(flash[:danger]).to eq I18n.t "admin.new_statistics.wrong_date"
      end

      it "returns flash if invalid date" do
        post :create, new_statistics: {choosen: Settings.admin.new_statistics.users,
          times: Settings.admin.new_statistics.duration,
          date_from: "", date_to: Date.today.to_s}, format: :js
        expect(flash[:danger]).to eq I18n.t "admin.new_statistics.invalid_date"
      end
    end
  end

  it "returns chart if not duration choosen type" do
    post :create, new_statistics: {choosen: Settings.admin.new_statistics.users,
      times: Settings.admin.new_statistics.this_week, date_from: "", date_to: ""}, format: :js
    expected = ChartService.new(Settings.admin.new_statistics.users,
      Settings.admin.new_statistics.this_week).get_chart
    expect(assigns(:chart)).to eq expected
  end
end
