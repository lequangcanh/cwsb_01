require "rails_helper"

RSpec.describe Admin::SupportsController, type: :controller do
  before do
    sign_in FactoryGirl.create :admin
  end

  describe "GET #index" do
    it do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe "POST #create" do
    let(:user) {FactoryGirl.create :user}

    context "returns js" do
      before {post :create, user_id: user.id, format: :js}

      it {expect(assigns(:support)).to be_new_record}
      it {expect(assigns(:supports)).to eq Support.of_user user.id}
    end
  end
end
