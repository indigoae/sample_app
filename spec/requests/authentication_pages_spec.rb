require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }
    it { should have_link('Sign up now!', href: signup_path) }

  end

  describe "signin" do
    before { visit signin_path }

    let(:submit) { "Sign in" }

    describe "with an invalid user" do

      before { click_button submit }

      it { should have_selector('title', text: full_title('Sign in')) }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "sign in success" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in') }

    end

  end

end

