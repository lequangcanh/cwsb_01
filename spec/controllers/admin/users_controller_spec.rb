require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  before do
    sign_in FactoryGirl.create :admin
  end

  describe "GET #index" do
    it do
      get :index
      expect(response).to have_http_status :success
    end

    context "returns users by status" do
      it {expect(User.active.count).not_to be_nil}
      it {expect(User.blocked.count).not_to be_nil}
      it {expect(User.reject.count).not_to be_nil}
    end
  end

  describe "PATCH #update" do
    let(:user) {FactoryGirl.create :user}

    it "raise flash if not found user" do
      patch :update, id: 100,
        user: FactoryGirl.attributes_for(:user, status: "blocked"), format: :json
      expect(controller).to set_flash[:danger]
    end

    it "returns json if update successfully" do
      patch :update, id: user,
        user: FactoryGirl.attributes_for(:user, status: "blocked"), format: :json
      expected = {flash: I18n.t("admin.users.succ_update"), status: 200,
        total_active: User.active.count, total_block: User.blocked.count,
        total_reject: User.reject.count}.to_json
      expect(response.body).to eq expected
    end

    it "returns json if update fail" do
      patch :update, id: user,
        user: FactoryGirl.attributes_for(:user, status: nil), format: :json
      expected = {flash: I18n.t("admin.users.fail_update"), status: 400}.to_json
      expect(response.body).to eq expected
    end
  end
end
