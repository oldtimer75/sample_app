require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "signup_page" do
		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign Up') }
		it { should have_selector('title', text: full_title('Sign Up')) }
	end
end
