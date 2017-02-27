require "rails_helper"
include Rails.application.routes.url_helpers

RSpec.describe "users/edit.html.erb", type: :view do
  let(:user) {FactoryGirl.create :user}

  before do
    sign_in user
    assign :user, user
    render
  end
  context "displays user's profile" do
    it {expect(rendered).to include user.email}
    it {expect(rendered).to include user.name}
  end
end
