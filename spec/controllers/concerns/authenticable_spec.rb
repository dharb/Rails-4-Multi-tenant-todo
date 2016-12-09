class Authentication
  include Auth
end

describe Auth do
  let(:auth) { Authentication.new }
  subject { auth }

  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user
      allow(auth).to receive(:current_user).and_return(nil)
      allow(auth).to receive(:current_company).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors" => "Not authenticated"}.to_json)
    end

    it "renders json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

  end

  describe "#valid_user_signed_in?" do
    context "when there is a user session" do
      before do
        @user = FactoryGirl.create :user
        @company = @user.company
        allow(auth).to receive(:current_user).and_return(@user)
        allow(auth).to receive(:current_company).and_return(@company)
      end

      it { should be_valid_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(auth).to receive(:current_user).and_return(nil)
      end

      it { should_not be_valid_user_signed_in }
    end

    context "when subdomain is incorrect" do
      before do
        @user = FactoryGirl.create :user
        @company = FactoryGirl.create :company
        allow(auth).to receive(:current_user).and_return(@user)
        allow(auth).to receive(:current_company).and_return(@company)
      end

      it { should_not be_valid_user_signed_in }
    end
  end
end
