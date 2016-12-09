describe Api::V1::CompaniesController do
  describe "GET #show" do
    before(:each) do
      @company = FactoryGirl.create :company
      get :show, id: @company.id
    end

    it "rednders correct name" do
      company_response = json_response
      expect(company_response[:name]).to eql @company.name
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @company_attributes = FactoryGirl.attributes_for :company
        post :create, { company: @company_attributes }
      end

      it "renders json for the company just created" do
        company_response = json_response
        expect(company_response[:subdomain]).to eql @company_attributes[:subdomain]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @invalid_company_attributes = { name: "uber", subdomain: "ub er"}
        post :create, { company: @invalid_company_attributes }
      end

      it "renders error json" do
        company_response = json_response
        expect(company_response).to have_key(:errors)
      end

      it "renders correct json error" do
        company_response = json_response
        expect(company_response[:errors][:subdomain]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @company = FactoryGirl.create :company
      delete :destroy, { id: @company.id }
    end

    it { should respond_with 204 }

  end
end
