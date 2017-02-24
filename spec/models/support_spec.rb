require "rails_helper"

RSpec.describe Support, type: :model do
  context "associations" do
    it {is_expected.to belong_to :user}
  end

  context "validates" do
    it {is_expected.to validate_presence_of :content}
  end

  it "returns to list support of a user" do
    user = FactoryGirl.create :user
    s1 = FactoryGirl.create :support, content: "hi", user: user
    s2 = FactoryGirl.create :support, content: "hello", user: user
    expect(Support.of_user(user.id)).to eq [s1, s2]
  end

  describe "returns list unread supports" do
    let!(:s1) {FactoryGirl.create :support, is_read: true, from_admin: false}
    let!(:s2) {FactoryGirl.create :support, is_read: true, from_admin: true}
    let!(:s3) {FactoryGirl.create :support, is_read: false, from_admin: false}
    let!(:s4) {FactoryGirl.create :support, is_read: false, from_admin: true}

    it "returns list admin unread supports" do
      expect(Support.admin_unread).to eq [s3]
    end

    it "returns list user unread supports" do
      expect(Support.user_unread).to eq [s4]
    end
  end

  describe "get list latest user id" do
    let!(:user1) {FactoryGirl.create :user}
    let!(:user2) {FactoryGirl.create :user}
    let!(:s1) {FactoryGirl.create :support, user: user1, created_at: Time.now}
    let!(:s2) {FactoryGirl.create :support, user: user2, created_at: Time.now + 1.hours}
    let!(:s3) {FactoryGirl.create :support, user: user1, created_at: Time.now + 2.hours}

    it "returns list descending supports" do
      expect(Support.created_desc).to eq [s3, s2, s1]
    end

    it "returns list latest user id unique" do
      expect(Support.latest_user_id).to eq [user1.id, user2.id]
    end
  end
end
