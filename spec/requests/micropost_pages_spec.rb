require 'spec_helper'

describe "Micropost Pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information"  do

			it "should not create a micropost" do
				expect { click_button "Post" }.should_not change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.should change(Micropost, :count).by(1) 
			end
		end
	end

	describe "micropost destruction" do 
		before { FactoryGirl.create(:micropost, user: user) }

		describe "as correct user" do
			before { visit root_path }

			it "should delete a micropost" do
				expect { click_link "delete" }.should change(Micropost, :count).by(-1)
			end
		end
	end

	describe "sidebar micropost counts" do
		before { FactoryGirl.create(:micropost, user: user, content: "this is the first post") }
		
		describe "single micropost" do
			before { visit root_path }
			it { should have_content("1 micropost") }
		end

		describe "multiple microposts" do
			before { FactoryGirl.create(:micropost, user: user, content: "this is the second post") }
			before { visit root_path }
			it { should have_content("2 microposts") }
		end
	end

	describe "should not delete other users micrposts" do
		before { FactoryGirl.create(:micropost, user: user, content: "a post created") }
		let(:userb) { FactoryGirl.create(:user) }
		before { sign_in userb }
		before { visit user_path(user) }
		it { should_not have_link('delete') }
	end

end
