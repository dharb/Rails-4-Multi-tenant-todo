describe Task do
  let(:task) { FactoryGirl.build :task }
  subject { task }

  it { should respond_to(:title) }
  it { should respond_to(:private) }
  it { should belong_to(:user) }
  it { should belong_to(:company) }
  it { should respond_to(:user_id) }
  it { should respond_to(:company_id) }
  it { should validate_presence_of :user_id }
end
