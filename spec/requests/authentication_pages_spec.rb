require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "Authorization" do

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "submitting a DELETE request to the Users#destroy action as an admin on self" do
      let(:admin) { FactoryGirl.create(:admin) }

      before do
        sign_in admin
        delete user_path(admin)
      end
      specify { response.should redirect_to(root_path) }
    end


    describe "for non-signed in user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "visiting the edit page" do
        before { visit edit_user_path(user) }

        it { should have_selector('h1',    text: 'Sign in') }
        it { should have_content ('Please sign in.') }

        describe "after signing in" do
          before { sign_in user }
          it { should have_selector('title', text: "Edit user")}

          describe "it should only friendly forward once" do
            before do
              delete signout_path
              sign_in user
            end

            it { should have_selector('title', text: user.name) }
          end


        end
      end

      describe "submitting to the update action" do
        before { put user_path(user) }
        specify { response.should redirect_to(signin_path) }
      end

      describe "visiting the user index" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in') }
        it { should have_content ('Please sign in.') }
      end
    end

    describe "for wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

      before { sign_in user }

      describe "visit different persons edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting to another users update" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end


    end
  end

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

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in') }

    end

  end

end

