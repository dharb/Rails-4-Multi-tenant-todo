describe Company do
  before { @company = FactoryGirl.build(:company) }

  subject { @company }

  it { should respond_to(:name) }
  it { should respond_to(:subdomain) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:subdomain) }
  it { should have_many(:users) }
  it { should have_many(:tasks) }
  it { should allow_value('example').for(:subdomain) }
  it { should_not allow_value('exam ple').for(:subdomain) }
  it { should be_valid }

  describe "#users association" do
    before do
      @company.save
      5.times { FactoryGirl.create :user, company: @company }
    end
    it "destroys associated tasks on self destruct" do
      users = @company.users
      @company.destroy
      users.each do |user|
        expect(User.find(user)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
