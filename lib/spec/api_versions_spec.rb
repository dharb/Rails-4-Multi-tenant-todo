describe ApiVersions do
  let(:api_constraints_v1) { ApiVersions.new(version: 1) }
  let(:api_constraints_v2) { ApiVersions.new(version: 2, default: true) }

  describe "header matches" do

    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'api.todo.dev', headers: {"Accept" => "application/vnd.todo.v1"})
      expect(api_constraints_v1.matches?(request)).to be true
    end

    it "return default API version when 'default' option is specified" do
      request = double(host: 'api.todo.dev')
      expect(api_constraints_v2.matches?(request)).to be true
    end
  end
end
