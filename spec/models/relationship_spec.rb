require 'spec_helper'

describe "Relationship" do
  
	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }

	subject { relationship }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow follower to access follower_id" do
			expect do
				Relationship.new(follower_id: follower.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should == follower }
		its(:followed) { should == followed }
	end

	describe "when followed id is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end

	it "should destroy relationships for a given user" do
		relationships = follower.relationships
		follower.relationships.destroy
		relationships.each do |relationship|
			Relationship.find_by_follower_id(follower.id).should be_nil
		end
	end


	
end
