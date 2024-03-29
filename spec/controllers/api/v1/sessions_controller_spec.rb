describe Api::V1::SessionsController do

  describe "POST #create" do
   before(:each) do
    @user = FactoryGirl.create :user
   end
    context "when credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: "password" }
        post :create, { session: credentials }
      end

      it "returns corresponding user" do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end
    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: "invalid" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.auth_token
    end

    it { should respond_with 204 }

  end
end
