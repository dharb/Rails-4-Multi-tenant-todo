describe Api::V1::UsersController do
  describe "GET #show" do
    context "on proper subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @company = @user.company
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        get :show, { id: @user.id }
      end

      it "checks hash" do
        user_response = json_response
        expect(user_response[:email]).to eql @user.email
      end

      it { should respond_with 200 }
    end

    context "on incorrect subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @company = FactoryGirl.create :company
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        get :show, { id: @user.id }
      end

      it "renders error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it { should respond_with 401 }
    end
  end

  describe "POST #create" do

    context "when successfully created" do
      before(:each) do
        @company = FactoryGirl.build(:user).company
        @user_attributes = FactoryGirl.attributes_for(:user).merge(company_id: @company.id)
        within_subdomain(@company.subdomain)
        post :create, { user: @user_attributes }
      end

      it "renders json for user just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "without subdomain" do
      before(:each) do
        @company = FactoryGirl.build(:user).company
        @user_attributes = FactoryGirl.attributes_for(:user).merge(company_id: @company.id)
        post :create, { user: @user_attributes }
      end

      it "renders error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders json errors" do
        user_response = json_response
        expect(user_response[:errors]).to include "Unspecified company"
      end

      it { should respond_with 401 }
    end

    context "when not created" do
      before(:each) do
        @company = FactoryGirl.build(:user).company
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        within_subdomain(@company.subdomain)
        post :create, { user: @invalid_user_attributes }
      end

      it "renders error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders json errors" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @company = @user.company
      within_subdomain(@company.subdomain)
      auth_header @user.auth_token
    end

    context "when successfully updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "new@example.com" } }
      end

      it "renders json for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "new@example.com"
      end

      it { should respond_with 200 }
    end

    context "when not updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "bad.com" } }
      end

      it "renders error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders json errors" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @company = @user.company
      within_subdomain(@company.subdomain)
      auth_header @user.auth_token
      delete :destroy, id: @user.auth_token
    end
    it { should respond_with 204 }
  end
end
