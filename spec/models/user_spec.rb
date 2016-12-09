describe User do
  before { @user = FactoryGirl.build(:user) }
  # before { @user_with_tasks = FactoryGirl.build(:user, :with_tasks) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:company_id) }
  it { should belong_to(:company) }
  it { should have_many(:tasks) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:auth_token) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
  it { should be_valid }

  describe "#tasks association" do
    before do
      @user.save
      5.times { FactoryGirl.create :task, user: @user }
    end
    it "destroys associated tasks on self destruct" do
      tasks = @user.tasks
      @user.destroy
      tasks.each do |task|
        expect(Task.find(task)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "Generating auth tokens" do
    it "generates unique token" do
      allow(Devise).to receive(:friendly_token).and_return("tokentoken12345")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "tokentoken12345"
    end

    it "generates different token when one is taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "tokentoken12345")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end
end
