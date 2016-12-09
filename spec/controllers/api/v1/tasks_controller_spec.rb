describe Api::V1::TasksController do
  describe "GET #show" do
    context "on proper subdomain" do
      before(:each) do
        user = FactoryGirl.create :user
        @company = user.company
        @task = FactoryGirl.create :task, user: user
        within_subdomain(@company.subdomain)
        auth_header user.auth_token
        get :show, { company_id: @company.id, id: @task.id }
      end

      it "renders correct title" do
        task_response = json_response
        expect(task_response[:title]).to eql @task.title
      end

      it { should respond_with 200 }
    end

    context "on incorrect subdomain" do
      before(:each) do
        user = FactoryGirl.create :user
        @company = FactoryGirl.create :company
        @task = FactoryGirl.create :task
        within_subdomain(@company.subdomain)
        auth_header user.auth_token
        get :show, { id: @task.id }
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it { should respond_with 401 }
    end
  end

  describe "GET #index" do
    context "on proper subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @company = @user.company
        @user_2 = FactoryGirl.create :user, company: @company
        @user_outside_domain = FactoryGirl.create :user
        FactoryGirl.create :task, user: @user
        FactoryGirl.create :task, user: @user, private: true
        FactoryGirl.create :task, user: @user_2
        FactoryGirl.create :task, user: @user_2, private: true
        FactoryGirl.create :task, user: @user_outside_domain
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        get :index
      end

      it "returns own private tasks, company public tasks, and no other company tasks" do
        tasks_response = json_response
        expect(tasks_response[:tasks]).to have(3).items
      end

      it { should respond_with 200 }
    end

    context "on incorrect subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @company = FactoryGirl.create :company
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        get :index
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it { should respond_with 401 }
    end
  end

  describe "POST #create" do
    context "successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @company = user.company
        within_subdomain(@company.subdomain)
        @task_attributes = FactoryGirl.attributes_for :task
        auth_header user.auth_token
        post :create, { user_id: user.id, task: @task_attributes }
      end

      it "renders json for the task just created" do
        task_response = json_response
        expect(task_response[:title]).to eql @task_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "on incorrect subdomain" do
      before(:each) do
        user = FactoryGirl.create :user
        @company = FactoryGirl.create :company
        within_subdomain(@company.subdomain)
        @task_attributes = FactoryGirl.attributes_for :task
        auth_header user.auth_token
        post :create, { user_id: user.id, task: @task_attributes }
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it { should respond_with 401 }
    end
    context "when not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @company = user.company
        within_subdomain(@company.subdomain)
        @invalid_task_attributes = { title: nil }
        auth_header user.auth_token
        post :create, { user_id: user.id, task: @invalid_task_attributes }
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it "renders correct json error" do
        task_response = json_response
        expect(task_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @task = FactoryGirl.create :task, user: @user
      @company = @user.company
      auth_header @user.auth_token
    end

    context "on incorrect subdomain" do
      before(:each) do
        company = FactoryGirl.create :company
        within_subdomain(company.subdomain)
        patch :update, { user_id: @user.id, id: @task.id, task: { title: "Example 1" } }
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it { should respond_with 401 }
    end

    context "when successfully updated" do
      before(:each) do
        within_subdomain(@company.subdomain)
        patch :update, { user_id: @user.id, id: @task.id, task: { title: "Example 1" } }
      end

      it "renders correct json title" do
        task_response = json_response
        expect(task_response[:title]).to eql "Example 1"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        within_subdomain(@company.subdomain)
        patch :update, { user_id: @user.id, id: @task.id, task: { title: "" } }
      end

      it "renders error json" do
        task_response = json_response
        expect(task_response).to have_key(:errors)
      end

      it "renders the correct json errors" do
        task_response = json_response
        expect(task_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    context "on correct subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @task = FactoryGirl.create :task, user: @user
        @company = @user.company
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        delete :destroy, { user_id: @user.id, id: @task.id }
      end

      it { should respond_with 204 }
    end

    context "on incorrect subdomain" do
      before(:each) do
        @user = FactoryGirl.create :user
        @task = FactoryGirl.create :task, user: @user
        @company = FactoryGirl.create :company
        within_subdomain(@company.subdomain)
        auth_header @user.auth_token
        delete :destroy, { user_id: @user.id, id: @task.id }
      end

      it { should respond_with 401 }
    end
  end
end
